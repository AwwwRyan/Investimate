from django.contrib import admin
from .models import User, portfolio, transaction, stock, watchlist

admin.site.register(User)
admin.site.register(portfolio)
admin.site.register(transaction)
admin.site.register(stock)
admin.site.register(watchlist)