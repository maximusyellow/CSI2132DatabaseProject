set search_path = 'OnlineTravel';

create table person (
	firstName char(15) not null,
	lastName char(20) not null,
	email varchar(60) not null,
	primary key (email)
);

create table phonenumber (
	email varchar(60) not null,
	phonenum int not null,
	primary key (email, phonenum),
	foreign key (email) references person
);

create table employee (
	employeeID varchar(10) not null,
	worktype char(50),
	salary numeric(8,2),
	country char(40) not null,
	email varchar(60) not null,
	primary key (employeeID),
	foreign key (email) references person
);

create table subordination(
	employeeID varchar(10) not null,
	managerID varchar(10) not null,
	primary key (employeeID, managerID),
	foreign key (employeeID) references employee,
	foreign key (managerID) references employee
);

create table branch (
	country char(40) not null,
	managerID varchar(10) not null,
	primary key (country)
);

create table branch_employee (
	country char(40) not null,
	employeeID varchar(10) not null,
	primary key (country, employeeID),
	foreign key (country) references branch,
	foreign key (employeeID) references employee
);

create table sys_user (
	userID varchar(10) not null,
	joinDate char(20) not null,
	email varchar(60) not null,
	primary key (userID),
	foreign key (email) references person
);

create table host (
	userID varchar(10) not null,
	primary key (userID),
	foreign key (userID) references sys_user
);

create table property (
	propertyID varchar(10) not null,
	userID varchar(10) not null,
	country char(40) not null,
	perNightFee numeric(8,2),
	name char(100),
	maxguests int,
	numbathrooms int,
	houseNumber int,
	street char(50),
	postalCode varchar(6),
	city char(50),
	province char(50),
	entireHome boolean,
	sparkClean boolean,
	wifi boolean,
	heating boolean,
	description varchar(250),
	primary key (propertyID),
	foreign key (userID) references sys_user,
	foreign key (country) references branch
);

create table booking_info(
	bookingID varchar(10) not null,
	bookerID varchar(10) not null,
	signDate date not null,
	startDate date not null,
	endDate date not null,
	paymentType char(10) not null,
	paymentComplete boolean not null,
	propertyID varchar(10) not null,
	totalCost numeric(8,2) not null,
	primary key (bookingID),
	foreign key (propertyID) references property,
	foreign key (bookerID) references sys_user
);

create table review(
	userID varchar(10) not null,
	reviewID varchar(10) not null,
	propertyID varchar(10) not null,
	reviewDate date not null,
	overallRating int not null,
	primary key (reviewID),
	foreign key (userID) references sys_user,
	foreign key (propertyID) references property
);
