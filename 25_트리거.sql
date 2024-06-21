--Ʈ���� - Ʈ���Ŵ� ���̺� ������ ���·� AFTER, BEFOREƮ���� �ֽ��ϴ�
--AFTER�� DML������ Ÿ�����̺� ����� ���Ŀ� �����ϴ� Ʈ����
--BEFORE�� DML������ Ÿ�����̺� ����Ǳ� ������ �����ϴ� Ʈ����
SET SERVEROUTPUT ON;

CREATE TABLE TBL_TEST(
    ID VARCHAR2(30),
    TEXT VARCHAR2(30)
);

--Ʈ���� ����
CREATE OR REPLACE TRIGGER TBL_TEST_TRG
    AFTER UPDATE OR INSERT OR DELETE -- Ʈ���� ������ ���۽���
    ON TBL_TEST --������ ���̺�
    FOR EACH ROW --��� �࿡ ����
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ʈ���� ������!');
END;
--
INSERT INTO TBL_TEST VALUES('AAA123', 'HELLO'); --Ʈ���� ����
UPDATE TBL_TEST SET TEXT = 'BYE' WHERE ID = 'AAA123'; --Ʈ���� ����
DELETE FROM TBL_TEST WHERE ID = 'AAA123'; --Ʈ���� ����
--------------------------------------------------------------------------------
--AFTER TRIGGER
-- :OLD = ������ �� (I : �Է����ڷ�, U : �������ڷ�, D : �������ڷ�)

-- �������̺�� ������̺� ����
CREATE TABLE TBL_USER(
    ID VARCHAR2(20) PRIMARY KEY,
    NAME VARCHAR2(20),
    ADDRESS VARCHAR2(30)
);

CREATE TABLE TBL_USER_BACKUP(
    ID VARCHAR2(20),
    NAME VARCHAR2(20),
    ADDRESS VARCHAR2(30),
    UPDATEDATE DATE DEFAULT SYSDATE,
    M_TYPE CHAR(10), --����Ÿ��
    M_USER VARCHAR2(20) --������ �����
);
--TLB_USER�� ������Ʈ OR ����Ʈ �� �Ͼ��, ���������͸� ���.
CREATE OR REPLACE TRIGGER TBL_USER_BACKUP_TRG
    AFTER UPDATE OR DELETE
    ON TBL_USER
    FOR EACH ROW
DECLARE
    V VARCHAR2(10); --��������
BEGIN
    
    IF UPDATING THEN --UPDATE�� �Ͼ�� TRUE
        V := '����';
    ELSIF DELETING THEN -- DELETE�� �Ͼ�� TRUE
        V := '����';
    END IF;
    
    --����Ǳ� ���ڷ�
    INSERT INTO TBL_USER_BACKUP VALUES(:OLD.ID, :OLD.NAME, :OLD.ADDRESS, SYSDATE ,V, USER() ); --���̵�, NAME, ADDRESS
        
END;

INSERT INTO TBL_USER VALUES('AAA', 'AAA', 'AAA');
INSERT INTO TBL_USER VALUES('BBB', 'BBB', 'BBB');

UPDATE TBL_USER SET NAME = 'NEWAAA' WHERE ID = 'AAA'; --Ʈ���� ����
DELETE FROM TBL_USER WHERE ID = 'BBB'; --Ʈ���� ����

SELECT * FROM TBL_USER_BACKUP;
--BEFRE TRIGGER
--:NEW ���� �� �� (I : �Է��� �ڷ�, U : ������ �ڷ�)
CREATE OR REPLACE TRIGGER TBL_USER_MAKING_TRG
    BEFORE INSERT
    ON TBL_USER
    FOR EACH ROW
BEGIN
    --�μ�Ʈ�� �Ǳ����� ������ �����͸� ȫ** ����
    :NEW.NAME := SUBSTR(:NEW.NAME, 1, 1 ) || '**'; 
END;
--
INSERT INTO TBL_USER VALUES ('CCC', 'ȫ�浿', '�����');
INSERT INTO TBL_USER VALUES ('DDD', '�̼���', '�����');

SELECT * FROM TBL_USER;











