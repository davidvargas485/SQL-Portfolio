# Show Customers (their full names, customer ID, and country) who are not in the US. (Hint: != or <> can be used to say "is not equal to").

SELECT 
    FirstName || ' ' || LastName AS fullname,
    customerID,
    country
FROM
    chinook.customers
WHERE
    country NOT LIKE '%USA%';

# Show only the customers from Argentina.

SELECT 
    FirstName || ' ' || LastName AS fullname,
    customerID,
    country
FROM
    chinook.customers
WHERE
    country LIKE '%Argentina%';

# Find the Invoices of customers who are from Brazil. 

SELECT
    invoices.InvoiceID,
    customers.FirstName,
    customers.LastName,
    invoices.InvoiceDate,
    invoices.BillingCountry
FROM
    chinook.invoices AS invoices
LEFT JOIN
    chinook.customers AS customers
ON
    invoices.CustomerID =  customers.CustomerID
WHERE
    invoices.BillingCountry = 'Brazil'
ORDER BY
    invoices.InvoiceDate;
    
# Show the Employees who are Sales Agents.

SELECT
    FirstName || ' ' || LastName AS fullname,
    title
FROM
    chinook.employees
WHERE
    title LIKE '%Agent%';

# Extract a list of countries from which purchases have been made.

SELECT
    DISTINCT BillingCountry AS country
FROM
    chinook.invoices
ORDER BY
    country;

# Which countries have the most invoices and how much did they spend?

SELECT
    BillingCountry AS country,
    COUNT(BillingCountry) AS num_invoices,
    SUM(invoices.Total) AS total_spent
FROM
    chinook.invoices
GROUP BY
    country
ORDER BY
    total_spent DESC,
    num_invoices DESC;

# Which customers have made the most orders and how much did they spend?

SELECT
    customers.CustomerID,
    customers.FirstName,
    customers.LastName,
    COUNT(customers.CustomerID) AS num_orders,
    invoices.BillingCountry,
    SUM(invoices.Total) AS total_spent
FROM
    chinook.customers AS customers
LEFT JOIN
    chinook.invoices AS invoices
ON
    customers.CustomerID = invoices.CustomerID
GROUP BY
    customers.CustomerID
ORDER BY
    total_spent DESC,
    num_orders DESC,
    BillingCountry;

# Retreieve the invoices and their corresponding sales agent.

SELECT 
    invoices.InvoiceID,
    employees.FirstName,
    employees.LastName
FROM
    chinook.invoices AS invoices
JOIN
    chinook.customers AS customers
ON
    invoices.CustomerID = customers.CustomerID
JOIN
    chinook.employees AS employees
ON
    customers.SupportRepID = employees.EmployeeID
ORDER BY
    invoices.InvoiceID;

# How many Invoices were there in 2009?

SELECT
    COUNT(InvoiceID) AS num_invoices
FROM
    chinook.invoices
WHERE
    InvoiceDate LIKE '%2009%';

# What are the total sales for 2009?

SELECT
    (substr(InvoiceDate,1,4)) as year,
    SUM(Total)
FROM 
    chinook.invoices
WHERE
    year LIKE '%2009%';

# Which year had the most invoices?

SELECT
    (substr(InvoiceDate,1,4)) as year,
    COUNT(InvoiceID) AS num_invoices
FROM 
    chinook.invoices
GROUP BY
    year
ORDER BY
    num_invoices DESC;

# Retreieve purchased tracks and their corresponding invoice ID. 

SELECT
    tracks.TrackID,
    tracks.Name,
    invoice.InvoiceLineID
FROM
    chinook.invoice_items AS invoice
JOIN
    chinook.tracks AS tracks
ON
    invoice.TrackID = tracks.TrackID
ORDER BY
    tracks.TrackID;

# Write a query that includes the purchased track name AND artist name with each invoice line ID.
/* In order to get the artist name, we need to first link the albums table since this has a foreign key in the artists table and the tracks table */

SELECT
    DISTINCT tracks.Name AS track_name,
    artists.Name AS artist_name,
    invoice.InvoiceLineID
FROM
    chinook.invoice_items AS invoice
LEFT JOIN
    chinook.tracks AS tracks
ON
    invoice.TrackID = tracks.TrackID
INNER JOIN
    chinook.albums AS albums
ON
    tracks.AlbumID = albums.AlbumID
LEFT JOIN
    chinook.artists AS artists
ON
    albums.ArtistID = artists.ArtistID;

# Provide a query that shows all the Tracks, and include the Album name, Media type, and Genre.

SELECT
    tracks.Name AS track_name,
    albums.Title AS album_name,
    media_types.Name AS media_type,
    genres.Name AS genre
FROM
    chinook.tracks AS tracks
JOIN
    chinook.albums AS albums
ON
    tracks.AlbumID = albums.AlbumID
JOIN
    chinook.genres AS genres
ON
    tracks.GenreID = genres.GenreID
JOIN
    chinook.media_types AS media_types
ON
    tracks.MediaTypeID = media_types.MediaTypeID;

# Show the total sales made by each sales agent.

SELECT
    employees.EmployeeID,
    employees.FirstName,
    employees.LastName,
    SUM(invoices.Total) AS total_sales
FROM
    chinook.employees AS employees
JOIN
    chinook.customers AS customers
ON
    employees.EmployeeId = customers.SupportRepId
JOIN
    chinook.invoices AS invoices
ON
    customers.CustomerID = invoices.CustomerID
WHERE 
    employees.Title = 'Sales Support Agent' 
GROUP BY
    employees.EmployeeID;

# Which sales agent made the most dollars in sales in 2009?

SELECT
    employees.EmployeeID,
    employees.FirstName,
    employees.LastName,
    SUM(invoices.Total) AS total_sales
FROM
    chinook.employees AS employees
JOIN
    chinook.customers AS customers
ON
    employees.EmployeeId = customers.SupportRepId
JOIN
    chinook.invoices AS invoices
ON
    customers.CustomerID = invoices.CustomerID
WHERE
    employees.Title = 'Sales Support Agent' AND
    invoices.InvoiceDate LIKE '%2009%'
GROUP BY
    employees.EmployeeID
ORDER BY
    total_sales DESC;
    
# Which playlists have the most items?

SELECT
    playlists.Name AS playlist_type,
    COUNT(playlist_track.PlaylistID) AS num_items
FROM
    chinook.playlists AS playlists
LEFT JOIN
    chinook.playlist_track AS playlist_track
ON
    playlists.PlaylistID = playlist_track.PlaylistID
GROUP BY
    playlist_type
ORDER BY
    num_items DESC;

# What are the names of the songs in the "Music" playlist?

SELECT 
    tracks.Name AS track_name
FROM
    chinook.tracks AS tracks
JOIN
    chinook.playlist_track AS playlist_track
ON
    tracks.TrackID = playlist_track.TrackID
JOIN
    chinook.playlists AS playlists
ON
    playlists.PlaylistID = playlist_track.PlaylistID
WHERE
    playlists.Name = "Music";

# What is the most purchased media type and how much money has each media type made?

SELECT
    media_types.Name,
    COUNT(media_types.Name) AS num_purchases,
    SUM(invoice_items.UnitPrice) AS revenue
FROM
    chinook.media_types AS media_types
JOIN
    chinook.tracks AS tracks
ON
    media_types.MediaTypeID = tracks.MediaTypeID
JOIN
    chinook.invoice_items AS invoice_items
ON 
    tracks.trackID = invoice_items.TrackID
GROUP BY
    media_types.Name
ORDER BY
    num_purchases DESC;

# What is the most purchased genre?

SELECT
    genres.Name,
    COUNT(genres.Name) AS num_purchases,
    SUM(invoice_items.UnitPrice) AS revenue
FROM
    chinook.genres AS genres
JOIN
    chinook.tracks AS tracks
ON
    genres.GenreID = tracks.GenreID
JOIN
    chinook.invoice_items AS invoice_items
ON 
    tracks.trackID = invoice_items.TrackID
GROUP BY
    genres.Name
ORDER BY
    num_purchases DESC;

# Retrieve how many times each track has been purchased.

SELECT
    tracks.Name AS track_name,
    COUNT(tracks.Name) AS num_purchases
FROM
    chinook.tracks
JOIN
    chinook.invoice_items AS invoice_items
ON 
    tracks.trackID = invoice_items.TrackID
GROUP BY
    track_name
ORDER BY
    num_purchases DESC;

# Retrieve the names of the customers who have purchased each track.

SELECT
    tracks.Name AS track_name,
    customers.CustomerID,
    customers.FirstName,
    customers.LastName
FROM
    chinook.tracks
JOIN
    chinook.invoice_items AS invoice_items
ON 
    tracks.trackID = invoice_items.TrackID
JOIN
    chinook.invoices AS invoices
ON 
    invoice_items.InvoiceID = invoices.InvoiceID
JOIN
    chinook.customers AS customers
ON
    invoices.CustomerID = customers.CustomerID
ORDER BY
    track_name;

# Retrieve the song title, the artist who created it, the album it is from, the genre, and the media type.

SELECT
    tracks.Name AS track_name,
    artists.Name,
    albums.Title AS album_title,
    genres.Name AS genre,
    media_types.Name AS media_type
FROM
    chinook.tracks AS tracks
JOIN
    chinook.albums AS albums
ON
    tracks.AlbumID = albums.AlbumID
JOIN
    chinook.artists AS artists
ON
    albums.ArtistID = artists.ArtistID
JOIN
    chinook.media_types AS media_types
ON
    tracks.MediaTypeID = media_types.MediaTypeID
JOIN
    chinook.genres AS genres
ON
    tracks.GenreID = genres.GenreID
ORDER BY
    album_title;

# Which albums have the most tracks?

SELECT
    albums.Title AS album_title,
    COUNT(*) AS num_songs
FROM
    chinook.tracks AS tracks
LEFT JOIN
    chinook.albums AS albums
ON
    tracks.AlbumID = albums.AlbumID
GROUP BY
    album_title
ORDER BY
    num_songs DESC;