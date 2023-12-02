"""
URL configuration for invsetimate project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from invsetimate import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('stock/<str:stockid>',views.allstocks),
    path('watchlist/',views.watchlist_add),
    path('portfolio/<str:type>',views.portfolio_views),
    path('portfolioheader/<int:id>',views.portfolio_header),
    path('watchlistview/<int:id>',views.watchlist_get),
    path('watchlistfour/<int:id>',views.watchlist_four),
    path('portfoliolist/<int:id>',views.portfolio_page),
    path('graphstocks/<str:stockid>/<int:day>',views.graph),
    path('searching/<str:sl>',views.searching),
    path('loginpage/',views.user_login),
    path('regipage/',views.create_user),
    path('rubie/<int:id>',views.get_user_rubies),
    path('updaterubies/<int:id>/<str:rubies>',views.update_user_rubies),
]
