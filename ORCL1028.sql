/*[2022. 10. 28. �������]
* ���� ���ǿ� �´� ���̺��� �����Ͻÿ�.
* ���̺�� : T_MENU_1028

* ���� �÷� (�÷����� �����ϰ� ���� ��!)
�޴� ���̵� : ������, �⺻Ű
�޴� �̸� : 128����Ʈ ������, Null �̸� �ȵ�!
���� : 10�ڸ� ������, �⺻�� 0
���� : 64����Ʈ ������, Null ����
�޴��������� : ��¥Ÿ��

* �Ʒ� �����͸� ���̺� �����Ͻÿ�.

1 ���̹��� 6000 ������ǰ �������
2 �ᳪ������� 7000 ź��ȭ�� �������
3 �߰����� 3000 �ܹ��� �������
4 ��Ʈ���ұ��� 8000 ź��ȭ�� �������
5 ��� 2000 �а��� �������

* ��Ʈ���ұ����� ������ 8500������ �����Ͻÿ�.

* �޴����� ����� �����Ͻÿ�.

* ������ �ش� �����͸� ��ȸ�Ͻÿ�.*/
CREATE TABLE T_MENU_1028
(
    menu_id NUMBER(10) PRIMARY KEY, 
    menu VARCHAR2(32) NOT NULL, --varchar2(128)
    price NUMBER(16) Default 0, --number(10)
    type VARCHAR2(32), --varchar2(128)
    menu_date DATE
);
ALTER TABLE T_MENU_1028 MODIFY price NUMBER(16) Default 0;

INSERT INTO T_MENU_1028 (menu_id, menu, price, type, menu_date)
VALUES(1, '���̹���',6000, '������ǰ', SYSDATE);

INSERT INTO T_MENU_1028 (menu_id, menu, price, type, menu_date)
VALUES(2, '�ᳪ�������',7000, 'ź��ȭ��', SYSDATE);

INSERT INTO T_MENU_1028 (menu_id, menu, price, type, menu_date)
VALUES(3, '�߰�����',3000, '�ܹ���', SYSDATE);

INSERT INTO T_MENU_1028 (menu_id, menu, price, type, menu_date)
VALUES(4, '��Ʈ���ұ���',8000, 'ź��ȭ��', SYSDATE);

INSERT INTO T_MENU_1028 (menu_id, menu,  type, menu_date)
VALUES(5, '���', '�а���', SYSDATE);

INSERT INTO T_MENU_1028 (menu_id, menu, price, type, menu_date)
VALUES((SELECT NVL(MAX(menu_id),0)+1 FROM T_MENU_1028), '��Ʈ��',8000, 'ź��ȭ��', SYSDATE);

UPDATE T_MENU_1028
SET price =8500;
WHERE menu_id = 4;

DELETE 
--SELECT *
FROM T_MENU_1028
WHERE menu_id = 5;

commit;

select * from t_menu_1028;
--------------------------------------------------------------------------------
--10-27-2�� HE_STUDENT,HE_STUDENT2,HE_STUDENT3 ��� ������ �����ؼ� �����ִ� ������ �����
select stdno,name,ssn,id,null,reg_date  --�÷��� ������ ������� �Ѵ�
from HE_STUDENT
union all
select stdno,name,ssn,id,address,reg_date
from HE_STUDENT2
union all
select stdno,name,ssn,id,address,reg_date
from HE_STUDENT3;
--------------------------------------------------------------------------------
select * from HE_STUDENT;
select * from HE_STUDENT2
ORDER BY STDNO;
select * from HE_STUDENT3;
--2���̺� ������ ������

--���̺� create
--������ insert/update/delete
--insert
INSERT INTO HE_STUDENT3
SELECT *  FROM HE_STUDENT2 --VALUE�� �ڸ��� �ٰ� SELECT * FROM HE_STUDENT3�Ἥ ������ ��ĥ �� �ִ�
WHERE STDNO IN (5,6,7,8,9); -- PK�� �ɸ��� ������ �ɾ ���ǰ��鸸 �־��ش�
COMMIT;
--WHERE STDNO IN(10,11) --SAMPLE

--delete
TRUNCATE TABLE HE_STUDENT3; -- �����͸� ��������� -- �׳� �ٷ� ������ ����°� ���������� ���� �ξ� ������ ���̰� �ִ�.
--�����Ͱ� �߷ȴٰ� ����. ROLLBACK �Ұ� --�ٷ� �ڵ� COMMIT�� �Ź���.
--DDL

DELETE --��ü�� ���� �� �ִ� / ���ǿ� ���󼭵� ���� �� �ִ�. 
       -- ���� ���鼭 ã�Ƽ� ����°�
       --���� COMMIT�Ȱ� �ƴ� ����.
       --DML
FROM HE_STUDENT3;



--CREATE/CREATE AS/ALTER/TRUNCATE/DROP
SELECT * FROM HE_STUDENT3;
SELECT * FROM T_MENU_1028;

----------------------------------���̺� �����
--DROP TABLE ���̺��; --�ѹ��� ���� �ѹ� �ȵ�~
DROP TABLE T_MENU_1028;

------------------------���̺� �����ϱ� -���̺��� ����+���ε����� ����
SELECT * FROM HE_STUDENT6;

CREATE TABLE  HE_STUDENT3
AS  --�����Ҷ� AS�� ������Ѵ�~
SELECT * FROM HE_STUDENT2;

-----------------------���� ���̺� ���� �Ҷ� Ư�� ����+�÷��� �����ϱ�
CREATE TABLE  HE_STUDENT4
AS  
SELECT stdno,name FROM HE_STUDENT2;

----------------------���� ���̺� ���� �춧 Ư�� ����+�÷�+Ư�� �����͸� �����ϱ�
CREATE TABLE  HE_STUDENT5
AS  
SELECT stdno,name FROM HE_STUDENT2
where stdno <10;

------------------------���� ���̺� ���� -������
CREATE TABLE  HE_STUDENT6
AS  
SELECT * FROM HE_STUDENT2
where 1=2; -- ���� �ɼ� ���� ������ �ɾ������ ������ ������ �� �ִ�


--------------------���̺� �̸� �ٽ� ���� RENAME �����̸� TO ���ο��̸�
RENAME HE_STUDENT6 TO HE_STUDENT7;
--------------------���̺� �����ϱ� ALTER ���̺��� ����(�÷�)����
--ALTER TABLE HE_STUDENT6;
          
          --ADD / RENAME COLUMN / MODIFY / DROP COLUMN--;

ALTER TABLE HE_STUDENT7
ADD (UPD_DATE DATE);

ALTER TABLE HE_STUDENT7
ADD (NICKNAME VARCHAR2(32) DEFAULT'�������');

ALTER TABLE HE_STUDENT7
RENAME COLUMN id TO stdid;

ALTER TABLE HE_STUDENT7
MODIFY (address VARCHAR2(512));

ALTER TABLE HE_STUDENT7
DROP COLUMN nickname;

SELECT * FROM HE_STUDENT7;

--������ CRUD
--���̺� CRUD

-------------------------------------MERGE ����

CREATE TABLE TABLE_TO
AS
SELECT * FROM TABLE_FROM;
--FROM�����͸� ->TO�� �Űܼ� ����
--����
--��ü ���� �������� <--�������� <--�ǹ����� <--����� ����

--�����Ⱓ ~10/28
--��ġ -�ֱ������� ������ �ؾ��ϴ� ��
--��ġ ���� 00:00 ���� �����Ѵ�.
SELECT * FROM TABLE_TO;
SELECT * FROM TABLE_FROM;

INSERT INTO TABLE_TO
SELECT * FROM TABLE_FROM;
---------------------------------MERGE
--����: �߰��Ұų� ���ų�
--������ ������, ������ �߰�

MERGE INTO TABLE_TO TT  -- TABLE_TO�� �����ϰڴ�    /TT,TF�� ������
USING TABLE_FROM TF
ON (TT.ID = TF.ID)
--ON (TT.ID = TF.ID AND TT.NAME=TF.NAME) --ID�� ����,NAME�� ���� ��츦 �����°�
--ID�� ������ NAME�� �ٸ���? ���ս���
WHEN MATCHED THEN --������ �ִ� ���
    UPDATE SET TT.name = TF.name
WHEN NOT MATCHED THEN --������ ���� ��츦 ������ ó����
    INSERT VALUES (TF.ID,TF.NAME);
    
--�⺻Ű ���� -> Ư��
--�⺻Ű (PK) / �ܷ�Ű (FK)

CREATE TABLE T_PERSON_INFO(
    ID NUMBER(10),
--    ID NUMBER(10) PRIMARY KEY,
    NAME VARCHAR2(24),
    CONSTRAINT T_PERSON_INFO_PK PRIMARY KEY(ID) --�������� �ɱ�
);

CREATE TABLE T_HOBBY_LIST(
    ID NUMBER(10),
    NO NUMBER(10),
    HOBBY VARCHAR2(24),
    PREFER NUMBER(2), --CHECK (PREFER BETWEEN 1AND 10), --1~10������ ���ڸ� �����ֵ��� ���ǰɱ�
    CONSTRAINT T_HOBBY_LIST PRIMARY KEY(ID,NO) --PK�ΰ� ���� �Ϸ��� �̷��� �����
);

-----------------------���������� �߰��ϰڴ�
ALTER TABLE T_HOBBY_LIST
ADD CONSTRAINT T_HOBBY_LIST_PF_CHK CHECK(PREFER BETWEEN 1 AND 10);

INSERT INTO T_HOBBY_LIST
VALUES(18,1,'���',10);

--DELETE T_HOBBY_LIST
--WHERE ID =18;

-----------------------------������ ��ȸ
SELECT * FROM USER_SEQUENCES;
-------------------------------�������� ��ȸ
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'T_TEAM_INFO_SET';
----------------------------�������� ����
--�����ϴ°� ���� DROP�ߴٰ� �ٽ� �߰��ؾ��� 
ALTER TABLE T_TEAM_INFO_SET
DROP CONSTRAINT T_TEAM_INFO_SET_FK;


---------------------�ڵ����� ó���� �� �ְ� �����ִ�
---------------------SEQUENCE
CREATE SEQUENCE T_PERSON_INFO_SEQ
INCREMENT BY 1
START WITH 21
--MAXVALUE 100
--MINVALUE 1
--CYCLE --CYCLE/NOCYCLE
--CACHE 20 --�⺻���� 20�̴�
;

-----------------------������ ���� ��ȸ�ϱ�
SELECT * FROM USER_SEQUENCES
WHERE SEQUENCE_NAME = 'T_PERSON_INFO_SEQ';


SELECT * FROM T_HOBBY_LIST;
SELECT NVL(MAX(ID),0)+1 FROM T_PERSON_INFO;
SELECT T_PERSON_INFO_SEQ.NEXTVAL FROM DUAL;


INSERT INTO T_PERSON_INFO
VALUES(T_PERSON_INFO_SEQ.NEXTVAL,'������'); --������ ���� ������ ���

SELECT * FROM T_HOBBY_LIST ORDER BY ID ,NO; 
SELECT * FROM T_PERSON_INFO;

SELECT ID,COUNT(*),COUNT(*)+1 "��������",MAX(NO),MAX(NO)+1"��������" FROM T_HOBBY_LIST
GROUP BY ID;

--���̵� �־�������! �⺻Ű�� �ߺ����� �ʰ� �Ϸ���
--���� �Ű��� �ϴ� �κ��� ����,,,, -> ���������� ������ ���� �����
INSERT INTO T_HOBBY_LIST
VALUES(21,(SELECT NVL(MAX(NO),0)+1 FROM T_HOBBY_LIST WHERE ID =21),'�',10);

SELECT MAX(NO)
FROM T_HOBBY_LIST
WHERE ID=18;

----------------------------------------

CREATE TABLE T_TEAM_INFO(
    ID NUMBER(10),
    NO NUMBER(10),
    NAME VARCHAR2(24), --VARCHAR VARCHAR2 ����� ���� VARCHAR2�� �ֽ��̰� ����Ǵ°��̴�
    PS_ID NUMBER(10) CONSTRAINT T_TEAM_INFO_FK REFERENCES T_PERSON_INFO(ID)--FK����
--                   ��������       �������Ǹ�      �����ϰڴ�    ������̺�(��÷�)
);
SELECT * FROM T_TEAM_INFO;
--FK ���� ->NULL.   �ܷ�Ű ->�ٸ� ���̺��� �ĺ���(�⺻Ű) -> �ĺ��ڿ� �����ϴ� ��

INSERT INTO T_TEAM_INFO
VALUES(1,1,'1��',18);

INSERT INTO T_TEAM_INFO
VALUES(1,2,'1��',19);

--INSERT INTO T_TEAM_INFO
--VALUES(1,3,'1��',22);    --���Ἲ ��������(SCOTT.T_TEAM_INFO_FK)�� ����Ǿ����ϴ�- �θ� Ű�� �����ϴ�
--  T_PERSON_INFO�� 22�� ����.
INSERT INTO T_TEAM_INFO
VALUES(1,3,'1��',NULL);  --�θ� Ű �����Ѵ� �ߴ��� NULL�� �Է°���

---------------------FK�ܷ�Ű
SELECT * FROM T_PERSON_INFO;
DELETE FROM T_PERSON_INFO WHERE ID =18; --ORA-02292: ���Ἲ ��������(SCOTT.T_TEAM_INFO_FK)�� ����Ǿ����ϴ�- �ڽ� ���ڵ尡 �߰ߵǾ����ϴ�
-----------�������
UPDATE T_TEAM_INFO
SET PS_ID=NULL  --�ڽ��� �����ϰ� �ִ� ���� ���� NULL�� �ٲ��ְ��� ��������
WHERE PS_ID=18;
--FK ���� ��, �����ϰ� �ִ� ���̺��� ������ ������ ��Ȱ���� ����.
--������ �ȵ� ��� �ذ��
--1. �����ϰ� �ִ� ���̺� �ش� �����͸� ��� ã�Ƽ� �����, ������ ����
--2. ON DELETE CASCADE;
--3. ON DELETE SET NULL;
--4. ����Ű ������ ���ϰ� �׳� ���ų�...
CREATE TABLE T_TEAM_INFO_CAS(
    ID NUMBER(10),
    NO NUMBER(10),
    NAME VARCHAR2(24), 
    PS_ID NUMBER(10) CONSTRAINT T_TEAM_INFO_CAS_FK REFERENCES T_PERSON_INFO(ID) ON DELETE CASCADE--FK����
);

CREATE TABLE T_TEAM_INFO_SET(
    ID NUMBER(10),
    NO NUMBER(10),
    NAME VARCHAR2(24), 
    PS_ID NUMBER(10) CONSTRAINT T_TEAM_INFO_SET_FK REFERENCES T_PERSON_INFO(ID) ON DELETE SET NULL--FK����
);
SELECT * FROM T_PERSON_INFO;

SELECT * FROM T_TEAM_INFO_CAS;--������ �������� �����ϴ� ������ ���� ������

SELECT * FROM T_TEAM_INFO_SET;  --�������� �������� �����Ͱ� NULL�� �ٲ�

DELETE
--SELECT *
FROM T_PERSON_INFO
WHERE ID =22;





-----------------------------������ ��ȸ     *�ߺ�*
SELECT * FROM USER_SEQUENCES;
-------------------------------�������� ��ȸ
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'T_TEAM_INFO_SET';
----------------------------�������� ����
--�����ϴ°� ���� DROP�ߴٰ� �ٽ� �߰��ؾ��� 
ALTER TABLE T_TEAM_INFO_SET
DROP CONSTRAINT T_TEAM_INFO_SET_FK;