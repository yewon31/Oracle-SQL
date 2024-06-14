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
--------------------------------------------------------------------
-- HAVING�� - �׷������ ����
SELECT DEPARTMENT_ID, SUM(SALARY), COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING SUM(SALARY) >= 100000 OR COUNT(*) >= 5;
--
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY), COUNT(*), COUNT(COMMISSION_PCT) AS Ŀ�̼ǹ޴»��
FROM EMPLOYEES
WHERE JOB_ID NOT LIKE 'SA%'
GROUP BY DEPARTMENT_ID, JOB_ID
HAVING AVG(SALARY) >= 10000
ORDER BY AVG(SALARY) DESC;
--
SELECT DEPARTMENT_ID, AVG(SALARY) AS �޿����, SUM(SALARY) AS �޿���
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL AND HIRE_DATE LIKE '05%'
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 5000
ORDER BY DEPARTMENT_ID DESC;

-- �������
-- ROLLUP - GROUP BY���� �Բ� ���ǰ�, �����׷��� �հ�, ��Ż ���� ���մϴ�.
SELECT DEPARTMENT_ID,
        SUM (SALARY),
        AVG (SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID; -- ROLLUP X

SELECT DEPARTMENT_ID,
        SUM (SALARY),
        AVG (SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID)
ORDER BY DEPARTMENT_ID; -- ROLLUP O, ��ü �Ѱ�

SELECT DEPARTMENT_ID,
        JOB_ID,
        SUM(SALARY),
        AVG(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID; -- ROLLUP X

SELECT DEPARTMENT_ID,
        JOB_ID,
        SUM(SALARY),
        AVG(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID; -- ROLLUP O, ��ü �Ѱ� + �� �׷� �Ѱ�

-- CUBE - �Ѿ� + ����׷쿡 �Ѱ谡 �߰���
SELECT DEPARTMENT_ID,
        JOB_ID,
        SUM(SALARY),
        AVG(SALARY)
FROM EMPLOYEES
GROUP BY CUBE ( DEPARTMENT_ID, JOB_ID )
ORDER BY DEPARTMENT_ID;

-- GROUPING�Լ� - �׷���̷� ������� ���� 0��ȯ, �Ѿ� �Ǵ� ť��� ������� ���� ���� 1�� ��ȯ
SELECT DECODE(GROUPING(department_id), 1, '<<�Ѱ�>>', department_id) department_id,
       DECODE(GROUPING(job_id), 1, '<�Ұ�>', job_id) AS job_id,
       TRUNC(SUM(salary))
FROM employees
GROUP BY CUBE(department_id, job_id) --ROLLUP/CUBE �ٲ㺸��
ORDER BY department_id;

-----------------------------------------------------------------------------------------
--���� 1.
--��� ���̺��� JOB_ID�� ��� ���� ���ϼ���.
SELECT JOB_ID, COUNT(JOB_ID) �����
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY ����� DESC;
--��� ���̺��� JOB_ID�� ������ ����� ���ϼ���. ������ ��� ������ �������� �����ϼ���.
SELECT JOB_ID, TO_CHAR(AVG(SALARY), '$999,999,999') �������
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY ������� DESC;
--�ÿ� ���̺��� JOB_ID�� ���� ���� �Ի����� ���ϼ���. JOB_ID�� �������� �����ϼ���.
SELECT JOB_ID, MIN(HIRE_DATE) "���� ���� �Ի���"
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY JOB_ID DESC;

--���� 2.
--��� ���̺��� �Ի� �⵵ �� ��� ���� ���ϼ���.
SELECT TO_CHAR(HIRE_DATE, 'YY') �Ի�⵵, COUNT(*) �����
FROM EMPLOYEES
GROUP BY TO_CHAR(HIRE_DATE, 'YY')
ORDER BY ����� DESC;

--���� 3.
--�޿��� 1000 �̻��� ������� �μ��� ��� �޿��� ����ϼ���. �� �μ� ��� �޿��� 2000�̻��� �μ��� ���
SELECT DEPARTMENT_ID, TRUNC(AVG(SALARY)) ��ձ޿�
FROM EMPLOYEES
WHERE SALARY >= 1000
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 2000
ORDER BY ��ձ޿� DESC;

--���� 4.
--��� ���̺��� commission_pct(Ŀ�̼�) �÷��� null�� �ƴ� �������
--department_id(�μ���) salary(����)�� ���, �հ�, count�� ���մϴ�.
--���� 1) ������ ����� Ŀ�̼��� �����Ų �����Դϴ�.
--���� 2) ����� �Ҽ� 2° �ڸ����� ���� �ϼ���.
SELECT DEPARTMENT_ID, TRUNC(AVG((SALARY+(SALARY*COMMISSION_PCT))), 2) �޿����, SUM(SALARY) �޿��հ�, COUNT(*)
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL
GROUP BY DEPARTMENT_ID
ORDER BY �޿���� DESC;

--���� 5.
--�μ����̵� NULL�� �ƴϰ�, �Ի����� 05�⵵ �� ������� �μ� �޿���հ�, �޿��հ踦 ��ձ��� ���������մϴ�
--����) ����� 10000�̻��� �����͸�
SELECT DEPARTMENT_ID, TRUNC(AVG(SALARY), 2) �޿����, SUM(SALARY) �޿��հ�, COUNT(*)
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
    AND HIRE_DATE LIKE '05%'
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 10000
ORDER BY �޿���� DESC;

--���� 6.
--������ ������, ���հ踦 ����ϼ���
SELECT DECODE(GROUPING(JOB_ID), 1, '���հ�', JOB_ID) JOB_ID
    , SUM(SALARY) ������
FROM EMPLOYEES
GROUP BY ROLLUP(JOB_ID);

--���� 7.
--�μ���, JOB_ID�� �׷��� �Ͽ� ��Ż, �հ踦 ����ϼ���.
--GROUPING()�� �̿��Ͽ� �Ұ� �հ踦 ǥ���ϼ���
SELECT DECODE(GROUPING(DEPARTMENT_ID), 1, '�Ѱ�', DEPARTMENT_ID) DEPARTMENT_ID
    , DECODE(GROUPING(JOB_ID), 1, '�Ұ�', JOB_ID) JOB_ID
    , COUNT(*) TOTAL
    , SUM(SALARY) �հ�
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID, JOB_ID;

