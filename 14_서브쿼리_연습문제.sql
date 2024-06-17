--문제 1.
--EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 데이터를 출력 하세요 ( AVG(컬럼) 사용)
SELECT E.*
FROM EMPLOYEES E
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEES);
--EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 수를 출력하세요
SELECT COUNT(*)
FROM EMPLOYEES E
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEES);
--EMPLOYEES 테이블에서 job_id가 IT_PFOG인 사원들의 평균급여보다 높은 사원들을 데이터를 출력하세요.
SELECT E.*
FROM EMPLOYEES E
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEES
                WHERE JOB_ID = 'IT_PROG');

--문제 2.
--DEPARTMENTS 테이블에서 manager_id가 100인 사람의 department_id(부서아이디) 와
--EMPLOYEES 테이블에서 department_id(부서아이디) 가 일치하는 모든 사원의 정보를 검색하세요.
SELECT E.*
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID = (   SELECT DEPARTMENT_ID
                            FROM DEPARTMENTS D
                            WHERE MANAGER_ID = 100);
                
--문제 3.
--EMPLOYEES테이블에서 “Pat”의 manager_id보다 높은 manager_id를 갖는 모든 사원의 데이터를 출력하세요
SELECT E.*
FROM EMPLOYEES E
WHERE MANAGER_ID > (SELECT MANAGER_ID
                    FROM EMPLOYEES
                    WHERE FIRST_NAME = 'Pat');
--EMPLOYEES테이블에서 “James”(2명)들의 manager_id와 같은 모든 사원의 데이터를 출력하세요.
SELECT E.*
FROM EMPLOYEES E
WHERE MANAGER_ID IN (SELECT MANAGER_ID
                    FROM EMPLOYEES
                    WHERE FIRST_NAME = 'James');
--Steven과 동일한 부서에 있는 사람들을 출력해주세요.
SELECT E.*
FROM EMPLOYEES E
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                    FROM EMPLOYEES
                    WHERE FIRST_NAME = 'Steven');
--Steven의 급여보다 많은 급여를 받는 사람들은 출력하세요.
SELECT E.*
FROM EMPLOYEES E
WHERE SALARY > ANY (SELECT SALARY
                    FROM EMPLOYEES
                    WHERE FIRST_NAME = 'Steven');
--문제 4.
--EMPLOYEES테이블 DEPARTMENTS테이블을 left 조인하세요
--조건) 직원아이디, 이름(성, 이름), 부서아이디, 부서명 만 출력합니다.
--조건) 직원아이디 기준 오름차순 정렬
SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.FIRST_NAME, E.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY EMPLOYEE_ID ASC;

--문제 5.
--문제 4의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT  E.EMPLOYEE_ID, E.LAST_NAME, E.FIRST_NAME, E.DEPARTMENT_ID, 
        (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID) DEPARTMENT_NAME
FROM EMPLOYEES E
ORDER BY EMPLOYEE_ID ASC;

--문제 6.
--DEPARTMENTS테이블 LOCATIONS테이블을 left 조인하세요
--조건) 부서아이디, 부서이름, 스트릿_어드레스, 시티 만 출력합니다
--조건) 부서아이디 기준 오름차순 정렬
SELECT  D.DEPARTMENT_ID, D.DEPARTMENT_NAME, L.STREET_ADDRESS, L.CITY
FROM DEPARTMENTS D
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID
ORDER BY DEPARTMENT_ID ASC;

--문제 7.
--문제 6의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT  D.DEPARTMENT_ID, D.DEPARTMENT_NAME, 
        (SELECT STREET_ADDRESS FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) STREET_ADDRESS,
        (SELECT CITY FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) CITY
FROM DEPARTMENTS D
ORDER BY D.DEPARTMENT_ID ASC;

--문제 8.
--LOCATIONS테이블 COUNTRIES테이블을 스칼라 쿼리로 조회하세요.
--조건) 로케이션아이디, 주소, 시티, country_id, country_name 만 출력합니다
--조건) country_name기준 오름차순 정렬
SELECT  L.LOCATION_ID, L.STREET_ADDRESS, L.CITY, L.COUNTRY_ID,
        (SELECT COUNTRY_NAME FROM COUNTRIES C WHERE C.COUNTRY_ID = L.COUNTRY_ID) COURNTY_NAME
FROM LOCATIONS L
ORDER BY COURNTY_NAME ASC;

----------------------------------------------------------------------------------------------------
--문제 9.
--EMPLOYEES테이블 에서 first_name기준으로 내림차순 정렬하고, 41~50번째 데이터의 행 번호, 이름을 출력하세요
SELECT E2.RN, E2.FIRST_NAME
FROM (  SELECT ROWNUM RN, E1.*
        FROM (  SELECT E.*
                FROM EMPLOYEES E
                ORDER BY E.FIRST_NAME DESC) E1) E2
WHERE RN BETWEEN 41 AND 50;

--문제 10.
--EMPLOYEES테이블에서 hire_date기준으로 오름차순 정렬하고, 31~40번째 데이터의 행 번호, 사원id, 이름, 번호, 
--입사일을 출력하세요.
SELECT RN, EMPLOYEE_ID, FIRST_NAME, PHONE_NUMBER, HIRE_DATE
FROM (  SELECT ROWNUM RN, E.*
        FROM (  SELECT *
                FROM EMPLOYEES
                ORDER BY HIRE_DATE ASC) E) 
WHERE RN BETWEEN 31 AND 40;

--문제 11.
--COMMITSSION을 적용한 급여를 새로운 컬럼으로 만들고 10000보다 큰 사람들을 뽑아 보세요. (인라인뷰를 쓰면 됩니다)
SELECT *
FROM (  SELECT E.*, SALARY+SALARY*NVL(COMMISSION_PCT, 0) FINAL_SALARY
        FROM EMPLOYEES E)
WHERE FINAL_SALARY > 10000;


--문제12
--EMPLOYEES테이블, DEPARTMENTS 테이블을 left조인하여, 입사일 오름차순 기준으로 10-20번째 데이터만 출력합니다.
--조건) rownum을 적용하여 번호, 직원아이디, 이름, 입사일, 부서이름 을 출력합니다.
--조건) hire_date를 기준으로 오름차순 정렬 되어야 합니다. rownum이 망가지면 안되요.
--[방법1]JOIN 걸고 인라인 뷰
SELECT RN, EMPLOYEE_ID, FIRST_NAME, HIRE_DATE, DEPARTMENT_NAME
FROM (  SELECT ROWNUM RN, A.*
        FROM (  SELECT E.*, D.DEPARTMENT_NAME
                FROM EMPLOYEES E
                LEFT JOIN DEPARTMENTS D
                ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
                ORDER BY E.HIRE_DATE ASC) A)
WHERE RN BETWEEN 10 AND 20;
--[방법2]인라인 뷰로 다 가져오고 JOIN(or 스칼라 서브쿼리)
SELECT RN, EMPLOYEE_ID, FIRST_NAME, HIRE_DATE,
        (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = B.DEPARTMENT_ID)DEPARTMENT_NAME
FROM (  SELECT ROWNUM RN, A.*
        FROM (  SELECT E.*
                FROM EMPLOYEES E
                ORDER BY E.HIRE_DATE ASC) A) B
WHERE RN BETWEEN 10 AND 20;

--문제13
--SA_MAN 사원의 급여 내림차순 기준으로 ROWNUM을 붙여주세요.
--조건) SA_MAN 사원들의 ROWNUM, 이름, 급여, 부서아이디, 부서명을 출력하세요.
SELECT ROWNUM RN, A.FIRST_NAME, A.SALARY, A.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM (  SELECT *
        FROM EMPLOYEES
        WHERE JOB_ID = 'SA_MAN'
        ORDER BY SALARY DESC) A
JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = A.DEPARTMENT_ID;

--문제14
--DEPARTMENTS테이블에서 각 부서의 부서명, 매니저아이디, 부서에 속한 인원수 를 출력하세요.
--조건) 인원수 기준 내림차순 정렬하세요.
--조건) 사람이 없는 부서는 출력하지 뽑지 않습니다.
--한트) 부서의 인원수 먼저 구한다. 이 테이블을 조인한다.
SELECT D.DEPARTMENT_NAME, D.MANAGER_ID, E.CNT 인원수
FROM (  SELECT DEPARTMENT_ID, COUNT(*) CNT
        FROM EMPLOYEES
        GROUP BY DEPARTMENT_ID) E
JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
ORDER BY 인원수 DESC;

--문제15
--부서에 모든 컬럼, 주소, 우편번호, 부서별 평균 연봉을 구해서 출력하세요.
--조건) 부서별 평균이 없으면 0으로 출력하세요
SELECT D.*, L.STREET_ADDRESS, TRUNC(NVL(평균연봉, 0))
FROM DEPARTMENTS D
JOIN LOCATIONS L
ON L.LOCATION_ID = D.LOCATION_ID
LEFT JOIN (     SELECT DEPARTMENT_ID, AVG(SALARY) 평균연봉
                FROM EMPLOYEES
                GROUP BY DEPARTMENT_ID) E
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

--문제16
--문제 15결과에 대해 DEPARTMENT_ID기준으로 내림차순 정렬해서 ROWNUM을 붙여 1-10데이터 까지만
--출력하세요
SELECT *
FROM (SELECT ROWNUM RN, A.*
        FROM (  SELECT D.*, L.STREET_ADDRESS, TRUNC(NVL(평균연봉, 0))
                FROM DEPARTMENTS D
                JOIN LOCATIONS L
                ON L.LOCATION_ID = D.LOCATION_ID
                LEFT JOIN (     SELECT DEPARTMENT_ID, AVG(SALARY) 평균연봉
                                FROM EMPLOYEES
                                GROUP BY DEPARTMENT_ID) E
                ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
                ORDER BY D.DEPARTMENT_ID DESC) A)
WHERE RN BETWEEN 1 AND 10;