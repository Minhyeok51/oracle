--[2022. 10. 26. SQL �������]

--1. student ���̺�
--�̸�(Firstname)�� �빮�ڷ� �����ϸ鼭 �� 5���� �� �̸��� ����ϼ���.
SELECT *
FROM student
WHERE REGEXP_LIKE(name, '^[A-Z][a-z]{4} '); 

--2. panmae ���̺�
--�� �Ǹ����� �� �� �Ǹ��� ������ �� �Ǹ��� �ݾ��� ����ϼ���.
SELECT p_date"�Ǹ�����",SUM(p_qty)"�� �Ǹż���",SUM(p_total)"�� �Ǹűݾ�"
--,p_code GROUP BY�� ������ ���� �÷��̶� ->ORA-00979: GROUP BY ǥ������ �ƴմϴ�.<-���� �߻�
--SELECT *
FROM panmae
GROUP BY p_date
ORDER BY p_date;

--3. panmae ���̺�
--�Ǹ����� �������� �� ��ǰ�ڵ�� �� �Ǹż����� �� �Ǹűݾ��� �����ּ���.
--�Ǹ����� �������� ��� ��ǰ�� �Ǹż����� �Ǹűݾ��� �Ұ踦 ����ϰ�,
--�������� ��ü �Ǹż����� �Ǹűݾ��� �հ赵 �����ּ���.
SELECT p_date"�Ǹ�����",p_code"��ǰ�ڵ�",SUM(p_qty)"�Ǹż���",SUM(p_total)"�Ǹűݾ�"
FROM panmae
GROUP BY rollup(p_date ,p_code)
ORDER BY p_date;

---------------------------------------------------------------------------------
SELECT s.name �л��̸�,p.name "��� �����̸�",deptno
FROM student s JOIN professor p
ON s.profno = p.profno
order by deptno;

--Inner join �����Ͱ� �ִ� ����(null�� �ƴ�)���� ���̴°�
SELECT s.name �л��̸�,p.name "��� �����̸�",deptno
FROM student s , professor p
where s.profno = p.profno
and s.profno IS NOT NULL;

SELECT *
FROM professor p,student s 
--where���Ǿ��� ��� ������ �����ع����� ������
WHERE p.profno = s.profno;

SELECT s.name �л��̸�,p.name "��� �����̸�"
FROM professor p JOIN student s 
ON p.profno = s.profno;

--Outer Join
SELECT s.name �л��̸�,p.name "��� �����̸�"
FROM student s, professor p
WHERE s.profno = p.profno(+);

SELECT s.name �л��̸�,NVL(p.name,'������') "��� �����̸�"
FROM student s LEFT OUTER JOIN professor p --student�� �������� ��� professor�� ��������(left) �����ϰڴ�
ON s.profno = p.profno;

--CROSS JOIN
SELECT *
FROM professor p,student s ;
--where���Ǿ��� ����ϸ� ��� �ึ�� ������ �����ع���
--CROSS JOIN�� ��� ����
SELECT *
FROM professor p  cross join student;
-------------------------------------------------------------------------

SELECT *
FROM department;
SELECT *
FROM student;

--���� ��ų ���̺� ����
--���̺� �÷�Ȯ���ϰ�
--���� ���� �÷� ���ϰ�
--Inner/Outer �� ���� ���ϰ�

--1.�л��̸�, �����а��ڵ�(deptno1),�а���
SELECT s.name,s.deptno1,d.dname
FROM student s join department d
on s.deptno1 = d.deptno;

--2.�л��̸�,�������ڵ�(deptno2),�а���(�ִ°͸�)
SELECT s.name,s.deptno2,d.dname
FROM student s inner join department d
on s.deptno2 = d.deptno;

--3.�л��̸�,�������ڵ�(deptno2),�а��� (�������� ���, �л������ʹ� �����ֱ�)
SELECT s.name,s.deptno2,d.dname
FROM student s left outer join department d
on s.deptno2 = d.deptno;

SELECT s.name,s.deptno2,d.dname
FROM student s ,department d
where s.deptno2 = d.deptno(+); --(+)�� outer join 

--4.�����̸�,�Ҽ��а��ڵ�, �а���(�ִ°͸�)
SELECT p.name,p.deptno,d.dname
FROM professor p inner join department d
on p.deptno = d.deptno;

SELECT p.name,p.deptno,d.dname
FROM professor p ,department d
where p.deptno = d.deptno;

--5.�����̸�,�Ҽ��а��ڵ�, ����а����� ��������(�а���� �����ֱ�)
SELECT p.name,p.deptno,d.dname
FROM professor p left outer join department d
on p.deptno = d.deptno;

--6.�л���,�����а��ڵ�,�����а���, ��米����ȣ, ��米����(�ִ°͸�)
SELECT s.name"�л���",s.deptno1"�����а��ڵ�",d.dname �����а���,s.profno ��米����ȣ,p.name ��米����
FROM student s ,department d,professor p
where s.deptno1 = d.deptno
AND s.profno = p.profno;

SELECT s.name"�л���",s.deptno1"�����а��ڵ�",d.dname �����а���,s.profno ��米����ȣ,p.name ��米����
FROM student s 
    JOIN department d
    ON s.deptno1 = d.deptno
    JOIN professor p
    ON s.profno = p.profno;

--7.�л���,�����а��ڵ�,�����а���, ��米����ȣ, ��米����(���� �л��� �����ֱ�)
SELECT s.name"�л���",s.deptno1"�����а��ڵ�",d.dname �����а���,s.profno ��米����ȣ,p.name ��米����
FROM student s ,department d,professor p
where s.deptno1 = d.deptno
AND s.profno = p.profno(+);

SELECT s.name"�л���",s.deptno1"�����а��ڵ�",d.dname �����а���,s.profno ��米����ȣ,p.name ��米����
FROM student s 
    JOIN department d
    ON s.deptno1 = d.deptno
    LEFT OUTER JOIN professor p
    ON s.profno = p.profno;

--------------------------------------------------------------------------------
--JOIN = ����� NOT = ������

SELECT *
FROM customer
order by point;

SELECT *
FROM gift;

SELECT c.gname"����", c.point"����Ʈ"
,g.gname"��ǰ��" ,g.g_start"����Ʈstart",g.g_end"����Ʈend"
FROM customer c,gift g
where c.point between g.g_start and g.g_end;
--------------------------------------------------------------------------------

select * from student;
select * from score;
select * from hakjum;
--�л� ��ȣ,�л��̸�,����,����
select s.studno"�й�",s.name"�̸�",sc.total"����",h.grade"����"
from student s , score sc , hakjum h
where s.studno = sc.studno
and sc.total between h.min_point and h.max_point;

select s.studno"�й�",s.grade"�г�",s.name"�̸�",sc.total"����",h.grade"����"
from student s
    join score sc 
    on s.studno = sc.studno
    join  hakjum h
    on sc.total between h.min_point and h.max_point
    order by h.grade;
--------------------------------------------------------------------------------

select * from emp2;
select * from p_grade order by s_pay desc;

--NVL(�÷�,NULL�� ��� �⺻ ��)�Լ�
--NVL2(�÷�,NULL�� �ƴѰ�� ó���� ����,NULL �ΰ�� ó���� ����)�Լ�
--���, �̸�, ��ȭ��ȣ, �޿�(270,000,000), ����(position)(�⺻ emp2������,������ p_grade������), �ּұ޿�(000,000),�ִ�޿�(000,000)

select e.empno"���",e.name"�̸�",e.tel"����",TO_CHAR(e.pay,'999,999,999')"�޿�",NVL(e.position,p.position)"����",
TO_CHAR(p.s_pay,'999,999,999')"�ּұ޿�",TO_CHAR(p.e_pay,'999,999,999')"�ִ�޿�",RANK() OVER(ORDER BY e.pay DESC)"�޿�����"
from emp2 e, p_grade p
where e.pay between p.s_pay and p.e_pay --�� �κ��� ���� ���ν�Ű��
order by pay desc;

select e.empno"���",e.name"�̸�",e.tel"����",TO_CHAR(e.pay,'999,999,999')"�޿�",NVL(e.position,p.position)"����",
TO_CHAR(p.s_pay,'999,999,999')"�ּұ޿�",TO_CHAR(p.e_pay,'999,999,999')"�ִ�޿�",RANK() OVER(ORDER BY e.pay DESC)"�޿�����"
from emp2 e join p_grade p
on e.pay between p.s_pay and p.e_pay
order by pay desc;

--------------------------------------------------------------------------------
--emp2, p_grade
--�̸�, �¾�⵵,���س⵵(2010), �ѱ��� ����, ��������(�������ִ� ����),�������Ͼ��ٸ�...����
select * from emp2;
select * from p_grade;

select e.name,to_char(e.birthday,'YYYY') ����,'2010' ���س⵵, '2011'-to_char(e.birthday,'YYYY') �ѱ��ĳ���
,NVL(e.position,'���޾���') ��������,p.position"���� ���̿� �´� ����",e.pay"�޿�",p2.position"�޿��� �´� ����"
--"�޿� ���ؿ� �´� ���� ��������" self join �ؾ��Ѵ�
from emp2 e, p_grade p,p_grade p2
where '2011'-to_char(e.birthday,'YYYY') between p.s_age and p.e_age
and e.pay between p2.s_pay and p2.e_pay
order by e.birthday;

--------------------------------------------------------------------------------
select * from emp;
--���, �̸�, ����� ���, ����� �̸�
--SELF JOIN <--�ڱⰡ �ڽ��� �����Ѵ�.
select e1.empno ���,e1.ename �̸�,e1.mgr "����� ���",e2.ename"����� �̸�"
from emp e1, emp e2
where e1.mgr=e2.empno ;

select e.empno ���,e.ename �̸�,e2.mgr "����� ���",e2.ename"����� �̸�"
from emp e  join emp e2
on e2.mgr=e.empno ;