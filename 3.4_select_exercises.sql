USE albums_db;

#Explore the structure of the albums table
SELECT * FROM albums;

DESCRIBE albums;

#Name of all albums by Pink Floyd
SELECT NAME FROM albums
WHERE artist = "Pink Floyd";

#The year Sgt. Pepper's Lonely Hearts Club band was released
SELECT release_date FROM albums
WHERE NAME = "Sgt. Pepper's Lonely Hearts Club Band";

#The genre for album Nevermind
SELECT genre FROM albums
WHERE NAME = "Nevermind";

#Which albums were released in the 1990's
SELECT NAME FROM albums
WHERE release_date BETWEEN "1990" AND "1999";

#Which albums had less than 20 million certified sales
SELECT NAME FROM albums
WHERE sales < 20;

#All the albums with a genre of "Rock"
SELECT NAME FROM albums 
WHERE genre = "Rock";

