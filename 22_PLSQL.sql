--PLSQL(���α׷� SQL)
--������ F5���� ������ ���Ѽ� �����ŵ�ϴ� (CTRL + ���� X)
--��±����� ���� ���๮
SET SERVEROUTPUT ON; 
--�͸��� 
DECLARE
    V_NUM NUMBER; --���� ����
    V_NAME VARCHAR2(10) := 'ȫ�浿';
BEGIN
    
    V_NUM := 10;
    --V_NMAE := 'ȫ�浿';
    
    dbms_output.put_line(V_NAME || '���� ���̴� ' || V_NUM || '�Դϴ�.');   
    
END;

--DML������ �Բ� ����� �� �ֽ��ϴ�.
--SELECT -> INSERT -> INSERT
DECLARE
    NAME VARCHAR2(30);
    SALARY NUMBER;
    LAST_NAME EMPLOYEES.LAST_NAME%TYPE; --EMP���̺��� LAST_NAME�÷��� ������ Ÿ������ �����ϰ���.
BEGIN
    
    SELECT FIRST_NAME, LAST_NAME, SALARY 
    INTO  NAME, LAST_NAME, SALARY -- ���� ����� ������ ����
    FROM EMPLOYEES 
    WHERE EMPLOYEE_ID = 100;
    
    DBMS_OUTPUT.PUT_LINE(NAME);
    DBMS_OUTPUT.PUT_LINE(SALARY);
    DBMS_OUTPUT.PUT_LINE(LAST_NAME);
    
END;
--------------------------------------------------
--2008�� �Ի��� ����� �޿� ����� ���ؼ� ���ο� ���̺� INSERT
CREATE TABLE EMP_SAL(
    YEARS VARCHAR2(50),
    SALARY NUMBER(10)
);

DECLARE
    YEARS VARCHAR2(50) := 2009;
    SALARY NUMBER;
BEGIN
    SELECT AVG(SALARY)
    INTO SALARY -- ���� SALARY�� ����
    FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE, 'YYYY') = YEARS;
    
    INSERT INTO EMP_SAL VALUES (YEARS, SALARY); 
    COMMIT;
    
END;

--
SELECT * FROM EMP_SAL;
--------------------------------------------------
--3. ��� ���̺��� �����ȣ�� ���� ū ����� ã�Ƴ� ��, 
--	 �� ��ȣ +1������ �Ʒ��� ����� emps���̺� employee_id, last_name, email, hire_date, job_id��  �ű� �Է��ϴ� �͸� ����� ����� ���ô�.
--<�����>   : steven
--<�̸���>   : stevenjobs
--<�Ի�����> : ���ó�¥
--<JOB_ID> : CEO
DECLARE
    NUM NUMBER;
BEGIN
    SELECT MAX(EMPLOYEE_ID) + 1
    INTO NUM --NUM�� ����
    FROM EMPLOYEES;
    
    INSERT INTO EMPS_IT(EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
    VALUES(NUM, 'STEVEN', 'STEVEN JOBS', SYSDATE, 'CEO'  );
    
    COMMIT;
END;