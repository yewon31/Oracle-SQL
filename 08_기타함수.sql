-- NULLó�� �Լ�

-- NVL NULL�� ��� ó��
SELECT NVL (1000, 0), NVL (NULL, 0) FROM DUAL;
SELECT NULL + 1000 FROM DUAL; -- NULL�� ������ ���� NULL�� ����.
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT AS �����޿� FROM EMPLOYEES;
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY * NVL(COMMISSION_PCT, 0) AS �����޿� FROM EMPLOYEES; --a

-- NVL2(���, ���̾ƴѰ��, ���ΰ��)
SELECT NVL2(300, 'NULL�� �ƴմϴ�', 'NULL�Դϴ�' ) FROM DUAL;
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, NVL2(COMMISSION_PCT, SALARY + SALARY + COMMISSION_PCT , SALARY ) AS �����޿� FROM EMPLOYEES; --a

-- COALESCE (��, ��, �� ..... ) - NULL�� �ƴ� ù��° ���� ��ȯ ������
SELECT COALESCE (1, 2, 3) FROM DUAL; -- 10 ���
SELECT COALESCE (NULL, 2, 3, 4) FROM DUAL; -- 2 ���
SELECT COALESCE (NULL, NULL, 3, NULL ) FROM DUAL; -- 3 ���
SELECT COALESCE (COMMISSION_PCT, 0) FROM EMPLOYEES; -- NVL�� ����

-- DECODE (���, �񱳰�, �����, �񱳰�, ����� ..,ELSE��)
SELECT DECODE ('A', 'A', 'A�Դϴ�' ) FROM DUAL; -- IF��
SELECT DECODE ('X', 'A', 'A�Դϴ�', 'A���ƴ�') FROM DUAL;
SELECT DECODE ('B', 'A', 'A�Դϴ�'
                  , 'B', 'B�Դϴ�'
                  , 'C', 'C�Դϴ�'
                  , '���� �ƴմϴ�.') FROM DUAL; --ELSE IF ����
                  
SELECT * FROM EMPLOYEES;

SELECT JOB_ID, DECODE(JOB_ID, 'IT_PROG', 'SALARY * 1.1'
                            , 'AD_VP', 'SALARY * 1.2'
                            , 'FI_MGR', 'SALARY * 1.3'
                            , 'SALARY' ) AS ��� 
            , DECODE(JOB_ID, 'IT_PROG', SALARY * 1.1
                            , 'AD_VP', SALARY * 1.2
                            , 'FI_MGR', SALARY * 1.3
                            , SALARY ) AS �޿� FROM EMPLOYEES;
                            
-- CASE WHEN THEN ELSE END (SWITCH���� ���)
SELECT JOB_ID,
        CASE JOB_ID WHEN 'IT_PROG' THEN SALARY * 1.1
                    WHEN 'AD_VP' THEN SALARY * 1.2
                    WHEN 'FI_MGR' THEN SALARY * 1.3
                    ELSE SALARY
        END AS �޿� FROM EMPLOYEES;

-- �񱳿� ���� ������ WHEN���� �ۼ�
SELECT JOB_ID,
        CASE WHEN JOB_ID='IT_PROG' THEN SALARY * 1.1
             WHEN JOB_ID='AD_VP' THEN SALARY * 1.2
             WHEN JOB_ID='FI_MGR' THEN SALARY * 1.3
             ELSE SALARY
        END AS �޿� FROM EMPLOYEES;
---------------------------------------------------------------
--���� 1.
--�������ڸ� �������� EMPLOYEE���̺��� �Ի�����(hire_date)�� �����ؼ� �ټӳ���� 10�� �̻���
--����� ������ ���� ������ ����� ����ϵ��� ������ �ۼ��� ������. 
--���� 1) �ټӳ���� ���� ��� ������� ����� �������� �մϴ�.
SELECT EMPLOYEE_ID AS �����ȣ
    , CONCAT(FIRST_NAME, LAST_NAME) AS �����
    , HIRE_DATE AS �Ի�����
    , TRUNC((SYSDATE-HIRE_DATE)/365) AS �ټӳ��
    FROM EMPLOYEES
    WHERE (SYSDATE-HIRE_DATE)/365 >= 10
    ORDER BY �ټӳ�� DESC;


--���� 2.
--EMPLOYEE ���̺��� manager_id�÷��� Ȯ���Ͽ� first_name, manager_id, ������ ����մϴ�.
--100�̶�� �����塯 
--120�̶�� �����塯
--121�̶�� ���븮��
--122��� �����ӡ�
--�������� ������� ���� ����մϴ�.
--���� 1) �μ��� 50�� ������� ������θ� ��ȸ�մϴ�
--���� 2) DECODE�������� ǥ���غ�����.
--���� 3) CASE�������� ǥ���غ�����.
SELECT FIRST_NAME
    , MANAGER_ID
    , DECODE (MANAGER_ID, 100, '����'
                          , 120, '����'
                          , 121, '�븮'
                          , 122, '����'
                          , '���') AS ����
    , CASE MANAGER_ID 
        WHEN 100 THEN '����' 
        WHEN 120 THEN '����' 
        WHEN 121 THEN '�븮' 
        WHEN 122 THEN '����' 
        ELSE '���'
        END AS ����2                      
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID=50;


--���� 3. 
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