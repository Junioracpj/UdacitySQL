/*
When was the earliest order ever placed? You only need to return the date.
*/
SELECT min(occurred_at)
FROM orders;

/*
Try performing the same query as in question 1 without using an aggregation function.
*/
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

/*
When did the most recent (latest) web_event occur?
*/
SELECT max(occurred_at)
FROM web_events;

/*
Try to perform the result of the previous query without using an aggregation function.
*/
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

/*
Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean
amount of each paper type purchased per order. Your final answer should have 6 values -
one for each paper type for the average number of sales, as well as the average amount.
*/
SELECT avg(standard_qty) mean_standard, avg(gloss_qty) mean_gloss,
 avg(poster_qty) mean_poster, avg(standard_amt_usd) mean_standard_usd,
 avg(gloss_amt_usd) mean_gloss_usd, avg(poster_amt_usd) mean_poster_usd
FROM orders;

/*
Via the video, you might be interested in how to calculate the MEDIAN.
Though this is more advanced than what we have covered so far try finding
- what is the MEDIAN total_usd spent on all orders?
*/
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

/*
Which account (by name) placed the earliest order?
Your solution should have the account name and the date of the order.
*/
SELECT a.name nome, min(o.occurred_at) dia
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
GROUP BY nome
ORDER BY dia
LIMIT 1;

/*
Find the total sales in usd for each account. You should include two columns
- the total sales for each company's orders in usd and the company name.
*/
SELECT a.name nome, sum(o.total_amt_usd) total
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
GROUP BY nome
ORDER BY nome;

/*
Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event?
Your query should return only three values - the date, channel, and account name.
*/
SELECT w.channel canal, w.occurred_at dia, a.name nome
FROM web_events as w
JOIN accounts as a
ON a.id = w.account_id
ORDER BY dia DESC;

/*
Find the total number of times each type of channel from the web_events was used.
 Your final table should have two columns - the channel and the number of times the channel was used.
*/
SELECT w.channel canal, count(w.channel) total
FROM web_events as w
GROUP BY canal
ORDER BY total DESC;

/*
Who was the primary contact associated with the earliest web_event?
*/
SELECT a.name nome, occurred_at as dia
FROM web_events as w
JOIN accounts as a
ON a.id = w.account_id
ORDER BY dia
LIMIT 1;

/*

What was the smallest order placed by each account in terms of total usd.
Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
*/
SELECT a.name nome, min(o.total_amt_usd) total
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
GROUP BY name
ORDER BY total;

/*
Find the number of sales reps in each region. Your final table should have two columns -
the region and the number of sales_reps. Order from fewest reps to most reps.
*/
SELECT r.name nome, count(s.name) quant
FROM region as r
JOIN sales_reps as s
ON r.id = s.region_id
GROUP BY nome
ORDER BY quant;

/*
For each account, determine the average amount of each type of paper they purchased
across their orders. Your result should have four columns -one for the account name and one
for the average quantity purchased for each of the paper types for each account.
*/
SELECT a.name nome, avg(standard_qty) mean_standard, avg(gloss_qty) mean_gloss, avg(poster_qty) mean_poster
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY nome;

/*
For each account, determine the average amount spent per order on each paper type.
Your result should have four columns - one for the account name and one for
the average amount spent on each paper type.
*/
SELECT a.name nome, avg(standard_amt_usd) mean_standard, avg(gloss_amt_usd) mean_gloss, avg(poster_amt_usd) mean_poster
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY nome;

/*
Determine the number of times a particular channel was used in the web_events table
for each sales rep. Your final table should have three columns -
the name of the sales rep, the channel, and the number of occurrences.
Order your table with the highest number of occurrences first.
*/
SELECT s.name sales_name, w.channel canal, count(w.channel) total
FROM accounts as a
JOIN sales_reps as s
ON s.id = a.sales_rep_id
JOIN web_events as w
ON a.id = w.account_id
GROUP BY sales_name, canal
ORDER BY total DESC;

/*
Determine the number of times a particular channel was used in the web_events table
for each region. Your final table should have three columns -
the region name, the channel, and the number of occurrences.
Order your table with the highest number of occurrences first.
*/
SELECT r.name region_name, w.channel canal, count(w.channel) total
FROM sales_reps  as s
JOIN region as r
ON r.id = s.region_id
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN web_events as w
ON a.id = w.account_id
GROUP BY region_name, canal
ORDER BY total DESC;

/*
Use DISTINCT to test if there are any accounts associated with more than one region.
*/
SELECT DISTINCT r.name region, a.name conta
FROM accounts as a
JOIN sales_reps as s
ON a.sales_rep_id = s.id
JOIN region as r
ON r.id = s.region_id
ORDER BY conta;

/*
Have any sales reps worked on more than one account?
*/
SELECT DISTINCT s.name sales_name, a.name conta
FROM accounts as a
JOIN sales_reps as s
ON a.sales_rep_id = s.id
ORDER BY sales_name;

/*
How many of the sales reps have more than 5 accounts that they manage
*/
SELECT s.name sales_name, count(a.name) valor
FROM sales_reps as s
JOIN accounts as a
ON a.sales_rep_id = s.id
GROUP BY sales_name
HAVING count(a.name) >= 5
ORDER BY valor DESC;

/*
How many accounts have more than 20 orders?
*/
SELECT a.name conta, count(o.id) quant
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY conta
HAVING count(o.id) > 20
ORDER BY quant DESC;

/*
Which account has the most orders?
*/
SELECT a.name conta, count(o.id) quant
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY conta
ORDER BY quant DESC
LIMIT 1;

/*
Which accounts spent more than 30,000 usd total across all orders?
*/
SELECT a.name conta, sum(o.total_amt_usd) total_gasto
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY conta
HAVING sum(o.total_amt_usd)> 30000
ORDER BY total_gasto DESC;

/*
Which accounts spent less than 1,000 usd total across all orders?
*/
SELECT a.name conta, sum(o.total_amt_usd) total_gasto
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY conta
HAVING sum(o.total_amt_usd)< 1000
ORDER BY total_gasto DESC;

/*
Which account has spent the most with us?
*/
SELECT a.name conta, sum(o.total_amt_usd) total_gasto
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY conta
ORDER BY total_gasto DESC
LIMIT 1;

/*
Which account has spent the least with us?
*/
SELECT a.name conta, sum(o.total_amt_usd) total_gasto
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY conta
ORDER BY total_gasto
LIMIT 1;

/*
Which accounts used facebook as a channel to contact customers more than 6 times?
*/
SELECT a.name conta, w.channel canal, count(*) quant
FROM accounts as a
JOIN web_events as w
ON a.id = w.account_id
GROUP BY conta, canal
HAVING count(*) > 6 AND w.channel = 'facebook'
ORDER BY quant;

/*
Which account used facebook most as a channel?
*/
SELECT a.name conta, w.channel canal, count(*) quant
FROM accounts as a
JOIN web_events as w
ON a.id = w.account_id
GROUP BY conta, canal
HAVING w.channel = 'facebook'
ORDER BY quant DESC
LIMIT 1;

/*
Which channel was most frequently used by most accounts?
*/
SELECT a.name conta, w.channel canal, count(*) quant
FROM accounts as a
JOIN web_events as w
ON a.id = w.account_id
GROUP BY conta, canal
ORDER BY quant DESC
LIMIT 1;

/*
Find the sales in terms of total dollars for all orders in each year,
ordered from greatest to least. Do you notice any trends in the yearly sales totals?
*/
SELECT DATE_PART('year', occurred_at) ano, sum(total_amt_usd)
FROM orders
GROUP BY 1
ORDER By 2 DESC;

/*
Which year did Parch & Posey have the greatest sales in terms of total number
of orders? Are all years evenly represented by the dataset?
*/
SELECT DATE_PART('year', occurred_at) ano, count(total)
FROM orders
GROUP BY 1
ORDER By 2 DESC;

/*
Which month did Parch & Posey have the greatest sales in terms of total number
 of orders? Are all months evenly represented by the dataset?
*/
SELECT DATE_PART('month', occurred_at) ano, count(total)
FROM orders
GROUP BY 1
ORDER By 2 DESC;

/*
In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
*/
SELECT DATE_TRUNC('month', o.occurred_at) ano, a.name conta, sum(o.gloss_amt_usd) total_gloss
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
GROUP BY 1, 2
HAVING a.name = 'Walmart'
ORDER By 3 DESC
LIMIT 1;

/*
Write a query to display for each order, the account ID, total amount of the order,
and the level of the order - ???Large??? or ???Small??? - depending on if the order is
$3000 or more, or smaller than $3000.
*/
SELECT account_id, total_amt_usd,
	CASE WHEN total_amt_usd > 3000 THEN 'large'
  ELSE 'Small' END AS level
FROM orders;

/*
Write a query to display the number of orders in each of three categories, based on
the total number of items in each order. The three categories are: 'At Least 2000',
'Between 1000 and 2000' and 'Less than 1000'.
*/
SELECT account_id, total,
	CASE WHEN total BETWEEN 1000 AND 2000 THEN 'Between 1000 and 2000'
  WHEN total >= 2000 THEN 'At Least 2000'
  ELSE 'Less than 1000' END AS level
FROM orders;

/*
We would like to understand 3 different levels of customers based on the amount
associated with their purchases. The top level includes anyone with a Lifetime
Value (total sales of all orders) greater than 200,000 usd. The second level is
between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd.
Provide a table that includes the level associated with each account. You should
provide the account name, the total sales of all orders for the customer, and the level.
Order with the top spending customers listed first.
*/
SELECT a.name empresa, sum(o.total_amt_usd) total_gasto,
  CASE WHEN sum(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Level 2'
  WHEN sum(o.total_amt_usd) >= 200000 THEN 'Level 1'
  ELSE 'Level 3' END AS level
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

/*
We would now like to perform a similar calculation to the first, but we want
to obtain the total amount spent by customers only in 2016 and 2017.
\Keep the same levels as in the previous question. Order with the top spending customers listed first.
*/
SELECT a.name empresa, DATE_PART('year',occurred_at) ano, sum(o.total_amt_usd) total_gasto,
  CASE WHEN sum(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Level 2'
  WHEN sum(o.total_amt_usd) >= 200000 THEN 'Level 1'
  ELSE 'Level 3' END AS level
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
GROUP BY 1, 2
HAVING DATE_PART('year',occurred_at) >= 2016
ORDER BY 3 DESC;

/*
We would like to identify top performing sales reps, which are sales reps associated
with more than 200 orders. Create a table with the sales rep name, the total number
of orders, and a column with top or not depending on if they have more than 200 orders.
Place the top sales people first in your final table.
*/
SELECT s.name sales_name, count(*) total_orders,
	CASE WHEN count(*) > 200 THEN 'top'
  ELSE 'not' END AS is_top
FROM sales_reps as s
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN orders as o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

/*

The previous didn't account for the middle, nor the dollar amount associated with the sales.
 Management decides they want to see these characteristics represented as well.
 We would like to identify top performing sales reps, which are sales reps associated with
 more than 200 orders or more than 750000 in total sales. The middle group has any rep with
 more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total
 number of orders, total sales across all orders, and a column with top, middle, or low depending
 on this criteria. Place the top sales people based on dollar amount of sales first in your final table.
 You might see a few upset sales people by this criteria!
*/
SELECT s.name sales_name, count(*) total_ordens, sum(o.total_amt_usd) total_usd,
	CASE WHEN count(*) > 200 OR sum(o.total_amt_usd) > 750000 THEN 'top'
    WHEN count(*) > 150 OR sum(o.total_amt_usd) > 500000 THEN 'middle'
    ELSE 'low' END AS level
FROM sales_reps as s
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN orders as o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;
