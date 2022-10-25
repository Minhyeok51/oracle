select studno"��ȣ",name"�̸�",id"���̵�"
from student
where height >=160 and height <=175
union all
select profno,name,id
from professor
--where deptno between 101 and 201
where deptno in(101,102,103,201)
and bonus is null;

select '�̸�:' ||name "�̸�",'���̵�:'||id"���̵�",'�ֹι�ȣ:'||substr(jumin,1,6)||'-'||substr(jumin,7) as "�ֹι�ȣ"
from student;

--SUBSTR(����÷�,������ġ,����) SUBSTRB(����÷�,������ġ,����)
SELECT SUBSTR(jumin, 1,6), SUBSTRB(jumin,1,6), SUBSTR('�ѱ�',1,1),SUBSTRB('�ѱ�',1,3)
FROM student;

--INSTR(����÷�,ã������,������ġ,���°�� ������?)
SELECT tel,INSTR(tel,'-',1,1),INSTR(tel,')',1,1),SUBSTR(tel,INSTR(tel,'-',1,1)+1,4)
FROM student;

SELECT 'A-B-C-D', INSTR('A-B-C-D','-' ,1, 1)
,INSTR('A-B-C-D','-' ,1, 3)
,INSTR('A-B-C-D','-' ,3, 2)
FROM dual;

--�л����̺��� �� �л��� �̸�/��ȭ��ȣ/��ȭ��ȣ�� ������ȣ�� ���
--055)381-2158
--   4
--SUBSTR(1,3)
SELECT name,tel,
SUBSTR(tel,1,INSTR(tel,')',1,1)-1) ������ȣ,
SUBSTR(tel,INSTR(tel,')',1,1)+1,INSTR(tel,'-',1,1)-(INSTR(tel,')',1,1)+1)) ��ȭ��ȣ���ڸ�,
SUBSTR(tel,INSTR(tel,'-',1,1)+1,4)��ȭ��ȣ��4�ڸ�
FROM student;

--INSTR(����÷�,ã������,������ġ,ã�����ڰ� ���° ���� ��ġ�� ã���ų�)
--SUBSTR(����÷�,������ġ,����)
SELECT 'AB-C-D+E+F=ADEF'
    ,SUBSTR('AB-C-D+E+F=ADEF',6,5)
    ,SUBSTR('AB-C-D+E+F=ADEF',12,4)
    ,INSTR('AB-C-D+E+F=ADEF','-',1,1)
    ,INSTR('AB-C-D+E+F=ADEF','-',1,2)
    ,INSTR('AB-C-D+E+F=ADEF','+',1,1)
FROM dual;

--LPAD(�ķ�(����),�ڸ���(���ڸ��� ���ڴ�),��ĭ�� ä���) --����
--RPAD(�ķ�(����),�ڸ���(���ڸ��� ���ڴ�),��ĭ�� ä���) --������
SELECT grade ,LPAD(grade,2,'0'),RPAD(grade,4,'*')
FROM student;

SELECT LPAD(SUBSTR(jumin,7),13,'*')
FROM student;

--TRIM
--LTRIM,RTRIM
--(���ڿ�/�÷�,���� ����)

SELECT '*abcd*',LTRIM('*abcd*','*'),RTRIM('*abcd*','*')
FROM dual;
--TRIM �յڷ� ������� ���� ���ֱ� (���� ���� ���°�)
SELECT ' this is computer ',TRIM(' this is computer ')
FROM dual;

--REPLACE
--REPLACE(�÷�/���ڿ�, old���ڸ� ,new���ڷ� �ٲٰڴ�)
SELECT 'ABCD',REPLACE('ABCD','C','H')
FROM dual;

--1.emp���̺� �ִ� �̸����� 2��° 3��° ���ڸ� **�� �ٲٱ�
SELECT REPLACE(ename,SUBSTR(ename,2,1),'*')
FROM emp;

--2.student���̺� �ֹι�ȣ �� 7�ڸ��� *�� �ٲٱ�. rpad -x replace���
SELECT REPLACE(jumin,SUBSTR(jumin,7),'*******')
FROM student;

--3.student ���̺� tel ��ȭ��ȣ���� ��ȭ��ȣ ���ڸ��� *�ιٲٱ�
--051)345-****
SELECT tel,REPLACE(tel,SUBSTR(tel,INSTR(tel,'-',1,1)+1,4),'****'),
substr(tel,-4,4)
FROM student;

-------------------------�����Լ�

--ROUND(ó��������,����ڸ���)

SELECT ROUND(123.4),ROUND(123.5,0)
,ROUND(123.46,1),ROUND(123.49,1)
,ROUND(123.46,2),ROUND(123.49,2)
,ROUND(126.55,0)
,ROUND(126.55,1)
-- . ���� ���� �ݿø� ���ѹ���
,ROUND(126.55,-1)
FROM dual;

--TRUNC(ó��������, �ڸ���) -����ó��
SELECT TRUNC(123.4),TRUNC(123.5,0)
,TRUNC(123.46,1),TRUNC(123.49,1)
,TRUNC(123.46,2),TRUNC(123.49,2)
,TRUNC(126.55,0)
,TRUNC(126.55,1)
-- . ���� ���� ��������
,TRUNC(126.55,-1)
FROM dual;

SELECT TRUNC(51217,-2)
FROM dual;

--MOD -����������
SELECT MOD(10,2),MOD(9,2),MOD(10,4)
FROM dual;

--CEIL(���� ����� ū ����),FLOOR(���� ����� ���� ����)
SELECT rownum,ename,CEIL(rownum/3) "TEAMNO"
FROM emp;
--WHERE rownum<=5

--POWER ����(����,����)
SELECT POWER(10,3),POWER(2,10)
FROM dual;

--��¥ �Լ�
--���� ��¥,�ð�
SELECT SYSDATE
FROM dual;

--create user, create date, update user, update date
--������ �����,�����Ͻ�      ,���� �����,  �����Ͻ�

--LAST_DAY �ش� ���� ������ ��¥
SELECT LAST_DAY(SYSDATE),LAST_DAY('2022-02-01')
FROM dual;

--�������ȸ( EX.ī��� ���α׷�,�̹��޿� ����� ��� ��ȸ)
SELECT '2022-10-01' ,LAST_DAY('2022-10-01')
FROM dual;

--ADD_MONTHS(��¥, ���� ���� ��) �Լ�
SELECT '2022-10-01', LAST_DAY(ADD_MONTHS('2022-10-01',2)) --10��1��~12�� ����
FROM dual;

--ROUND�ݿø�, TRUNC����/����
SELECT
TO_CHAR(ROUND(SYSDATE),'YYYY-MM-DD HH24:MI:SS'),
TO_CHAR(TRUNC(SYSDATE),'YYYY-MM-DD HH24:MI:SS')
FROM dual;

--����ȯ�Լ�
--TO_NUMBER(����ó�����乮��)
SELECT 2+2+'4'+TO_NUMBER('18')
FROM dual;

--TO_CHAR�������·� �ٲٴ� �Լ�
SELECT SYSDATE, TO_CHAR(SYSDATE,'YYYY')
, TO_CHAR(SYSDATE,'YYYY-MM-DD') --DATAŸ���� ���Ŀ� �°� ����ϱ� ��/��/��
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH:MI:SS')--��/��/�� ��:��:��
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS')--��/��/�� ��:��:�� 24�ð� ǥ���
FROM dual;

--Ex
SELECT TO_CHAR(birthday,'YYYY-MM-DD HH24:MI:SS')
,TO_CHAR(birthday,'MM')
,TO_CHAR(birthday,'DD')
FROM student;

desc student;

--Ex
--�������̺� ������ �߿� 1~3���� �Ի��� ����� ������ �����ֶ�
SELECT * 
FROM emp
WHERE TO_CHAR(hiredate,'MM') BETWEEN 01 AND 03;

--�ٸ��� ���� 9��ߵǳ�?
SELECT 50000,TO_CHAR(50000,'99,999')
,TO_CHAR(50000,'99,999.99')
,TO_CHAR(50000,'099,999.99')
,TO_CHAR(4444450000,'FM999,999,999,999') --3�ڸ����� �޸��� ��� ���� ���, ���� ���� �ȸ����� ���� ����.
--�տ� ���� ����� �ʹٸ� FM �� �պκп� �߰�
FROM dual;

--1.progessor ���̺��� ��ȸ�Ͽ� 201�� �а��� �ٹ��ϴ� �������� �̸���
--�޿�, ���ʽ�,������ 124,556���� ���. ��, ������(pay*12)+bonus�� ���
SELECT name"�̸�",pay"�޿�",NVL(bonus,0),TO_CHAR((pay*12)+NVL(bonus,0),'FM999,999,999,999,999')"����"
FROM professor
WHERE deptno IN(201);

--2.emp���̺� ��ȸ, comm���� ������ �ִ� �������
--empno,ename,hiredate,�ѿ���, 15%�λ� �� ������ ���
--�� �ѿ����� (sal*12)+comm���� ����ϰ�
--15%�λ��� ���� �ѿ����� 15%�λ� ��
SELECT empno,ename,hiredate,TO_CHAR((sal*12)+NVL(comm,0),'999,999')"�ѿ���",TO_CHAR(((sal*12)+NVL(comm,0))*1.15,'999,999')"15%�λ� �� ����"
FROM emp;
--WHERE comm IS NOT NULL;

--1.progessor ���̺��� ��ȸ�Ͽ� 201�� �а��� �ٹ��ϴ� �������� �̸���
--�޿�, ���ʽ�,������ 124,556���� ���. ��, ������(pay*12)+bonus�� ���
SELECT *
FROM professor
WHERE deptno IN(201);

--NVL()�Լ�
--NULL�� ���� ������ ����� �ٸ� ��
--NVL(�÷�,�ٲ� ��)
SELECT pay ,NVL(bonus,0)
FROM professor
WHERE deptno IN(201);

--NVL(�÷�,NULL�� ��� �⺻ ��)�Լ�
--NVL2(�÷�,NULL�� �ƴѰ�� ó���� ����,NULL �ΰ�� ó���� ����)�Լ�

SELECT ename,sal,comm, NVL2(comm,comm+100,500)as "�߰� ���ʽ�"
FROM emp;

--ex)
--emp���̺��� deptno�� 30���� ������� ��ȸ�Ͽ� comm���� ���� ���'Exist'�� ����ϰ�
--comm���� null�� ��� 'Empty'�� ���
SELECT empno,ename,comm,NVL(comm,0),NVL2(comm,'Exist','Empty')
FROM emp
WHERE deptno =30;


--DECODE()�Լ�
--(a==b) ? a:b;
--DECODE(A,B,'ture','false'); A�� B�� ������ 'true'�κ�,�ƴϸ�'false'
SELECT deptno
,DECODE(deptno,'10','�����а�')
,DECODE(deptno,'10','�����а�','�������а�')
,DECODE(deptno,'10','�����а�','20','������ �а�','30','�������а�','�׿ܵ��')
,DECODE(deptno,'10',DECODE(ename,'CLARK','�����ϴ���','���Դ���'),'�ϸ��ϴ���')
FROM emp;

--ex1)
--student���̺��� ����Ͽ�
--�� 1����(deptno1)�� 101���� �а� �л����� �̸��� �ֹι�ȣ,������ ����ϵ�
--������ �ֹι�ȣ(jumin)�÷��� �̿��Ͽ� 7��° ���ڰ� 1�ϰ�� '����',2�ϰ��'����'�� ����ϼ���
SELECT name,jumin,DECODE(SUBSTR(jumin,7,1),'1','����','����')"����"
FROM student
WHERE deptno1 =101;
--ex2)
--student���̺��� 1������(deptno1) 101���� �л��� �̸��� ����ó�� ������ ���
--��,������ȣ�� 02�� '����',031�� '���',051��'�λ�',��������'�� ��'
SELECT name,tel,DECODE(SUBSTR(tel,1,INSTR(tel,')',1,1)-1),'02','����','031','���','051','�λ�','�� ��')"����"
FROM student;
--WHERE deptno1=101;

--CASE �� WHEN (SWITCH CASE)
--CASE ���� WHEN ��� THEN ���
--         WHEN ��� THEN ���
--          ELSE ���
--          END
SELECT name,tel,SUBSTR(tel,1,INSTR(tel,')',1,1)-1)"������ȣ"
,CASE(SUBSTR(tel,1,INSTR(tel,')',1,1)-1)) WHEN '02'THEN'����'
                                        WHEN '031'THEN'���'
                                        WHEN '051'THEN'�λ�'
                                        ELSE '�� ��'
                                        END AS"����"
FROM student;

SELECT name ,jumin,SUBSTR(jumin,3,2)"��"
,CASE WHEN SUBSTR(jumin,3,2) IN ('01','02','03') THEN '1�б�'
    WHEN SUBSTR(jumin,3,2) IN ('04','05','06') THEN '2�б�'
    WHEN SUBSTR(jumin,3,2) BETWEEN 07 AND 09 THEN '3�б�'
    ELSE '4�б�'
    END AS"�б� ����"
FROM student;

--CASE WHEN
--emp���̺��� ��ȸ�Ͽ� empno,ename,sal,level(�޿����)�� ���
--�� �޿������ sal�� ��������
-- 1-1000�̸� Level 1,
-- 1001-2000 �̸� Level 2,
-- 2001-3000�̸� level 3,
-- 3001 - 4000�̸� level 4,
-- 4001���� ������ level5�� ���
SELECT empno,ename,sal,
CASE WHEN sal between 1 and 1000 THEN 'Level 1'
WHEN sal between 1001 and 2000 THEN 'Level 2'
WHEN sal between 2001 and 3000 THEN 'Level 3'
WHEN sal between 3001 and 4000 THEN 'Level 4'
ELSE 'Level 5'
END AS "LEVEL"
FROM emp;

--���Խ� (Regular Expression)
--���Խ� ���� ->JS,Java,SQL
SELECT *
FROM t_reg;

--REGEXP_LIKE(����÷�,���Խ�) �Լ�
SELECT *
FROM t_reg
WHERE text like 'A%' OR text like 'a%';

SELECT *
FROM t_reg
--WHERE REGEXP_LIKE(text,'[a-z]'); --�ҹ��ڰ� �ֳ�?
--WHERE REGEXP_LIKE(text,'[A-Z]'); --�빮�ڰ� �ֳ�?
--WHERE REGEXP_LIKE(text,'[a-zA-Z]'); --�ҹ��ڵ� �빮�ڵ� �ֳ�?
--WHERE REGEXP_LIKE(text,'[0-9]'); --���ڰ� �ֳ�?
--WHERE REGEXP_LIKE(text,'[a-z] [0-9]');--�ҹ���^����(�ҹ��ڶ����� �� ���̽��� �ֳ�?
--WHERE REGEXP_LIKE(text,'[a-z]  [0-9]');--�ҹ���^^����(�ҹ��ڶ����� �� ���̽��� �ֳ�?
--WHERE REGEXP_LIKE(text, '[[:space:]]'); --���Ⱑ ���ԵǾ��ֳ�
--WHERE REGEXP_LIKE(text,'[A-Z]{2}'); --�빮�ڰ� 2�� �پ��ִ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text,'[A-Z]{3}'); --�빮�ڰ� 3�� �پ��ִ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text,'[A-Z]{4}'); --�빮�ڰ� 4�� �پ��ִ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text, '[0-9]{3}'); --���ڰ� 3�� �پ��ִ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text, '[A-Z][0-9]{3}'); --�빮�� �ְ� ���ڰ� 3�� �پ��ִ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text, '[0-9][a-z]{3}'); -- ���ڰ� �ְ� �ҹ��� 3�� �پ��ִ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text, '^[A-Z]'); --ù ���ڰ� �빮�ڷ� �����ϴ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text, '^[a-z]'); --ù ���ڰ� �ҹ��ڷ� �����ϴ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text, '^[a-zA-Z]'); --ù ���ڰ� �ҹ��ڵ� �빮�ڵ� �����ϴ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text, '^[0-9]'); --ù ���ڰ� ���ڷ� �����ϴ� ���̽��� �ֳ�

--WHERE REGEXP_LIKE(text, '[a-zA-Z]$'); --������ ���ڰ� �ҹ��ڵ� �빮�ڵ� �����ϴ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text, '[0-9]$'); --������ ���ڰ� ���ڷ� �����ϴ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text, '[0-9a-z]$'); --������ ���ڰ� ����/�ҹ��� �����ϴ� ���̽��� �ֳ�
--WHERE REGEXP_LIKE(text, '^[^a-z]'); --ù ���ڰ� �ҹ��ڷ� �������� �ʴ� ���̽�
--WHERE REGEXP_LIKE(text, '^[^0-9]'); --ù ���ڰ� ���ڰ� �ƴѰɷ� �����ϴ� ���̽�
--WHERE REGEXP_LIKE(text, '^[^0-9a-z]'); --ù ���ڰ� ���ڳ� �ҹ��ڰ� �ƴѰɷ� �����ϴ� ���̽�
--WHERE REGEXP_LIKE(text, '[^a-z]'); --�ҹ���'��' ������� �ʴ� ���̽�
WHERE NOT REGEXP_LIKE(text, '[a-z]'); --NOT(�ҹ��ڰ� ���Ե� ���̽��� ã�Ƽ�) : �ҹ��ڰ� ���� ���̽�

SELECT tel
FROM student
--WHERE REGEXP_LIKE(tel, '^02\)[0-9]{3}-') --02)�� �����ϴ� ���̽� ')'������ �տ� \�־����
--WHERE REGEXP_LIKE(tel, '^02\)[0-9]{3,4}-') --{3,4} 3�ڸ� �Ǵ� 4�ڸ�
WHERE REGEXP_LIKE(tel, '^01([0|1|6|7|8|9])-?{[0-9]{3,4}}-?{[0-9]{4}}$') 
--�޴��� ��ȣ�� �ĺ��ϴ� ���Խ�
-- -? �� -�����ų� ���ų�
--010-1234-5678
--01012345678
--010 011 016 017 018 019