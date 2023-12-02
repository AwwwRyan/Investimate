from django.db import models

class User(models.Model):
    id=models.BigIntegerField(primary_key=True)
    username = models.CharField(max_length=50)
    password = models.CharField(max_length=20)
    dob = models.DateField()
    rubies = models.DecimalField(default=10000,decimal_places=4,max_digits=15)
    curr_inv = models.DecimalField(default=0,decimal_places=4,max_digits=15)

    def __str__(self):
        return self.username


class portfolio(models.Model):
    id=models.AutoField(primary_key=True)
    user_id = models.IntegerField()
    stock_id = models.CharField(max_length=20)
    amount = models.DecimalField(decimal_places=4,max_digits=15)
    holdings = models.IntegerField(default=0)
    type = models.CharField(max_length=5,default='')
    def __str__(self):
        return self.stock_id


class transaction(models.Model):
    date_bought = models.DateField()
    time_bought = models.TimeField()
    user_id = models.IntegerField()
    amount = models.DecimalField(decimal_places=4,max_digits=15)

class stock(models.Model):
    stockname = models.CharField(max_length=50)
    stoc_id = models.CharField(max_length=20)

    def __str__(self):
        return (self.stockname + " " + self.stoc_id)

class watchlist(models.Model):
    id=models.AutoField(primary_key=True)
    user_id = models.IntegerField()
    stock_id = models.CharField(max_length=20)
    ideal_buy = models.DecimalField(decimal_places=4,max_digits=15)
    ideal_sell = models.DecimalField(decimal_places=4,max_digits=15)
    def __str__(self):
        return self.stock_id