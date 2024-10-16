import os
import firebase_admin
from firebase_admin import credentials, messaging

# Ruta al archivo JSON con las credenciales
cred = credentials.Certificate(
    os.path.join(os.path.dirname(__file__), "seguridad-278d6-firebase-adminsdk-2j729-632aed8d9d.json")
)

# Inicializa la app de Firebase
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