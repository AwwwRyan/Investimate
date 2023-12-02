from datetime import date, timedelta
from jugaad_data.nse import stock_df

df = stock_df(symbol="SBIN", from_date=(date.today() - timedelta(days=1)) - timedelta(days=30), to_date=date.today() - timedelta(days=1), series="EQ")

date_prev_close_pairs = {}
data=[]

for index, row in df.iterrows():
    date = row['DATE']  
    prev_close = row['PREV. CLOSE']  
    date_prev_close_pairs[date] = prev_close
for date, prev_close in date_prev_close_pairs.items():
    a={
        'date':date.strftime('%Y-%m-%d'),
        'prevclose':prev_close,
    }
    data.append(a)
print(data)

