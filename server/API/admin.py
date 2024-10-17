from django.contrib import admin
from .models import User, Area, Home, Home_User, Security, Security_Area

# Register your models here.

admin.site.register(User)
admin.site.register(Area)
admin.site.register(Home)
admin.site.register(Home_User)
admin.site.register(Security)
admin.site.register(Security_Area)