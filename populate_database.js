function makeid(length) {
   var result           = '';
   var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
   var charactersLength = characters.length;
   for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
   }
   return result;
}

var fs = require("fs");
var DateGenerator = require('random-date-generator');

var firstnames = fs.readFileSync("first-names.txt", "utf-8");
var firstnames_array = firstnames.split("\r\n")

var lastnames = fs.readFileSync("last-names.txt", "utf-8");
var lastnames_array = lastnames.split("\n")

var words = fs.readFileSync("random-words.txt", "utf-8");
var words_array = words.split("\n")

var countries = fs.readFileSync("countries.txt", "utf-8");
var countries_array = countries.split("\n")

var cities = fs.readFileSync("city_names.txt", "utf-8");
var cities_array = cities.split("\n")

var streets = fs.readFileSync("street-names.txt", "utf-8");
var streets_array = streets.split("\n")

var provinces = fs.readFileSync("prefectures.txt", "utf-8");
var provinces_array = provinces.split("\n")

var numFirstNames = firstnames_array.length;
var numLastNames = lastnames_array.length;
var numWords = words_array.length;
var numCountries = countries_array.length;
var numCities = cities_array.length;
var numStreets = streets_array.length;
var numProvinces = provinces_array.length;

var positions = ['developer', 'human resource', 'marketing', 'researcher', 'accountant', 'analyst']
var numPositions = positions.length;

people_query = 'INSERT INTO \"OnlineTravel\".person(firstname,lastname,email) VALUES';
employee_query = 'INSERT INTO \"OnlineTravel\".employee(employeeid,worktype,salary,country,email) VALUES';
subordination_query = 'INSERT INTO \"OnlineTravel\".subordination(employeeid,managerid) VALUES';
branch_query = 'INSERT INTO \"OnlineTravel\".branch(country,managerid) VALUES';
branch_employee_query = 'INSERT INTO \"OnlineTravel\".branch_employee(country,employeeid) VALUES';

var people = [];
var employees = [];
var countriesInDatabase = 5;

// Creates persons
for (let step = 0; step < 1000; step++) {
	firstname = firstnames_array[Math.floor(Math.random() * numFirstNames)];
	lastname = lastnames_array[Math.floor(Math.random() * numLastNames)];
	email = words_array[Math.floor(Math.random() * numWords)] + "_" + words_array[Math.floor(Math.random() * numWords)] + "@hotmail.com";
	people.push({firstName: firstname, lastName: lastname, email: email})
 	people_query = people_query + " (\'" + firstname + "\', \'" + lastname + "\', \'" + email + "\'),"
}

people_query = people_query.substring(0, people_query.length - 1) + ";"

var numberPeople = people.length;

// Creates managers
for (let step = 0; step < countriesInDatabase; step++) {
	person = people[step];
	employeeID = makeid(10);
	worktype = positions[Math.floor(Math.random() * numPositions)];
	salary = Math.floor(Math.random() * 3) * 1000 + 320000
	countryIndex = Math.floor(Math.random() * numCountries)
	country = countries_array[countryIndex];
	managerid = employeeID;
	email = person.email;
	employees.push({employeeid: employeeID, worktype: worktype, salary: salary, country: country, email: email})
 	employee_query = employee_query + " (\'" + employeeID + "\', \'" + worktype + "\', \'" + salary + "\', \'" + country + "\', \'" + email + "\'),"
}

// Creates employees
for (let step = 0; step < 30; step++) {
	person = people[countriesInDatabase + step];
	manager = employees[Math.floor(Math.random() * countriesInDatabase)];
	employeeID = makeid(10);
	worktype = positions[Math.floor(Math.random() * numPositions)];
	salary = Math.floor(Math.random() * 3) * 1000 + 120000
	country = manager.country;
	managerid = manager.employeeid;
	email = person.email;
	employees.push({employeeid: employeeID, worktype: worktype, salary: salary, country: country, email: email})
 	employee_query = employee_query + " (\'" + employeeID + "\', \'" + worktype + "\', \'" + salary + "\', \'" + country + "\', \'" + email + "\'),"
 	subordination_query = subordination_query + " (\'" + employeeID + "\', \'" + managerid + "\'),"
}

employee_query = employee_query.substring(0, employee_query.length - 1) + ";"
subordination_query = subordination_query.substring(0, subordination_query.length - 1) + ";"

// Creates branches
for (let step = 0; step < countriesInDatabase; step++) {
	manager = employees[step];
	managerid = manager.employeeid;
	country = manager.country;
 	branch_query = branch_query + " (\'" + country + "\', \'" + managerid + "\'),"
}

branch_query = branch_query.substring(0, branch_query.length - 1) + ";"

branch_manager_constraint = "ALTER TABLE \"OnlineTravel\".employee" +
    " ADD CONSTRAINT employee_country_fkey FOREIGN KEY (country)" +
    " REFERENCES \"OnlineTravel\".branch (country);" +
" ALTER TABLE \"OnlineTravel\".branch"+
    " ADD CONSTRAINT employee_country_fkey FOREIGN KEY (managerid)"+
   " REFERENCES \"OnlineTravel\".employee (employeeid);"

// Creates branch_employees
for (let step = 0; step < employees.length; step++) {
	employee = employees[step];
	employeeID = employee.employeeid;
	country = employee.country;
 	branch_employee_query = branch_employee_query + " (\'" + country + "\', \'" + employeeID + "\'),"
}

branch_employee_query = branch_employee_query.substring(0, branch_employee_query.length - 1) + ";"

num_employees = employees.length;

user_query = 'INSERT INTO \"OnlineTravel\".sys_user(userid,joindate,email) VALUES';

var users = []

// Creates system_users
for (let step = 0; step < 200; step++) {
	person = people[num_employees + step];
	userid = makeid(10);
	date = Math.floor(Math.random() * 30) + 1
	month = Math.floor(Math.random() * 12) + 1
	year = Math.floor(Math.random() * 10) + 2010
	if (date < 10){
		date = "0" + date
	}
	if (month < 10){
		month = "0" + month
	}
	email = person.email;
	full_date = "" + year + "-" + month + "-" + date
	users.push({userid: userid, joinDate: full_date, email: email})
 	user_query = user_query + " (\'" + userid + "\', \'" + full_date + "\', \'" + email + "\'),"
 }

user_query = user_query.substring(0, user_query.length - 1) + ";"

phonenumber_query = 'INSERT INTO \"OnlineTravel\".phonenumber(email,phonenum) VALUES';

// Creates phone numbers
for (let step = 0; step < people.length; step++) {
	person = people[step];
	email = person.email;
	for (let random_step = 0; random_step < Math.floor(Math.random() * 3) + 1; random_step++) {
		number = Math.floor(Math.random() * 89999999) + 10000000
		phonenumber_query = phonenumber_query + " (\'" + email + "\', " + number + "),"
	}
}

phonenumber_query = phonenumber_query.substring(0, phonenumber_query.length - 1) + ";"

// Creates hosts
hosts = []
host_query = 'INSERT INTO \"OnlineTravel\".host(userid) VALUES';
for (let step = 0; step < 150; step++) {
	user = users[step];
	userid = user.userid
	hosts.push({userid: userid})
 	host_query = host_query + " (\'" + userid + "\'),"
 }

host_query = host_query.substring(0, host_query.length - 1) + ";"

// Creates properties
properties = []
property_query = 'INSERT INTO \"OnlineTravel\".property(propertyID,userID,country,perNightFee,name,maxguests,' + 
					'numbathrooms,houseNumber,street,postalCode,city,province,entireHome,sparkClean,wifi,heating,description) VALUES';
featureOptions = ['FALSE', 'TRUE', 'NULL']
for (let step = 0; step < hosts.length; step++) {
	user = users[step];
	userid = user.userid
	propertyID = makeid(10);
	perNightFee = Math.floor(Math.random() * 100) + 20
	country = employees[Math.floor(Math.random() * countriesInDatabase)].country;
	name = "Best " + words_array[Math.floor(Math.random() * numWords)] + " " + words_array[Math.floor(Math.random() * numWords)] + 
			" in lovely " + words_array[Math.floor(Math.random() * numWords)];
	maxguests = Math.floor(Math.random() * 5)
	numbathrooms = Math.floor(Math.random() * 3)
	houseNumber = Math.floor(Math.random() * 10000)
	postalcode = makeid(6);
	street = streets_array[Math.floor(Math.random() * numStreets)];
	city = cities_array[Math.floor(Math.random() * numCities)];
	province = provinces_array[Math.floor(Math.random() * numProvinces)];
	description = "This house is the best " + words_array[Math.floor(Math.random() * numWords)] + 
				" "  + words_array[Math.floor(Math.random() * numWords)] + "."
	entireHome = featureOptions[Math.floor(Math.random() * 3)];
	sparkClean = featureOptions[Math.floor(Math.random() * 3)];
	wifi = featureOptions[Math.floor(Math.random() * 3)];
	heating = featureOptions[Math.floor(Math.random() * 3)];
	properties.push({propertyID: propertyID, userid: userid, country: country, perNightFee: perNightFee, name: name, maxguests: maxguests,
					numbathrooms: numbathrooms, houseNumber: houseNumber, street: street, postalcode: postalcode, city: city, province: province,
					entireHome: entireHome, sparkClean: sparkClean, wifi: wifi, heating: heating, description: description})
 	property_query = property_query + " (\'" + propertyID + "\', \'" + userid + "\', \'" + country + "\', " + perNightFee + 
 					", \'" + name + "\', " + maxguests + ", " + numbathrooms + ", " + houseNumber + ", \'" + street + 
 					"\', \'" + postalcode + "\', \'" + city + "\', \'" + province + "\', " + entireHome + ", " + sparkClean +
 					", " + wifi + ", " + heating + ", \'" + description + "\'),"
}

property_query = property_query.substring(0, property_query.length - 1) + ";"

// Creates BookingInfo
booking_query = 'INSERT INTO \"OnlineTravel\".booking_info(bookingID,bookerID,signDate,startDate,endDate,paymentType,paymentComplete,' + 
					'propertyID,totalCost) VALUES';
numProperties = properties.length
numUsers = users.length
paymentTypes = ['VISA', 'Debit', 'Wire']

let minimum_date = new Date(2020, 1, 1);
for (let step = 0; step < 150; step++) {
	bookingID = makeid(10);
	user = users[Math.floor(Math.random() * numUsers)];
	userid = user.userid
	property = properties[Math.floor(Math.random() * numProperties)];
	propertyID = property.propertyID;
	perNightFee = property.perNightFee

	daysToRent = Math.floor(Math.random() * 20)
	signDate = new Date(minimum_date.getFullYear(), minimum_date.getMonth(), minimum_date.getDate() + Math.floor(Math.random() * 60));
	startDate = new Date(signDate.getFullYear(), signDate.getMonth(), signDate.getDate() + Math.floor(Math.random() * 200));
	endDate = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + Math.floor(Math.random() * daysToRent) + 1);
	signDate = signDate.toISOString().slice(0, 10)
	startDate = startDate.toISOString().slice(0, 10)
	endDate = endDate.toISOString().slice(0, 10)

	paymentType = paymentTypes[Math.floor(Math.random() * 3)];
	totalCost = perNightFee * daysToRent
 	booking_query = booking_query + " (\'" + bookingID + "\', \'" + userid + "\', \'" + signDate + "\', \'" + startDate + "\', \'" + endDate + 
 					"\', \'" + paymentType + "\', FALSE, \'" + propertyID + "\', " + totalCost + "),"
}

booking_query = booking_query.substring(0, booking_query.length - 1) + ";"

// Creates Review
review_query = 'INSERT INTO \"OnlineTravel\".review(userID,reviewID,propertyID,reviewDate,overallRating) VALUES';

for (let step = 0; step < 150; step++) {
	reviewID = makeid(10);
	user = users[Math.floor(Math.random() * numUsers)];
	userid = user.userid
	property = properties[Math.floor(Math.random() * numProperties)];
	propertyID = property.propertyID;
	date = new Date(minimum_date.getFullYear(), minimum_date.getMonth(), minimum_date.getDate() + Math.floor(Math.random() * 60));
	date = date.toISOString().slice(0, 10);
	overallRating = Math.floor(Math.random() * 11)
 	review_query = review_query + " (\'" + userid + "\', \'" + reviewID + "\', \'" + propertyID + "\', \'" + date + 
 					"\', " + overallRating + "),"
}

review_query = review_query.substring(0, review_query.length - 1) + ";"

const { Client } = require('pg')

const client = new Client({
	user: 'postgres',
	host: 'localhost',
	database: 'postgres',
	password: 'XXXXXXXXX',
	port: 5432
})
client.connect().then(() => console.log('connected')).catch(err => console.error('connection error', err.stack))

client.query(people_query, (err, res) => {
	if (err) {
		throw err
	}
	console.log("Successfully created people")
})

client.query(phonenumber_query, (err, res) => {
	if (err) throw err
	console.log("Successfully created phone numbers")
})

client.query(user_query, (err, res) => {
	if (err) throw err
	console.log("Successfully created users")
})

client.query(employee_query, (err, res) => {
	if (err) throw err
	console.log("Successfully created employees")
})

client.query(branch_query, (err, res) => {
	if (err) throw err
	console.log("Successfully created branches")
})

client.query(branch_manager_constraint, (err, res) => {
	if (err) throw err
	console.log("Successfully created foreign key referencing between branch and manager")
})

client.query(branch_employee_query, (err, res) => {
	if (err) throw err
	console.log("Successfully created relationship set between employee and their branches")
})

client.query(subordination_query, (err, res) => {
	if (err) throw err
	console.log("Successfully created subordination relationships")
})

client.query(host_query, (err, res) => {
	if (err) throw err
	console.log("Successfully created hosts")
})

client.query(property_query, (err, res) => {
	if (err) throw err
	console.log("Successfully created properties")
})

client.query(booking_query, (err, res) => {
	if (err) throw err
	console.log("Successfully created bookings")
})

client.query(review_query, (err, res) => {
	if (err) throw err
	console.log("Successfully created reviews")
	client.end()
})