/*[2022. 10. 31. �������]

1. ���� �� ��ɾ�� � ����� �����ϴ� ��ɾ����� �ۼ��ϰ�,
�� ����� �������� �ִٸ� �����Ͻÿ�.
DELETE FROM ���̺��;
TRUNCATE TABLE ���̺��;*/

--delete
TRUNCATE TABLE ���̺��; -- �����͸� ��������� -- �׳� �ٷ� ������ ����°� ���������� ���� �ξ� ������ ���̰� �ִ�.
--�����Ͱ� �߷ȴٰ� ����. ROLLBACK �Ұ� --�ٷ� �ڵ� COMMIT�� �Ź���.
--DDL

DELETE --��ü�� ���� �� �ִ� / ���ǿ� ���󼭵� ���� �� �ִ�. 
       -- ���� ���鼭 ã�Ƽ� ����°�
       --���� COMMIT�Ȱ� �ƴ� ����. ROLLBACK ����
       --DML
FROM ���̺��;
/*
2. ���� ���ǿ� ���� ���̺��� �����Ͻÿ�.
���̺�� : T_MEMBER_POINT

*���� �÷�
ID : ������ 6�ڸ�
���� : ������ 6�ڸ�
���ID : ������ 24����Ʈ, Null �ȵ�.
���� : ������ 3�ڸ�, ������ 0������ 100�������� �Է� ������.
ä���Ͻ� : ��¥��, �� �Էµ� ���� ���� ��� �Է½ð��� �⺻������ ����
�� �⺻Ű(PK) : ID�� ������ ����
*/
CREATE TABLE T_MEMBER_POINT
(
    id NUMBER(6),
    no NUMBER(6),
    meber_id VARCHAR2(24) NOT NULL,
    score NUMBER(3) CHECK (score BETWEEN 1 AND 100),
    m_date DATE Default SYSDATE,
    CONSTRAINT T_MEMBER_POINT PRIMARY KEY(id,no)
);

--ALTER TABLE T_MEMBER_POINT
--MODIFY (score NUMBER(3) CHECK (score BETWEEN 0 AND 100));
/*
3. ���� ���ǿ� �´� �������� �����Ͻÿ�.
�������� : T_MEMBER_POINT_PK_SEQ
*������
1���� �����ϸ� 1�� �����Ѵ�.
���� ������ 1~999999
��ȯ���� �ʵ��� �Ѵ�.*/
CREATE SEQUENCE T_MEMBER_POINT_PK_SEQ
INCREMENT BY 1
START WITH 1
MAXVALUE 999999
MINVALUE 1
NOCYCLE; 
/*
4. ������ �������� ���� �ҷ��� ����ϴ� ����� �ۼ��Ͻÿ�.
*/
INSERT INTO T_MEMBER_POINT(id,no,meber_id,score)
VALUES(T_MEMBER_POINT_PK_SEQ.nextval,T_MEMBER_POINT_PK_SEQ.nextval,'hell',30);

select *  from T_MEMBER_POINT;
--------------------------------------------------------------------------------

----------------�ε���(INDEX)
----------------ORACLA index(��� ��ġ�� �ִ°�?)
--�˻��� ������ �ϱ����� ������ ������ �ϴ���

select *
from he_student4;

CREATE TABLE HE_STUDENT8
(
    STDNO NUMBER(4),
    NAME VARCHAR2(24)
);
SELECT * FROM HE_STUDENT8;

--STDNO,NAME 2�� �ִ� HE_STUDENT8
--��ȸ(SELECT) WHERE ����
--�����Ͱ� 20���� �ִ�ġ�� WHERE���� -> �ð��� ���� �Ҹ��
--WHERE ���� INDEX�� �ɷ��ִ� �ķ� �������� ���Ǹ���� -> �ð��� ��������->1��, 2��
--��ü �������� 15% ������ ���� ��ȸ�ϴ� CASE.
--�����Ͱ� ������ �������, INDEX �Ŵ°��� ������ �����ϼ� �ִ� (INDEX�� ����ϴ� ����������)

--HE_STUDENT8 ���̺� + ������
--INDEX -> INDEX ������ ������. -> ������ ��ȸ�� ��������

-- 1~10     WHERE 1~4;
--1 2 3 4 5 ... 10
/*
            ����
        1~5     6~10
    1~3   4,5  6,8   8~10
*/
--INDEX --> PRIMARY KEY -> INDEX ->�ε��� ������, ���ı��� .ASC DESC
--INDEX : PK, NOT NULL, UNIQUE�� �ֵ����� �Ŵ°� ����.
--1000BYTE�� �Ѵ� ���� INDEX�� ���ϴ°� ���ش�

INSERT INTO HE_STUDENT8
VALUES(1,'������');

INSERT INTO HE_STUDENT8
VALUES(2,'������');

INSERT INTO HE_STUDENT8
VALUES(5,'�����');

INSERT INTO HE_STUDENT8
VALUES(4,'�赿��');

INSERT INTO HE_STUDENT8
VALUES(3,'�Ǽ���');

SELECT * FROM HE_STUDENT8
WHERE STDNO <10; --�⺻Ű�� ��ȸ���ǿ� ���� �⺻Ű ���� ������ �ȴ�.
--ORDER BY STDNO;
ALTER TABLE HE_STUDENT8
ADD CONSTRAINT HE_STUDENT8_PK PRIMARY KEY(STDNO);

--ORDER BY�� ������ ������ �������� �ʴ´�. -->��ȸ�� �Ϸ��� ORDER BY ����Ѵ�
--ORDER BY ������ �⺻������? INSERT INTO �� ���� ó�� �������� �׷��� �ʴ�
--���̺� ������ ���� -> �� ��ġ ���� --> �� �� �� �� 
--WHERE �⺻Ű�� ���ǿ� ���� �⺻Ű ���� ���ĵȴ�.(PRIMARY KEY, INDEX�� ���� �ɷ���)
--NULL�����Ѿֵ��� INDEX�� �����ϴ°� �����ִ°� ����

-------------------------������ �ε����� �����ϴ� ���!
--CREATE INDEX �ε����̸�
--ON ���̺� (�÷� ASC/DESC);

--DROP INDEX �ε����̸�;

--CREATE UNIQUE INDEX HE_STUDENT8_IDX_NAME;
--INDEX

-----------------------�ε��� �����
CREATE INDEX HE_STUDENT8_IDX_NAME
ON HE_STUDENT8 (NAME ASC);
-----------------------�ε��� �����ϱ�
DROP INDEX HE_STUDENT8_IDX_NAME;

SELECT * FROM HE_STUDENT8
WHERE NAME NOT LIKE '��%';

--COM_CODE ȸ���ڵ� : 10 --�ε��� ������ ��ȸ�� �� ��������
SELECT * FROM HE_STUDENT8
--WHERE COM_CODE =10
AND STDNO<10
AND NAME LIKE '��%'; 

-------------------------------------��(View) �����ְ���� �͸� ������ �� ���
--Table ������ ����(30��)  -> ���� ������/ �����ְ� ������ ������ View�� ����� ����

SELECT * FROM HE_STUDENT8;

SELECT e.empno,e.ename,e.job,e.deptno,d.dname
FROM emp e, dept d
where e.deptno = d.deptno;

CREATE OR REPLACE VIEW V_HE_STD8
AS
SELECT name FROM HE_STUDENT8;

SELECT * FROM V_HE_STD8;

CREATE OR REPLACE VIEW V_EMP_DEPT
AS
    SELECT e.empno,e.ename,e.job,e.deptno,d.dname
    FROM emp e, dept d
    where e.deptno = d.deptno;

--------------------------VIEW �����
DROP VIEW V_HE_STD8;
SELECT * FROM V_EMP_DEPT;

--MASTER���̺� - �Ѱ� / DETAIL���̺� - �κкκ�
--����(����/�����) - ���ٰ��ɿ���

--�� ������ ������ �ִ� �������� ��밡��.
--A���̺� �÷��� 30���ִ�. 15���� �������� 15���� �����
--���������� 15���� VIEW�� �����

-----------------------VIEW ������ ��ȸ�ϱ�
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_INDEXES;
SELECT * FROM USER_SEQUENCES;
SELECT * FROM USER_CONSTRAINTS;

-----------------------------------SUB QUERY ��������(��ø��) --SELECT
SELECT * FROM EMP;

SELECT * FROM DEPT;
--WHERE DEPTNO =20;

--��������
SELECT /*QUERY ��Į�� ��������*/
FROM/*QUERY �ζ��� ��*/
WHERE; /*QUERY ���� ����*/


                    /*QUERY ��Į�� ��������*/
 SELECT EMPNO,ENAME,JOB,DEPTNO,
    (SELECT DNAME 
    FROM DEPT D 
    WHERE D.DEPTNO= E.DEPTNO) AS "�μ��̸�"
FROM EMP E; --JOIN

                    /*QUERY �ζ��� ��*/
SELECT *
FROM EMP E, 
    (SELECT DEPTNO,DNAME
    FROM DEPT 
    WHERE DEPTNO IN (10,20)
    ) D
WHERE E.DEPTNO = D.DEPTNO;

                    /*QUERY ���� ����*/
SELECT * 
FROM EMP e
WHERE e.DEPTNO = (SELECT DEPTNO FROM DEPT WHERE DNAME = 'SALES');

SELECT * FROM DEPT;

--------------------------------------------------------------------------------
SELECT * FROM emp2;
SELECT * FROM dept2;

--1.emp2 �� �ִ� ���, �̸�, �μ��ڵ带 �����ֱ�.
--��, �μ��� ������ ���￡ �ִ� �μ��� ��츸 �����ֱ�.
--*���ѻ��� : JOIN ����. SUB-QUERY Ȱ��
SELECT e.empno,e.name,e.deptno
FROM emp2 e,(SELECT dcode FROM dept2  WHERE area LIKE 'Seoul%' or area LIKE 'Busan%') d
WHERE e.deptno = d.dcode;
                            ------

SELECT empno,name,deptno
FROM emp2
WHERE deptno IN(SELECT dcode FROM dept2
                WHERE area LIKE 'Seoul%');
                
-----2.
--Table : professor, department --sub-query Ȱ��
--Meg Ryan �������� �ʰ� �Ի��� ������� �̸�/�Ի���/�а��� ���
select name,hiredate ,(select dname from department d where p.deptno = d.deptno)
from professor p
where hiredate > '85/09/18';
                            ------
--JOIN
SELECT P.NAME,P.HIREDATE,P.DEPTNO , D.DNAME
FROM PROFESSOR P ,DEPARTMENT D
WHERE HIREDATE >(SELECT HIREDATE FROM PROFESSOR
WHERE NAME = 'Meg Ryan')
AND P.DEPTNO = D.DEPTNO;

--SUBQUERY
select name,hiredate ,(select dname from department d where p.deptno = d.deptno)
from professor p
where HIREDATE >(SELECT HIREDATE FROM PROFESSOR
WHERE NAME = 'Meg Ryan');

-----3.
--Table : student
--������(deptno1)�� 101�̰ų� 201�� �л����� ���Ű���� ū �л����� �й�/�̸�/Ű ���
,avg(height)
select studno,name,avg(height)
from student
where deptno1 in(101,201)
group by rollup (studno,name);

                            ------

SELECT studno, name, height
FROM student
where height >(SELECT AVG(height)
FROM student
where deptno1 in('101','201'));

----4. emp2���̺�.
--��ü ������ �߿��� (section head���� �� �ּ� ������ �޴� ����� ����)�������� ���� ���� ������� 
--�̸�/����/���� ��� (������ 000,000,���·� ��������)
select name,position,to_char(pay,'999,999,999')
from emp2
where pay>(select min(pay)
from emp2
where position ='Section head'
);

----5. student���̺�.
--(2�г� �л��� �� ü���� ���� ���� ������ �л��� ���ΰԺ��� )
--��ü �л��� �� �����԰� ���� ������ �л��� �̸�/������/�г� ���
select name,weight,grade 
from student
where weight <(select max(weight) from student where grade =2);

----------�� �г⺰, �ִ� �������� �л����� ������ ���
--�ִ������ �г� ������ ��ġ�ϴ� �л� ������ ���
--(SUB-QUERY ���� �� - ���� �÷�)
SELECT * 
FROM student
WHERE (grade,weight) IN (SELECT grade,max(weight)
FROM student
group by grade);

--�г⺰ �ִ������
SELECT grade,max(weight)
FROM student
group by grade; --�׷���̿� �� �÷��� ����Ʈ���� ���� �ִ�.

--������ ������ ���� ������ ���
SELECT * 
FROM student
WHERE (deptno1,weight) IN (SELECT deptno1,max(weight)
FROM student
group by deptno1);

SELECT deptno , (SELECT dname FROM dept d WHERE e.deptno = d.deptno)
FROM emp e;

--��� ���� ��ȸ ->�̸�  UNIQUE ->���� �̸��� �ϳ���.
--SUBQUERY SELECT MAX(�̸�) FROM ��� WHERE ��� ='';
--��� - �̸��� 2�� - ����(���,�븮)