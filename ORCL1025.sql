--[2022. 10. 25. �������]

/*emp2 ���̺��� �������� �Ʒ� ������ ���
����� �߿� 70��� ���̸鼭 ������ȣ�� �������� ����(02), ��⵵(031)�� �����ϴ� ������� ������ �Ʒ��� ���� ����Ͻÿ�.
���, �̸�, �������, ���, �޿�(pay), ������(�޿��� 150%)
, �����з�(��, ������ ���� �����̶� family�� ǥ��)
,��ȭ��ȣ, �޿�����
(��, �޿������� �Ʒ��� ���� �з�)
3500�� 1�� ~ 4500�� : '��'
4500�� 1�� ~ 6õ�� : '��"
6000�� 1�� �̻� : '��'
�� ��... : 'ȭ����'
*/
SELECT empno"���",name"�̸�",birthday"�������",hobby"���",pay"�޿�",pay*1.5"������",REPLACE(emp_type,'employee','familly')"���� �з�",tel
, CASE WHEN pay BETWEEN 35000001 AND 45000000 THEN '��' 
WHEN pay BETWEEN 45000001 AND 60000000 THEN '��'
WHEN pay >60000000 THEN '��'
ELSE 'ȭ����'
END AS "�޿�����"
FROM emp2
WHERE birthday like '7%' and 
SUBSTR(tel,1,INSTR(tel,')',1,1)-1) in (02,031);

/* �ؼ�
SELECT empno"���",name"�̸�",birthday"�������",hobby"���",pay"�޿�",pay*1.5"������",REPLACE(emp_type,'employee','familly')"���� �з�",tel
,CASE WHEN pay BETWEEN 35000001 AND 45000000 THEN '��' 
      WHEN pay BETWEEN 45000001 AND 60000000 THEN '��'
      WHEN pay >=60000001 THEN '��'
      ELSE 'ȭ����'
      END AS "�޿�����"
FROM emp2
WHERE TO_CHAR(birthday,'YY') BETWEEN 70 AND 79
AND SUBSTR(tel,1,INSTR(tel, ')',1,1)-1) IN(02,031);*/


--Groupó�� �Լ���....
SELECT hiredate,TO_CHAR(hiredate,'YY-MM')
FROM emp;

--COUNT() �Լ�: ���� ����
--SUM() �Լ� : �� ��
--AVG() �Լ� : ���
SELECT COUNT(*)
FROM emp;

SELECT COUNT(*) --COUNTüũ ��, NULL�� ����
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT COUNT(*),SUM(sal),SUM(comm),AVG(sal),AVG(NVL(comm,0)) --NULL�ΰ�쵵 �����ϱ� ���� NVL���
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--SUM() �Լ� : �� ��
SELECT SUM(sal)
FROM emp;
--WHERE sal BETWEEN 1000 AND 2000

--MAX() /MIN() �Լ� --�ִ�/�ּ�
SELECT MAX(sal), MIN(sal),MAX(comm),MIN(comm)
,MAX(hiredate),MIN(hiredate)
FROM emp;

SELECT STDDEV(sal)"ǥ������", VARIANCE(sal)"�л�"
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT deptno,job,ROUND(AVG(sal),2) as "�޿��� ���"--group by �� ��� ������ ���� ��� ����. �׷���� ���ؿ� ���� �͸� ���� ���� ����
--SELECT *
FROM emp --emp ��ü ������ ��� �޿� ���
--WHERE deptno in(10,20)
GROUP BY deptno,job --�μ���ȣ �������� ���(�׷�ȭ�ؼ�)
ORDER BY deptno DESC;        --�μ���ȣ �������� �������� ����

--����(�׷�)�Լ� ������ �Ϲ� �÷��� ���� GROUP By�� ���ԵǾ� �־�� SELECT�� ��밡�� 

--student �� �г� ��, ���Ű�� ��� ������
--���� 101 102 201 202
SELECT grade"�г�", AVG(height)���Ű ,AVG(weight)��ո�����
--SELECT *
FROM student
WHERE deptno1 IN(101,102,201,202)
--AND height>=170 --���ʿ� ��� ����� 170�̻��� ����鸸 ������ ���
GROUP BY grade --GROUP BY, HAVING
HAVING AVG(height)>=170 -- GROUP BY �����Լ� �鿡 ���� ������ �ִ� ��� HAVING���
ORDER BY grade  DESC;
--��� Ű�� 170�̻��� �г���� ������ ���ڴ�.

--EMP���̺� �μ��� �ѿ���(SAL*12+COMM)����  2000�̻��� �μ����� �μ��� ��� �޿��� ������
SELECT deptno,TO_CHAR(AVG(sal*12+NVL(comm,0)),'999,999.99')"��� ����"
--SELECT *
FROM emp
GROUP BY deptno
HAVING AVG(sal*12+NVL(comm,0))>=0
ORDER BY deptno;
--HAVING AVG(sal)>2000

--1.�μ��� ������ ��� �޿� �� �����
SELECT deptno,job,AVG(sal),COUNT(*)
FROM emp
GROUP BY deptno,job
ORDER BY deptno, job;
--2. �μ��� ��� �޿��� ��� ��
SELECT deptno,ROUND(AVG(sal),2),COUNT(*)
FROM emp
GROUP BY deptno;
--3. ��ü ����� ��� �޿��� ��� ��
SELECT COUNT(*)"�����",ROUND(AVG(sal),2)
FROM emp;


--ROLLUP() ///���� 1,2,3�� ���� ��� ��ħ

--  UI(Front) <-> Java(Server) <-> Database(Oracle)
--  ��躸���� <->��赥���͸� Ȯ��<-> DB Query�Ұ����¸� ���� ��ȯ
--  ��躸���� <->��赥���͸� Ȯ��(���� �����͸� �Ұ����·� ����)<-> DB Query�׳� ���̽� ���/���� ������ ��ȯ //�̷������ε� �ڹٿ��� ó���ص� �ȴ�

SELECT deptno,job,ROUND(AVG(sal),0),COUNT(*)
FROM emp
--GROUP BY ROLLUP((deptno,job)) --���� �ո� �߰��ϴ� ���
--GROUP BY ROLLUP(deptno,job)
GROUP BY deptno, ROLLUP(job) --job�������� Rollup����
ORDER BY deptno, job;
--ROLLUP()�Ұ� ó�� ����
--GROUP BY deptno,job �� �����͸� ����
--�Ұ�ó���� ROLLUP()
--GROUP BY ROLLUP(deptno,job) ��ȣ �����ʺ��� �ϳ��� ����鼭 �Ұ�
--deptno,job    (�μ���,������)�Ұ�
--deptno        (�μ���)�Ұ�
--              (��ü)�Ұ�

--�������̺�
--(�� �μ�(deptno)�� ���޺�(position)) ��ձ޿��� ������ ��
--1)�μ��� �Ұ�(��ձ޿��� ������ ��)�� �ձ��� ���
SELECT deptno,position,AVG(pay)��ձ޿�,COUNT(*)"���� ��"
--SELECT *
FROM professor
--GROUP BY deptno,ROLLUP(position)

ORDER BY deptno;

--2)�μ���/���޺�/��ü �Ұ� �Բ� ���̵���
SELECT position,deptno,AVG(pay)��ձ޿�,COUNT(*)"���� ��"
--SELECT *
FROM professor
GROUP BY ROLLUP( position,deptno)
--GROUP BY CUBE(position,deptno) --CUBE���ο��ִ� ��ҵ� ���� �Ұ�+���� �� �� ����
--GROUP BY GROUPING SETS(position,deptno) --GROUPING SETS()���ο� �ִ� �� ��ҵ麰 �Ұ踸 ������
ORDER BY position ;


--���� ����� ������
--������ ����� -���� ����� - ��� ����� - ���� �� �����
--LAG() /LEAD() �Լ�(����,����)
--LAG/LEAD(������,���°��/��,null�ΰ�� �⺻��) OVER(���ı���)
SELECT empno,ename,sal
    ,LAG(sal, 2,0) OVER(ORDER BY sal)"����" --������ �� ������
    ,LAG(sal,1,0) OVER(ORDER BY sal) "��"--���� �� ������
    ,LEAD(sal,1,0) OVER(ORDER BY sal)"��"--���� �� �����͸� �����ϰڴ�
    ,LEAD(sal,2,0) OVER(ORDER BY sal)"����"--���Ŀ� ���� �� �����͸� �����ϰڴ�
FROM emp
ORDER BY sal;

--�л��� Ű������ �����ؼ�
--ū ������� (��������) �����ϰ�
--�� ����, ���� Ű�� �����͵� ���� ������
--�й�,�̸�,�г�,Ű(�� �ջ�� Ű,�޻�� Ű)--�� ������ �⺻Ű 100
SELECT studno,name,grade,height
    ,LAG(height,1,100) OVER(ORDER BY height DESC)"�ջ�� Ű"    --�� ������
    ,LEAD(height,1,100) OVER(ORDER BY height DESC)"�޻�� Ű"   --�� ������
    ,RANK() OVER(ORDER BY height DESC) "��ũ" --���ı��ؿ� �´� �� ���� (�ߺ��� ���� ����)
    ,DENSE_RANK() OVER(ORDER BY height DESC)"������ũ"  --���ı��ؿ� �´� �� ���� (�ߺ��� ������ ����)
FROM student
ORDER BY height DESC;

--RANK(), DENSE_RANK
--RANK()/DENSE_RANK() OVER(���ı���)

--emp���̺� 10,20�� �μ��� ���� ��������
--�μ�,�̸�,�޿�,�޿������� ����ϼ���
SELECT deptno,ename,sal
,DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC)||'��'"�޿� ����" --(PARTITION BY)�μ����� �����ؼ� �׾ȿ��� ������ �ű�ڴ�
--,RANK() OVER(PARTITION BY deptno ORDER BY sal DESC)||'��'"�޿� ����" --(PARTITION BY)�μ����� �����ؼ� �׾ȿ��� ������ �ű�ڴ�
FROM emp
--WHERE deptno IN(10,20)
ORDER BY deptno,sal DESC;

--rownum (Default�� ������ִ� ���ȣ)/ ROW_NUMBER() (�ǵ��ؼ� ����� �ִ� �� ��ȣ)
SELECT rownum,empno,ename
,ROW_NUMBER() OVER (ORDER BY empno) "ROW NUMBER"
,ROW_NUMBER() OVER (ORDER BY empno DESC) "ROW NUMBER DESC"
FROM emp
--WHERE rownum<=5
ORDER BY empno DESC;

--JOIN
SELECT *
FROM emp;

SELECT *
FROM dept;

--      (       emp     )
--      ��� /�̸� /�μ���ȣ /�μ��̸�
--                (       dept    )

SELECT e.empno,e.ename,e.deptno,d.dname -- e. ����� ������ ���� �����ִ°� ����
FROM emp e,dept d   --JOIN ���̺� emp,dept
WHERE e.deptno =d.deptno;   --JOIN ���� deptno�� ���� ���
--JOIN ON
SELECT e.empno,e.ename,d.dname
--JOIN �� ���� WHERE��ſ� ON
--FROM emp e JOIN dept d
FROM emp e INNER JOIN dept d --INNER / OUTER JOIN �� �ִ�
ON e.deptno =d.deptno;

SELECT s.name �л��̸�,p.name "��� �����̸�",deptno
FROM student s JOIN professor p
ON s.profno = p.profno
order by deptno;

SELECT * FROM professor;
SELECT * FROM student;