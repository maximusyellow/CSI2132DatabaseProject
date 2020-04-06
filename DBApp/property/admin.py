from django.contrib import admin

# Register your models here.
from .models import Employee, Property, Host, Person
admin.site.register(Employee)
admin.site.register(Property)
admin.site.register(Host)
admin.site.register(Person)