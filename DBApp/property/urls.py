from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('bookingInfo/', views.BookingInfo, name='booking'),
    path('results/', views.results, name='results'),
]
