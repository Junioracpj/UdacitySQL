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
SELECT s.name sales_name, r.name region, sum(o.total_amt_usd) total
FROM sales_reps as s
JOIN region as r
ON r.id = s.region_id
JOIN accounts as a
ON s.id = a.sales_rep_id
JOIN orders as o
ON o.account_id = a.id
GROUP BY 1, 2;

/*
For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
*/
SELECT region, sum(total_usd) region_total_usd, sum(total_order) region_total_order
FROM (SELECT s.name sales_name, r.name region,
      sum(o.total_amt_usd) total_usd,
      sum(o.total) total_order
    FROM sales_reps as s
    JOIN region as r
    ON r.id = s.region_id
    JOIN accounts as a
    ON s.id = a.sales_rep_id
    JOIN orders as o
    ON o.account_id = a.id
  	GROUP BY 1, 2) sub
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
