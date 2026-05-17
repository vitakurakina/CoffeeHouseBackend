from flask import Flask, jsonify, request, send_from_directory
import mysql.connector
import os
from auth import auth_bp
from config import db_config

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
app.register_blueprint(auth_bp)

IMAGE_FOLDER = os.path.join(os.path.dirname(__file__), "ItemImages")


# ---------- UTILS ----------
def get_db():
    return mysql.connector.connect(**db_config)


@app.route('/images/<path:filename>')
def get_image(filename):
    return send_from_directory(IMAGE_FOLDER, filename)


# ---------- DRINKS ----------
@app.route('/drinks', methods=['GET'])
def get_drinks():
    con = get_db()
    cursor = con.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            d.id_drink,
            d.name AS name,
            dp.price AS price,
            ds.name AS size,
            dsc.text AS description,
            dt.name AS info,
            dc.name AS category,
            d.photo AS image
        FROM drinks d
        LEFT JOIN descriptions dsc ON d.id_description = dsc.id_description
        LEFT JOIN categories dc ON d.id_category = dc.id_category
        LEFT JOIN drinks_types dt ON d.id_type = dt.id_type
        LEFT JOIN drinks_prices dp ON d.id_drink = dp.id_drink
        LEFT JOIN drinks_sizes ds ON dp.id_size = ds.id_size
        ORDER BY d.id_drink;
    """)

    rows = cursor.fetchall()

    result = {}

    for row in rows:
        drink_id = row["id_drink"]

        photo = row["image"]
        if photo:
            photo = photo.strip().strip("'").strip('"')
            image_url = f"http://192.168.1.58:5000/images/{photo}"
        else:
            image_url = ""

        if drink_id not in result:
            result[drink_id] = {
                "name": row["name"],
                "description": row["description"],
                "info": row["info"],
                "category": row["category"],
                "image": image_url,
                "sizes": []
            }

        result[drink_id]["sizes"].append({
            "size": row["size"],
            "price": row["price"]
        })

    cursor.close()
    con.close()

    return jsonify(list(result.values()))


# ---------- DESSERTS ----------
@app.route('/desserts', methods=['GET'])
def get_desserts():
    con = get_db()
    cursor = con.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            d.name AS name,
            d.price AS price,
            dsc.text AS description,
            dc.name AS category,
            d.photo AS image
        FROM desserts d
        LEFT JOIN descriptions dsc ON d.id_description = dsc.id_description
        LEFT JOIN categories dc ON d.id_category = dc.id_category;
    """)

    desserts = cursor.fetchall()

    result = []
    for d in desserts:
        photo = d["image"]

        if photo:
            photo = photo.strip().strip("'").strip('"')
            image_url = f"http://192.168.1.58:5000/images/{photo}"
        else:
            image_url = ""

        result.append({
            "name": d["name"],
            "price": d["price"],
            "description": d["description"],
            "category": d["category"],
            "image": image_url
        })

    cursor.close()
    con.close()

    return jsonify(result)


# ---------- BONUS ----------
@app.route('/add-bonus', methods=['POST'])
def add_bonus():
    data = request.json

    user_id = data.get("userId")
    total_price = data.get("totalPrice")

    if user_id is None or total_price is None:
        return jsonify({"error": "Missing data"}), 400

    bonus = int(total_price * 0.1)  # ✅ 10%

    con = get_db()
    cursor = con.cursor()

    cursor.execute("""
        UPDATE users
        SET bonus_amount = bonus_amount + %s
        WHERE id_user = %s
    """, (bonus, user_id))

    con.commit()

    cursor.close()
    con.close()

    return jsonify({
        "addedBonus": bonus,
        "totalPrice": total_price
    })


# ---------- RUN ----------
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)