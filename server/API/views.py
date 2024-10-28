import json

from .firebase.firebase_config import send_fcm_message
from .serializer import *
from .models import *
import requests
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework_simplejwt.tokens import RefreshToken

from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi

class HomeViewSet(viewsets.ModelViewSet):
    queryset = Home.objects.all()
    serializer_class = HomeSerializer

    @action(detail=False, methods=['post'])
    @swagger_auto_schema(
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'message': openapi.Schema(type=openapi.TYPE_STRING),
                'homeId': openapi.Schema(type=openapi.TYPE_INTEGER)
            }
        )
    )
    def send_message(self, request):
        message = request.data.get('message')
        homeId = request.data.get('homeId')

        home = Home.objects.get(pk=homeId)

        if home is not None:
            url_home = home.HomeAssistant_Url
            token_home = home.HomeAssistant_Token

            url = url_home + '/api/services/shopping_list/add_item'

            headers = {
                "Authorization": f"Bearer {token_home}",
                "Content-Type": "application/json"
            }

            data = {
                'name': message
            }

            response = requests.post(
                url,
                headers=headers,
                data=json.dumps(data)
            )

            if response.status_code == 200: 
                return Response({
                    'info': 'message is received from HA'
                }, status=200)
            else:
                return Response({
                    'info': response
                }, status=400)

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    @action(detail=False, methods=['post'])
    @swagger_auto_schema(
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'username': openapi.Schema(type=openapi.TYPE_STRING),
                'password': openapi.Schema(type=openapi.TYPE_STRING)
            }
        )
    )
    def login(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        if username is None or password is None:
            return Response({'detail': 'Username and password are required.'}, status=400)

        user = User.objects.get(username=username)

        if password is None or not user.check_password(password):
            if user is not None:
                refresh = RefreshToken.for_user(user)
                return Response({
                    'is_login': True,
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                    'token_phone': user.token_phone,
                    'id': user.id
                }, status=200)

        return Response({'detail': 'Invalid credentials'}, status=404)

class AreaViewSet(viewsets.ModelViewSet):
    queryset = Area.objects.all()
    serializer_class = AreaSerializer

    @swagger_auto_schema(
        manual_parameters=[
            openapi.Parameter('home_id', openapi.IN_QUERY, description="Requiere home ID number", type=openapi.TYPE_INTEGER)
        ]
    )
    @action(detail=False, methods=['get'])
    def HelpBtn(self, request):
        home_id = request.query_params.get('home_id')

        if home_id is not None:
            home_id = int(home_id)
            home = Home_User.objects.get(home=home_id)
            home_area = Home.objects.get(pk=home.home.id)
            area = Area.objects.get(pk=home_area.area.id)

            homes = Home.objects.filter(area=area)

            try:
                security = Security_Area.objects.filter(area=area)
                for sec in security:
                    sec = Security.objects.get(pk=sec.security.id)
                    url = sec.url_home + '/api/services/notify/persistent_notification'
                    print(url)
                    token = sec.token_home
                    print(token)

                    headers = {
                        "Authorization": f"Bearer {token}",
                        "Content-Type": "application/json"
                    }
                    data = {
                        'message': f'Home {home_id} needs help',
                        'title': f'Help Button {home_id}'
                    }

                    requests.post(
                        url,
                        headers=headers,
                        data=json.dumps(data)
                    )
            except:
                return Response({
                    'info': 'message is sent to all users in the area'
                }, status=200)
                    

            for home in homes:
                home = Home_User.objects.get(pk=home.id)
                user = User.objects.get(pk=home.user.id)
                token_fcm = user.token_phone

                send_fcm_message(token_fcm, 'Help Button', f'Home {home_id} needs help')

            return Response({
                'info': 'message is sent to all users in the area'
            }, status=200)
        else:
            return Response({
                'info': 'home_id is required'
            }, status=400)

class Home_UserViewSet(viewsets.ModelViewSet):
    queryset = Home_User.objects.all()
    serializer_class = Home_UserSerializer

    @swagger_auto_schema(
        manual_parameters=[
            openapi.Parameter('user', openapi.IN_QUERY, description="Optional user number", type=openapi.TYPE_INTEGER)
        ]
    )
    def list(self, request, *args, **kwargs):
        user_id = request.query_params.get('user')

        if user_id is not None:
            user_id = int(user_id)
            user = User.objects.get(pk=user_id)
            home_user = Home_User.objects.filter(user=user)
            data = {
                'user': user.id
            }

            data['home'] = []

            for home_user_instance in home_user:
                home = Home.objects.get(pk=home_user_instance.home.id)
                home_data = {
                    'id': home.id,
                    'url': home.HomeAssistant_Url,
                    'token': home.HomeAssistant_Token,
                    'is_deleted': home.is_deleted,
                    'help_btn': home.help_btn,
                    'area': home.area.name
                }
                data['home'].append(home_data)

            return Response(data)
        else:
            home_user = self.queryset

        serializer = Home_UserSerializer(home_user, many=True)
        return Response(serializer.data)
    
    @swagger_auto_schema(
        manual_parameters=[
            openapi.Parameter('user', openapi.IN_QUERY, description="Optional user number", type=openapi.TYPE_INTEGER),
            openapi.Parameter('home', openapi.IN_QUERY, description="Optional home number", type=openapi.TYPE_INTEGER)
        ]
    )
    def destroy(self, request, *args, **kwargs):
        user_id = request.query_params.get('user')
        home_id = request.query_params.get('home')

        if user_id is not None and home_id is not None:
            user_id = int(user_id)
            home_id = int(home_id)
            user = User.objects.get(pk=user_id)
            home = Home.objects.get(pk=home_id)

            home_user = Home_User.objects.get(user=user, home=home)
            home_user.delete()

            return Response({
                'info': 'home_user deleted'
            }, status=200)
        else:
            return Response({
                'info': 'user and home are required'
            }, status=400)

class SecurityViewSet(viewsets.ModelViewSet):
    queryset = Security.objects.all()
    serializer_class = SecuritySerializer

class Security_AreaViewSet(viewsets.ModelViewSet):
    queryset = Security_Area.objects.all()
    serializer_class = Security_AreaSerializer