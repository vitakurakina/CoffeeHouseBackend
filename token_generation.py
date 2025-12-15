import secrets
import string

def generate_qr_token(length: int = 64) -> str:
    alphabet = string.ascii_letters + string.digits  # A-Z, a-z, 0-9
    token = ''.join(secrets.choice(alphabet) for _ in range(length))
    return token
