-- ��ȯ�Լ�
-- ����ȯ�Լ�

-- �ڵ�����ȯ (���ڿ� ����, ���ڿ� ��¥)
SELECT * FROM EMPLOYEES WHERE SALARY >= '20000'; -- ���� -> ���� �ڵ�����ȯ
SELECT * FROM EMPLOYEES WHERE HIRE_DATE >= '08/01/01'; -- ���� -> ��¥ �ڵ�����ȯ

-- ��������ȯ
-- TO_CHAR -> ��¥�� ����
SELECT TO_CHAR( SYSDATE, 'YYYY-MM-DD HH:MI:SS' ) AS �ð� FROM DUAL;
SELECT TO_CHAR( SYSDATE, 'YY-MM-DD AM HH12:MI:SS') AS TIME FROM DUAL;
SELECT TO_CHAR( SYSDATE, 'YY"��" MM"��" DD"��"') AS TIME FROM DUAL;

-- TO CHAR -> ���ڸ� ����
SELECT TO_CHAR(20000, '999,999,999') AS RESULT FROM DUAL; -- 9�ڸ� ���ڷ� ǥ��
SELECT TO_CHAR(20000, '099,999,999') AS RESULT FROM DUAL; -- 9�ڸ��� 0���� ä��
SELECT TO_CHAR(20000, '999') AS RESULT FROM DUAL; -- �ڸ����� �����ϸ� # ó���˴ϴ�.
SELECT TO_CHAR(20000.123, '999999.9999') AS RESULT FROM DUAL; -- ���� 6�ڸ�, �Ǽ� 4�ڸ�
SELECT TO_CHAR(20000, '$999,999,999') AS RESULT FROM DUAL; -- $��ȣ
SELECT TO_CHAR(20000, 'L999,999,999') AS RESULT FROM DUAL; -- �� �� ����ȭ���ȣ.

-- ���� ȯ�� 1372.17�� �϶�, SALARY���� ��ȭ�� ǥ��
SELECT FIRST_NAME, TO_CHAR( SALARY * 1372.17, 'L999,999,999,999' ) AS ��ȭ FROM EMPLOYEES;

-- TO_DATE ���ڸ� ��¥��
SELECT SYSDATE - TO_DATE( '2024-06-13', 'YYYY-MM-DD' ) FROM DUAL; -- ��¥ ������ ���缭 ��Ȯ�� ����
SELECT TO_DATE( '2024�� 06�� 13��', 'YYYY"��" MM"��" DD"��"' ) FROM DUAL; -- ��¥ ���� ���ڰ� �ƴ϶�� ""
SELECT TO_DATE( '24-06-13 11�� 30�� 23��', 'YYYY-MM-DD HH"��" MI"��" SS"��"' ) FROM DUAL;


-- 2024��06��13�� �� ���ڷ� ��ȯ�Ѵٸ�?
SELECT '240613' FROM DUAL;
SELECT TO_CHAR( TO_DATE('240613', 'YYMMDD') , 'YYYY"��" MM"��" DD"��"' ) AS �� FROM DUAL;

-- TO_NUMBER ���ڸ� ���ڷ�
SELECT '4000' - 1000 FROM DUAL; -- �ڵ�����ȯ
SELECT TO_NUMBER('4000') - 1000 FROM DUAL; -- �������ȯ �� ����

SELECT '$5,500' - 1000 FROM DUAL; -- �ڵ�����ȯ X
SELECT TO_NUMBER ('$5,500', '$999,999') - 1000 FROM DUAL; -- ���ڷ� ������ �ڵ����� �Ұ����� ��� ����� ��ȯ