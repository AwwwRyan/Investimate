# Generated by Django 4.2.5 on 2023-09-16 09:00

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='portfolio',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('user_id', models.IntegerField()),
                ('stock_id', models.CharField(max_length=20)),
                ('amount', models.DecimalField(decimal_places=4, max_digits=15)),
            ],
        ),
        migrations.CreateModel(
            name='stock',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('stockname', models.CharField(max_length=50)),
                ('stoc_id', models.CharField(max_length=20)),
            ],
        ),
        migrations.CreateModel(
            name='transaction',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date_bought', models.DateField()),
                ('time_bought', models.TimeField()),
                ('user_id', models.IntegerField()),
                ('amount', models.DecimalField(decimal_places=4, max_digits=15)),
            ],
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('username', models.CharField(max_length=50)),
                ('user_name', models.CharField(default='', max_length=50)),
                ('password', models.CharField(max_length=20)),
                ('dob', models.DateField()),
                ('rubies', models.DecimalField(decimal_places=4, default=0, max_digits=15)),
                ('curr_inv', models.DecimalField(decimal_places=4, max_digits=15)),
            ],
        ),
        migrations.CreateModel(
            name='watchlist',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('user_id', models.IntegerField()),
                ('stock_id', models.CharField(max_length=20)),
                ('ideal_buy', models.DecimalField(decimal_places=4, max_digits=15)),
                ('ideal_sell', models.DecimalField(decimal_places=4, max_digits=15)),
            ],
        ),
    ]
