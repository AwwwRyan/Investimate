from rest_framework import serializers
from .models import watchlist
from .models import User,portfolio

class userauthSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id','username', 'password', 'dob', 'rubies','curr_inv']

class watchlistSerializer(serializers.ModelSerializer):
    class Meta:
        model=watchlist
        fields=['id','user_id','stock_id','ideal_buy','ideal_sell']

class portfolioSerializer(serializers.ModelSerializer):
    class Meta:
        model = portfolio
        fields=['id','user_id','stock_id','amount','holdings','type']
