/*Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for the Midwest region. Your final table should include three columns:
the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.*/
SELECT r.name region, s.name sales, a.name account
FROM sales_reps  as s
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN region as r
ON r.id = s.region_id
WHERE r.name = 'Midwest'
ORDER BY a.name;

/*Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for accounts where the sales rep has a first name starting with S and in the Midwest region.
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.*/
SELECT r.name region, s.name sales, a.name account
FROM sales_reps  as s
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN region as r
ON r.id = s.region_id
WHERE r.name = 'Midwest' AND s.name LIKE('S%')
ORDER BY a.name;

/*Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for accounts where the sales rep has a last name starting with K and in the Midwest region.
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.*/
SELECT r.name region, s.name sales, a.name account
FROM sales_reps  as s
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN region as r
ON r.id = s.region_id
WHERE r.name = 'Midwest' AND s.name LIKE('K%')
ORDER BY a.name;

/*Provide the name for each region for every order, as well as the account name and the unit price
they paid (total_amt_usd/total) for the order. However, you should only provide the results if the
standard order quantity exceeds 100. Your final table should have 3 columns:
region name, account name, and unit price. In order to avoid a division by zero error, adding .
01 to the denominator here is helpful total_amt_usd/(total+0.01). */
SELECT r.name region, a.name account, o.total_amt_usd/(total+0.01) total
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
AND standard_qty > 100
JOIN sales_reps as s
on s.id = a.sales_rep_id
JOIN region as r
ON r.id = s.region_id
ORDER BY a.name;

/*Provide the name for each region for every order, as well as the account name and the unit price
 they paid (total_amt_usd/total) for the order. However, you should only provide the results
 if the standard order quantity exceeds 100 and the poster order quantity exceeds 50.
 Your final table should have 3 columns: region name, account name, and unit price.
 Sort for the smallest unit price first. In order to avoid a division by zero error,
 adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01). */
 SELECT r.name region, a.name account, o.total_amt_usd/(total+0.01) total_price
 FROM orders as o
 JOIN accounts as a
 ON a.id = o.account_id
 AND standard_qty > 100 AND poster_qty > 50
 JOIN sales_reps as s
 on s.id = a.sales_rep_id
 JOIN region as r
 ON r.id = s.region_id
 ORDER BY total_price;

/*Provide the name for each region for every order, as well as the account name and the unit price
 they paid (total_amt_usd/total) for the order. However, you should only provide the results if the
 standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table
 should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first.
 In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).*/
 SELECT r.name region, a.name account, o.total_amt_usd/(total+0.01) total_price
 FROM orders as o
 JOIN accounts as a
 ON a.id = o.account_id
 AND standard_qty > 100 AND poster_qty > 50
 JOIN sales_reps as s
 on s.id = a.sales_rep_id
 JOIN region as r
 ON r.id = s.region_id
 ORDER BY total_price DESC;

/*What are the different channels used by account id 1001? Your final table should have only 2 columns:
account name and the different channels.
You can try SELECT DISTINCT to narrow down the results to only the unique values.*/
 SELECT DISTINCT a.name account, w.channel channel
 FROM accounts as a
 JOIN web_events as w
 ON	a.id = w.account_id
 AND a.id = 1001;

/*Find all the orders that occurred in 2015. Your final table should have 4 columns:
occurred_at, account name, order total, and order total_amt_usd. */
SELECT o.occurred_at dia, a.name account, o.total quant,
o.total_amt_usd total_usd
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY dia;

/*Provide a table for all web_events associated with account name of Walmart. There should be three columns.
 Be sure to include the primary_poc, time of the event, and the channel for each event.
 Additionally, you might choose to add a fourth column to assure only Walmart events were chosen */
SELECT a.primary_poc, w.occurred_at, w.channel
  FROM web_events as w
  JOIN accounts as a
  ON a.id = w.account_id
  WHERE a.name = 'Walmart';

/*Provide a table that provides the region for each sales_rep along with their associated accounts.
 Your final table should include three columns: the region name, the sales rep name, and the account name.
 Sort the accounts alphabetically (A-Z) according to account name.*/
SELECT a.name, s.name, r.name
  FROM sales_reps as s
  JOIN accounts as a
  ON a.sales_rep_id = s.id
  JOIN region as r
  ON s.region_id = r.id
  ORDER BY a.name DESC;

/*Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total)
for the order. Your final table should have 3 columns: region name, account name, and unit price.
A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.*/
SELECT r.name as region, a.name as name, o.total_amt_usd/(total+0.01) as unit_price
  FROM orders as o
  JOIN accounts as a
  ON a.id = o.account_id
  JOIN sales_reps as s
  ON s.id = a.sales_rep_id
  JOIN region as r
  ON s.region_id = r.id;
