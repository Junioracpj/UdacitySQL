/*
The first time you write a subquery it might seem really complex. Let's try breaking
it down into its different parts. If you get stuck look again at the video above.
We want to find the average number of events for each day for each channel.
The first table will provide us the number of events for each day and channel,
and then we will need to average these values together using a second query.
You try solving this yourself.
*/
SELECT channel, avg(quant) media_eventos
FROM
  (SELECT DATE_TRUNC('day',occurred_at), channel,  count(*) quant
  FROM web_events
  GROUP BY 1, 2) sub
GROUP BY 1
ORDER BY 1;


/*
Use the result of the previous query to find only the orders that took place
in the same month and year as the first order, and then pull the average for each type of paper qty in this month
*/

SELECT DATE_TRUNC('month', occurred_at), avg(standard_qty) mean_stand,
      avg(gloss_qty) mean_gloss, avg(poster_qty) mean_poster,
      sum(total_amt_usd) total_mes
FROM orders
GROUP BY 1
HAVING DATE_TRUNC('month', occurred_at) = (SELECT
                                          DATE_TRUNC('month',min(occurred_at))
                                          FROM orders);

/*
Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
*/
WITH tab1 as (SELECT s.name sales_name, r.name region_name, sum(o.total_amt_usd) total_region
    FROM sales_reps as s
    JOIN region as r
    ON r.id = s.region_id
    JOIN accounts as a
    ON s.id = a.sales_rep_id
    JOIN orders as o
    ON o.account_id = a.id
    GROUP BY 1, 2),

    tab2 as (SELECT region_name, max(total_region) max_region
    FROM tab1
    GROUP by 1)

SELECT tab1.sales_name, tab2.region_name, tab2.max_region
FROM tab1
JOIN tab2
ON tab2.region_name = tab1.region_name AND tab2.max_region = tab1.total_region;


/*
For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
*/
WITH tab1 as (SELECT s.name sales_name, r.name region,
                sum(o.total_amt_usd) total_usd,
                sum(o.total) total_order
              FROM sales_reps as s
              JOIN region as r
              ON r.id = s.region_id
              JOIN accounts as a
              ON s.id = a.sales_rep_id
              JOIN orders as o
              ON o.account_id = a.id
            	GROUP BY 1, 2)

SELECT region, sum(total_usd) region_total_usd, sum(total_order) region_total_order
FROM  tab1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/*
How many accounts had more total purchases than the account name which has
bought the most standard_qty paper throughout their lifetime as a customer?
*/
WITH tab1 as (SELECT a.name nome,
              sum(o.standard_qty) total_stand,
              sum(o.total) total_tab1
              FROM orders as o
              JOIN accounts as a
              ON a.id = o.account_id
              GROUP BY 1
              ORDER BY 1
              LIMIT 1),

    tab2 as (SELECT a.name conta, sum(o.total) best_total
              FROM accounts as a
              JOIN orders as o
              ON o.account_id = a.id
              GROUP BY 1
              HAVING sum(o.total) > (SELECT total_tab1 FROM tab1))

SELECT count(*)
FROM tab2;

/*
For the customer that spent the most (in total over their lifetime as a customer)
total_amt_usd, how many web_events did they have for each channel?
*/
WITH tab1 as (SELECT a.id conta,
              sum(o.total_amt_usd) total_usd
              FROM orders as o
              JOIN accounts as a
              ON a.id = o.account_id
              GROUP BY 1
              ORDER BY 1
              LIMIT 1),

    tab2 as (SELECT conta from tab1)

SELECT account_id, channel, count(channel)
FROM web_events
GROUP BY 1, 2
HAVING account_id = (SELECT conta from tab1);

/*
What is the lifetime average amount spent in terms of total_amt_usd for the top
 10 total spending accounts?
*/
WITH tab1 as (SELECT a.name conta, sum(o.total_amt_usd) total_gasto
              FROM orders as o
              JOIN accounts as a
              ON a.id = o.account_id
              GROUP BY 1
              ORDER BY 2 DESC
              LIMIT 10)

SELECT avg(total_gasto)
FROM tab1;

/*
What is the lifetime average amount spent in terms of total_amt_usd, including
only the companies that spent more per order, on average, than the average of all orders.
*/``
WITH tab1 as (SELECT a.name conta, avg(o.total_amt_usd) total_gasto
              FROM orders as o
              JOIN accounts as a
              ON a.id = o.account_id
              GROUP BY 1
              HAVING avg(o.total_amt_usd) > (SELECT avg(total_amt_usd) FROM orders))

SELECT avg(total_gasto)
FROM tab1;    
