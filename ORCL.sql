SELECT * 
FROM dept;

-- �ݷ��̸� �˾����� �����ؼ� ����
SELECT DNAME , DEPTNO 
FROM dept;

DESC dept;
--WHERE

--����̸��� �޿� ����
--AS�� ������ ����
--1. '�ϳ� ����Ϸ��� ''�ΰ���� 2.q'[i'm fine]'
SELECT EMPNO "���",ENAME  "�̸�",SAL AS "�޿�", 'i''m fine' "���ʽ��÷�"
        ,q'[i'm fine]' as "���"
FROM emp;
--distinct �ߺ�����

--��ȭ��ȣ 010-123-1234
--��ȣ1||��ȣ2||��ȣ3
--010 123 1234
select distinct deptno from emp;

select GNO, point, 'gno='||gno||'����Ʈ�� '||point "��"
from customer;

select NAME || q'['s ]' "ID",q'[ID : ]'||ID "AND",q'[WEIGHT is ]'||WEIGHT||q'[kg]' "WEIGHT"
from student;

SELECT name||'''s ' || 'ID : '||id || ', WEIGHT is '||weight||'kg' AS "ID AND WEIGHT"
from STUDENT;

SELECT ename||'('||job||') , '||ename||''''||job||'''' as "NAME AND JOB" FROM emp;

SELECT 
ename||'''s ' || 'sal is $'||sal as "Name and Sal"
FROM emp;

SELECT ename, job, sal
FROM emp
WHERE sal>2000;

SELECT *
FROM emp
WHERE hiredate>='1981-11-17';
--WHERE hiredate='81/11/17';
--���� ����ǥ�� �����
--WHERE ename ='KING';

SELECT ename,sal+500 as "sal bonus"
from emp;

SELECT ename, job, sal, hiredate
FROM emp
WHERE hiredate BETWEEN '81/03/01' AND '81/12/01';
--WHERE sal BETWEEN 2000 AND 3000;
--WHERE sal>=2000 and sal<=3000;    and�� �����ϱ�
--and or not

SELECT *
FROM emp
WHERE deptno  NOT IN( 10,20); 
--IN , NOT IN
--DEPTNO �ȿ�(IN) 10,��20�� ������
--WHERE deptno !=10 and deptno<> 20;   10�� �ƴϰ� 20�� �ƴϴ�. <>�� not�� �ǹ�

SELECT *
FROM emp
--IS (NOT) ---
--NULL�� �ֵ鸸 ã�ڴ�
WHERE comm IS  NULL;

SELECT name
FROM student
WHERE name LIKE '%o%';
--�빮�� D�� �����ϴ� ����� ���´�. ----LIKE Ű���� ��� + D%
--o�� ������ ��� %o
--%o% o�� ��������� ã�ڴ�

SELECT *
FROM student
WHERE id LIKE 'C___%';
-- 'C___' = ���̵� C�� �����ϸ鼭 �ڿ�___3�ڸ� �� �ִ»��. '_'�� �ڸ����� ����

SELECT *
FROM student
WHERE id like '%b_in%';
--WHERE id LIKE '%in%';
--WHERE id LIKE '%in'

SELECT *
FROM emp
ORDER BY sal DESC;--���� / desc�� �������� / asc�� ���������ε� �׳� �⺻����

--�������߿� 81�� 01�� 01�� ���ķ� �Ի��� ������ �����
--�μ��� 10���μ��� �ƴ� �μ��� �ٴϴ� �������� ������
--�޿��� ���� ������� �����ּ���(���,�̸�,�Ի�����,�޿�,�μ���ȣ).
SELECT empno "���",ename "�̸�",hiredate "�Ի�����",sal"�޿�",deptno"�μ���ȣ"
FROM emp
WHERE hiredate >= '81/01/01' AND deptno NOT IN(10) 
ORDER BY sal DESC;


SELECT *
FROM student
ORDER BY grade DESC,height desc;

select studno,name,grade ,0
from student 
where grade =4
UNION ALL   --�ΰ� ��ĥ�� �ݷ��� �� �������  ������
select studno,name,grade,height
from student 
where height <=170;

SELECT studno, name, deptno1
FROM student;

select profno,name,deptno
from professor;

SELECT studno, name 
FROM student
where deptno1 =101
--intersect -- ������
minus --������
select studno,name
from student
where deptno2 = 201;

--comm <-��/����/���ʽ�
--ȸ���������߿� ���ʽ� �ݾ��� null�� �ƴ� �������� ����/����(job)������ ����
--���������� ���� ���Ŀ��� �̸� ������������ ����

select *
from emp
where comm is not null
order by job ,ename desc;

--      ù���ڸ� �빮��
select initcap(ename),lower(ename),upper('abc')
from emp;
                --����� ���ڴ� 1byte �ѱ��� 2or3 byte
select job ,length(job), lengthb(job), length('���'),lengthb('���')
from emp;

select concat('a','b') , concat(ename ,job)
from emp;

select concat('a','b')
--dual�� �ӽ÷� ���� ���̺�
from dual;

select substr('abc1234',4,4)
from dual;
select substr('abc1234',-5,2)
from dual;

select 
substr(jumin,1,6)||'-'||substr(jumin,7) as "�ֹι�ȣ"
from student;

--student�߿��� 75����� 76����� ��� ������ ���
select *
from student
where jumin like '75%' or jumin like '76%';

select *
from student
--where substr(jumin, 1,2) =75 or substr(jumin, 1,2)=76
where substr(jumin, 1,2) in(75,76); 

select *
from student
where jumin like '75%' 
union all
select *
from student
where jumin like '76%';