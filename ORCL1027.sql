--[2022. 10. 27. SQL �������]
/*  �����@
���� ���̺� : panmae, product, gift
��� ������ : ��ǰ��, ��ǰ��, ���ż���, �ѱݾ�,
��������Ʈ, ����2����������Ʈ, ����ǰ��, ����Ʈ ����

- panmae ���̺��� �������� ����Ʈ�� �����ش�.
- ����Ʈ�� ������ �ݾ� 1���� 100�� ����Ʈ�� �ο��Ѵ�.
(��, 01�� 01�� ���� ���� �̺�Ʈ�� ���� 1���� 200�� ����Ʈ�� �ο��Ѵ�.)
- ��������Ʈ�� ����2����������Ʈ�� ��� �����ش�.
(�� ���, �̺�Ʈ ���� 01�� 01���� �����ϰ�� ����Ʈ�� ���� �� ���̴�.)
- ����2����������Ʈ�� �������� �ش� ����Ʈ �������� ������ �ִ� ����ǰ�� �����ش�.
- ����ǰ �� ���� �ش� ����ǰ�� ���� �� �ִ� ����Ʈ�� ������ �Բ� �����ش�.

* ��� ��İ� �÷� ����� ǥ��Ǵ� �̸� Ȯ��!
*/
select * from panmae;
select * from product;
select * from gift;
select SUBSTR(pan.p_date,1,4)||'-'||SUBSTR(pan.p_date,5,2)||'-'||SUBSTR(pan.p_date,7,2)"�Ǹ�����"
--,TO_CHAR(TO_DATE(pan.p_date),'YYYY-MM-DD')"�Ǹ�����" 
-- p_date�� Ÿ���� VARCHAR2(��Ʈ��Ÿ��)���� �Ǿ��־ TO_DATE�� ������������ �ٲ��� TO_CHAR�����
,pan.p_code"��ǰ�ڵ�"
,p.p_name"��ǰ��"
,TO_CHAR(p.p_price,'999,999')"��ǰ��"
,pan.p_qty"���ż���",TO_CHAR(pan.p_total,'999,999')"�ѱݾ�",TO_CHAR(pan.p_total*100,'999,999')"��������Ʈ"
,DECODE(SUBSTR(pan.p_date,5,4),'0101',TO_CHAR(pan.p_total*200,'999,999'),TO_CHAR(pan.p_total*100,'999,999'))"����2����������Ʈ"
--,CASE WHEN(SUBSTR(pan.p_date,5,4) ='0101') THEN pan.p_total*200
--      ELSE pan.p_total*100
--      END"����2����������Ʈ"
,g.gname"����ǰ��"
,TO_CHAR(g.g_start,'999,999')"����ƮSTART"
,TO_CHAR(g.g_end,'999,999')"����ƮEND"
from panmae pan,product p,gift g
where pan.p_code = p.p_code
and DECODE(SUBSTR(pan.p_date,5,4),'0101',pan.p_total*200,pan.p_total*100) between g.g_start and g.g_end 
--and CASE WHEN(SUBSTR(pan.p_date,5,4) ='0101') THEN pan.p_total*200
--      ELSE pan.p_total*100
--      END between g.g_start and g.g_end 
order by pan.p_date ;
--------------------------------------------------------------------------------

--COMMIT;
--ROLLBACK;
/*
Data Type
VARCHAR2	������
NUMBER	������
DATE	��¥
*/
--HE_STUDENT �л�����
--�й� : NUMBER
--�̸�  : VARCHAR2
--�ֹι�ȣ : VARCHAR2
--ID : VARCHAR2
--��� �Ͻ� : DATE
--stdno NUMBER(10,5) -- 12345.12345

----------------------------���̺� ����------------------------------------------
CREATE TABLE HE_STUDENT
(
    stdno NUMBER(10), -- 12345.12345 -- 12345
    name VARCHAR2(32), -- �̸�
    ssn VARCHAR2(16), --221122-1222457
    id VARCHAR2(32), --���̵�
    reg_date DATE
);

--------------------------------------------------------------------------------
----------------------------���̺� �����͸� ����---------------------------------

INSERT INTO HE_STUDENT (stdno, name, ssn, id, reg_date)
VALUES(1, '������','1111111111111', 'bed', SYSDATE);

INSERT INTO HE_STUDENT -- 5���� ���� ���� ��θ� �����Ÿ� ��������
VALUES(2, '������','1111111111112', 'kse', SYSDATE);

INSERT INTO HE_STUDENT (stdno, name, ssn, id, reg_date)
VALUES(3, '�Ǽ���','1111111111113', 'ksm', SYSDATE);

INSERT INTO HE_STUDENT (stdno, name, ssn, id, reg_date)
VALUES(4, '�赿��','1111111111114', '', SYSDATE);
commit;
--------------------------------------------------------------------------------
----------------------------������Ʈ---------------------------------------------
--������Ʈ�� ����Ʈ �ϱ��� ���� �ּ� ó���ϰ� ����Ʈ�� �� ���� Ȯ���� �Ŀ� �����ض�~
--�й� 2��,3�� ������� ID�� ���� he_�߰�.
UPDATE HE_STUDENT
SET id='he_'||id--�ٲ��÷�=�ٲ� ����
--SELECT * FROM HE_STUDENT
WHERE stdno in (2,3);--�ٲ� ��� ���� ����

--id �� null �� ����� id�� id_none�̶�� ����
UPDATE HE_STUDENT
SET id='id_none'
WHERE id IS NULL;

--���̺� ���� ��� �����Ϳ� stdno�� 100�� ����
UPDATE HE_STUDENT
SET stdno=100+stdno;
commit;
select * from HE_STUDENT;
--------------------------------------------------------------------------------
---------------------------------������ �����------------------------------------
--DELETE 
SELECT *
FROM HE_STUDENT;
--WHERE stdno = 102;
--------------------------------------------------------------------------------

--���̺� ����� 2
CREATE TABLE HE_STUDENT2
(
    stdno NUMBER(10) NOT NULL, -- 12345.12345 -- 12345
    name VARCHAR2(32) NOT NULL, -- �̸�
    ssn VARCHAR2(16), --221122-1222457
    id VARCHAR2(32) Default 'id_empty', --���̵�
    address VARCHAR2(256), --�ּ�
    reg_date DATE
);

INSERT INTO HE_STUDENT2 (stdno, name, ssn, id,address, reg_date)
VALUES(5, '�����','1111111111115', 'health','�ｺ��ٷο�', SYSDATE);

INSERT INTO HE_STUDENT2 (stdno, name, ssn, id,address, reg_date)
VALUES(6, '����','1111111111116', 'bae','õ�ȹ���30��', SYSDATE);

INSERT INTO HE_STUDENT2 (stdno, name, ssn, id,address, reg_date)
VALUES(7, '������','1111111111117', 'bingfinite','��������', SYSDATE);

INSERT INTO HE_STUDENT2 (stdno, name, ssn, id,address, reg_date)
VALUES(8, '�ŵ�ȣ','1111111111118', null,'���ѹα�', SYSDATE);

INSERT INTO HE_STUDENT2 (stdno, name, ssn, address, reg_date)
VALUES(9, '�Ƚ���','1111111111119', '�ƻ������ҰŸ�', SYSDATE);

SELECT * FROM HE_STUDENT2;

UPDATE HE_STUDENT2
SET id ='leon'
WHERE ID IS NULL;
--------------------------------------------------------------------------------

--���̺� ����� 3
CREATE TABLE HE_STUDENT3
(
    stdno NUMBER(10) PRIMARY KEY, -- 12345.12345 -- 12345
    name VARCHAR2(32) NOT NULL, -- �̸�
    ssn VARCHAR2(16), --221122-1222457
    id VARCHAR2(32) UNIQUE, --���̵�
    address VARCHAR2(256), --�ּ�
    reg_date DATE
);

INSERT INTO HE_STUDENT3 (stdno, name, ssn, address, reg_date)
VALUES(10, '������','1111111111110', '���������Ÿ�', SYSDATE);

INSERT INTO HE_STUDENT3 (stdno, name, ssn, address, reg_date)
VALUES(11, '�̱���','1111111111211', '���������Ÿ�', SYSDATE);

INSERT INTO HE_STUDENT3 (stdno, name, ssn, address, reg_date)
VALUES((SELECT NVL(MAX(stdno),0)+1 FROM HE_STUDENT3), '�̴ٿ�','1111111111212', '�ƻ���Ÿ��', SYSDATE);
--���� ���� NULL�� �Ǿ��ֱ� ������ NVL�� �������ش�.

SELECT max(stdno)+1 FROM HE_STUDENT;    --->���� stdno 105
SELECT stdno FROM HE_STUDENT2;  ---->10
SELECT NVL(max(stdno),0)+1 FROM HE_STUDENT3; ---->12

--1�� HE_STUDENT ->stdno 1 2 3 4�� ���󺹱���Ű��
UPDATE HE_STUDENT
SET stdno = stdno-100;
commit;
--2�� HE_STUDENT,HE_STUDENT2,HE_STUDENT3 ��� ������ �����ؼ� �����ִ� ������ �����
select stdno,name,ssn,id,null,reg_date 
from HE_STUDENT
union all
select stdno,name,ssn,id,address,reg_date
from HE_STUDENT2
union all
select stdno,name,ssn,id,address,reg_date
from HE_STUDENT3;