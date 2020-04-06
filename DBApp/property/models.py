# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Person(models.Model):
    first_name = models.CharField(max_length=15, blank=True, null=False)
    last_name = models.CharField(max_length=20, blank=True, null=False)
    email = models.CharField(max_length=60, blank=True, null=False, primary_key=True)
    
    class Meta:
        managed = False
        db_table = 'person'

class PhoneNumber(models.Model):
    email = models.ForeignKey('Person', models.DO_NOTHING)
    phone_num = models.IntegerField(null=False)

    class Meta:
        managed = False
        db_table = 'phonenumber'

class Employee(models.Model):
    employee_id = models.CharField(max_length=20,primary_key=True)
    worktype = models.CharField(max_length=50)
    salary = models.DecimalField(max_digits=8, decimal_places=2)
    country = models.CharField(max_length=40, null=False)
    email = models.ForeignKey('Person', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'employee'
        unique_together = (('employee_id', 'email'),)

class Subordination(models.Model):
    employee_id = models.ForeignKey(Employee, models.DO_NOTHING, related_name='employee_ids')
    manager_id = models.ForeignKey(Employee, models.DO_NOTHING, related_name='manager_ids')

    class Meta:
        managed = False
        db_table = 'subordination'


class Branch(models.Model):
    country = models.CharField(max_length=40, null=False, primary_key=True)
    manager_id = models.CharField(max_length=10, null=False)

    class Meta:
        managed = False
        db_table = 'branch'


class BranchEmployee(models.Model):
    country = models.OneToOneField('Branch', models.DO_NOTHING)
    employee_id = models.OneToOneField('Employee', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'branch_employee'
        unique_together = (('country', 'employee_id'),)


class SysUser(models.Model):
    user_id = models.CharField(max_length=20,primary_key=True, null=False)
    email = models.ForeignKey('Person', models.DO_NOTHING)
    join_date = models.CharField(max_length=20, null=False)

    class Meta:
        managed = False
        db_table = 'sys_user'
        unique_together = (('user_id', 'email'),)

class Host(models.Model):
    user_id = models.OneToOneField('SysUser', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'host'

class Property(models.Model):
    property_id = models.CharField(max_length=10, null=False, primary_key=True)
    user_id = models.OneToOneField('SysUser', models.DO_NOTHING)
    country = models.OneToOneField('Branch', models.DO_NOTHING)
    perNightFee = models.DecimalField(max_digits=8, decimal_places=2)
    name = models.CharField(max_length=100)
    max_guests = models.IntegerField()
    num_bathrooms = models.IntegerField()
    house_number = models.IntegerField()
    street = models.CharField(max_length=50)
    postal_code = models.CharField(max_length=6)
    city = models.CharField(max_length=50)
    province = models.CharField(max_length=50)
    entire_home = models.BooleanField()
    spark_clean = models.BooleanField()
    wifi = models.BooleanField()
    heating = models.BooleanField()
    description = models.CharField(max_length=250)


    class Meta:
        managed = False
        db_table = 'Property'
        unique_together = (('property_id', 'user_id', 'country'),)



class BookingInfo(models.Model):
    booking_id = models.CharField(max_length=10, null=False, primary_key=True)
    booker_id = models.ForeignKey('SysUser', models.DO_NOTHING)
    sign_date = models.DateField(null=False)
    start_date = models.DateField(null=False)
    end_date = models.DateField(null=False)

    class Meta:
        managed = False
        db_table = 'BookingInfo'
        unique_together = (('booking_id', 'booker_id'),)


class Review(models.Model):
    user_id = models.ForeignKey(SysUser, models.DO_NOTHING)
    property_id = models.ForeignKey(Property, models.DO_NOTHING)
    review_id = models.CharField(max_length=10, null=False)
    review_date = models.DateField(null=False)
    overall_rating = models.IntegerField(null=False)

    class Meta:
        managed = False
        db_table = 'Review'
        unique_together = (('user_id', 'property_id', 'review_id'),)

