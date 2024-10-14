from django.urls import path, include
from rest_framework import routers
from . import views

app_name = "api"

router = routers.DefaultRouter()

router.register(r'home', views.HomeViewSet)
router.register(r'user', views.UserViewSet)
router.register(r'area', views.AreaViewSet)
router.register(r'home_user', views.Home_UserViewSet)
router.register(r'security', views.SecurityViewSet)
router.register(r'security_area', views.Security_AreaViewSet)

urlpatterns = [
    path('', include(router.urls)),
]