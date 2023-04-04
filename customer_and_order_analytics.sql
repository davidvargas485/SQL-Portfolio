#1. How many orders were placed in January?

SELECT
    COUNT(orderID) AS num_orders
FROM
    BIT_DB.JanSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID';

#2. How many of those orders were for an iPhone?

SELECT
    COUNT(orderID) AS num_iphone_orders
FROM
    BIT_DB.JanSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID' AND
    Product LIKE '%iPhone%';

#3. Select the customer account numbers for all the orders that were placed in February.

SELECT
    DISTINCT customers.acctnum,
    febsales.orderID
FROM
    BIT_DB.customers AS customers
INNER JOIN
    BIT_DB.FebSales AS febsales
ON
    customers.order_id = febsales.orderID
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID'
ORDER BY
    customers.acctnum;

#4. Which product was the cheapest one sold in January, and what was the price?

SELECT
    Product,
    price
FROM
    BIT_DB.JanSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID'
GROUP BY
    Product
ORDER BY
    price ASC
LIMIT 1;

/* Let's double check in case there is another product with the same price */

SELECT
    Product,
    price
FROM
    BIT_DB.JanSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID' AND
    price <= 
        (SELECT MIN(price) 
        FROM BIT_DB.JanSales)
GROUP BY
    Product;

#5. What is the total revenue for each product sold in January? 
    
SELECT
    Product,
    ROUND((SUM(Quantity)*price),2) AS Revenue
FROM
    BIT_DB.JanSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID'
GROUP BY
    Product
ORDER BY
    revenue DESC;

#6. Which products were sold in February at 548 Lincoln St, Seattle, WA 98101, how many of each were sold, and what was the total revenue?

SELECT
    Product,
    (num_sold * price) AS Revenue
FROM
    (SELECT
        Product,
        SUM(Quantity) AS num_sold,
        price
    FROM
        BIT_DB.FebSales
    WHERE
        length(orderID) = 6 AND 
        orderID <> 'Order ID' AND
        location LIKE '%548 Lincoln St, Seattle, WA 98101%'
    GROUP BY
        Product) AS product_info
ORDER BY
    revenue;

#7. How many customers ordered more than 2 products at a time in February, and what was the average amount spent for those customers?

SELECT
    COUNT(acctnum) AS num_customers,
    ROUND(AVG(Quantity * price),2) AS avg_spent
FROM
    BIT_DB.FebSales AS febsales
LEFT JOIN
    BIT_DB.customers AS customers
ON
    customers.order_id = febsales.orderID
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID' AND
    Quantity > 2;

/* Let's double check to verify that there 278 customers who purchased more than 2 of a product in one order */

SELECT 
    *
FROM
    FebSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID' AND
    Quantity > 2;

/* There are only 263 orders in the FebSales table where the quantity is more than 2 */
/* This should not be the case. I was expecting there to be 278 orders, since there are 278 rows in the below query */

SELECT
    *
FROM
    BIT_DB.FebSales AS febsales
LEFT JOIN
    BIT_DB.customers AS customers
ON
    customers.order_id = febsales.orderID
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID' AND
    Quantity > 2;

/* After exporting the output of the above table, and importing it into Excel for inspection, it appears that there are duplicate orderID's */
/* This means that multiple account numbers are linked to the same order ID, which should not be the case. */
/* For example, account number 41861194 and 86869999 are linked to order 155130 */

SELECT
    *
FROM
    BIT_DB.FebSales AS febsales
LEFT JOIN
    BIT_DB.customers AS customers
ON
    customers.order_id = febsales.orderID
WHERE
    Quantity > 2 AND
    orderID = 155130;

/* As you can see, there are two account numbers linked to one order. There are multiple instances where this is the case. */
/* There was most likely a flaw in the data collection process for this dataset. */

