/*
Using Derek's previous video as an example, create another running total.
This time, create a running total of standard_amt_usd (in the orders table)
over order time with no date truncation. Your final table should have two columns:
one with the amount being added for each new row, and a second with the running total.
*/

  SELECT standard_amt_usd, occurred_at,
  DATE_PART('month', occurred_at) mes,
  sum(standard_amt_usd) OVER (PARTITION BY DATE_PART('month', occurred_at)
    ORDER BY occurred_at) total_usd
  FROM orders;

/*
Now, modify your query from the previous quiz to include partitions. Still create
a running total of standard_amt_usd (in the orders table) over order time,
but this time, date truncate occurred_at by year and partition by that same
year-truncated occurred_at variable. Your final table should have three columns:
One with the amount being added for each row, one for the truncated date,
and a final column with the running total within each year.
*/
WITH tab1 as (SELECT sum(standard_amt_usd)total,
              DATE_PART('year', occurred_at) ano
              FROM orders
              GROUP BY 2)

SELECT ano, sum(total) OVER (ORDER BY ano) FROM tab1;

/*
Select the id, account_id, and total variable from the orders table, then create
a column called total_rank that ranks this total amount of paper ordered
(from highest to lowest) for each account using a partition.
Your final table should have these four columns.
*/

SELECT id, account_id, total,
DENSE_RANK() OVER (PARTITION BY account_id ORDER BY total DESC) as total_rank
FROM orders;


SELECT id,
     account_id,
     standard_qty,
     DATE_TRUNC('month', occurred_at) AS month,
     DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
     SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
     COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
     AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
     MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
     MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders

/*
Now, create and use an alias to shorten the following query (which is different
than the one in Derek's previous video) that has multiple window functions.
Name the alias account_year_window, which is more descriptive than main_window in the example above.
*/

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders

WINDOW account_year_window as (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at));


/*
Modify Derek's query from the previous video in the SQL Explorer below to perform
this analysis. You'll need to use occurred_at and total_amt_usd in the orders
table along with LEAD to do so. In your query results, there should be four columns:
occurred_at, total_amt_usd, lead, and lead_difference.
*/
WITH tab1 as (SELECT occurred_at,
  SUM(total_amt_usd) AS total_usd_count
  FROM orders
  GROUP BY 1)

SELECT occurred_at,
       total_usd_count,
       LAG(total_usd_count) OVER (ORDER BY occurred_at) AS lag,
       LEAD(total_usd_count) OVER (ORDER BY occurred_at) AS lead,
       total_usd_count - LAG(total_usd_count) OVER (ORDER BY occurred_at) AS lag_difference,
       LEAD(total_usd_count) OVER (ORDER BY occurred_at) - total_usd_count AS lead_difference
FROM tab1;

/*
Use the NTILE functionality to divide the accounts into 4 levels in terms of the
amount of standard_qty for their orders. Your resulting table should have the account_id,
the occurred_at time for each order, the total amount of standard_qty paper purchased,
and one of four levels in a standard_quartile column.
*/
SELECT account_id, occurred_at, standard_qty,
NTILE(4) OVER (PARTITION BY  account_id ORDER BY standard_qty) as percentite
FROM orders
ORDER BY account_id DESC;

SELECT account_id, occurred_at, gloss_qty,
NTILE(2) OVER (PARTITION BY  account_id ORDER BY gloss_qty) as percentite
FROM orders
ORDER BY account_id DESC;

/*
Use the NTILE functionality to divide the orders for each account into 100 levels
in terms of the amount of total_amt_usd for their orders. Your resulting table
should have the account_id, the occurred_at time for each order, the total
amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.
*/
SELECT account_id, occurred_at, total_amt_usd,
NTILE(100) OVER (PARTITION BY  account_id ORDER BY total_amt_usd) as total_percentile
FROM orders
ORDER BY account_id DESC;

/*
Write a query that uses UNION ALL on two instances (and selecting all columns)
of the accounts table. Then inspect the results and answer the subsequent quiz.
*/
SELECT * FROM accounts
UNION ALL
SELECT * FROM accounts;

/*
Add a WHERE clause to each of the tables that you unioned in the query above,
filtering the first table where name equals Walmart and filtering the second
table where name equals Disney. Inspect the results then answer the subsequent quiz.
*/
SELECT * FROM accounts
WHERE name = 'Walmart'
UNION
SELECT * FROM accounts
WHERE name = 'Disney';
