from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector
from config import db_config
from token_generation import generate_qr_token

auth_bp = Blueprint('auth', __name__, url_prefix='/api')

def get_db():
    return mysql.connector.connect(**db_config)


@auth_bp.route('/signup', methods=['POST'])
def register():
    data = request.json
    login = data.get('login')
    email = data.get('email')
    password = data.get('password')

    if not login or not email or not password:
        return jsonify({"error": "Логин, Email и пароль обязательны"}), 400

    con = get_db()
    cursor = con.cursor()

    cursor.execute("SELECT id_user FROM users WHERE email = %s", (email,))
    if cursor.fetchone():
        cursor.close()
        con.close()
        return jsonify({"error": "Пользователь уже существует"}), 409

    password_hash = generate_password_hash(password)
    qr_token = generate_qr_token()
    bonus_amount = 0
    is_confirmed = 0

    cursor.execute(
        "INSERT INTO users (login, email, password_hash, qr_token, bonus_amount, is_confirmed) VALUES (%s, %s, %s, %s, %s, %s)",
        (login, email, password_hash, qr_token, bonus_amount, is_confirmed)
    )

    con.commit()
    cursor.close()
    con.close()

    return jsonify({"message": "Регистрация успешна"}), 201


@auth_bp.route('/signin', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"error": "Email и пароль обязательны"}), 400

    con = get_db()
    cursor = con.cursor()

    cursor.execute(
        "SELECT id_user, login, password_hash, qr_token, bonus_amount FROM users WHERE email = %s",
        (email,)
    )
    user = cursor.fetchone()

    cursor.close()
    con.close()

    if not user:
        return jsonify({"error": "Неверный email или пароль"}), 401

    user_id, login, password_hash, qr_token, bonus_amount = user

    if not check_password_hash(password_hash, password):

        return jsonify({"error": "Неверный email или пароль"}), 401

    return jsonify({"message": "Успешный вход",
        "userId": user_id,
        "login": login,
        "qrToken": qr_token,
        "bonusAmount": bonus_amount}), 200

@auth_bp.route('/me', methods=['GET'])
def me():
    auth_header = request.headers.get('Authorization')

    if not auth_header:
        return jsonify({"error": "Нет токена"}), 401

    parts = auth_header.split()

    if len(parts) != 2 or parts[0] != "Bearer":
        return jsonify({"error": "Неверный формат токена"}), 401

    token = parts[1]

    con = get_db()
    cursor = con.cursor()

    cursor.execute(
        "SELECT id_user, login, email, qr_token, bonus_amount "
        "FROM users WHERE qr_token = %s",
        (token,)
    )

    user = cursor.fetchone()

    cursor.close()
    con.close()

    if not user:
        return jsonify({"error": "Неверный токен"}), 401

    user_id, login, email, qr_token, bonus_amount = user

    return jsonify({
        "userId": user_id,
        "login": login,
        "email": email,
        "qrToken": qr_token,
        "bonusAmount": bonus_amount
    }), 200
