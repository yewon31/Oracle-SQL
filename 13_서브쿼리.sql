-- �������� (SELECT �������� Ư����ġ�� �ٽ� SELECT�� ���� ����)
-- ������ �������� - ���������� ����� 1���� ��������

-- ���ú��� �޿��� �������
-- 1. ������ �޿��� ã�´�.
-- 2. ã�� �޿��� WHERE���� �ִ´�.

-- [1]��������
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy';

-- [2]�������� + ��������
SELECT *
FROM EMPLOYEES
WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy');

-- 103���� ������ �������
SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103;

SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103);

-- �������� - ���� �÷��� ��Ȯ�� �Ѱ����� �մϴ�.
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 103); --����

-- �������� - �������� ������ �����̶��, ������ �������� �����ڸ� ������մϴ�. (������ ���������� ó��)
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Steven'; --2��
SELECT *
FROM EMPLOYEES
WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Steven'); --����

----------------------------------------------------------------------------------------
-- ������ �������� - ���������� ����� ������ ���ϵǴ� ��� ANY, ALL, IN
SELECT SALARY
FROM EMPLOYEES
WHERE FIRST_NAME = 'David'; -- 4800, 6800, 9500

-- ���̺���� �ּұ޿����� ���̹޴� ���
-- 4800���� ū
SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'); -- > 4800

-- ���̺���� �ִ�޿����� ���Թ޴� ���
-- 9500���� ����
SELECT *
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'); -- < 9500

-- ���̺���� �ִ�޿����� ���̹޴� ���
-- 9500���� ū
SELECT *
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'); -- > 9500

-- ���̺���� �ּұ޿����� ���Թ޴� ���
-- 4800���� ����
SELECT *
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'); -- < 4800

-- ���̺��� �μ��� ����
-- [1]��������
SELECT DEPARTMENT_ID
FROM EMPLOYEES WHERE FIRST_NAME = 'David';

-- [2]�������� + ��������
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM EMPLOYEES WHERE FIRST_NAME = 'David');
----------------------------------------------------------------------------------------
-- ��Į��(Scalar) �������� - SELECT���� ���������� ���� ��� (JOIN�� ��ü��)
-- [���1]�⺻(LEFT JOIN)
SELECT FIRST_NAME,
       D.DEPARTMENT_NAME,
       D.LOCATION_ID --������ Į���� 2�� �̻��̸� JOIN
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;
-- [���2]��Į��
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) DEPARTMENT_NAME --������ Į���� 1���� ��Į�� ��������
FROM EMPLOYEES E;

-- ��Į�������� �ٸ� ���̺��� 1���� �÷��� ������ �ö�, JOIN���� ���� ���
SELECT FIRST_NAME,
       JOB_ID,
       (SELECT JOB_TITLE FROM JOBS J WHERE J.JOB_ID = E.JOB_ID) AS JOB_TITLE,
       (SELECT MIN_SALARY FROM JOBS J WHERE J.JOB_ID = E.JOB_ID) AS MIN_SALARY --���̺� 1������ 2�� Į�� �����ðŸ� JOIN�� ����
FROM EMPLOYEES E;

-- 2�� ���̺�
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) DEPARTMENT_NAME,
       (SELECT JOB_TITLE FROM JOBS J WHERE J.JOB_ID = E.JOB_ID) AS JOB_TITLE --�� ���̺��� 1������ �����ðŸ� ��Į�������� ����
FROM EMPLOYEES E;

-----------------------------------------------------------------------------------------------------------
-- �ζ��� �� - FROM�� ������ ������������ ���ϴ�.
-- �ζ��� �信�� (�����÷�) �� �����, �� �÷��� ���ؼ� ��ȸ�� ������ ����մϴ�.

SELECT *
FROM (SELECT *
      FROM EMPLOYEES);

-- ROWNUM�� ��ȸ�� ������ ���� ��ȣ�� �ٽ��ϴ�.
-- [1]rownum -> order
SELECT ROWNUM,
       FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC; --(��ROWNUM ���� ���ϰ� ORDER�� -> �ζ��� �� �߰�)

-- [2-1]�켱 order ��
SELECT FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC; --ROWNUM�� ���̰� order

-- [2-2]order -> rownum
SELECT ROWNUM,
       FIRST_NAME,
       SALARY
FROM (SELECT FIRST_NAME,
               SALARY
        FROM EMPLOYEES
        ORDER BY SALARY DESC)
        WHERE ROWNUM BETWEEN 1 AND 10; --����
      --WHERE ROWNUM BETWEEN 11 AND 20; --�Ұ���(��ROWNUM�� 1���� �� �� ���� -> �ζ��� �� �߰�)
      
-- [3]order -> rownum -> 11~20�� ��������
SELECT *
FROM (SELECT ROWNUM RN, --����
       FIRST_NAME,
       SALARY
        FROM (SELECT FIRST_NAME,
                       SALARY
                FROM EMPLOYEES
                ORDER BY SALARY DESC))
WHERE RN BETWEEN 11 AND 20;

-----------------------------------------------------
-- ����
-- �ټӳ�� 5��° �Ǵ� ����鸸 ���
SELECT *
FROM (SELECT FIRST_NAME,
             HIRE_DATE,  
             TRUNC( (SYSDATE - HIRE_DATE) / 365 ) AS �ټӳ�� -- �ȿ��� ���� ���󿭿� ���ؼ� ����ȸ �س��� �ζ��κ䰡 ����
      FROM EMPLOYEES
      ORDER BY �ټӳ�� DESC)
WHERE MOD (�ټӳ��, 5) = 0;

--08_��Ÿ�Լ�.sql ���� 3. 
--EMPLOYEES ���̺��� �̸�, �Ի���, �޿�, ���޴�� �� ����մϴ�.
--����1) HIRE_DATE�� XXXX��XX��XX�� �������� ����ϼ���. 
--����2) �޿��� Ŀ�̼ǰ��� �ۼ�Ʈ�� ������ ���� ����ϰ�, 1300�� ���� ��ȭ�� �ٲ㼭 ����ϼ���.
--����3) ���޴���� 5�� ���� �̷�� ���ϴ�. �ټӳ���� 5�� ������ ���޴������ ����մϴ�.
--����4) �μ��� NULL�� �ƴ� �����͸� ������� ����մϴ�.
SELECT FIRST_NAME AS �̸�
    , TO_CHAR(HIRE_DATE, 'YYYY"��"MM"��"DD"��"') AS �Ի���
    , TO_CHAR(SALARY+(SALARY*NVL(COMMISSION_PCT, 0))*1300, 'L999,999,999,999') AS �޿�
    , DECODE(REMAINDER(TRUNC((SYSDATE-HIRE_DATE)/365), 5), 0, '���޴��', '���޴�� �ƴ�') AS ���޴�� 
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID IS NOT NULL;

--�ζ��� �信�� ���̺� ������� ��ȸ
SELECT  ROWNUM AS RN,
        A.*
FROM (  SELECT  E.* ,
                TRUNC( (SYSDATE - HIRE_DATE) / 365 ) AS �ټӳ��
        FROM EMPLOYEES E
        ORDER BY �ټӳ�� DESC
) A
WHERE MOD (�ټӳ��, 5) = 0;