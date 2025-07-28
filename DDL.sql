-- DDL
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Hotels CASCADE;
DROP TABLE IF EXISTS HotelManagers CASCADE;
DROP TABLE IF EXISTS Review CASCADE;
DROP TABLE IF EXISTS Loyalty_program CASCADE;
DROP TABLE IF EXISTS Room CASCADE;
DROP TABLE IF EXISTS Reservations CASCADE;
DROP TABLE IF EXISTS Payments CASCADE;
DROP TABLE IF EXISTS Administrators CASCADE;
DROP TABLE IF EXISTS Languages CASCADE;
DROP TABLE IF EXISTS Administrator_Language CASCADE;
DROP TABLE IF EXISTS Hotel_HotelManager CASCADE;
DROP TABLE IF EXISTS Hotel_Administrators CASCADE;
DROP TABLE IF EXISTS User_Hotel CASCADE;

DROP TYPE IF EXISTS room_type;
DROP TYPE IF EXISTS user_type;
DROP TYPE IF EXISTS status;
DROP TYPE IF EXISTS payment_status;
DROP TYPE IF EXISTS payment_method;
DROP TYPE IF EXISTS program_type;


CREATE TYPE room_type AS ENUM(
	'Single',
	'Double',
	'President Suite',
	'Cabana',
	'Connecting'
);


CREATE TYPE user_type AS ENUM(
	'guest', 
	'manager', 
	'admin'
);


CREATE TYPE status AS ENUM(
	'Confirmed', 
	'Canceled'
);


CREATE TYPE payment_status AS ENUM(
	'Paid',
	'Pending', 
	'Completed'
);


CREATE TYPE payment_method AS ENUM(
	'Credit Card',
	'PayPal'
);


CREATE TYPE program_type AS ENUM(
	'Gold',
	'Silver',
	'Platinum'
);


CREATE TABLE Users (
    User_ID SERIAL PRIMARY KEY,
	Username VARCHAR(255),
    Password VARCHAR(255),
    Email VARCHAR(255) UNIQUE
	CHECK (Email~ '^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$'),
    UserType user_type
);


CREATE TABLE Hotels (
    Hotel_ID SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    Contact_Number VARCHAR(50),
    Email VARCHAR(255) UNIQUE
	CHECK (Email~ '^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$'),
    Rating DECIMAL(2,1),
	Country VARCHAR(255)
);


CREATE TABLE HotelManagers (
    Manager_ID SERIAL PRIMARY KEY,
    Hotel_ID SERIAL,
    Full_Name VARCHAR(255) NOT NULL,
    Contact_Number VARCHAR(20),
    Email VARCHAR(255),
    FOREIGN KEY (Hotel_ID) REFERENCES Hotels(Hotel_ID)
);


CREATE TABLE Review (
    Hotel_ID SERIAL NOT NULL,
    User_ID SERIAL NOT NULL,
    Review_ID SERIAL NOT NULL,
    Rating DECIMAL(2, 1),    
	Comment TEXT,
    Date DATE, 
    PRIMARY KEY (Hotel_ID, User_ID, Review_ID),  
    FOREIGN KEY (Hotel_ID) REFERENCES Hotels(Hotel_ID) ON DELETE CASCADE,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON DELETE CASCADE
);


CREATE TABLE Loyalty_program (
	Program_ID SERIAL,
    User_ID SERIAL,
    Points INT,
    Program_type VARCHAR(100), 
    PRIMARY KEY (Program_ID, User_ID),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID) ON DELETE CASCADE
);


CREATE TABLE Room (
	Room_ID SERIAL PRIMARY KEY,
	Hotel_ID SERIAL,
	Room_type room_type,
	Capacity INT,
    Price_Per_Night DECIMAL(10, 2),
    Availability BOOLEAN,
	FOREIGN KEY (Hotel_ID) REFERENCES Hotels(Hotel_ID) ON DELETE CASCADE
);


CREATE TABLE Reservations (
    Reservation_ID SERIAL PRIMARY KEY,
    User_ID SERIAL,
    Room_ID SERIAL,
    Check_in_Date DATE,
    Check_out_Date DATE,
    Status status NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);


CREATE TABLE Payments (
    Payment_ID SERIAL PRIMARY KEY, 
    Reservation_ID SERIAL,
    Amount DECIMAL(10, 2),
    Payment_Method payment_method,
    Payment_Status payment_status,
    FOREIGN KEY (Reservation_ID) REFERENCES Reservations(Reservation_ID)
);


CREATE TABLE Administrators (
    Admin_ID SERIAL PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    Email VARCHAR(255),
    Full_Name VARCHAR(255)
);


CREATE TABLE Languages (
    Language_ID SERIAL PRIMARY KEY,
    Language_Name VARCHAR(255) NOT NULL
);


CREATE TABLE Administrator_Language (
    Admin_ID SERIAL,
    Language_ID SERIAL,
    PRIMARY KEY (Admin_ID, Language_ID),
    FOREIGN KEY (Admin_ID) REFERENCES Administrators(Admin_ID) ON DELETE CASCADE,
    FOREIGN KEY (Language_ID) REFERENCES Languages(Language_ID) ON DELETE CASCADE
);


CREATE TABLE Hotel_HotelManager (
	Hotel_ID SERIAL,
	Manager_ID SERIAL,
	PRIMARY KEY (Hotel_ID, Manager_ID),
	FOREIGN KEY (Hotel_ID) REFERENCES Hotels(Hotel_ID) ON DELETE CASCADE,
	FOREIGN KEY (Manager_ID) REFERENCES HotelManagers(Manager_ID) ON DELETE CASCADE
);


CREATE TABLE Hotel_Administrators (
	Hotel_ID SERIAL,
	Admin_ID SERIAL,
	PRIMARY KEY (Hotel_ID, Admin_ID),
	FOREIGN KEY (Hotel_ID) REFERENCES Hotels(Hotel_ID) ON DELETE CASCADE,
	FOREIGN KEY (Admin_ID) REFERENCES Administrators(Admin_ID) ON DELETE CASCADE
);


CREATE TABLE User_Hotel (
	User_ID SERIAL,
	Hotel_ID SERIAL,
	PRIMARY KEY (User_ID, Hotel_ID),
	FOREIGN KEY (User_ID) REFERENCES Users (User_ID) ON DELETE CASCADE,
	FOREIGN KEY (Hotel_ID) REFERENCES Hotels(Hotel_ID) ON DELETE CASCADE
);
