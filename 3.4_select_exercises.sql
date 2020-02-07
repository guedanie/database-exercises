USE albums_db;

#Explore the structure of the albums table
SELECT * FROM albums;

DESCRIBE albums;

#Name of all albums by Pink Floyd
SELECT NAME AS "Albums by Pink Floyd"
FROM albums
WHERE artist = "Pink Floyd";

#The year Sgt. Pepper's Lonely Hearts Club band was released
SELECT release_date, NAME, artist 
FROM albums
WHERE NAME = "Sgt. Pepper's Lonely Hearts Club Band";

#The genre for album Nevermind
SELECT genre 
FROM albums
WHERE NAME = "Nevermind";

#Which albums were released in the 1990's
SELECT NAME, release_date 
FROM albums
WHERE release_date BETWEEN 1990 AND 1999
ORDER BY release_date;

#Which albums had less than 20 million certified sales
SELECT artist, NAME, sales 
FROM albums
WHERE sales < 20
ORDER BY sales;

#All the albums with a genre of "Rock" - it doesn't pick alternatives, like Hard Rock, because SQL is very specific, unless otherwise specified.
SELECT NAME, genre 
FROM albums 
WHERE genre = "Rock";

#Bonus
SELECT *
FROM albums
WHERE genre LIKE '%rock%'
