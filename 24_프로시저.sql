--������ ���ν��� (�Ϸ��� SQL ó�� ������ ����ó�� ��� ����ϴ� ����)

SET SERVEROUTPUT ON;
--����� ȣ���� �ֽ��ϴ�
CREATE OR REPLACE PROCEDURE NEW_JOB_POC --���ν�����
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
--ȣ��
EXEC NEW_JOB_POC;

--------------------------------------------------------------------------------
--���ν����� �Ű����� IN
CREATE OR REPLACE PROCEDURE NEW_JOB_PROC -- �̸��� ������ �ڵ����� ������.
    (P_JOB_ID IN VARCHAR2,
     P_JOB_TITLE IN VARCHAR2,
     P_MIN_SALARY IN JOBS.MIN_SALARY%TYPE := 0, -- ���̺��� Ÿ�԰� ������ Ÿ��
     P_MAX_SALARY IN JOBS.MAX_SALARY%TYPE := 10000
    )
IS
BEGIN
    
    INSERT INTO JOBS_IT VALUES(P_JOB_ID, P_JOB_TITLE, P_MIN_SALARY, P_MAX_SALARY);
    COMMIT;

END;
--
EXEC NEW_JOB_PROC('EXAMPLE', 'EXAMPLE', 1000, 10000);
EXEC NEW_JOB_PROC('EXAMPLE'); -- �Ű������� ��ġ���� ������ X
EXEC NEW_JOB_PROC('SAMPLE', 'SAMPLE2'); -- DEFAULT�Ű������� �ִٸ�, �⺻������ ���޵˴ϴ�.

SELECT * FROM JOBS_IT;
--------------------------------------------------------------------------------
--PLSQL��� ���� ���, Ż�⹮, Ŀ�� ������ ���ν����� ���� �ֽ��ϴ�.
--JOB_ID�� �����ϸ� UPDATE, ������ INSERT
CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (A IN VARCHAR2, --JOB_ID
     B IN VARCHAR2,
     C IN NUMBER,
     D IN NUMBER
    )
IS
    CNT NUMBER; --��������
BEGIN
    SELECT COUNT(*)
    INTO CNT -- ������ CNT�� ����
    FROM JOBS_IT
    WHERE JOB_ID = A; 
    
    IF CNT = 0 THEN
        --INSERT
        INSERT INTO JOBS_IT VALUES(A, B, C ,D);
    ELSE 
        --UPDATE
        UPDATE JOBS_IT 
        SET JOB_ID = A,
            JOB_TITLE = B,
            MIN_SALARY = C,
            MAX_SALARY = D
        WHERE JOB_ID = A;
    END IF;
    
    COMMIT;
    
END;
--
EXEC NEW_JOB_PROC('AD', 'ADMIN', 1000, 10000);
EXEC NEW_JOB_PROC('AD_VP', 'ADMIN2', 1000, 20000);


SELECT * FROM JOBS_IT;
--------------------------------------------------------------------------------
--OUT�Ű����� - �ܺη� ���� �����ֱ� ���� �Ű�����
CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (A IN VARCHAR2, --JOB_ID
     B IN VARCHAR2,
     C IN NUMBER,
     D IN NUMBER,
     E OUT NUMBER -- �ܺη� ������ �Ű�����
    )
IS
    CNT NUMBER; --��������
BEGIN
    SELECT COUNT(*)
    INTO CNT -- ������ CNT�� ����
    FROM JOBS_IT
    WHERE JOB_ID = A; 
    
    IF CNT = 0 THEN
        --INSERT
        INSERT INTO JOBS_IT VALUES(A, B, C ,D);
    ELSE 
        --UPDATE
        UPDATE JOBS_IT 
        SET JOB_ID = A,
            JOB_TITLE = B,
            MIN_SALARY = C,
            MAX_SALARY = D
        WHERE JOB_ID = A;
    END IF;
    
    -- �ƿ� �Ű������� ���� �Ҵ�
    E := CNT;
        
    COMMIT;
    
END;
--
DECLARE
    CNT NUMBER;
BEGIN
    --EXEC ����
    NEW_JOB_PROC('AD_VP', 'ADMIN', 1000, 10000, CNT); 
    
    DBMS_OUTPUT.PUT_LINE('���ν��� ���ο��� �Ҵ���� ��:' || CNT);
    
END;
--------------------------------------------------------------------------------
--RETURN�� - ���ν����� ������.
--EXCEPTION WHEN OTHERS THEN - ���� �߻��ϸ� �����
CREATE OR REPLACE PROCEDURE NEW_JOB_PROC2
    (P_JOB_ID IN JOBS.JOB_ID%TYPE
    )
IS
    CNT NUMBER;
    SALARY NUMBER;
BEGIN
    
    SELECT COUNT(*)
    INTO CNT
    FROM JOBS
    WHERE JOB_ID = P_JOB_ID;
    
    IF CNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('���� �����ϴ�');
        RETURN; -- ���ν��� ����
    ELSE 
        
        SELECT MAX_SALARY
        INTO SALARY
        FROM JOBS
        WHERE JOB_ID = P_JOB_ID;
        
        DBMS_OUTPUT.PUT_LINE('�ִ�޿�:' || SALARY );
        
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('���ν��� ���� ����!!');  
    
    --����ó�� ���� (���ܸ� ������ ���ܹ����� �����)
    EXCEPTION WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('���ܰ� �߻��߽��ϴ�');
    
END;
--
EXEC NEW_JOB_PROC2('AD'); --RETURN ���� ������ ���ν��� ����
EXEC NEW_JOB_PROC2('AD_VP');
--------------------------------------------------------------------------------
--3. ���ν����� DEPTS_PROC
--- �μ���ȣ, �μ���, �۾� flag(I: insert, U:update, D:delete)�� �Ű������� �޾� 
--DEPTS���̺� ���� flag�� i�� INSERT, u�� UPDATE, d�� DELETE �ϴ� ���ν����� �����մϴ�.
--- �׸��� ���������� commit, ���ܶ�� �ѹ� ó���ϵ��� ó���ϼ���.
--- ����ó���� �ۼ����ּ���.
CREATE OR REPLACE PROCEDURE DEPTS_PROC
    (DEPT_ID IN DEPARTMENTS.DEPARTMENT_ID%TYPE,
     DEPT_NAME IN DEPARTMENTS.DEPARTMENT_NAME%TYPE,
     FLAG IN VARCHAR2
    )
IS
BEGIN
    
    IF FLAG = 'I' THEN
        INSERT INTO DEPTS(DEPARTMENT_ID, DEPARTMENT_NAME) VALUES(DEPT_ID, DEPT_NAME);
    ELSIF FLAG = 'U' THEN
        UPDATE DEPTS 
        SET DEPARTMENT_NAME = DEPT_NAME
        WHERE DEPARTMENT_ID = DEPT_ID;
    ELSIF FLAG = 'D' THEN
        DELETE FROM DEPTS WHERE DEPARTMENT_ID = DEPT_ID;
    END IF;

    COMMIT;
    
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
END;
--
CREATE TABLE DEPTS AS (SELECT * FROM DEPARTMENTS WHERE 1 = 2);
--
EXEC DEPTS_PROC(10, 'AD', 'I');
EXEC DEPTS_PROC(10, 'ADMIN', 'U');

SELECT * FROM DEPTS;
--6. ���ν����� - SALES_PROC
--- sales���̺��� ������ �Ǹų����̴�.
--- day_of_sales���̺��� �Ǹų��� ������ ���� ������ �Ѹ����� ����ϴ� ���̺��̴�.
--- ������ sales�� ���ó�¥ �Ǹų����� �����Ͽ� day_of_sales�� �����ϴ� ���ν����� �����غ�����.
--����) day_of_sales�� ���������� �̹� �����ϸ� ������Ʈ ó��
CREATE TABLE SALES(
    SNO NUMBER(5) CONSTRAINT SALES_PK PRIMARY KEY, -- ��ȣ
    NAME VARCHAR2(30), -- ��ǰ��
    TOTAL NUMBER(10), --����
    PRICE NUMBER(10), --����
    REGDATE DATE DEFAULT SYSDATE --��¥
);
CREATE TABLE DAY_OF_SALES(
    REGDATE DATE,
    FINAL_TOTAL NUMBER(10)
);

INSERT INTO SALES(SNO, NAME, TOTAL, PRICE) VALUES (1, '�Ƹ޸�ī��', 3, 1000);
INSERT INTO SALES(SNO, NAME, TOTAL, PRICE) VALUES (2, '�ݵ���', 2, 2000);
INSERT INTO SALES(SNO, NAME, TOTAL, PRICE) VALUES (3, '��ü��', 1, 3000);

--
CREATE OR REPLACE PROCEDURE SALES_PROC
IS
    CNT NUMBER := 0; --��Ż��
    FLAG NUMBER := 0; --���ó�¥ �����Ͱ� �ִ��� ����
BEGIN  
    --1. ���ó�¥�� �ݾ� ����
    SELECT SUM(TOTAL * PRICE)
    INTO CNT
    FROM SALES 
    WHERE TO_CHAR(REGDATE, 'YYYYMMDD') = TO_CHAR(SYSDATE, 'YYYYMMDD');
    --2. �������̺� ���ó�¥ ���������Ͱ� �ִ��� Ȯ��.
    SELECT COUNT(*)
    INTO FLAG
    FROM DAY_OF_SALES 
    WHERE TO_CHAR(REGDATE, 'YYYYMMDD') = TO_CHAR(SYSDATE, 'YYYYMMDD');
    
    IF FLAG <> 0 THEN --�����Ͱ� �̹� �ִ°��
        UPDATE DAY_OF_SALES 
        SET FINAL_TOTAL = CNT -- �ݾ� �հ�
        WHERE TO_CHAR(REGDATE, 'YYYYMMDD') = TO_CHAR(SYSDATE, 'YYYYMMDD');
    ELSE -- �����Ͱ� ���°��
        INSERT INTO DAY_OF_SALES VALUES(SYSDATE, CNT);
    END IF;
    
    COMMIT;
    
END;
--
EXEC SALES_PROC;

SELECT * FROM DAY_OF_SALES;













