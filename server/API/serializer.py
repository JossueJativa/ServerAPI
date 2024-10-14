from rest_framework import serializers
from .models import *

class HomeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Home
        fields = '__all__'

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            'username',
            'password',
            'first_name',
            'last_name',
            'email',
            'token_phone'
        ]

class AreaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Area
        fields = '__all__'

class Home_UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Home_User
        fields = '__all__'

class SecuritySerializer(serializers.ModelSerializer):
    class Meta:
        model = Security
        fields = '__all__'

class Security_AreaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Security_Area
        fields = '__all__'