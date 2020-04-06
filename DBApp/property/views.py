from django.http import HttpResponse
from django.views import generic
from django.shortcuts import get_object_or_404, render
from django.urls import reverse
from django.template import loader
from datetime import date

from .models import Property, BookingInfo, Person

curr_date = str(date.today())

def results(request):
    #query = "SELECT * FROM public.property AS H INNER JOIN public.room AS R ON R.property_id = H.property_id and R.chain_id = H.chain_id WHERE city = '" + location + "' AND capacity = '" + capacity + "' "
    properties_list = Property.objects.all()
    template = loader.get_template('properties.html')
    context = {
        'properties_list': properties_list,
    }
    return HttpResponse(template.render(context, request))


def index(request):
    properties_list = []

    if('search' in request.GET):
        location = request.GET['location'].capitalize()
        indate = request.GET['indate']
        outdate = request.GET['outdate']
        capacity = request.GET['capacity'].lower()
        query = "SELECT e.property_id, e.user_id, e.country, e.perNightFee, e.name, e.max_guests, e.num_bathrooms, e.house_number, e.street, e.postal_code, e.city, e.province, e.entire_home, e.spark_clean, e.wifi, e.heating, e.description From property e WHERE e.house_number NOT IN(SELECT house_number FROM bookingInfo WHERE NOT(('"+indate+"' < bookingInfo.start_date AND '"+indate+"' < bookingInfo.start_date) OR('"+outdate+"' > bookingInfo.end_date AND '"+outdate+"' > bookingInfo.end_date)) AND 1=bookingInfo.property_id AND 1=bookingInfo.house_number) AND e.num_guests = '"+capacity + "' AND e.city = '"+location+"'"
        properties_list = Property.objects.raw(query)



    return render(request, 'properties-searchbar.html', {'properties_list': properties_list})


def booking(request):
    
    mylist = BookingInfo.objects.select_related('host')
    
    if('dateSearch' in request.GET):
        date = request.GET['date']
        
        mylist = BookingInfo.objects.filter(from_date = date).select_related('host')
        

    if request.method == "POST":
        if ('property_id' in request.POST):
            stat = request.POST['status']
            property_obj = BookingInfo.objects.get(BookingInfo_id = request.POST['property_id'])
            property_obj.status = stat
            property_obj.save(update_fields=['status'])
    
    #if request.method == "POST":
     #   if ('book_submit' in request.POST):
     #       BookingInfoidcount = BookingInfo.objects.all().count()+1
     #       res = BookingInfo(BookingInfo_id=BookingInfoidcount)
     #       res.chain_id = request.POST['chain_id']
     ##       res.property_id = request.POST['property_id']
     #       room = get_object_or_404(
     #           Room, room_num=request.POST['room_num'], chain_id=request.POST['chain_id'], property_id=request.POST['property_id'])
     #       res.room_num = room
     #       res.person_id = request.POST['cust_id']
     #      res.from_date = request.POST['indate']
     #      res.to_date = request.POST['outdate']
     #      res.status = request.POST['status']
      #      res.save()

    return render(request, 'bookingInfo.html', {'mylist':mylist})
