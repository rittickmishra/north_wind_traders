use north_wind_traders
create database north_wind_traders
use north_wind_traders
select * from categories
select * from customers
select * from employees
select * from order_details
select * from orders
select * from products
select * from shippers

-- 1. total cost of each product 
select p.productName,p.productID,SUM(od.unitPrice * od.quantity) AS total_cost from products p
join order_details od
on p.productID=od.productID
GROUP BY p.productID, p.productName
order by total_cost desc

-- 2. Total customer by each country
select country,count(country) as total_customer from customers
group by country
order by total_customer desc
-- 3. 
select c.country,s.companyName,count(o.orderID) total_orders,c.companyName from customers c
join orders o
on c.customerID = o.customerID
join shippers s
on o.shipperID = s.shipperID
group by c.country,s.companyName
ORDER BY c.companyName,total_orders DESC;
-- 4.Which shipper company  delivered the highest orders?
select s.companyName,count(o.orderID) orderss from shippers s
join orders o
on s.shipperID=o.shipperID
group by s.companyName
order by orderss desc
limit 1 
 
 -- 5. which employee reports to which as who is has the higher authority 
SELECT
    e.employeeName          AS employee,
    e.title                 AS employee_title,
    m.employeeName          AS reports_to,
    m.title                 AS manager_title
FROM employees e
LEFT JOIN employees m
    ON e.reportsTo = m.employeeID
ORDER BY
    m.employeeName,
    e.employeeName;
    
-- 6.Which customers have placed more than 10 orders?
 select count(customerID) as no_of_order from orders
 group by customerID
 having count(customerID) > 10    
 -- 7.How many orders were placed each year?
 select count(orderID) as total_order,year(orderDate) as yearly_order from orders
 group by yearly_order
-- 8.find top 5 best selling product by total_quantity sold
SELECT
    p.productName,
    c.categoryName,
    SUM(od.quantity)     AS total_quantity_sold
FROM order_details od
JOIN products   p ON od.productID = p.productID
JOIN categories c ON p.categoryID = c.categoryID
GROUP BY
    p.productID,
    p.productName,
    c.categoryName
ORDER BY total_quantity_sold DESC
LIMIT 5;
-- 9.what is the month-by-month count for the year 2014
SELECT
    orderID,
    orderDate,
    freight,
    ROUND(
        SUM(freight) OVER (
            ORDER BY orderDate
            ROWS UNBOUNDED PRECEDING
        ),
    2)                      AS running_total_freight
FROM orders
WHERE YEAR(orderDate) = 2014
ORDER BY orderDate;
-- 10.
SELECT
    c.companyName AS customer_name,
    c.contactName                AS contact_person,
    c.country,
    COUNT(DISTINCT o.orderID)    AS total_orders,
    ROUND(
        SUM(od.unitPrice * od.quantity * (1 - od.discount))
    , 2)                         AS total_amount_spent
FROM customers     c
JOIN orders        o  ON c.customerID = o.customerID
JOIN order_details od ON o.orderID    = od.orderID
GROUP BY
    c.customerID,
    c.companyName,
    c.contactName,
    c.country
ORDER BY total_amount_spent DESC
LIMIT 10;
-- 11.How many orders were shipped late? (shippedDate > requiredDate)
SELECT COUNT(*) AS late_orders
FROM orders
WHERE shippedDate > requiredDate;
-- 12. Top 5 Customers Who Ordered the Most Different Products
SELECT
    c.companyName                       AS customer_name,
    c.country,
    COUNT(DISTINCT od.productID)        AS different_products
FROM customers     c
JOIN orders        o  ON c.customerID  = o.customerID
JOIN order_details od ON o.orderID     = od.orderID
GROUP BY
    c.customerID,
    c.companyName,
    c.country
ORDER BY different_products DESC
LIMIT 5;
