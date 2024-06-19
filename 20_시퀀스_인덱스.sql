--시퀀스 (순차적으로 증가하는 값)
--주로 PK에 적용될 수 있습니다. 

SELECT * FROM USER_SEQUENCES;

--시퀀스 생성 (외워~)
CREATE SEQUENCE DEPTS_SEQ 
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 10
    NOCACHE --캐시에 시퀀스를 두지 않음
    NOCYCLE; --최대값에 도달했을 때 재사용X
    
--적용
DROP TABLE DEPTS;
CREATE TABLE DEPTS (
    DEPT_NO NUMBER(2) PRIMARY KEY,
    DEPT_NAME VARCHAR(30)
);

--시퀀스 사용방법 2개
SELECT DEPTS_SEQ.CURRVAL FROM DUAL; --현재 시퀀스 (NEXTVAL가 선행 되어야함)
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL; --현재 시퀀스 증가값만큼 증가

--시퀀스 적용
INSERT INTO DEPTS VALUES( DEPTS_SEQ.NEXTVAL , 'EXAMPLE' ); 

--시퀀스 수정
ALTER SEQUENCE DEPTS_SEQ MAXVALUE 1000;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 10;

--시퀀스가 이미 사용되고 있다면, DROP하면 안됩니다.
--만약 시퀀스를 초기화 해야한다면?
--시퀀스의 증가값을 -음수 로 만들어서 초기화 인것처럼 쓸 수 는 있습니다.
SELECT DEPTS_SEQ.CURRVAL FROM DUAL;

--1. 시퀀스의 증가를 -(현재값 -1) 로 바꿈
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY -69; 
--2. 현재시퀀스를 전진
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL;
--3. 다시 증가값을 1로 변경
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 1;
------------------------------------------------------------
--시퀀스 응용 (나중에 테이블을 설계할 때, 데이터가 엄청많다면 PK에 시퀀스의 사용 고려)
--문자열 PK (년도값-일련번호)
--년도가 바뀌면 시퀀스를 초기화
CREATE TABLE DEPTS2(
    DEPT_NO VARCHAR2(20) PRIMARY KEY,
    DEPT_NAME VARCHAR2(20)
);
INSERT INTO DEPTS2 VALUES( TO_CHAR(SYSDATE, 'YYYY-MM-') || LPAD(DEPTS_SEQ.NEXTVAL, 6, 0) , 'EXAMPLE');
SELECT * FROM DEPTS2;
--시퀀스 삭제
DROP SEQUENCE 시퀀스명;


--------------------------------------------------------------------------------
--INDEX
--INDEX는 PK, UNIQUE에 자동으로 생성되고, 조회를 빠르게 하는 HINT역할을 합니다.
--INDEX종류는 고유인덱스, 비고유인덱스 가 있습니다.
--UNIQUE한 컬럼에는 UNIQUE인덱스(고유) 인덱스가 쓰입니다.
--일반컬럼에는 비고유 인덱스를 지정할 수 있습니다.
--INDEX는 조회를 빠르게 하지만, DML구문이 많이 사용되는 컬럼은 오히려 성능저하를 부를 수도 있습니다.


--인덱스 생성
CREATE TABLE EMPS_IT AS (SELECT * FROM EMPLOYEES);

--인덱스가 없을 때 조회
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'Nancy';

--비고유 인덱스 생성 (부착)
CREATE INDEX EMPS_IT_IX ON EMPS_IT (FIRST_NAME);

--인덱스 생성후 FIRST_NAME으로 다시 조회
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'Nancy';

--인덱스 삭제 (인덱스는 삭제하더라도 테이블에 영향을 미치지 않습니다)
DROP INDEX EMPS_IT_IX;

--결합인덱스 (여러개 컬럼을 동시에 인덱스로 지정)
CREATE INDEX EMPS_IT_IX ON EMPS_IT (FIRST_NAME, LAST_NAME);

SELECT * FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy'; --힌트 얻음
SELECT * FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy' AND LAST_NAME = 'Greenberg'; --힌트얻음
SELECT * FROM EMPLOYEES WHERE LAST_NAME = 'Greenberg'; --힌트 얻음

--고유인덱스 (PK, UNIQUE에서 자동생성됨)
--CREATE UNIQUE INDEX 인덱스명 ~~~~~~~