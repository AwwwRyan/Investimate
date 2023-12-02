from .models import *
from .serializer import watchlistSerializer,portfolioSerializer,userauthSerializer
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
from jugaad_data.nse import NSELive
from django.core.exceptions import ObjectDoesNotExist 
from datetime import date, timedelta
from jugaad_data.nse import stock_df


n = NSELive()

@api_view(['GET'])
def graph(request, stockid, day):
    if request.method == 'GET':
        day = day
        df = stock_df(symbol=stockid, 
                      from_date=(date.today() - timedelta(days=1)) - timedelta(days=day), 
                      to_date=date.today() - timedelta(days=1), 
                      series="EQ")
        date_prev_close_pairs = {}
        data = []
        for index, row in df.iterrows():
            row_date = row['DATE']  
            prev_close = row['PREV. CLOSE']
            date_prev_close_pairs[row_date] = prev_close
        for row_date, prev_close in date_prev_close_pairs.items():
            a = {'date': row_date.strftime('%Y-%m-%d'), 'prevclose': prev_close}
            data.append(a)
        return Response(data)

@api_view(['GET'])
def allstocks(request,stockid):
    if request.method=='GET':
        q = n.stock_quote(stockid)
        stocks = stock.objects.filter(stoc_id=stockid).first()
        a={'stockname': stocks.stockname,
            'priceInfo':q['priceInfo']['lastPrice'],
           'change':q['priceInfo']['change'],
           'pChange':q['priceInfo']['pChange'],
           'prevClose':q['priceInfo']['previousClose'],
           'open':q['priceInfo']['open'],
           'close':q['priceInfo']['close'],
           'vwap':q['priceInfo']['vwap'],
           'lowerCP':q['priceInfo']['lowerCP'],
           'upperCP':q['priceInfo']['upperCP'],
           'basePrice':q['priceInfo']['basePrice'],
           'intradayhigh':q['priceInfo']['intraDayHighLow']['max'],
           'intradaylow':q['priceInfo']['intraDayHighLow']['min']}
        
        return Response(a)

@api_view(['GET'])
def watchlist_get(request, id):
    if request.method == "GET":
        watchlists = watchlist.objects.filter(user_id=id)

        data = []
        for item in watchlists:
            q = n.stock_quote(item.stock_id)
            c=q['priceInfo']['change']

            stock_data = {
                "stock_id": item.stock_id,
                "lastPrice": float(q['priceInfo']['lastPrice']),
                "ideal_buy": item.ideal_buy,
                "ideal_sell": item.ideal_sell,
                "change":c
            }
            data.append(stock_data)

        return Response(data)

@api_view(['GET'])
def watchlist_four(request, id):
    if request.method == "GET":
        data = []
        watchlists = watchlist.objects.filter(user_id=id).order_by('-id')[:4][::-1]

        for i in watchlists:
            q = n.stock_quote(i.stock_id)
            stocks = stock.objects.filter(stoc_id=i.stock_id).first()
            try:

                fourdata = {
                    'stock_id': i.stock_id,
                    'stockname': stocks.stockname,
                    'lastPrice': float(q['priceInfo']['lastPrice']),
                    'pChange': q['priceInfo']['pChange'],
                }
                data.append(fourdata)
            except:
                continue
        return Response(data)

@api_view(['POST','GET'])
def watchlist_add(request):
    user_id = request.data.get('user_id')
    stock_id = request.data.get('stock_id')
    watchlist_obj = None

    try:
        watchlist_obj = watchlist.objects.get(user_id=user_id, stock_id=stock_id)
    except ObjectDoesNotExist:  
        serializer = watchlistSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors)
    
    if watchlist_obj:
        new_buy = request.data.get('ideal_buy', 0)
        new_sell = request.data.get('ideal_sell', 0)

        watchlist_obj.ideal_buy = new_buy
        watchlist_obj.ideal_sell = new_sell
        watchlist_obj.save()

        serializer = watchlistSerializer(watchlist_obj)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
@api_view(['POST','GET','PUT'])
def portfolio_views(request,type):
        user_id = request.data.get('user_id')
        stock_id = request.data.get('stock_id')

        try:
            portfolio_obj = portfolio.objects.get(user_id=user_id, stock_id=stock_id)
        except portfolio.DoesNotExist:
            portfolio_obj = None

        if portfolio_obj:
            existing_holdings = portfolio_obj.holdings
            existing_amount = portfolio_obj.amount
            new_holdings = request.data.get('holdings', 0)
            new_amount = request.data.get('amount', 0)
            if type == 'buy':
                portfolio_obj.holdings = float(existing_holdings) + float(new_holdings)
                portfolio_obj.amount = float(existing_amount) + float(new_amount)
            if type =='sell':
                portfolio_obj.holdings = float(existing_holdings) - float(new_holdings)
                portfolio_obj.amount = float(existing_amount) - float(new_amount)
            portfolio_obj.save()

            serializer = portfolioSerializer(portfolio_obj)
            return Response(serializer.data, status=status.HTTP_200_OK)

        serializer = portfolioSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def portfolio_header(request,id):
    if request.method=='GET':
        hold=portfolio.objects.filter(user_id=id)
        invested=0.0
        net=0.0
        for i in hold:
            q = n.stock_quote(i.stock_id)
            invested+=float(i.amount)*i.holdings
            net+=float(q['priceInfo']['lastPrice']) * i.holdings
        return Response({"invested_amt":invested,"netvalue":net})
    
@api_view(['GET'])
def portfolio_page(request,id):
    if request.method=='GET':
        port=portfolio.objects.filter(user_id=id)
        portfolio_data=[]
        for i in port:
            q = n.stock_quote(i.stock_id)
            lp=q['priceInfo']['lastPrice']
            c=q['priceInfo']['change']

            data={
                'stock_id': i.stock_id,
                'lastprice':lp,
                'holdings':i.holdings,
                'change':c                
            }
            portfolio_data.append(data)
            print("hello")
            
        return Response(portfolio_data)
    
        
@api_view(['GET'])
def searching(request, sl):
    if request.method == 'GET':
        sl = sl.upper()
        st = stock.objects.filter(stoc_id__startswith=sl)
        amt = []
        for i in st:
            q = n.stock_quote(i.stoc_id)

            try:
                lp = q['priceInfo'].get('lastPrice', None)
                pc = q['priceInfo'].get('pChange', None)

                data = {
                    'stoc_id': i.stoc_id,
                    'last_price': float(lp),
                    'percent_change': float(pc),
                }
                amt.append(data)
            except:
                continue

        return Response(amt)
    
@api_view(['POST','PUT'])
def user_login(request):
    id = request.data["id"]
    if request.method=='PUT':
        try:
            user = User.objects.get(pk = id)
        except User.DoesNotExist:
            return Response({"status":0})
        serializer = userauthSerializer(user,data = request.data)
        print(request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"status":1})
        else :
            return Response(serializer.errors)
        
    if request.method == 'POST':
        pw = request.data["password"]
        try:
            user = User.objects.get(pk = id)
        except User.DoesNotExist:
            return Response({"status":0})
        if user.password==pw:
            serializer = userauthSerializer(user)
            return Response({"status":1 ,"data": serializer.data})
        else:
            return Response({"status":2})

@api_view(['POST','PUT'])
def create_user(request):
    if request.method == 'POST':
       serializer = userauthSerializer(data= request.data)
       if serializer.is_valid():
           serializer.save()
           return Response({"status":1,"data":serializer.data})
       return Response(serializer.errors)

@api_view(['GET'])
def get_user_rubies(request, id):
    try:
        user = User.objects.get(pk=id)
        return Response(user.rubies)
    except User.DoesNotExist:
        return Response({"error": "User not found"}, status=404)

@api_view(['PUT'])
def update_user_rubies(request, id, rubies):
    try:
        user = User.objects.get(pk=id)
    except User.DoesNotExist:
        return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'PUT':
        try:
            new_rubies = float(rubies)
            user.rubies = new_rubies
            user.save()
            return Response({"message": "Rubies updated successfully"})
        except (TypeError, ValueError):
            
            return Response({"error": "Invalid rubies value"}, status=status.HTTP_400_BAD_REQUEST)