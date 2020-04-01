# Query 1
select firstname, lastname, totalcost as rental_price, signdate, 
country as branch, paymenttype, paymentcomplete as payment_status
from person natural join sys_user natural join booking_info natural join property
order by paymenttype asc, signdate desc;

# Query 2
create view GuestListView as 
	(select firstname, lastname, email, joindate as join_date, userid as guest_id, country as branch_id
		from (person natural join sys_user), booking_info natural join (select propertyid, country from property) as simple_property
		where userid = bookerid);

# Query 3
select * 
from person natural join sys_user, booking_info
where userid = bookerid
order by totalcost asc limit 1;

# Query 4
select *, country as branch_id
from (select propertyid, avg(overallRating) as average_rating
	  from review group by propertyid) as average_review natural join 
	  (select distinct property.* 
	   from property natural join booking_info) as rented_properties
order by branch_id asc, average_rating asc;

# Query 5
select distinct property.*
from property left join booking_info on property.propertyid = booking_info.propertyid
where booking_info.propertyid is null;

# Query 6
select property.*, startdate, enddate
from property natural join booking_info
where (EXTRACT(DAY FROM startdate) <= 10 and EXTRACT(DAY FROM enddate) >= 10) or 
(EXTRACT(MONTH FROM startdate) < EXTRACT(MONTH FROM enddate) and EXTRACT(DAY FROM enddate) >= 10);

# Query 7 - note: managers are considered to be employees
select distinct employee_with_names.employeeid, salary, firstname, lastname, country as branch_id, country as branch_name, managerid
from (person natural join employee) as employee_with_names, subordination
where (employee_with_names.employeeid = subordination.employeeid 
	   or employee_with_names.employeeid = subordination.managerid) and salary >= 15000
order by managerid asc, employeeid asc;

# Query 8
create view Bill as 
	(select firstname as host_first_name, lastname as host_last_name, housenumber, 
		street, postalcode, city, province, totalcost as paid_amount, paymenttype
		from property natural join (select totalcost, paymenttype, propertyid from booking_info) as simple_info
		natural join host natural join sys_user natural join person
	limit 1);

# Query 9 - we assume that the query knows which number to update, what number to update to, 
# and the email of the user that needs updating
update phonenumber set phonenumber = 9999999 where phonenumber = 1234567 and email = 'uttergarbage@hotmail.com';

# Query 10
create function FirstNameFirst (firstName varchar(15), lastname varchar(15))
	returns varchar(31)
	return firstname + " " + lastname as full_name;
end;