mySQL ScratchPad

-- SHORTEST
(SELECT STN.CITY, LENGTH(STN.CITY) AS my_LENGTH
    FROM STATION STN 
        ORDER BY my_LENGTH, CITY LIMIT 1)
UNION
-- LONGEST
(SELECT STN.CITY, LENGTH(STN.CITY) AS my_LENGTH
    FROM STATION STN
        ORDER BY my_LENGTH DESC, CITY LIMIT 1);

-- Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:
-- Root: If node is root node.
-- Leaf: If node is leaf node.
-- Inner: If node is neither root nor leaf node.

SELECT N, 
CASE 
    WHEN P IS NULL THEN 'Root' 
    WHEN N IN (SELECT DISTINCT P FROM BST) THEN 'Inner' 
    ELSE 'Leaf' 
    END 
FROM BST 
ORDER BY N;


SELECT cam.company_id,
    CASE 
    WHEN cam.revenue-cam.expenses < 0 THEN CONCAT('($',cam.revenue-cam.expenses,')') 
    ELSE CONCAT('$',cam.revenue-cam.expenses)
    END AS profit
FROM campaigns cam;



SELECT com.country, CONCAT(com.name,' =',prof.profit) AS companies
FROM    country com
        campaigns cam 
WHERE com.id = cam.id

--subquery

SELECT cam.company_id,
    CASE 
    WHEN cam.revenue-cam.expenses < 0 THEN CONCAT('($',cam.revenue-cam.expenses,')') 
    ELSE CONCAT('$',cam.revenue-cam.expenses)
    END AS profit
FROM campaigns cam;

SELECT com.country, com.name,
    CASE 
    WHEN cam.revenue-cam.expenses < 0 THEN CONCAT('($',cam.revenue-cam.expenses,')') 
    ELSE CONCAT('$',cam.revenue-cam.expenses)
    END AS profit
FROM    campaigns cam,
        companies com
WHERE com.id = cam.company_id
ORDER BY cam.company_id;

SELECT DISTINCT country, CONCAT(com.name,' =', "profit")  
FROM (
SELECT com.country, com.name, SUM(cam.revenue-cam.expenses) OVER(PARTTION BY com.country) AS profit,
    CASE 
    WHEN cam.revenue-cam.expenses < 0 THEN CONCAT('($',cam.revenue-cam.expenses,')') 
    ELSE CONCAT('$',cam.revenue-cam.expenses)
    END AS profit
FROM    campaigns cam,
        companies com
WHERE com.id = cam.company_id
ORDER BY cam.company_id);



----- second try
WITH dat AS(
SELECT com.country, com.name,
    CASE 
    WHEN cam.revenue-cam.expenses < 0 THEN CONCAT('($',cam.revenue-cam.expenses,')') 
    ELSE CONCAT('$',cam.revenue-cam.expenses)
    END AS profit
FROM    campaigns cam,
        companies com
WHERE com.id = cam.company_id
ORDER BY cam.company_id)

SELECT DISTINCT country
FROM dat;


---- FINAL
WITH dat AS(
SELECT  DISTINCT com.country, 
        com.name,
        CASE 
        WHEN SUM(cam.revenue-cam.expenses) OVER(PARTITION BY com.name) < 0 
            THEN CONCAT(' =($',SUM(cam.revenue-cam.expenses) OVER(PARTITION BY com.name),')') 
            ELSE CONCAT(' =$',SUM(cam.revenue-cam.expenses) OVER(PARTITION BY com.name))
        END as profit
FROM    campaigns cam,
        companies com
WHERE com.id = cam.company_id
ORDER BY com.country, profit DESC)


SELECT  country, GROUP_CONCAT(CONCAT(name, profit)) AS companies
FROM dat
GROUP BY country
;


WITH dat AS(
    SELECT  DISTINCT com.country, 
            com.name, SUM(cam.revenue-cam.expenses) OVER(PARTITION BY cam.company_id) AS profit
    FROM    campaigns cam,
            companies com
    WHERE com.id = cam.company_id
    ORDER BY com.country, profit DESC)
 
SELECT  country, GROUP_CONCAT(CONCAT(name, profit)) AS companies
FROM dat
GROUP BY country 
;


Write an SQL query to calculate the bonus of each employee. The bonus of an employee is 100% of their salary if the ID of the employee is an odd number and the employee name does not start with the character 'M'. The bonus of an employee is 0 otherwise.

Return the result table ordered by employee_id.
# Write your MySQL query statement below
SELECT employee_id, 
        CASE WHEN employee_id %2 <>0 AND LEFT(name, 1) <> 'M' 
        THEN salary 
        ELSE 0 
        END  AS bonus
FROM Employees
ORDER BY employee_id;

SELECT 
    employee_id,
    CASE 
        WHEN employee_id % 2 <> 0 AND name NOT LIKE 'M%' THEN salary
        ELSE 0
    END bonus
FROM
    Employees
ORDER BY 
    employee_id

# -----------

SELECT 
    *
FROM    (
    SELECT 
        CONCAT (
            Name, 
            '(', 
            LEFT(Occupation, 1), 
            ')'
                ) AS name2
    FROM
        OCCUPATIONS
        ) a
            
UNION

SELECT 
    CONCAT  (
        "There are a total of ", 
        CNT," ", 
        LOWER(Occupation), 
        's.'
            ) AS cnt2
FROM    (
    SELECT  
        COUNT(Occupation) AS CNT, 
        Occupation
    FROM    
        OCCUPATIONS
    GROUP BY 
        Occupation
    ORDER BY 
        CNT, 
        Occupation
        ) b
ORDER BY name2;

/*NOTE: Ordering table 'a' by Name made no difference AFTER the union, so only used final order by (name2).*/

