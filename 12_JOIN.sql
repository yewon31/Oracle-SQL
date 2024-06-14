SELECT * FROM INFO;
SELECT * FROM AUTH;

-----------------------------------------------------------
-- INNER JOIN
SELECT *
FROM INFO
/*INNER*/ JOIN AUTH
ON INFO.AUTH_ID = AUTH.AUTH_ID;

SELECT INFO.ID,
        INFO.TITLE,
        INFO.CONTENT,
        INFO.AUTH_ID, -- ������ �� �ִ� KEY, ���̺�.�÷��� ���� ���ϸ� ����
        AUTH.NAME
FROM INFO
INNER JOIN AUTH
ON INFO.AUTH_ID = AUTH.AUTH_ID;

-- ���̺� ALIAS
SELECT I.ID,
        I.TITLE,
        I.CONTENT,
        I.AUTH_ID,
        A.NAME
FROM INFO I -- ���̺� �����
INNER JOIN AUTH A
ON I.AUTH_ID = A.AUTH_ID;

-- ������ Ű�� ���ٸ� using ���� ��� ����
SELECT *
FROM INFO I
INNER JOIN AUTH A
USING(AUTH_ID);

-----------------------------------------------------------
-- OUTER JOIN
-- LEFT OUTER JOIN (OUTER��������) - �������̺��� ������ �Ǽ�, �������̺��� �ٳ���.
SELECT * FROM INFO I LEFT OUTER JOIN AUTH A ON I.AUTH_ID= A.AUTH_ID;

-- RIGHT OUTER JOIN
SELECT * FROM INFO I RIGHT OUTER JOIN AUTH A ON I.AUTH_ID = A.AUTH_ID;

-- RIGHT������ ���̺� �ڸ��� �ٲ��ָ� LEFT JOIN
SELECT * FROM AUTH A RIGHT OUTER JOIN INFO I ON A.AUTH_ID = I.AUTH_ID;

-- FULL OUTER JOIN - ���ʵ����� �������� �� ����.
SELECT * FROM INFO I FULL OUTER JOIN AUTH A ON I.AUTH_ID = A.AUTH_ID;

-- CROSS JOIN (�߸��� ������ ���� - ������ ������ ����)
SELECT * FROM INFO I CROSS JOIN AUTH A;
-----------------------------------------------------------
-- SELF JOIN (�ϳ��� ���̺��� ������ ������ �Ŵ°� - ���� �ȿ� ���� ������ Ű �ʿ�)
SELECT * FROM EMPLOYEES;

SELECT *
FROM EMPLOYEES E
LEFT JOIN EMPLOYEES M
ON E.MANAGER_ID = M.EMPLOYEE_ID;
-----------------------------------------------------------
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;

SELECT * FROM EMPLOYEES E LEFT JOIN DEPARTMENTS D ON E. DEPARTMENT_ID = D. DEPARTMENT_ID;

-- ���� ������ ����
SELECT E.EMPLOYEE_ID,
       E.FIRST_NAME,
       D.DEPARTMENT_NAME,
       L.CITY
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
WHERE EMPLOYEE_ID >= 150;

-----------------------------------------------------------
--���� 1.
--EMPLOYEES ���̺��, DEPARTMENTS ���̺��� DEPARTMENT_ID�� ����Ǿ� �ֽ��ϴ�.
--EMPLOYEES, DEPARTMENTS ���̺��� ������� �̿��ؼ� 
--���� INNER , LEFT OUTER, RIGHT OUTER, FULL OUTER ���� �ϼ���. (�޶����� ���� ���� Ȯ��)
SELECT * FROM EMPLOYEES E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID; //106
SELECT * FROM EMPLOYEES E LEFT OUTER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID; //107
SELECT * FROM EMPLOYEES E RIGHT OUTER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID; //122
SELECT * FROM EMPLOYEES E FULL OUTER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID; //123

--���� 2.
--EMPLOYEES, DEPARTMENTS ���̺��� INNER JOIN�ϼ���
--����)employee_id�� 200�� ����� �̸�, department_id�� ����ϼ���
--����)�̸� �÷��� first_name�� last_name�� ���ļ� ����մϴ�
SELECT E.EMPLOYEE_ID, CONCAT(E.FIRST_NAME || ' ', E.LAST_NAME) �̸�, E.DEPARTMENT_ID 
FROM EMPLOYEES E 
JOIN DEPARTMENTS D 
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.EMPLOYEE_ID = 200;

--���� 3.
--EMPLOYEES, JOBS���̺��� INNER JOIN�ϼ���
--����) ��� ����� �̸��� �������̵�, ���� Ÿ��Ʋ�� ����ϰ�, �̸� �������� �������� ����
--HINT) � �÷����� ���� ����Ǿ� �ִ��� Ȯ��
SELECT E.FIRST_NAME �̸�, E.JOB_ID, J.JOB_TITLE 
FROM EMPLOYEES E
JOIN JOBS J
ON E.JOB_ID = J.JOB_ID
ORDER BY �̸�;

--���� 4.
--JOBS���̺�� JOB_HISTORY���̺��� LEFT_OUTER JOIN �ϼ���.
SELECT *
FROM JOBS J
LEFT OUTER JOIN JOB_HISTORY JH
ON JH.JOB_ID = J.JOB_ID;

--���� 5.
--Steven King�� �μ����� ����ϼ���.
SELECT CONCAT(E.FIRST_NAME || ' ', E.LAST_NAME) �̸�, D.DEPARTMENT_NAME �μ��� 
    FROM EMPLOYEES E 
    JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    WHERE E.FIRST_NAME = 'Steven'
    AND E.LAST_NAME = 'King';

--���� 6.
--EMPLOYEES ���̺�� DEPARTMENTS ���̺��� Cartesian Product(Cross join)ó���ϼ���
SELECT *
    FROM EMPLOYEES E 
    CROSS JOIN DEPARTMENTS D;

--���� 7.
--EMPLOYEES ���̺�� DEPARTMENTS ���̺��� �μ���ȣ�� �����ϰ� SA_MAN ������� �����ȣ, �̸�, 
--�޿�, �μ���, �ٹ����� ����ϼ���. (Alias�� ���)
SELECT E.JOB_ID, E.EMPLOYEE_ID �����ȣ, E.FIRST_NAME �̸�, E.SALARY �޿�, D.DEPARTMENT_NAME �μ���, L.CITY �ٹ���
    FROM EMPLOYEES E 
    JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
    WHERE E.JOB_ID = 'SA_MAN';

--���� 8.
--employees, jobs ���̺��� ���� �����ϰ� job_title�� 'Stock Manager', 'Stock Clerk'�� ���� ������
--����ϼ���.
SELECT E.FIRST_NAME �̸�, E.JOB_ID, J.JOB_TITLE 
FROM EMPLOYEES E
JOIN JOBS J
ON E.JOB_ID = J.JOB_ID
WHERE J.JOB_TITLE IN ('Stock Manager','Stock Clerk');

--���� 9.
--departments ���̺��� ������ ���� �μ��� ã�� ����ϼ���. LEFT OUTER JOIN ���
SELECT D.DEPARTMENT_NAME
FROM DEPARTMENTS D
LEFT OUTER JOIN EMPLOYEES E
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.EMPLOYEE_ID IS NULL;

--���� 10. 
--join�� �̿��ؼ� ����� �̸��� �� ����� �Ŵ��� �̸��� ����ϼ���
--��Ʈ) EMPLOYEES ���̺�� EMPLOYEES ���̺��� �����ϼ���.
SELECT E.FIRST_NAME "��� �̸�", M.FIRST_NAME "�Ŵ��� �̸�"
FROM EMPLOYEES E
LEFT JOIN EMPLOYEES M
ON E.MANAGER_ID = M.EMPLOYEE_ID;

--���� 11. 
--EMPLOYEES ���̺��� left join�Ͽ� ������(�Ŵ���)��, �Ŵ����� �̸�, �Ŵ����� �޿� ���� ����ϼ���
--����) �Ŵ��� ���̵� ���� ����� �����ϰ� �޿��� �������� ����ϼ���
SELECT E.FIRST_NAME "��� �̸�", M.FIRST_NAME "�Ŵ��� �̸�", M.SALARY "�Ŵ��� �޿�"
FROM EMPLOYEES E
LEFT JOIN EMPLOYEES M
ON E.MANAGER_ID = M.EMPLOYEE_ID
WHERE E.MANAGER_ID IS NOT NULL --INNER JOIN�� ����
ORDER BY M.SALARY DESC;

--���ʽ� ���� 12.
--���������̽�(William smith)�� ���޵�(�����)�� ���ϼ���.
SELECT M2.FIRST_NAME || ' > ' || M.FIRST_NAME || ' > ' || E.FIRST_NAME ���
FROM EMPLOYEES E
LEFT JOIN EMPLOYEES M
ON E.MANAGER_ID = M.EMPLOYEE_ID
LEFT JOIN EMPLOYEES M2
ON M.MANAGER_ID = M2.EMPLOYEE_ID
WHERE E.FIRST_NAME='William'
    AND E.LAST_NAME='Smith';

-----------------------------------------------------------
-- ����Ŭ ���� - ����Ŭ������ ����� �� �ְ�, ������ ���̺��� FROM�� ���ϴ�. ���������� WHERE�� ���ϴ�.
-- ����Ŭ INNER JOIN
SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID = A.AUTH_ID;

-- ����Ŭ LEFT JOIN
SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID = A.AUTH_ID(+); -- ���� ���̺� +

-- ����Ŭ RIGHT JOIN
SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID (+) = A.AUTH_ID;

-- ����Ŭ FULL OUTER JOIN�� ����

-- ũ�ν������� �߸��� ����(���� ������ �������� �� ��Ÿ��)
SELECT *
FROM INFO I, AUTH A;