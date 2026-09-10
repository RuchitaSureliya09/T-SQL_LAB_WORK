USE CSE_3A_128

--From the table EMPLOYEE perform the following queries:
SELECT * FROM EMPLOYEE

--1. Create a stored procedure to generate department-wise salary statistics like total salary, average
--salary, minimum salary, and maximum salary. (User enter only department name)

CREATE OR ALTER PROCEDURE SP_DEPARTMENT_SALARY_STATISTICS
    @DEPARTMENT VARCHAR(50)
AS
BEGIN
    SELECT
        DEPARTMENT,
        SUM(SALARY) AS TOTAL_SALARY,
        AVG(SALARY) AS AVERAGE_SALARY,
        MIN(SALARY) AS MINIMUM_SALARY,
        MAX(SALARY) AS MAXIMUM_SALARY
    FROM EMPLOYEE
    WHERE DEPARTMENT = @DEPARTMENT
    GROUP BY DEPARTMENT
END


EXEC SP_DEPARTMENT_SALARY_STATISTICS 'IT'



--2. Create a stored procedure that accepts a joining year and displays employees who joined that year.

CREATE OR ALTER PROCEDURE SP_EMPLOYEES_BY_JOININGYEAR
    @YEAR INT
AS
BEGIN
    SELECT *
    FROM EMPLOYEE
    WHERE JOININGYEAR = @YEAR
END


EXEC SP_EMPLOYEES_BY_JOININGYEAR 2024



--3. Create a stored procedure for dynamic employee search using parameters (User may enter partial cityname).

CREATE PROCEDURE SP_SEARCH_EMPLOYEE_BY_CITY
    @CITY VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM EMPLOYEE
    WHERE CITY LIKE '%' + @CITY + '%'
END


EXEC SP_SEARCH_EMPLOYEE_BY_CITY 'RAJ'



--4. Create a stored procedure that accepts a salary amount and displays employees earning more than the entered salary.

CREATE OR ALTER PROCEDURE SP_EMPLOYEES_ABOVE_SALARY
    @SALARY DECIMAL(8,2)
AS
BEGIN
    SELECT *
    FROM EMPLOYEE
    WHERE SALARY > @SALARY
END


EXEC SP_EMPLOYEES_ABOVE_SALARY 10000



--5. Create a stored procedure to display top N highest paid employees from each department 
--(Value of N is entered by user).

CREATE OR ALTER PROCEDURE SP_TOP_N_EMPLOYEES_BY_DEPARTMENT
    @N INT
AS
BEGIN
    SELECT *
    FROM
    (
        SELECT *,
        ROW_NUMBER() 
        OVER(PARTITION BY DEPARTMENT ORDER BY SALARY DESC) AS RN
        FROM EMPLOYEE
    ) AS E
    WHERE RN <= @N
    ORDER BY DEPARTMENT, SALARY DESC
END


EXEC SP_TOP_N_EMPLOYEES_BY_DEPARTMENT 2



--6. Create a stored procedure to increase salary department-wise by a given percentage. 
--(User Enter Department Name and %, e.g. Computer 10).

CREATE OR ALTER PROCEDURE SP_INCREASE_DEPARTMENT_SALARY
    @DEPARTMENT VARCHAR(50),
    @PERCENTAGE DECIMAL(5,2)
AS
BEGIN
    UPDATE EMPLOYEE
    SET SALARY = SALARY + (SALARY * @PERCENTAGE / 100)
    WHERE DEPARTMENT = @DEPARTMENT

    SELECT *
    FROM EMPLOYEE
    WHERE DEPARTMENT = @DEPARTMENT
END


EXEC SP_INCREASE_DEPARTMENT_SALARY 'IT', 5



--7. Create a stored procedure to display employees having experience greater than or equal to the entered years.

CREATE OR ALTER PROCEDURE SP_EMPLOYEES_BY_EXPERIENCE
    @YEARS INT
AS
BEGIN
    SELECT *,
        YEAR(GETDATE()) - JOININGYEAR AS EXPERIENCE
    FROM EMPLOYEE
    WHERE YEAR(GETDATE()) - JOININGYEAR >= @YEARS
END


EXEC SP_EMPLOYEES_BY_EXPERIENCE 3



--8. Create a stored procedure that accepts a number as input and displays details of the last N employees who joined the organization.

CREATE OR ALTER PROCEDURE SP_LAST_N_EMPLOYEES
    @N INT
AS
BEGIN
    SELECT TOP (@N) *
    FROM EMPLOYEE
    ORDER BY JOININGYEAR DESC, EID DESC
END


EXEC SP_LAST_N_EMPLOYEES 5



--From the table AUTHOR, PUBLISHER and BOOK perform the following queries:
SELECT * FROM AUTHOR
SELECT * FROM PUBLISHER
SELECT * FROM BOOK

--9. Create a stored procedure that accepts an author name and displays all books written by that author.

CREATE OR ALTER PROCEDURE SP_BOOKS_BY_AUTHOR
    @AUTHORNAME VARCHAR(100)
AS
BEGIN
    SELECT
        B.BOOKID, B.TITLE,
        B.PRICE, B.PUBLICATIONYEAR,
        A.AUTHORNAME
    FROM BOOK B
    INNER JOIN AUTHOR A
    ON B.AUTHORID = A.AUTHORID
    WHERE A.AUTHORNAME = @AUTHORNAME
END


EXEC SP_BOOKS_BY_AUTHOR 'ARUNDHATI ROY'



--10. Create a stored procedure that accepts a publication year and displays books published after that year.

CREATE OR ALTER PROCEDURE SP_BOOKS_AFTER_YEAR
    @YEAR INT
AS
BEGIN
    SELECT
        B.BOOKID, B.TITLE,
        B.PRICE, B.PUBLICATIONYEAR,
        A.AUTHORNAME, P.PUBLISHERNAME
    FROM BOOK B
    INNER JOIN AUTHOR A
    ON B.AUTHORID = A.AUTHORID
    INNER JOIN PUBLISHER P
    ON B.PUBLISHERID = P.PUBLISHERID
    WHERE B.PUBLICATIONYEAR > @YEAR
END


EXEC SP_BOOKS_AFTER_YEAR 2000



--11. Create a stored procedure that accepts a country name and displays all authors from that country with their books.

CREATE OR ALTER PROCEDURE SP_AUTHORS_BY_COUNTRY
    @COUNTRY VARCHAR(50)
AS
BEGIN
    SELECT
        A.AUTHORID, A.AUTHORNAME,
        A.COUNTRY, 
        B.BOOKID, B.TITLE
    FROM AUTHOR A
    INNER JOIN BOOK B
    ON A.AUTHORID = B.AUTHORID
    WHERE A.COUNTRY = @COUNTRY
END


EXEC SP_AUTHORS_BY_COUNTRY 'INDIA'



--12. Create a stored procedure that accepts a number as input and displays the top N most expensive books with author and publisher details.

CREATE OR ALTER PROCEDURE SP_TOP_N_EXPENSIVE_BOOKS
    @N INT
AS
BEGIN
    SELECT TOP (@N)
        B.BOOKID, B.TITLE,
        B.PRICE,
        A.AUTHORNAME, P.PUBLISHERNAME
    FROM BOOK B
    INNER JOIN AUTHOR A
    ON B.AUTHORID = A.AUTHORID
    INNER JOIN PUBLISHER P
    ON B.PUBLISHERID = P.PUBLISHERID
    ORDER BY B.PRICE DESC
END


EXEC SP_TOP_N_EXPENSIVE_BOOKS 5



--13. Create a stored procedure that accepts a publisher name and displays the total number of books published by that publisher.

CREATE OR ALTER PROCEDURE SP_TOTAL_BOOKS_BY_PUBLISHER
    @PUBLISHERNAME VARCHAR(100)
AS
BEGIN
    SELECT
        P.PUBLISHERNAME,
        COUNT(B.BOOKID) AS TOTAL_BOOKS
    FROM PUBLISHER P
    LEFT JOIN BOOK B
    ON P.PUBLISHERID = B.PUBLISHERID
    WHERE P.PUBLISHERNAME = @PUBLISHERNAME
    GROUP BY P.PUBLISHERNAME
END


EXEC SP_TOTAL_BOOKS_BY_PUBLISHER 'PENGUIN INDIA'



--14. Create a stored procedure that accepts a price range (Min Price Max Price) and displays books whose prices fall within that range.

CREATE OR ALTER PROCEDURE SP_BOOKS_BY_PRICE_RANGE
    @MINPRICE DECIMAL(8,2),
    @MAXPRICE DECIMAL(8,2)
AS
BEGIN
    SELECT
        B.BOOKID, B.TITLE,
        B.PRICE, B.PUBLICATIONYEAR,
        A.AUTHORNAME, P.PUBLISHERNAME
    FROM BOOK B
    INNER JOIN AUTHOR A
    ON B.AUTHORID = A.AUTHORID
    INNER JOIN PUBLISHER P
    ON B.PUBLISHERID = P.PUBLISHERID
    WHERE B.PRICE BETWEEN @MINPRICE AND @MAXPRICE
    ORDER BY B.PRICE
END


EXEC SP_BOOKS_BY_PRICE_RANGE 250, 400



--15. Create a stored procedure that accepts an author ID and deletes all books written by that author.

CREATE OR ALTER PROCEDURE SP_DELETE_BOOKS_BY_AUTHOR
    @AUTHORID INT
AS
BEGIN
    DELETE FROM BOOK
    WHERE AUTHORID = @AUTHORID
END


EXEC SP_DELETE_BOOKS_BY_AUTHOR 1
