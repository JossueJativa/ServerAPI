import json
import os
import firebase_admin
from firebase_admin import credentials, messaging
import requests

from API.models import Home, Security, Home_User, User

# Ruta al archivo JSON con las credenciales
cred = credentials.Certificate(
    os.path.join(os.path.dirname(__file__), "seguridad-278d6-firebase-adminsdk-2j729-632aed8d9d.json")
)

firebase_admin.initialize_app(cred)

def send_fcm_message(token, title, body):
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        token=token,
    )

    try:
        messaging.send(message)
    except Exception as e:
        print(f"Error al enviar el mensaje: {e}")

def send_security_notification(security_id, home_id):
    sec = Security.objects.get(pk=security_id)
    url = f"{sec.url_home}/api/services/notify/persistent_notification"
    token = sec.token_home
    home_name = Home.objects.get(pk=home_id).name

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    data = {
        'message': f'Home {home_name} needs help',
        'title': f'Help Button {home_name}, con id {home_id}'
    }

    response = requests.post(url, headers=headers, json=data)
    response.raise_for_status()

def send_fcm_notification(home_user_id, home_id):
    home_user = Home_User.objects.get(pk=home_user_id)
    user = User.objects.get(pk=home_user.user.id)
    token_fcm = user.token_phone
    home_name = Home.objects.get(pk=home_id).name
    send_fcm_message(token_fcm, 'Help Button', f'Home {home_name} needs help')