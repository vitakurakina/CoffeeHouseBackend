from flask import Flask, jsonify, request, send_from_directory
import mysql.connector
import os
from config import db_config

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False

IMAGE_FOLDER = os.path.join(os.path.dirname(__file__), "ItemImages")

con=mysql.connector.connect(**db_config)

@app.route('/images/<path:filename>')
def get_image(filename):
    return send_from_directory(IMAGE_FOLDER, filename)


@app.route('/menu', methods=['GET'])
def get_tables():
    cursor = con.cursor()
    cursor.execute("""SELECT
        CONCAT(d.name,' ', ds.name) AS name,
        CONCAT('Цена: ', d.price, '₽') AS price,
        CONCAT('Описание: ', dsc.text) AS description,
        CONCAT('Особенности напитка: ', dt.name) AS info,
        d.photo AS image
    FROM drinks d
    LEFT JOIN descriptions dsc ON d.id_description = dsc.id_description
    LEFT JOIN drinks_sizes ds ON d.id_size = ds.id_size
    LEFT JOIN drinks_types dt ON d.id_type = dt.id_type;
    """)

    drinks = cursor.fetchall()

    result = []
    for drink in drinks:
        name, price, description, info, photo = drink
        if photo:
            photo = photo.strip().strip("'").strip('"')
            image_url = f"http://192.168.31.8:5000/images/{photo}"
        else:
            image_url = ""
        result.append({
            "name": name,
            "price": price,
            "description": description,
            "info": info,
            "image": image_url
        })

    return jsonify(result)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
