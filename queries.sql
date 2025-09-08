CREATE TABLE Airports (
    airport_code VARCHAR(5) PRIMARY KEY,
    airport_name VARCHAR(100),
    airport_location VARCHAR(100),
    other_details TEXT
);

CREATE TABLE Flight_Schedules (
    flight_number VARCHAR(10) PRIMARY KEY,
    airline_code VARCHAR(5),
    usual_aircraft_type_code VARCHAR(10),
    origin_airport_code VARCHAR(5),
    destination_airport_code VARCHAR(5),
    departure_date_time DATE,
    arrival_date_time DATE,
    FOREIGN KEY (origin_airport_code) REFERENCES Airports(airport_code),
    FOREIGN KEY (destination_airport_code) REFERENCES Airports(airport_code)
);

CREATE TABLE Legs (
    leg_id INTEGER PRIMARY KEY,
    flight_number VARCHAR(10),
    origin_airport VARCHAR(5),
    destination_airport VARCHAR(5),
    actual_departure_time DATE,
    actual_arrival_time DATE,
    FOREIGN KEY (flight_number) REFERENCES Flight_Schedules(flight_number),
    FOREIGN KEY (origin_airport) REFERENCES Airports(airport_code),
    FOREIGN KEY (destination_airport) REFERENCES Airports(airport_code)
);

CREATE TABLE Flight_Costs (
    flight_number VARCHAR(10),
    aircraft_type_code VARCHAR(10),
    valid_from_date DATE,
    valid_to_date DATE,
    flight_cost DECIMAL(10, 2),
    PRIMARY KEY (flight_number, aircraft_type_code, valid_from_date),
    FOREIGN KEY (flight_number) REFERENCES Flight_Schedules(flight_number)
);

CREATE TABLE Calendar (
    day_date DATE PRIMARY KEY,
    day_number INTEGER,
    business_day_yn CHAR(1)
);

CREATE TABLE Booking_Agents (
    agent_id INTEGER PRIMARY KEY,
    agent_name VARCHAR(100),
    agent_details TEXT
);

CREATE TABLE Passengers (
    passenger_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    second_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_number VARCHAR(15),
    email_address VARCHAR(100),
    address_lines VARCHAR(100),
    city VARCHAR(50),
    state_province_county VARCHAR(50),
    country VARCHAR(50),
    other_passenger_details TEXT
);

CREATE TABLE Itinerary_Reservations (
    reservation_id INTEGER PRIMARY KEY,
    agent_id INTEGER,
    passenger_id INTEGER,
    reservation_status_code VARCHAR(10),
    ticket_type_code VARCHAR(10),
    travel_class_code VARCHAR(10),
    date_reservation_made DATE,
    number_in_party INTEGER,
    FOREIGN KEY (agent_id) REFERENCES Booking_Agents(agent_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id)
);

CREATE TABLE Itinerary_Legs (
    reservation_id INTEGER,
    leg_id INTEGER,
    PRIMARY KEY (reservation_id, leg_id),
    FOREIGN KEY (reservation_id) REFERENCES Itinerary_Reservations(reservation_id),
    FOREIGN KEY (leg_id) REFERENCES Legs(leg_id)
);

CREATE TABLE Reservation_Payments (
    payment_id INTEGER PRIMARY KEY,
    reservation_id INTEGER,
    FOREIGN KEY (reservation_id) REFERENCES Itinerary_Reservations(reservation_id)
);

CREATE TABLE Payments (
    payment_id INTEGER PRIMARY KEY,
    payment_status_code VARCHAR(10),
    payment_date DATE,
    payment_amount DECIMAL(10, 2)
);

-- Views
CREATE VIEW Passenger_Itinerary AS
SELECT p.passenger_id, p.first_name, p.last_name, ir.reservation_id, 
       fs.flight_number, fs.departure_date_time, fs.arrival_date_time, 
       a1.airport_name AS origin_airport, a2.airport_name AS destination_airport
FROM Passengers p
JOIN Itinerary_Reservations ir ON p.passenger_id = ir.passenger_id
JOIN Itinerary_Legs il ON ir.reservation_id = il.reservation_id
JOIN Legs l ON il.leg_id = l.leg_id
JOIN Flight_Schedules fs ON l.flight_number = fs.flight_number
JOIN Airports a1 ON fs.origin_airport_code = a1.airport_code
JOIN Airports a2 ON fs.destination_airport_code = a2.airport_code;

SELECT * FROM Passenger_Itinerary WHERE passenger_id = 100;

CREATE VIEW Customers_On_Flight AS
SELECT p.passenger_id, p.first_name, p.last_name, fs.flight_number
FROM Passengers p
JOIN Itinerary_Reservations ir ON p.passenger_id = ir.passenger_id
JOIN Itinerary_Legs il ON ir.reservation_id = il.reservation_id
JOIN Legs l ON il.leg_id = l.leg_id
JOIN Flight_Schedules fs ON l.flight_number = fs.flight_number;

SELECT * FROM Customers_On_Flight WHERE flight_number = 'AA1234';

CREATE VIEW Flights_By_Airport AS
SELECT fs.flight_number, a1.airport_name AS origin_airport, a2.airport_name AS destination_airport, 
       fs.departure_date_time, fs.arrival_date_time
FROM Flight_Schedules fs
JOIN Airports a1 ON fs.origin_airport_code = a1.airport_code
JOIN Airports a2 ON fs.destination_airport_code = a2.airport_code;

SELECT * FROM Flights_By_Airport WHERE origin_airport = 'JFK' OR destination_airport = 'JFK';

CREATE VIEW Flight_Schedule AS
SELECT fs.flight_number, a1.airport_name AS origin_airport, a2.airport_name AS destination_airport, 
       fs.departure_date_time, fs.arrival_date_time
FROM Flight_Schedules fs
JOIN Airports a1 ON fs.origin_airport_code = a1.airport_code
JOIN Airports a2 ON fs.destination_airport_code = a2.airport_code;

SELECT * FROM Flight_Schedule;

CREATE VIEW Flight_Status AS
SELECT fs.flight_number, fs.departure_date_time AS scheduled_departure, 
       l.actual_departure_time, fs.arrival_date_time AS scheduled_arrival, l.actual_arrival_time,
       CASE 
           WHEN l.actual_departure_time = fs.departure_date_time 
            AND l.actual_arrival_time = fs.arrival_date_time 
           THEN 'On Time'
           ELSE 'Delayed'
       END AS flight_status
FROM Flight_Schedules fs
JOIN Legs l ON fs.flight_number = l.flight_number;

SELECT * FROM Flight_Status;

CREATE VIEW Flight_Sales AS
SELECT fs.flight_number, SUM(p.payment_amount) AS total_sales
FROM Flight_Schedules fs
JOIN Legs l ON fs.flight_number = l.flight_number
JOIN Itinerary_Legs il ON l.leg_id = il.leg_id
JOIN Itinerary_Reservations ir ON il.reservation_id = ir.reservation_id
JOIN Reservation_Payments rp ON ir.reservation_id = rp.reservation_id
JOIN Payments p ON rp.payment_id = p.payment_id
GROUP BY fs.flight_number;

SELECT * FROM Flight_Sales WHERE flight_number = 'AA1234';
