# Generated by Django 5.1.1 on 2024-10-08 15:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('API', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='email',
            field=models.EmailField(max_length=255, unique=True),
        ),
        migrations.AlterField(
            model_name='user',
            name='token_phone',
            field=models.CharField(max_length=255),
        ),
    ]
