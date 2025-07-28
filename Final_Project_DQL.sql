-- DQL
-- Revenue Calculation
SELECT h.Name AS Hotel_Name, SUM(p.Amount) AS Total_Revenue
FROM Hotels h
JOIN Reservations rs ON h.Hotel_ID = rs.Reservation_ID
JOIN Payments p ON rs.Reservation_ID = p.Reservation_ID
GROUP BY h.Hotel_ID;

-- Top-Rated Hotels
SELECT Hotels.Hotel_ID, Hotels.Name, ROUND(AVG(Review.Rating), 1) AS Average_Rating
FROM Hotels
JOIN Review ON Hotels.Hotel_ID = Review.Hotel_ID
GROUP BY Hotels.Hotel_ID, Hotels.Name
ORDER BY Average_Rating DESC;

-- Room Type Preferences
SELECT Room.Room_Type, COUNT(Reservations.Room_ID) AS Reservation_Count
FROM Reservations
JOIN Room ON Reservations.Room_ID = Room.Room_ID
GROUP BY Room.Room_Type
ORDER BY Reservation_Count DESC;

-- Users who have made the most reservations 
SELECT u.Username, COUNT(*) AS Reservation_Count
FROM Users u
JOIN Reservations rs ON u.User_ID = rs.User_ID
GROUP BY u.User_ID
ORDER BY Reservation_Count DESC;

-- The correlation between room price and customer ratings
SELECT AVG(r.Price_Per_Night) AS Average_Room_Price, h.Rating AS Hotel_Rating
FROM Hotels h
JOIN Room r ON h.Hotel_ID = r.Hotel_ID
GROUP BY h.Rating;

-- The Number of Reservations for Each Season
SELECT Season, COUNT(Reservation_ID) AS Total_Reservations
FROM (SELECT Reservation_ID, Check_In_Date,
        CASE
            WHEN EXTRACT(MONTH FROM Check_In_Date) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM Check_In_Date) IN (6, 7, 8) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM Check_In_Date) IN (9, 10, 11) THEN 'Autumn'
            WHEN EXTRACT(MONTH FROM Check_In_Date) IN (12, 1, 2) THEN 'Winter'
            ELSE 'Unknown' -- in case there are any undefined cases
        END AS Season
    FROM Reservations
) AS SeasonalData
GROUP BY Season
ORDER BY Season;

-- List of most expensive  and cheapest hotel rooms for each hotel
SELECT h.Name,
    MIN(r.Price_Per_Night) AS Cheapest_Room_Price,
    MAX(r.Price_Per_Night) AS Most_Expensive_Room_Price
FROM Hotels h
JOIN Room r ON h.Hotel_ID = r.Hotel_ID
GROUP BY h.Name
ORDER BY Most_Expensive_Room_Price DESC;

--Average length of stay for each room category  
SELECT r.Room_Type,
    AVG(res.Check_out_date - res.Check_in_date) AS Average_Length_of_Stay
FROM Reservations res
JOIN Room r ON res.Room_ID = r.Room_ID
WHERE res.status!='Canceled'
GROUP BY r.Room_Type
ORDER BY Average_Length_of_Stay DESC;

-- The cheapest hotel room price per night in each country
SELECT h.Country, MIN(r.Price_Per_Night ) AS Cheapest_Price_Per_Night
FROM Hotels h
JOIN Room r ON h.Hotel_ID = r.Hotel_ID
GROUP BY h.Country
ORDER BY Cheapest_Price_Per_Night ASC;