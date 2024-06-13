-- �׷��Լ�
-- NULL�� ���ܵ� �����͵鿡 ���ؼ� �����.
SELECT MAX(SALARY), MIN(SALARY), SUM(SALARY), AVG(SALARY), COUNT(SALARY) FROM EMPLOYEES;
-- MIN, MAX�� ��¥, ���ڿ��� ���� �˴ϴ�.
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE), MIN(FIRST_NAME), MAX(FIRST_NAME) FROM EMPLOYEES;
-- COUNT() �ΰ��� �����
SELECT COUNT(*), COUNT(COMMISSION_PCT) FROM EMPLOYEES;
-- �μ��� 80�� �������, Ŀ�̼��� ���� �������
SELECT MAX (COMMISSION_PCT) FROM EMPLOYEES WHERE DEPARTMENT_ID = 80;
-- �׷��Լ���, �Ϲ��÷��� ���ÿ� ����� �Ұ���.
SELECT FIRST_NAME, AVG(SALARY) FROM EMPLOYEES; --����
-- �׷��Լ� �ڿ� OVER() �� ���̸�, �Ϲ��÷��� ���ÿ� ����� ������.
SELECT FIRST_NAME, AVG (SALARY) OVER(), COUNT (*) OVER(), SUM(SALARY) OVER() FROM EMPLOYEES;

-- GROUP BY�� - WHERE�� ORDER�� ���̿� �����ϴ�.
SELECT DEPARTMENT_ID,
        SUM (SALARY),
        AVG (SALARY),
        MIN (SALARY),
        MAX (SALARY),
        COUNT (*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

--GROUPȭ ��Ų �÷���, SELECT������ ���� �� �ֽ��ϴ�.
SELECT DEPARTMENT_ID,
FIRST NAME
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID; -- ����

-- 2�� �̻��� �׷�ȭ (���� �׷�)
SELECT DEPARTMENT_ID, 
        JOB_ID,
        SUM(SALARY) AS "�μ� ������ �޿� ��",
        AVG(SALARY) AS "�μ� ������ �޿� ���",
        COUNT(*) AS "�μ� �ο���",
        COUNT(*) OVER() "��ü ī��Ʈ" -- COUNT(*) OVER() ����ϸ� �� ���� ���� ��°���
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;
--------------------------------------------------------------------
-- �׷��Լ��� WHERE�� ���� �� ����
SELECT DEPARTMENT_ID,
AVG(SALARY)
FROM EMPLOYEES
WHERE AVG(SALARY) >= 5000 -- �׷��� ������ ���� ���� HAVING �̶�� ���� ����.
GROUP BY DEPARTMENT_ID;