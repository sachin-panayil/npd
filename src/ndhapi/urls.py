from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("healthCheck", views.health, name="healthCheck"),
]