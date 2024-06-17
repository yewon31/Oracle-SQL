--���� 1.
--EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� �����͸� ��� �ϼ��� ( AVG(�÷�) ���)
SELECT E.*
FROM EMPLOYEES E
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEES);
--EMPLOYEES ���̺��� ��� ������� ��ձ޿����� ���� ������� ���� ����ϼ���
SELECT COUNT(*)
FROM EMPLOYEES E
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEES);
--EMPLOYEES ���̺��� job_id�� IT_PFOG�� ������� ��ձ޿����� ���� ������� �����͸� ����ϼ���.
SELECT E.*
FROM EMPLOYEES E
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEES
                WHERE JOB_ID = 'IT_PROG');

--���� 2.
--DEPARTMENTS ���̺��� manager_id�� 100�� ����� department_id(�μ����̵�) ��
--EMPLOYEES ���̺��� department_id(�μ����̵�) �� ��ġ�ϴ� ��� ����� ������ �˻��ϼ���.
SELECT E.*
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID = (   SELECT DEPARTMENT_ID
                            FROM DEPARTMENTS D
                            WHERE MANAGER_ID = 100);
                
--���� 3.
--EMPLOYEES���̺��� ��Pat���� manager_id���� ���� manager_id�� ���� ��� ����� �����͸� ����ϼ���
SELECT E.*
FROM EMPLOYEES E
WHERE MANAGER_ID > (SELECT MANAGER_ID
                    FROM EMPLOYEES
                    WHERE FIRST_NAME = 'Pat');
--EMPLOYEES���̺��� ��James��(2��)���� manager_id�� ���� ��� ����� �����͸� ����ϼ���.
SELECT E.*
FROM EMPLOYEES E
WHERE MANAGER_ID IN (SELECT MANAGER_ID
                    FROM EMPLOYEES
                    WHERE FIRST_NAME = 'James');
--Steven�� ������ �μ��� �ִ� ������� ������ּ���.
SELECT E.*
FROM EMPLOYEES E
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                    FROM EMPLOYEES
                    WHERE FIRST_NAME = 'Steven');
--Steven�� �޿����� ���� �޿��� �޴� ������� ����ϼ���.
SELECT E.*
FROM EMPLOYEES E
WHERE SALARY > ANY (SELECT SALARY
                    FROM EMPLOYEES
                    WHERE FIRST_NAME = 'Steven');
--���� 4.
--EMPLOYEES���̺� DEPARTMENTS���̺��� left �����ϼ���
--����) �������̵�, �̸�(��, �̸�), �μ����̵�, �μ��� �� ����մϴ�.
--����) �������̵� ���� �������� ����
SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.FIRST_NAME, E.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY EMPLOYEE_ID ASC;

--���� 5.
--���� 4�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT  E.EMPLOYEE_ID, E.LAST_NAME, E.FIRST_NAME, E.DEPARTMENT_ID, 
        (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID) DEPARTMENT_NAME
FROM EMPLOYEES E
ORDER BY EMPLOYEE_ID ASC;

--���� 6.
--DEPARTMENTS���̺� LOCATIONS���̺��� left �����ϼ���
--����) �μ����̵�, �μ��̸�, ��Ʈ��_��巹��, ��Ƽ �� ����մϴ�
--����) �μ����̵� ���� �������� ����
SELECT  D.DEPARTMENT_ID, D.DEPARTMENT_NAME, L.STREET_ADDRESS, L.CITY
FROM DEPARTMENTS D
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID
ORDER BY DEPARTMENT_ID ASC;

--���� 7.
--���� 6�� ����� (��Į�� ����)�� �����ϰ� ��ȸ�ϼ���
SELECT  D.DEPARTMENT_ID, D.DEPARTMENT_NAME, 
        (SELECT STREET_ADDRESS FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) STREET_ADDRESS,
        (SELECT CITY FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) CITY
FROM DEPARTMENTS D
ORDER BY D.DEPARTMENT_ID ASC;

--���� 8.
--LOCATIONS���̺� COUNTRIES���̺��� ��Į�� ������ ��ȸ�ϼ���.
--����) �����̼Ǿ��̵�, �ּ�, ��Ƽ, country_id, country_name �� ����մϴ�
--����) country_name���� �������� ����
SELECT  L.LOCATION_ID, L.STREET_ADDRESS, L.CITY, L.COUNTRY_ID,
        (SELECT COUNTRY_NAME FROM COUNTRIES C WHERE C.COUNTRY_ID = L.COUNTRY_ID) COURNTY_NAME
FROM LOCATIONS L
ORDER BY COURNTY_NAME ASC;

----------------------------------------------------------------------------------------------------
--���� 9.
--EMPLOYEES���̺� ���� first_name�������� �������� �����ϰ�, 41~50��° �������� �� ��ȣ, �̸��� ����ϼ���
SELECT E2.RN, E2.FIRST_NAME
FROM (  SELECT ROWNUM RN, E1.*
        FROM (  SELECT E.*
                FROM EMPLOYEES E
                ORDER BY E.FIRST_NAME DESC) E1) E2
WHERE RN BETWEEN 41 AND 50;

--���� 10.
--EMPLOYEES���̺��� hire_date�������� �������� �����ϰ�, 31~40��° �������� �� ��ȣ, ���id, �̸�, ��ȣ, 
--�Ի����� ����ϼ���.
SELECT RN, EMPLOYEE_ID, FIRST_NAME, PHONE_NUMBER, HIRE_DATE
FROM (  SELECT ROWNUM RN, E.*
        FROM (  SELECT *
                FROM EMPLOYEES
                ORDER BY HIRE_DATE ASC) E) 
WHERE RN BETWEEN 31 AND 40;

--���� 11.
--COMMITSSION�� ������ �޿��� ���ο� �÷����� ����� 10000���� ū ������� �̾� ������. (�ζ��κ並 ���� �˴ϴ�)
SELECT *
FROM (  SELECT E.*, SALARY+SALARY*NVL(COMMISSION_PCT, 0) FINAL_SALARY
        FROM EMPLOYEES E)
WHERE FINAL_SALARY > 10000;


--����12
--EMPLOYEES���̺�, DEPARTMENTS ���̺��� left�����Ͽ�, �Ի��� �������� �������� 10-20��° �����͸� ����մϴ�.
--����) rownum�� �����Ͽ� ��ȣ, �������̵�, �̸�, �Ի���, �μ��̸� �� ����մϴ�.
--����) hire_date�� �������� �������� ���� �Ǿ�� �մϴ�. rownum�� �������� �ȵǿ�.
--[���1]JOIN �ɰ� �ζ��� ��
SELECT RN, EMPLOYEE_ID, FIRST_NAME, HIRE_DATE, DEPARTMENT_NAME
FROM (  SELECT ROWNUM RN, A.*
        FROM (  SELECT E.*, D.DEPARTMENT_NAME
                FROM EMPLOYEES E
                LEFT JOIN DEPARTMENTS D
                ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
                ORDER BY E.HIRE_DATE ASC) A)
WHERE RN BETWEEN 10 AND 20;
--[���2]�ζ��� ��� �� �������� JOIN(or ��Į�� ��������)
SELECT RN, EMPLOYEE_ID, FIRST_NAME, HIRE_DATE,
        (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = B.DEPARTMENT_ID)DEPARTMENT_NAME
FROM (  SELECT ROWNUM RN, A.*
        FROM (  SELECT E.*
                FROM EMPLOYEES E
                ORDER BY E.HIRE_DATE ASC) A) B
WHERE RN BETWEEN 10 AND 20;

--����13
--SA_MAN ����� �޿� �������� �������� ROWNUM�� �ٿ��ּ���.
--����) SA_MAN ������� ROWNUM, �̸�, �޿�, �μ����̵�, �μ����� ����ϼ���.
SELECT ROWNUM RN, A.FIRST_NAME, A.SALARY, A.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM (  SELECT *
        FROM EMPLOYEES
        WHERE JOB_ID = 'SA_MAN'
        ORDER BY SALARY DESC) A
JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = A.DEPARTMENT_ID;

--����14
--DEPARTMENTS���̺��� �� �μ��� �μ���, �Ŵ������̵�, �μ��� ���� �ο��� �� ����ϼ���.
--����) �ο��� ���� �������� �����ϼ���.
--����) ����� ���� �μ��� ������� ���� �ʽ��ϴ�.
--��Ʈ) �μ��� �ο��� ���� ���Ѵ�. �� ���̺��� �����Ѵ�.
SELECT D.DEPARTMENT_NAME, D.MANAGER_ID, E.CNT �ο���
FROM (  SELECT DEPARTMENT_ID, COUNT(*) CNT
        FROM EMPLOYEES
        GROUP BY DEPARTMENT_ID) E
JOIN DEPARTMENTS D
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
ORDER BY �ο��� DESC;

--����15
--�μ��� ��� �÷�, �ּ�, �����ȣ, �μ��� ��� ������ ���ؼ� ����ϼ���.
--����) �μ��� ����� ������ 0���� ����ϼ���
SELECT D.*, L.STREET_ADDRESS, TRUNC(NVL(��տ���, 0))
FROM DEPARTMENTS D
JOIN LOCATIONS L
ON L.LOCATION_ID = D.LOCATION_ID
LEFT JOIN (     SELECT DEPARTMENT_ID, AVG(SALARY) ��տ���
                FROM EMPLOYEES
                GROUP BY DEPARTMENT_ID) E
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

--����16
--���� 15����� ���� DEPARTMENT_ID�������� �������� �����ؼ� ROWNUM�� �ٿ� 1-10������ ������
--����ϼ���
SELECT *
FROM (SELECT ROWNUM RN, A.*
        FROM (  SELECT D.*, L.STREET_ADDRESS, TRUNC(NVL(��տ���, 0))
                FROM DEPARTMENTS D
                JOIN LOCATIONS L
                ON L.LOCATION_ID = D.LOCATION_ID
                LEFT JOIN (     SELECT DEPARTMENT_ID, AVG(SALARY) ��տ���
                                FROM EMPLOYEES
                                GROUP BY DEPARTMENT_ID) E
                ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
                ORDER BY D.DEPARTMENT_ID DESC) A)
WHERE RN BETWEEN 1 AND 10;