from django.db import models
from django.contrib.auth.models import AbstractUser

# Create your models here.
class User(AbstractUser):
    email = models.EmailField(max_length=255, unique=True, blank=False, null=False)
    token_phone = models.CharField(max_length=255, blank=False, null=False)

class Area(models.Model):
    name = models.CharField(max_length=255)

class Home(models.Model):
    HomeAssistant_Url = models.CharField(max_length=255)
    HomeAssistant_Token = models.CharField(max_length=255)
    is_deleted = models.BooleanField(default=False)
    help_btn = models.CharField(max_length=255)
    area = models.ForeignKey(Area, on_delete=models.CASCADE)

class Home_User(models.Model):
    home = models.ForeignKey(Home, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)

class Security(models.Model):
    name = models.CharField(max_length=255)
    address = models.CharField(max_length=255)
    N_home = models.IntegerField()

class Security_Area(models.Model):
    security = models.ForeignKey(Security, on_delete=models.CASCADE)
    area = models.ForeignKey(Area, on_delete=models.CASCADE)
    is_selected = models.BooleanField(default=False)

'''
Modelos según la conexión

----------------------------------------------
|   Home                                     |
----------------------------------------------
|   id                 |  Primary Key        |
|   HomeAssistant_Url  |                     |
|   HomeAssistant_Token|                     |
|   is_deleted         |                     | -> Borrado lógico
|   help_btn           |                     |
|   area               | Foreign Key         |
----------------------------------------------

----------------------------------------------
|   User                                     |
----------------------------------------------
|   id                 | Primary Key         |
|   username           |                     | -> Se muestra
|   password           |                     | -> Se muestra
|   first_name         |                     | -> Se muestra
|   last_name          |                     | -> Se muestra
|   email              |                     | -> Se muestra
|   is_staff           |                     |
|   is_active          |                     | -> Borrado lógico
|   date_joined        |                     |
|   is_superuser       |                     |
|   groups             |                     |
|   user_permissions   |                     |
|   token_phone        |                     | -> Se muestra
----------------------------------------------

----------------------------------------------
|   Area                                     |
----------------------------------------------
|   id                 | Primary Key         |
|   name               |                     |
----------------------------------------------

----------------------------------------------
|   Home_User                                |
----------------------------------------------
|   id                 | Primary Key         |
|   home               | Foreign Key         |
|   user               | Foreign Key         |
----------------------------------------------

----------------------------------------------
|   Security                                 |
----------------------------------------------
|   id                 | Primary Key         |
|   name               |                     |
|   address            |                     |
|   N_home             |                     |
----------------------------------------------

----------------------------------------------
|   Security_Area                            |
----------------------------------------------
|   id                 | Primary Key         |
|   security           | Foreign Key         |
|   area               | Foreign Key         |
|   is_selected        |                     | -> Seleccionada la seguridad en el área
----------------------------------------------
'''    