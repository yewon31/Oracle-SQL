-- 서브쿼리 (SELECT 구문들의 특정위치에 다시 SELECT가 들어가는 문장)
-- 단일행 서브쿼리 - 서브쿼리의 결과가 1행인 서브쿼리

-- 낸시보다 급여가 높은사람
-- 1. 낸시의 급여를 찾는다.
-- 2. 찾은 급여를 WHERE절에 넣는다.

-- [1]서브쿼리
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy';

-- [2]메인쿼리 + 서브쿼리
SELECT *
FROM EMPLOYEES
WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy');

-- 103번과 직업이 같은사람
SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103;

SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103);

-- 주의할점 - 비교할 컬럼은 정확히 한개여야 합니다.
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 103); --오류

-- 주의할점 - 여려행이 나오는 구문이라면, 다중행 서브퀴리 연산자를 써줘야합니다. (다중행 서브퀴리로 처리)
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Steven'; --2명
SELECT *
FROM EMPLOYEES
WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Steven'); --오류

----------------------------------------------------------------------------------------
-- 다중행 서브퀴리 - 서브퀴리의 결과가 여러행 리턴되는 경우 ANY, ALL, IN
SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME = 'David'; -- 4800, 6800, 9500

-- 데이비드의 최소급여보다 많이받는 사람
-- 4800보다 큰
SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'); -- > 4800

-- 데이비드의 최대급여보다 적게받는 사람
-- 9500보다 작은
SELECT *
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'); -- < 9500

-- 데이비드의 최대급여보다 많이받는 사람
-- 9500보다 큰
SELECT *
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'); -- > 9500

-- 데이비드의 최소급여보다 적게받는 사람
-- 4800보다 작은
SELECT *
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'); -- < 4800

-- 데이비드와 부서가 같은
-- [1]서브쿼리
SELECT DEPARTMENT_ID
FROM EMPLOYEES WHERE FIRST_NAME = 'David';

-- [2]메인쿼리 + 서브쿼리
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM EMPLOYEES WHERE FIRST_NAME = 'David');
----------------------------------------------------------------------------------------
-- 스칼라(Scalar) 서브쿼리 - SELECT분의 서브쿼리가 들어가는 경우 (JOIN을 대체함)
-- [방법1]기본(LEFT JOIN)
SELECT FIRST_NAME,
       D.DEPARTMENT_NAME,
       D.LOCATION_ID --가져올 칼럼이 2개 이상이면 JOIN
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;
-- [방법2]스칼라
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) DEPARTMENT_NAME --가져올 칼럼이 1개면 스칼라 서브쿼리
FROM EMPLOYEES E;

-- 스칼라쿼리는 다른 테이블의 1개의 컬럼을 가지고 올때, JOIN보다 구문 깔끔
SELECT FIRST_NAME,
       JOB_ID,
       (SELECT JOB_TITLE FROM JOBS J WHERE J.JOB_ID = E.JOB_ID) AS JOB_TITLE,
       (SELECT MIN_SALARY FROM JOBS J WHERE J.JOB_ID = E.JOB_ID) AS MIN_SALARY --테이블 1개에서 2개 칼럼 가져올거면 JOIN이 나음
FROM EMPLOYEES E;

-- 2개 테이블
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) DEPARTMENT_NAME,
       (SELECT JOB_TITLE FROM JOBS J WHERE J.JOB_ID = E.JOB_ID) AS JOB_TITLE --각 테이블에서 1개씩만 가져올거면 스칼라쿼리가 나음
FROM EMPLOYEES E;

-----------------------------------------------------------------------------------------------------------
-- 인라인 뷰 - FROM절 하위에 서브쿼리절이 들어갑니다.
-- 인라인 뷰에서 (가상컬럼) 을 만들고, 그 컬럼에 대해서 조회해 나갈때 사용합니다.

SELECT *
FROM (SELECT *
      FROM EMPLOYEES);

-- ROWNUM은 조회된 순서에 대해 번호가 붙습니다.
-- [1]rownum -> order
SELECT ROWNUM,
       FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC; --(★ROWNUM 먼저 구하고 ORDER됨 -> 인라인 뷰 추가)

-- [2-1]우선 order 만
SELECT FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC; --ROWNUM을 붙이고 order

-- [2-2]order -> rownum
SELECT ROWNUM,
       FIRST_NAME,
       SALARY
FROM (SELECT FIRST_NAME,
               SALARY
        FROM EMPLOYEES
        ORDER BY SALARY DESC)
        WHERE ROWNUM BETWEEN 1 AND 10; --가능
      --WHERE ROWNUM BETWEEN 11 AND 20; --불가능(★ROWNUM은 1부터 셀 수 있음 -> 인라인 뷰 추가)
      
-- [3]order -> rownum -> 11~20만 가져오기
SELECT *
FROM (SELECT ROWNUM RN, --가상열
       FIRST_NAME,
       SALARY
        FROM (SELECT FIRST_NAME,
                       SALARY
                FROM EMPLOYEES
                ORDER BY SALARY DESC))
WHERE RN BETWEEN 11 AND 20;

-----------------------------------------------------
-- 예시
-- 근속년수 5년째 되는 사람들만 출력
SELECT *
FROM (SELECT FIRST_NAME,
             HIRE_DATE,  
             TRUNC( (SYSDATE - HIRE_DATE) / 365 ) AS 근속년수 -- 안에서 만든 가상열에 대해서 재조회 해낼때 인라인뷰가 사용됨
      FROM EMPLOYEES
      ORDER BY 근속년수 DESC)
WHERE MOD (근속년수, 5) = 0;

--08_기타함수.sql 문제 3. 
--EMPLOYEES 테이블의 이름, 입사일, 급여, 진급대상 을 출력합니다.
--조건1) HIRE_DATE를 XXXX년XX월XX일 형식으로 출력하세요. 
--조건2) 급여는 커미션값이 퍼센트로 더해진 값을 출력하고, 1300을 곱한 원화로 바꿔서 출력하세요.
--조건3) 진급대상은 5년 마다 이루어 집니다. 근속년수가 5의 배수라면 진급대상으로 출력합니다.
--조건4) 부서가 NULL이 아닌 데이터를 대상으로 출력합니다.
SELECT FIRST_NAME AS 이름
    , TO_CHAR(HIRE_DATE, 'YYYY"년"MM"월"DD"일"') AS 입사일
    , TO_CHAR(SALARY+(SALARY*NVL(COMMISSION_PCT, 0))*1300, 'L999,999,999,999') AS 급여
    , DECODE(REMAINDER(TRUNC((SYSDATE-HIRE_DATE)/365), 5), 0, '진급대상', '진급대상 아님') AS 진급대상 
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID IS NOT NULL;

--인라인 뷰에서 테이블 엘리어스로 조회
SELECT  ROWNUM AS RN,
        A.*
FROM (  SELECT  E.* ,
                TRUNC( (SYSDATE - HIRE_DATE) / 365 ) AS 근속년수
        FROM EMPLOYEES E
        ORDER BY 근속년수 DESC
) A
WHERE MOD (근속년수, 5) = 0;