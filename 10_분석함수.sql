-- �м��Լ�
-- �м��Լ� OVER(���� ���)
SELECT FIRST_NAME,
       SALARY,
       RANK() OVER (ORDER BY SALARY DESC) AS �ߺ��������,
       DENSE_RANK() OVER (ORDER BY SALARY DESC) AS �ߺ����µ��,
       ROW_NUMBER() OVER (ORDER BY SALARY DESC) AS �Ϸù�ȣ,
       ROWNUM AS ��������ȸ����
FROM EMPLOYEES;

--ROWNUM�� ORDER ��ų �� ����� �ٲ�ϴ�.
SELECT ROWNUM,
        FIRST_NAME,
        SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC;