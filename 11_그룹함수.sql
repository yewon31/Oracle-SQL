-- 그룹함수
-- NULL이 제외된 데이터들에 대해서 적용됨.
SELECT MAX(SALARY), MIN(SALARY), SUM(SALARY), AVG(SALARY), COUNT(SALARY) FROM EMPLOYEES;
-- MIN, MAX는 날짜, 문자에도 적용 됩니다.
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE), MIN(FIRST_NAME), MAX(FIRST_NAME) FROM EMPLOYEES;
-- COUNT() 두가지 사용방법
SELECT COUNT(*), COUNT(COMMISSION_PCT) FROM EMPLOYEES;
-- 부서가 80인 사람들중, 커미션이 가장 높은사람
SELECT MAX (COMMISSION_PCT) FROM EMPLOYEES WHERE DEPARTMENT_ID = 80;
-- 그룹함수는, 일반컬럼이 동시에 사용이 불가능.
SELECT FIRST_NAME, AVG(SALARY) FROM EMPLOYEES; --오류
-- 그룹함수 뒤에 OVER() 를 붙이면, 일반컬럼과 동시에 사용이 가능함.
SELECT FIRST_NAME, AVG (SALARY) OVER(), COUNT (*) OVER(), SUM(SALARY) OVER() FROM EMPLOYEES;

-- GROUP BY절 - WHERE절 ORDER절 사이에 적습니다.
SELECT DEPARTMENT_ID,
        SUM (SALARY),
        AVG (SALARY),
        MIN (SALARY),
        MAX (SALARY),
        COUNT (*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

--GROUP화 시킨 컬럼만, SELECT구문에 적을 수 있습니다.
SELECT DEPARTMENT_ID,
FIRST NAME
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID; -- 에러

-- 2개 이상의 그룹화 (하위 그룹)
SELECT DEPARTMENT_ID, 
        JOB_ID,
        SUM(SALARY) AS "부서 직무별 급여 합",
        AVG(SALARY) AS "부서 직무별 급여 평균",
        COUNT(*) AS "부서 인원수",
        COUNT(*) OVER() "전체 카운트" -- COUNT(*) OVER() 사용하면 총 행의 개수 출력가능
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;
--------------------------------------------------------------------
-- 그룹함수는 WHERE에 적을 수 없음
SELECT DEPARTMENT_ID,
AVG(SALARY)
FROM EMPLOYEES
WHERE AVG(SALARY) >= 5000 -- 그룹의 조건을 적는 곳은 HAVING 이라고 따로 있음.
GROUP BY DEPARTMENT_ID;