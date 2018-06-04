
from django.conf.urls import url

from . import views

app_name = 'chat'

urlpatterns = [
    url('^$', views.index, name='index'),
    url('^(?P<room_name>[^/]+)/$', views.room, name='room'),
]
