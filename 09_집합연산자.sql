--���տ�����

/*
UNION = ������(�ߺ�x)
UNION ALL = ������ (�ߺ���)
INTERSECT = ������
MINUS = ������

�÷� ������ ��ġ�ؾ� ���տ����� ����� �����մϴ�.
*/
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '04%'
UNION
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
-----------------------------------------------------------------------
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '04%'
UNION ALL
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
-----------------------------------------------------------------------
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '04%'
INTERSECT
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
-----------------------------------------------------------------------
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '04%'
MINUS
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
-----------------------------------------------------------------------
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE LIKE '04%';
SELECT FIRST_NAME, HIRE_DATE FROM EMPLOYEES WHERE DEPARTMENT_ID = 20;
-----------------------------------------------------------------------
-- ���տ����ڴ� DUAL���� ���� �����͸� ���� ��ĥ ���� �ֽ��ϴ�.
SELECT 200 AS ��ȣ, 'HONG' AS �̸�, '�����' AS ���� FROM DUAL
UNION ALL
SELECT 300, 'LEE','��⵵' FROM DUAL
UNION ALL
SELECT EMPLOYEE_ID, LAST_NAME,'�����' FROM EMPLOYEES;

