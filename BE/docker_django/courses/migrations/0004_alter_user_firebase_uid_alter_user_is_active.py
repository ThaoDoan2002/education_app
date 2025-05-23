# Generated by Django 5.0.8 on 2025-04-14 08:31

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('courses', '0003_user_firebase_uid'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='firebase_uid',
            field=models.CharField(blank=True, max_length=128, null=True, unique=True),
        ),
        migrations.AlterField(
            model_name='user',
            name='is_active',
            field=models.BooleanField(default=False),
        ),
    ]
