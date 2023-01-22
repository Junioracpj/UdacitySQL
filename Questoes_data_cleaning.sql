/*
In the accounts table, there is a column holding the website for each company.
The last three digits specify what type of web address they are using. A list of
extensions (and pricing) is provided here. Pull these extensions and provide how
many of each website type exist in the accounts table.
*/
SELECT RIGHT(website, 3) tipo, count(*)
FROM accounts
GROUP BY 1;

/*

There is much debate about how much the name (or even the first letter of a company
name) matters. Use the accounts table to pull the first letter of each company name
to see the distribution of company names that begin with each letter (or number).
*/
SELECT LEFT(UPPER(name), 1) tipo, count(*)
FROM accounts
GROUP BY 1;

/*
Use the accounts table and a CASE statement to create two groups: one group of company
names that start with a number and a second group of those company names that start
with a letter. What proportion of company names start with a letter?
*/
WITH solution as (SELECT CASE WHEN LEFT(UPPER(name), 1) IN
                  ('0','1','2','3','4','5','6','7','8','9') THEN 'number'
                  ELSE 'letter' END AS result
                  FROM accounts)

SELECT result, count(*)
FROM solution
GROUP BY 1;

/*
Consider vowels as a, e, i, o, and u. What proportion of company names start with
a vowel, and what percent start with anything else?
*/
WITH solution as (SELECT CASE WHEN LEFT(UPPER(name), 1) = 'A' THEN 'A'
                              WHEN LEFT(UPPER(name), 1) = 'E' THEN 'E'
                              WHEN LEFT(UPPER(name), 1) = 'I' THEN 'I'
                              WHEN LEFT(UPPER(name), 1) = 'O' THEN 'O'
                              WHEN LEFT(UPPER(name), 1) = 'U' THEN 'U'
                              ELSE 'CONS' END AS vogal
                              FROM accounts)

SELECT vogal, count(*)
FROM solution
GROUP BY 1
ORDER BY 2;

/*
Use the accounts table to create first and last name columns that hold the first
and last names for the primary_poc.
*/
SELECT primary_poc, LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_name,
RIGHT(primary_poc,LENGTH(primary_poc) - STRPOS(primary_poc, ' '))last_name
FROM accounts;

/*
Now see if you can do the same thing for every rep name in the sales_reps table.
Again provide first and last name columns.
*/
SELECT name,
LEFT(name, STRPOS(name, ' ') - 1) first_name,
RIGHT(name,LENGTH(name) - STRPOS(name, ' '))last_name
FROM sales_reps;

/*
Each company in the accounts table wants to create an email address for each primary_poc.
The email address should be the first name of the primary_poc .
last name primary_poc @ company name .com.
*/
WITH tab1 as (SELECT primary_poc, LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_pri,
              RIGHT(primary_poc,LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_pri,
              name
              FROM accounts)

SELECT primary_poc, CONCAT(first_pri,'.',last_pri,'@',REPLACE(name, ' ', ''),'.com')
FROM tab1;

/*
We would also like to create an initial password, which they will change after their
first log in. The first password will be the first letter of the primary_poc's first
name (lowercase), then the last letter of their first name (lowercase), the first
letter of their last name (lowercase), the last letter of their last name (lowercase),
the number of letters in their first name, the number of letters in their last name,
and then the name of the company they are working with, all capitalized with no spaces.
*/

WITH tab1 as (SELECT name, primary_poc, LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_name,
              RIGHT(primary_poc,LENGTH(primary_poc) - STRPOS(primary_poc, ' '))last_name
              FROM accounts)

SELECT primary_poc, LOWER(CONCAT(first_name,'.',last_name,'@',REPLACE(name, ' ', ''),'.com')) email,
                    LOWER(CONCAT(LEFT(first_name, 1), RIGHT(first_name, 1),
                    LEFT(last_name, 1),RIGHT(last_name, 1),
                    LENGTH(first_name),LENGTH(last_name),REPLACE(name, ' ', ''))) senha
FROM tab1;

/*
Write a query to change the date into the correct SQL date format.
You will need to use at least SUBSTR and CONCAT to perform this operation
*/
01/31/2014 08:00:00 AM +0000

WITH tab1 as (SELECT date orig_date, SUBSTR(date, 7, 4) ano,
              LEFT(date, 2) mes,
              SUBSTR(date, 4, 2) dia
			  FROM sf_crime_data)

SELECT orig_date, (ano || '-' || mes || '-' || dia)::DATE as correct_data
FROM tab1;

/*
Use COALESCE to fill in each of the qty and usd columns with 0 for the table in
*/
SELECT COALESCE(o.id, a.id) filled_id, a.*, ito.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;
