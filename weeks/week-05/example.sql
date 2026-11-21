-- WEEK-05 Worked Example (w05_chinook)
USE w05_chinook;

SELECT al.AlbumId, al.Title, ar.Name AS artist_name
FROM Album AS al
JOIN Artist AS ar ON ar.ArtistId = al.ArtistId
ORDER BY al.AlbumId
LIMIT 3;
