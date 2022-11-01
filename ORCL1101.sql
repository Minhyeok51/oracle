/*[2022. 11. 01. SQL ������� ]

���̺� : professor, department
��� : ������ȣ, �����̸�, �а��̸�, �Ի�����
�а��� �Ի����� ���� ������ �������� ������ ���.*/

--date Ŭ���� �ֱ�(�̷�)
select profno,name,(select dname from department d where p.deptno = d.deptno),p.hiredate
from professor p
where (deptno,hiredate)in(select deptno ,min(hiredate)
from professor
group by deptno);
                    ------------------------------------
--����/��� (�ֹι�ȣ �տ� 2�ڸ�)�׷�ȭ
--����Ʈ�� �������, ����Ʈ�� �������

SELECT gno, gname, jumin, point
FROM customer
WHERE (SUBSTR(jumin, 1,2), point)IN
    (SELECT SUBSTR(jumin, 1, 2), MAX(point)
    FROM customer
    GROUP BY SUBSTR(jumin, 1, 2))
UNION ALL
SELECT gno, gname, jumin, point
FROM customer
WHERE (SUBSTR(jumin, 1,2), point)IN
                    (SELECT SUBSTR(jumin, 1, 2), MIN(point)
                    FROM customer
                    GROUP BY SUBSTR(jumin, 1, 2)
                    )
ORDER BY jumin, point desc;
--ORDER BY SUBSTR(jumin, 1 ,2), point desc;

SELECT gno, gname, jumin, point
FROM customer
WHERE (SUBSTR(jumin, 1,2), point) IN
    (
        SELECT SUBSTR(jumin, 1, 2), MAX(point)
        FROM customer
        GROUP BY SUBSTR(jumin, 1, 2)
        UNION ALL
        SELECT SUBSTR(jumin, 1, 2), MIN(point)
        FROM customer
        GROUP BY SUBSTR(jumin, 1, 2)
    );
            --------------------------------------------------
SELECT sal, sal2,sal4,sal2 * 2
FROM(
    SELECT sal, sal*2 sal2, sal*4 sal4
        --���⼭�� sal2���� �ȵ�. ���� ���¿� ����.
        --���ٰ����Ѱ� emp �ȿ� �ִ� sal�÷�
    FROM emp
);

SELECT MAX(RANK),MIN(RANK)
FROM(
SELECT GNO,GNAME,JUMIN,POINT,SUBSTR(JUMIN,1,2)
        ,DENSE_RANK() OVER(PARTITION BY SUBSTR(JUMIN,1,2) ORDER BY POINT DESC)"RANK"
FROM CUSTOMER
);

   
-------1��. From Table ��ü�� ��ü
SELECT gno, gname, jumin, point, substr(jumin, 1,2) subjumin, RANK
FROM 
(
    SELECT gno, gname, jumin, point
    --    ,RANK() OVER(ORDER BY point desc) RANK
        ,RANK() OVER(PARTITION BY SUBSTR(jumin, 1, 2) ORDER BY point desc) RANK
    FROM customer
)
WHERE (SUBSTR(jumin, 1,2), point) IN
    (
        SELECT SUBSTR(jumin, 1, 2), MAX(point)
        FROM customer
        GROUP BY SUBSTR(jumin, 1, 2)
        UNION ALL
        SELECT SUBSTR(jumin, 1, 2), MIN(point)
        FROM customer
        GROUP BY SUBSTR(jumin, 1, 2)
    )
ORDER BY jumin, point;

--2��. ���� ���̺� ������ Rank�� �ִ� ���̺��� Join
SELECT c.gno, c.gname, c.jumin, c.point, SUBSTR(c.jumin, 1, 2) subjumin
    ,rc.rank
FROM customer c,
    (SELECT gno, gname, jumin, point
    ,RANK() OVER(PARTITION BY SUBSTR(jumin, 1, 2) ORDER BY point desc) RANK
    FROM customer) rc
WHERE (SUBSTR(c.jumin, 1,2), c.point) IN
    (
        SELECT SUBSTR(jumin, 1, 2), MAX(point)
        FROM customer
        GROUP BY SUBSTR(jumin, 1, 2)
        UNION ALL
        SELECT SUBSTR(jumin, 1, 2), MIN(point)
        FROM customer
        GROUP BY SUBSTR(jumin, 1, 2)
    )
    AND c.GNO = rc.GNO
ORDER BY jumin, point;



--3��. ��ȸ ������ �ֹι�ȣ�� �ִ�, �ּ� ��ũ�� �̾Ƽ� ó���ϱ�
SELECT c.gno, c.gname, c.jumin, c.point, c.subjumin, c.rank
FROM (
    SELECT gno, gname, jumin, point
        ,substr(jumin, 1,2) subjumin
        ,RANK() OVER(PARTITION BY SUBSTR(jumin, 1, 2) ORDER BY point desc) RANK
    FROM customer
) c
WHERE (c.subjumin, c.rank) IN 
(
    select SUBSTR(jumin, 1, 2), MAX(RANK)
    FROM 
    (
    SELECT gno, gname, jumin, point
        ,RANK() OVER(PARTITION BY SUBSTR(jumin, 1, 2) ORDER BY point desc) RANK
    FROM customer
    ) GROUP BY SUBSTR(jumin, 1, 2)
    UNION ALL
    select SUBSTR(jumin, 1, 2), MIN(RANK)
    FROM 
    (
    SELECT gno, gname, jumin, point
        ,RANK() OVER(PARTITION BY SUBSTR(jumin, 1, 2) ORDER BY point desc) RANK
    FROM customer
    ) GROUP BY SUBSTR(jumin, 1, 2)
);

--4��. RANK �����̱� �ѵ�...
SELECT *
FROM (
SELECT gno, gname, jumin, point
    ,substr(jumin, 1,2) subjumin
    ,RANK() OVER(PARTITION BY SUBSTR(jumin, 1, 2) ORDER BY point desc) RANK
FROM customer ) c
WHERE c.RANK = 1 
or (c.subjumin, rank) IN (SELECT substr(jumin, 1,2), count(*)
                            FROM customer
                            GROUP BY substr(jumin, 1,2)
                            );
                            
--����� 5�� RANK 1 2 3 4 5 <-- COUNT(*) 
--RANK 1 2 3 3 3 <-- 5��~

-------------------------------������ ����
SELECT * FROM emp;

SELECT e1.empno, e1.ename,e1.mgr,e2.empno,e2.ename
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno;
--Ÿ��Ÿ�� ������ level ������ ��Ÿ�� ������� �����Դ��� Ȯ���� �� ����
SELECT empno,LPAD(ename,10*LEVEL,'-'),mgr,level
FROM emp
CONNECT BY PRIOR empno = mgr
START WITH empno = 7839;

SELECT empno,LPAD(ename,10*LEVEL,'-'),mgr,level
FROM emp
CONNECT BY PRIOR empno = mgr
START WITH empno = 7566;

SELECT empno,LPAD(ename,10*LEVEL,'-'),mgr,level
FROM emp
--WHERE level =3 �ٷ��� ��縦 ã�ڴ�
CONNECT BY PRIOR mgr = empno
START WITH empno = 7369;

----------SYS_CONNECT_BY_PATH()
----------CONNECT_BY_ISLEAF 
----------CONNECT_BY_ROOT �÷���
SELECT empno,LPAD(ename,10*LEVEL,'-'),mgr
    ,level,SYS_CONNECT_BY_PATH(ename, '-') path,CONNECT_BY_ISLEAF LEAF
    ,CONNECT_BY_ROOT empno root -- �� ���� ������ ���� ROOT�� ������
FROM emp
--WHERE CONNECT_BY_ISLEAF =1 --������ Ÿ���� ���� �������� �ִ� LEAF(�ٻ��) �����͸� �����޶�
WHERE CONNECT_BY_ISLEAF =0 --������ Ÿ���� ���� �������� �ִ� LEAF(�ٻ��)�� �ƴ� �����͸� �����޶�
and level <=2
CONNECT BY NOCYCLE PRIOR empno = mgr --NOCYCLE ����Ŭ ��� ���°� ����.
START WITH empno = 7839;

--�� �μ��� ������ ó��

--TABLE �μ����� --TABLE ������� - �ҼӺμ� �1��
                --TABLE ������� - �ҼӺμ� �����1��
                    --TABLE ������� - �ҼӺμ� ����1��
                    
--IT����
    --����� 1��
    --      ����1��
    --      ����2��
    --      �1��
    --        ����1��
    --        ����2��
    --      �2��
    --
    --�������Ⱥ�
    --�������
    
SELECT * FROM emp2;
--1.BOSS�� �������� ���������� ���� ���·� �����͸� ���
--empno,name,deptno,position, �߰��� ���� ���°� ���� ���̵���..LPADȰ���� �÷�, PATH���̴� �÷�
SELECT empno,LPAD(name,15*level,'-'),deptno,SYS_CONNECT_BY_PATH(position, ' - ')position,level
FROM emp2
CONNECT BY PRIOR empno = pempno
START WITH empno = 19900101
--ORDER BY empno; --��ü �����ͱ��� �̸����� ����
ORDER SIBLINGS BY empno;    --�������谡 �ִ� �ֵ� ���� �����ϰڴ�

--2-1) �̸��� Kevin Bacon �� ����� �������� �� �Ʒ��� ���� ������������ ������ ���������� �����ּ�
SELECT empno,LPAD(name,15*level,'-'),deptno,SYS_CONNECT_BY_PATH(position, '-')position,pempno,level
FROM emp2
CONNECT BY PRIOR empno = pempno
--START WITH empno = 19966102;
START WITH empno = (SELECT empno FROM emp2 WHERE name = 'Kevin Bacon');
--START WITH name = 'Kevin Bacon';

--2-2) �� 2-1 �������� Kevin Bacon������ ������ ���������鸸 ������
SELECT empno,LPAD(name,15*level,'-'),deptno,SYS_CONNECT_BY_PATH(position, '-')position,pempno,level
FROM emp2
--WHERE level > 1
WHERE name <> 'Kevin Bacon'
CONNECT BY PRIOR empno = pempno
START WITH name = 'Kevin Bacon';

--2-3) �� 2-1 �������� ���� ���������� ������
SELECT empno,LPAD(name,15*level,'-'),deptno,SYS_CONNECT_BY_PATH(position, '-')position,pempno,level
FROM emp2
WHERE CONNECT_BY_ISLEAF =1
CONNECT BY PRIOR empno = pempno
START WITH name = 'Kevin Bacon';

--3.�̸��� 'Sly Stallone' ������ ������ �������� ������
SELECT empno,LPAD(name,15*level,'-'),deptno,SYS_CONNECT_BY_PATH(position, '-')position,pempno,level
FROM emp2
CONNECT BY PRIOR  pempno=empno
START WITH name = 'Sly Stallone';

--4.Tom Cruise�� �ٷ� �� ����̸���?
SELECT empno,LPAD(name,10*level,'-'),deptno,SYS_CONNECT_BY_PATH(position, '-')position,pempno,level
FROM emp2
where level =2
CONNECT BY PRIOR  pempno=empno
START WITH name = 'Tom Cruise';

SELECT name
FROM emp2
WHERE empno = (
SELECT pempno FROM emp2
WHERE name = 'Tom Cruise');


---------------------------------- PL/SQL --------------------------------------
--Procedural Language / SQL

--SQL
--������ ������ ���� ��� ��...
--View ������ �����͸� ����(���͸�)

--PL/SQL
--Ư�� ����� �������� ����Ǿ��ִ� ������ ���� ->�Լ�(Function) -�����ʼ� ,���ν���(Procedure) -���Ͼ����
--������ �ۼ��ؼ� ����
--sqldeveloper tool���� ���� �ۼ�->Oracle DB����

--Java ������ ������ �ۼ� -> Oracle DB ����
--   ->�����Ϸ��� �ڹٿ���

--Java ������ ���ν����� ȣ�� -> (���ν��� ��������)Oracle DB ���� ����
--                              ->���ȿ��� ����

--PL/SQL ��� ����
/*
DECLARE (�����)
    IS (���ο��� ����� ���� ����)
BEGIN (�����)
EXCEPTION (����ó�� ��)
END (��)
*/

-------------------���ν��� ����
SELECT tname FROM tab;
SELECT * FROM HE_STUDENT8;

ALTER TABLE HE_STUDENT8
ADD POINT NUMBER(3) DEFAULT 0;
/
--plus10_point ���ν��� ����
CREATE OR REPLACE PROCEDURE plus10_point --�����
    IS                                   --�����
    BEGIN   --�����
        UPDATE HE_STUDENT8
        SET POINT = POINT +10;
        COMMIT;
            --����ó����
    END plus10_point;
    /
--���ν��� ȣ��
EXECUTE plus10_point();
/
CREATE OR REPLACE PROCEDURE plus10_point_by_stdno --�����
    (v_stdno IN NUMBER)--�Ķ����
    IS                                   --�����
    BEGIN   --�����
        UPDATE HE_STUDENT8
        SET POINT = POINT +10
        WHERE stdno = v_stdno;
        COMMIT;
            --����ó����
    END plus10_point_by_stdno;
    /   --���ָ� �������� �� ��
EXECUTE plus10_point_by_stdno(2);

/

CREATE OR REPLACE PROCEDURE plus10_point_by_name--�����
--    (v_name IN VARCHAR2)--�Ķ����
        (v_name IN HE_STUDENT8.NAME%TYPE
        ,o_result OUT VARCHAR2)
    IS                                   --�����
    BEGIN   --�����
        o_result := v_name||' plus10 point';
    
        UPDATE HE_STUDENT8
        SET POINT = POINT +10
        WHERE name = v_name;
        COMMIT;
            --����ó����
    END plus10_point_by_name;
    /
    
SET SERVEROUTPUT ON;    -- DBMS_OUTPUT �����ؼ� ��µǵ��� ����

DECLARE 
    out_result varchar2(64);
BEGIN
     plus10_point_by_name('������',out_result);
     DBMS_OUTPUT.PUT_LINE(out_result);  --println������
END;

/
SELECT * FROM HE_STUDENT8;