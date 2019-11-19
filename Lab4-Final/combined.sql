SET FOREIGN_KEY_CHECKS=0; 

-- Drop all the tables
DROP TABLE IF EXISTS Seat CASCADE;
DROP TABLE IF EXISTS CreditCard CASCADE;
DROP TABLE IF EXISTS Ticket CASCADE;
DROP TABLE IF EXISTS Contact CASCADE;
DROP TABLE IF EXISTS Booking CASCADE;
DROP TABLE IF EXISTS Passenger CASCADE;
DROP TABLE IF EXISTS Flight CASCADE;
DROP TABLE IF EXISTS Reservation CASCADE;
DROP TABLE IF EXISTS Airport CASCADE;
DROP TABLE IF EXISTS WeekDay CASCADE;
DROP TABLE IF EXISTS WeeklyFlight CASCADE;
DROP TABLE IF EXISTS Route CASCADE;
DROP TABLE IF EXISTS WeeklySchedule CASCADE;

-- Drop all the procedures
DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS addFlight;
DROP PROCEDURE IF EXISTS addReservation;
DROP PROCEDURE IF EXISTS addPassenger;
DROP PROCEDURE IF EXISTS addContact;
DROP PROCEDURE IF EXISTS addPayment;

-- Drop all the functions
DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;

-- Drop the view
DROP VIEW IF EXISTS allFlights;

SET FOREIGN_KEY_CHECKS=1;



-- Question 2 - Kevha706 and Mdas609
-- Please look at UpdatedRelationalDatabase.PNG for reference

-- Creating all the tables in the database

CREATE TABLE Seat 
(
     sNumber INT,
     sPassport INT,
     CONSTRAINT pk_Seat PRIMARY KEY(sNumber, sPassport)
);

CREATE TABLE CreditCard
(
    ccNumber BIGINT,
    ccName INT,
    CONSTRAINT pk_CreditCard PRIMARY KEY(ccNumber)
);

CREATE TABLE Ticket
(
     tNumber INT,
     tBooking INT NOT NULL,
     tPassenger INT NOT NULL,
     CONSTRAINT pk_Ticket PRIMARY KEY(tNumber)
);

CREATE TABLE Contact
(
     cID INT,
     cEmail VARCHAR(30),
     cPhone BIGINT,
     CONSTRAINT pk_Contact PRIMARY KEY(cID)
);

CREATE TABLE Booking
(
     bNumber INT,
     bPrice DOUBLE,
     bPayer BIGINT NOT NULL,
     CONSTRAINT pk_Booking PRIMARY KEY(bNumber)
);

CREATE TABLE Passenger
(
     pPassport INT,
     pName VARCHAR(30),
     CONSTRAINT pk_Passenger PRIMARY KEY(pPassport)
);

CREATE TABLE Flight
(
     fNumber INT NOT NULL AUTO_INCREMENT,
     fWeek INT,
     fWeeklyFlight INT NOT NULL,
     CONSTRAINT pk_Flight PRIMARY KEY(fNumber)
);

CREATE TABLE Reservation
(
     resNumber INT,
     resFlight INT NOT NULL,
     resContact INT,
     CONSTRAINT pk_Reservation PRIMARY KEY(resNumber)
);

CREATE TABLE Airport
(
     aID VARCHAR(3),
     aName VARCHAR(30),
     aCountry VARCHAR(30),
     CONSTRAINT pk_Airport PRIMARY KEY(aID)
);

CREATE TABLE WeekDay
(
     wdDay VARCHAR(10),
     wdFactor DOUBLE,
     wdYear INT NOT NULL,
     CONSTRAINT pk_WeekDay PRIMARY KEY(wdDay, wdYear)
);

CREATE TABLE WeeklyFlight 
(
     wfID INT NOT NULL AUTO_INCREMENT,
     wfTime TIME,
     wfDay VARCHAR(10),
     wfRoute INT NOT NULL,
     wfYear INT NOT NULL,
     CONSTRAINT pk_WeeklyFlight PRIMARY KEY(wfID)
);

CREATE TABLE Route
(
     rID INT NOT NULL AUTO_INCREMENT,
     rPrice DOUBLE,
     rDeptAirport VARCHAR(3) NOT NULL,
     rArrvAirport VARCHAR(3) NOT NULL,
     rYear INT,
     CONSTRAINT pk_Route PRIMARY KEY(rID)
);

CREATE TABLE WeeklySchedule
(
     wsYear INT,
     wsProfitFactor DOUBLE,
     CONSTRAINT pk_WeeklySchedule PRIMARY KEY(wsYear)
);



-- Create all the foreign keys constraints

ALTER TABLE Seat			
ADD CONSTRAINT fk_Seat_sNumber			 
FOREIGN KEY (sNumber)		  
REFERENCES Reservation(resNumber);

ALTER TABLE Seat			
ADD CONSTRAINT fk_Seat_sPassport			 
FOREIGN KEY (sPassport)		  
REFERENCES Passenger(pPassport);

ALTER TABLE Ticket          
ADD CONSTRAINT fk_Ticket_tBooking            
FOREIGN KEY (tBooking)           
REFERENCES Booking(bNumber);

ALTER TABLE Ticket          
ADD CONSTRAINT fk_Ticket_tPassenger          
FOREIGN KEY (tPassenger)         
REFERENCES Passenger(pPassport);

ALTER TABLE Contact         
ADD CONSTRAINT fk_Contact_cID       
FOREIGN KEY (cID)       
REFERENCES Passenger(pPassport);

ALTER TABLE Booking         
ADD CONSTRAINT fk_Booking_bNumber       
FOREIGN KEY (bNumber)       
REFERENCES Reservation(resNumber);

ALTER TABLE Booking         
ADD CONSTRAINT fk_Booking_bPayer             
FOREIGN KEY (bPayer)             
REFERENCES CreditCard(ccNumber);

ALTER TABLE Flight     
ADD CONSTRAINT fk_Flight_fWeeklyFlight            
FOREIGN KEY (fWeeklyFlight)           
REFERENCES WeeklyFlight(wfID);

ALTER TABLE Reservation     
ADD CONSTRAINT fk_Reservation_resFlight        
FOREIGN KEY (resFlight)            
REFERENCES Flight(fNumber);

ALTER TABLE WeekDay         
ADD CONSTRAINT fk_WeekDay_wdYear                  
FOREIGN KEY (wdYear)            
REFERENCES WeeklySchedule(wsYear);

ALTER TABLE WeeklyFlight    
ADD CONSTRAINT fk_WeeklyFlight_wfYear 
FOREIGN KEY (wfYear)
REFERENCES WeeklySchedule(wsYear);

ALTER TABLE WeeklyFlight
ADD CONSTRAINT fk_WeeklyFlight_wfDay 
FOREIGN KEY (wfDay)
REFERENCES WeekDay(wdDay);

ALTER TABLE WeeklyFlight
ADD CONSTRAINT fk_WeeklyFlight_wfRoute
FOREIGN KEY (wfRoute)
REFERENCES Route(rID);

ALTER TABLE Route 
ADD CONSTRAINT fk_Route_rDeptAirport
FOREIGN KEY (rDeptAirport) REFERENCES Airport(aID);

ALTER TABLE Route 
ADD CONSTRAINT fk_Route_rArrvAirport     
FOREIGN KEY (rArrvAirport)   
REFERENCES Airport(aID);

ALTER TABLE Route 
ADD CONSTRAINT fk_Route_rYear                
FOREIGN KEY (rYear)       
REFERENCES WeeklySchedule(wsYear);



-- Question 3 - Kevha706 and Mdas609

DELIMITER //

-- 3.a Creating procedure: addYear(year,factor)
CREATE PROCEDURE addYear(IN year INT, IN factor DOUBLE)
   BEGIN
        INSERT INTO WeeklySchedule VALUES (year, factor);
   END; 
//


-- 3.b Creating procedure: addDay(year,day,factor)
CREATE PROCEDURE addDay(IN year INT, IN day VARCHAR(10), IN factor DOUBLE)
   BEGIN
        INSERT INTO WeekDay VALUES (day, factor, year);
   END;
//


-- 3.c Creating procedure: addDestination(airport_code,name,country)
CREATE PROCEDURE addDestination(IN airport_code VARCHAR(3), IN name VARCHAR(30), IN country VARCHAR(30))
   BEGIN
        INSERT INTO Airport VALUES (airport_code, name, country);
   END;
//


-- 3.d Creating procedure: addRoute(departure_airport_code,arriveal_airport_code,year,routeprice)
CREATE PROCEDURE addRoute(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(30), IN year INT, IN routeprice DOUBLE)
   BEGIN
        INSERT INTO Route (rDeptAirport, rArrvAirport, rPrice, rYear) VALUES (departure_airport_code, arrival_airport_code, routeprice, year);
   END;
//


-- 3.e Creating procedure: addFlight(departure_airport_code,arrival_airport_code,year,day,departure_time)
CREATE PROCEDURE addFlight(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(30), IN year INT, IN day VARCHAR(10), IN departure_time TIME)
   BEGIN
       DECLARE route_id INT; -- Store route ID
       DECLARE counter INT; -- Counter for loop
       SELECT rID INTO route_id FROM Route 
       WHERE rDeptAirport = departure_airport_code 
       AND rArrvAirport = arrival_airport_code 
       AND rYear = year;

       -- Creating new WeeklyFlight
       INSERT INTO WeeklyFlight (wfTime, wfDay, wfRoute, wfYear)         
       VALUES (departure_time, day, route_id, year);

         SET counter = 1;
         WHILE counter <= 52 DO
            -- Connecting new flight to WeeklyFlight
            INSERT INTO Flight (fWeek, fWeeklyFlight) 
            VALUES(counter, (SELECT wfID FROM WeeklyFlight 
            WHERE wfTime = departure_time 
            AND wfDay = day 
            AND wfYear = year 
            AND wfRoute = route_id));
            SET counter = counter + 1;
         END WHILE;
   END;
//


-- Question 4 - Kevha706 and Mdas609


-- 4.a Creating help-function: calculateFreeSeats(flightnumber)
CREATE FUNCTION calculateFreeSeats (flightnumber INT) RETURNS INT
BEGIN
     DECLARE reservedSeats INT; 
     -- Count paid seats
     SELECT COUNT(*) INTO reservedSeats FROM Ticket 
     WHERE tBooking IN (
         SELECT resNumber 
         FROM Reservation 
         WHERE resFlight = flightnumber
     );
     RETURN 40 - reservedSeats; 
END;
//

-- 4.b Creating help-function: calculetePrice(flightnumber)
CREATE FUNCTION calculatePrice (flightnumber INT) RETURNS DOUBLE
BEGIN
        DECLARE Routeprice DOUBLE;
        DECLARE Weekdayfactor DOUBLE;
        DECLARE Freeseats INT;
        DECLARE profitfactor DOUBLE;

     -- Get Routeprice
     SELECT rPrice INTO Routeprice FROM Route 
     WHERE rID IN (
          SELECT wfRoute FROM WeeklyFlight 
          WHERE wfID IN (
               SELECT fWeeklyFlight FROM Flight 
               WHERE fNumber = flightnumber
          )
     );

     -- Get Weekdayfactor
     SELECT wdFactor INTO Weekdayfactor FROM WeekDay 
     WHERE wdDay IN (
          SELECT wfDay FROM WeeklyFlight 
          WHERE wfID IN (
              SELECT fWeeklyFlight FROM Flight 
              WHERE fNumber = flightnumber
          )
     );

      -- Get Freeseats
      SELECT calculateFreeSeats(flightnumber) INTO Freeseats;

      -- Get profitfactor
      SELECT wsProfitFactor INTO profitfactor 
      FROM WeeklySchedule WHERE wsYear IN ( 
          SELECT wfYear FROM WeeklyFlight 
          WHERE wfID IN (
               SELECT fWeeklyFlight FROM Flight 
               WHERE fNumber = flightnumber
          )
      );

        -- Apply the formula
        RETURN ROUND(Routeprice * Weekdayfactor * (40 - Freeseats + 1)/40 * profitfactor, 2);

END;
//


-- Question 5 - Kevha706 and Mdas609

-- Creating trigger: ticketGenerator
CREATE TRIGGER ticketGenerator
AFTER INSERT ON Booking 
FOR EACH ROW
BEGIN
        DECLARE ReservationNumber INT; 
        SET ReservationNumber = NEW.bNumber;

     INSERT INTO Ticket (tNumber, tBooking, tPassenger)
     SELECT rand()*987654321, ReservationNumber, sPassport 
     FROM Seat 
     WHERE sNumber = ReservationNumber;
END;
//


-- Question 6 - Kevha706 and Mdas609

-- 6.a. Creating procedure: addReservation()

CREATE PROCEDURE addReservation(
    IN departure_airport_code VARCHAR(3), 
    IN arrival_airport_code VARCHAR(3), 
    IN year INT, 
    IN week INT, 
    IN day VARCHAR(10), 
    IN time TIME, 
    IN number_of_passengers INT, 
    OUT output_reservation_nr INT)

BEGIN
    DECLARE flightnumber INT;
    DECLARE reservationnumber INT;
    
    -- Find flightnumber
    SELECT fNumber INTO flightnumber 
    FROM Flight 
    WHERE fWeek = week 
    AND fWeeklyFlight IN (
           SELECT wfID FROM WeeklyFlight 
           WHERE wfYear = year 
           AND wfDay = day 
           AND wfTime = time 
           AND wfRoute IN (
                   SELECT rID FROM Route 
                   WHERE rArrvAirport = arrival_airport_code 
                   AND rDeptAirport= departure_airport_code 
                   AND rYear = year
                   )
    );

    IF flightnumber IS NULL THEN
          SELECT 'There exist no flight for the given route, date and time' as 'Message';
    ELSE 
        IF number_of_passengers > calculateFreeSeats(flightnumber) THEN 
              SELECT 'There are not enough seats available on the chosen flight' as 'Message';
        ELSE
              SET reservationnumber = rand()*987654321;
              INSERT INTO Reservation VALUES (reservationnumber, flightnumber,NULL);
              SELECT reservationnumber INTO output_reservation_nr;
              SELECT 'OK' as 'Message';
        END IF;
    END IF;
END;
//


-- Question 6.b. Creating procedure: addPassenger()
CREATE PROCEDURE addPassenger(
    IN reservation_nr INT, 
    IN passport_number INT, 
    IN name VARCHAR(30))
BEGIN 
    IF (SELECT resNumber FROM Reservation WHERE resNumber = reservation_nr) IS NULL THEN
        SELECT 'The given reservation number does not exist' AS 'Message';
    ELSE	

        IF (SELECT bPayer FROM Booking WHERE bNumber = reservation_nr) is NOT NULL THEN
              SELECT 'The booking has already been payed and no futher passengers can be added' AS 'Message';

        ELSE

              IF (SELECT pPassport FROM Passenger WHERE pPassport = passport_number) is NULL THEN
                   INSERT INTO Passenger VALUES (passport_number, name);
                   INSERT INTO Seat VALUES (reservation_nr, passport_number);
                   SELECT 'OK' as 'Message';
              ELSE 
                   INSERT INTO Seat VALUES (reservation_nr, passport_number);
                   SELECT 'OK' as 'Message';
              END IF;
        END IF;
    END IF;
    
END;
//


-- Question 6.c. Creating procedure: addContact()
CREATE PROCEDURE addContact(
    IN reservation_nr INT, 
    IN passport_number INT, 
    IN email VARCHAR(30), 
    IN phone BIGINT)

BEGIN
    IF (SELECT resNumber FROM Reservation WHERE resNumber = reservation_nr) IS NULL THEN
         SELECT 'The given reservation number does not exist' AS 'Message';
    ELSE 
         IF (SELECT sPassport FROM Seat WHERE sPassport = passport_number AND sNumber = reservation_nr) IS NULL THEN
              SELECT 'The person is not a passenger of the reservation' AS 'Message';
         ELSE
              INSERT INTO Contact VALUES (passport_number, email, phone);
              SELECT 'OK' as 'Message';
         END IF;
    END IF;
END;
//


-- Question 6.d. Creating procedure: addPayment()
CREATE PROCEDURE addPayment(
    IN reservation_nr INT, 
    IN cardholder_name VARCHAR(30), 
    IN credit_card_number BIGINT)

BEGIN
    DECLARE contact INT;
    DECLARE number_of_passengers INT;
    DECLARE flightnumber INT;

    IF (SELECT resNumber FROM Reservation WHERE resNumber = reservation_nr) IS NULL THEN
          SELECT 'The given reservation number does not exist' AS 'Message';
    ELSE 
          SELECT cID INTO contact FROM Contact 
          WHERE cID IN (SELECT sPassport FROM Seat WHERE sNumber = reservation_nr);

          IF contact IS NULL THEN
                SELECT 'The reservation has no contact yet';
          ELSE
                -- Get number_of_passengers
                SELECT COUNT(sPassport) 
                INTO number_of_passengers 
                FROM Seat 
                WHERE sNumber = reservation_nr;
            
                -- Get flightnumber
                SELECT resFlight 
                INTO flightnumber 
                FROM Reservation 
                WHERE resNumber = reservation_nr;
            
                -- Check for unpaid seats
                IF (number_of_passengers > calculateFreeSeats(flightnumber)) THEN
                      SET SQL_SAFE_UPDATES= 0; 
                      SELECT 'There are not enough seats available on the flight anymore, deleting reservation' AS 'Message';
                      DELETE FROM Seat WHERE sNumber = reservation_nr;
                      DELETE FROM Reservation WHERE resNumber = reservation_nr;
                      SET SQL_SAFE_UPDATES= 1;
                ELSE
                      -- Add new Payment
                      INSERT INTO CreditCard VALUES (credit_card_number, cardholder_name);
                      -- Add entry to the Booking 
                      INSERT INTO Booking VALUES (reservation_nr, (number_of_passengers * calculatePrice(flightnumber)), credit_card_number);

                      SELECT 'OK' as 'Message';
                END IF;
           END IF;
     END IF;   
END;
//

DELIMITER ;

-- Question 7 - Kevha706 and Mdas609

-- Creating view: allFlights

CREATE VIEW allFlights AS
SELECT  Flight.fWeek AS 'departure_week', 
        WeeklyFlight.wfTime AS 'departure_time', 
        WeeklyFlight.wfDay AS 'departure_day',
        WeeklyFlight.wfYear AS 'departure_year', 
        DeptAirport.aName AS 'departure_city_name', 
        ArrvAirport.aName AS 'destination_city_name',
        calculateFreeSeats(Flight.fNumber) AS 'nr_of_free_seats',   
        calculatePrice(Flight.fNumber) AS 'current_price_per_seat' 

FROM Flight, 
     WeeklyFlight, 
     Route, 
     Airport DeptAirport, 
     Airport ArrvAirport

WHERE WeeklyFlight.wfRoute = Route.rID 
AND Flight.fWeeklyFlight = WeeklyFlight.wfID
AND DeptAirport.aID = Route.rDeptAirport
AND ArrvAirport.aID = Route.rArrvAirport;







