/*[2022. 11. 01. SQL 모닝퀴즈 ]

테이블 : professor, department
출력 : 교수번호, 교수이름, 학과이름, 입사일자
학과별 입사일이 가장 오래된 교수들의 정보를 출력.*/

--date 클수록 최근(미래)
select profno,name,(select dname from department d where p.deptno = d.deptno),p.hiredate
from professor p
where (deptno,hiredate)in(select deptno ,min(hiredate)
from professor
group by deptno);
                    ------------------------------------
--나이/년생 (주민번호 앞에 2자리)그룹화
--포인트가 많은사람, 포인트가 적은사람

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
        --여기서는 sal2접근 안됨. 없는 상태와 같음.
        --접근가능한건 emp 안에 있는 sal컬럼
    FROM emp
);

SELECT MAX(RANK),MIN(RANK)
FROM(
SELECT GNO,GNAME,JUMIN,POINT,SUBSTR(JUMIN,1,2)
        ,DENSE_RANK() OVER(PARTITION BY SUBSTR(JUMIN,1,2) ORDER BY POINT DESC)"RANK"
FROM CUSTOMER
);

   
-------1번. From Table 자체를 대체
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

--2번. 기존 테이블 정보에 Rank가 있는 테이블을 Join
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



--3번. 조회 기준을 주민번호별 최대, 최소 랭크를 뽑아서 처리하기
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

--4번. RANK 기준이긴 한데...
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
                            
--사람수 5명 RANK 1 2 3 4 5 <-- COUNT(*) 
--RANK 1 2 3 3 3 <-- 5등~

-------------------------------계층형 쿼리
SELECT * FROM emp;

SELECT e1.empno, e1.ename,e1.mgr,e2.empno,e2.ename
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno;
--타고타고 내려감 level 계층을 나타냄 몇레벨까지 내려왔는지 확인할 수 있음
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
--WHERE level =3 바로위 상사를 찾겠다
CONNECT BY PRIOR mgr = empno
START WITH empno = 7369;

----------SYS_CONNECT_BY_PATH()
----------CONNECT_BY_ISLEAF 
----------CONNECT_BY_ROOT 컬럼명
SELECT empno,LPAD(ename,10*LEVEL,'-'),mgr
    ,level,SYS_CONNECT_BY_PATH(ename, '-') path,CONNECT_BY_ISLEAF LEAF
    ,CONNECT_BY_ROOT empno root -- 이 계층 쿼리의 시작 ROOT가 누구냐
FROM emp
--WHERE CONNECT_BY_ISLEAF =1 --계층을 타고가서 제일 마지막에 있는 LEAF(잎사귀) 데이터를 보여달라
WHERE CONNECT_BY_ISLEAF =0 --계층을 타고가서 제일 마지막에 있는 LEAF(잎사귀)가 아닌 데이터를 보여달라
and level <=2
CONNECT BY NOCYCLE PRIOR empno = mgr --NOCYCLE 싸이클 계속 도는거 방지.
START WITH empno = 7839;

--각 부서별 데이터 처리

--TABLE 부서계층 --TABLE 사원정보 - 소속부서 운영1팀
                --TABLE 사원정보 - 소속부서 운영개발1부
                    --TABLE 사원정보 - 소속부서 지원1팀
                    
--IT본부
    --운영개발 1부
    --      개발1팀
    --      개발2팀
    --      운영1팀
    --        지원1팀
    --        지원2팀
    --      운영2팀
    --
    --정보보안부
    --인프라부
    
SELECT * FROM emp2;
--1.BOSS를 시작으로 부하직원의 계층 상태로 데이터를 출력
--empno,name,deptno,position, 추가로 계층 상태가 눈에 보이도록..LPAD활용한 컬럼, PATH보이는 컬럼
SELECT empno,LPAD(name,15*level,'-'),deptno,SYS_CONNECT_BY_PATH(position, ' - ')position,level
FROM emp2
CONNECT BY PRIOR empno = pempno
START WITH empno = 19900101
--ORDER BY empno; --전체 데이터기준 이름으로 정렬
ORDER SIBLINGS BY empno;    --형제관계가 있는 애들 맞춰 정렬하겠다

--2-1) 이름이 Kevin Bacon 인 사람을 기준으로 그 아래에 속한 부하직원들의 정보를 계층형으로 보여주셈
SELECT empno,LPAD(name,15*level,'-'),deptno,SYS_CONNECT_BY_PATH(position, '-')position,pempno,level
FROM emp2
CONNECT BY PRIOR empno = pempno
--START WITH empno = 19966102;
START WITH empno = (SELECT empno FROM emp2 WHERE name = 'Kevin Bacon');
--START WITH name = 'Kevin Bacon';

--2-2) 위 2-1 정보에서 Kevin Bacon본인을 제외한 부하직원들만 보여줘
SELECT empno,LPAD(name,15*level,'-'),deptno,SYS_CONNECT_BY_PATH(position, '-')position,pempno,level
FROM emp2
--WHERE level > 1
WHERE name <> 'Kevin Bacon'
CONNECT BY PRIOR empno = pempno
START WITH name = 'Kevin Bacon';

--2-3) 위 2-1 정보에서 가장 막내직원만 보여줘
SELECT empno,LPAD(name,15*level,'-'),deptno,SYS_CONNECT_BY_PATH(position, '-')position,pempno,level
FROM emp2
WHERE CONNECT_BY_ISLEAF =1
CONNECT BY PRIOR empno = pempno
START WITH name = 'Kevin Bacon';

--3.이름이 'Sly Stallone' 직원의 상사들을 계층으로 보여줘
SELECT empno,LPAD(name,15*level,'-'),deptno,SYS_CONNECT_BY_PATH(position, '-')position,pempno,level
FROM emp2
CONNECT BY PRIOR  pempno=empno
START WITH name = 'Sly Stallone';

--4.Tom Cruise의 바로 위 상사이름은?
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
--일일이 쿼리를 만들어서 사용 중...
--View 보여줄 데이터를 결정(필터링)

--PL/SQL
--특정 기능을 목적으로 집약되어있는 쿼리의 집합 ->함수(Function) -리턴필수 ,프로시저(Procedure) -리턴없어도됨
--쿼리를 작성해서 수행
--sqldeveloper tool에서 쿼리 작성->Oracle DB실행

--Java 실행할 쿼리를 작성 -> Oracle DB 실행
--   ->수정하려면 자바에서

--Java 실행할 프로시저를 호출 -> (프로시저 수행쿼리)Oracle DB 에서 실행
--                              ->디비안에서 수정

--PL/SQL 블록 구조
/*
DECLARE (선언부)
    IS (내부에서 사용할 변수 선언)
BEGIN (실행부)
EXCEPTION (예외처리 부)
END (끝)
*/

-------------------프로시저 생성
SELECT tname FROM tab;
SELECT * FROM HE_STUDENT8;

ALTER TABLE HE_STUDENT8
ADD POINT NUMBER(3) DEFAULT 0;
/
--plus10_point 프로시저 생성
CREATE OR REPLACE PROCEDURE plus10_point --선언부
    IS                                   --선언부
    BEGIN   --실행부
        UPDATE HE_STUDENT8
        SET POINT = POINT +10;
        COMMIT;
            --예외처리부
    END plus10_point;
    /
--프로시저 호출
EXECUTE plus10_point();
/
CREATE OR REPLACE PROCEDURE plus10_point_by_stdno --선언부
    (v_stdno IN NUMBER)--파라미터
    IS                                   --선언부
    BEGIN   --실행부
        UPDATE HE_STUDENT8
        SET POINT = POINT +10
        WHERE stdno = v_stdno;
        COMMIT;
            --예외처리부
    END plus10_point_by_stdno;
    /   --써주면 오류없이 잘 됨
EXECUTE plus10_point_by_stdno(2);

/

CREATE OR REPLACE PROCEDURE plus10_point_by_name--선언부
--    (v_name IN VARCHAR2)--파라미터
        (v_name IN HE_STUDENT8.NAME%TYPE
        ,o_result OUT VARCHAR2)
    IS                                   --선언부
    BEGIN   --실행부
        o_result := v_name||' plus10 point';
    
        UPDATE HE_STUDENT8
        SET POINT = POINT +10
        WHERE name = v_name;
        COMMIT;
            --예외처리부
    END plus10_point_by_name;
    /
    
SET SERVEROUTPUT ON;    -- DBMS_OUTPUT 실행해서 출력되도록 세팅

DECLARE 
    out_result varchar2(64);
BEGIN
     plus10_point_by_name('강시은',out_result);
     DBMS_OUTPUT.PUT_LINE(out_result);  --println같은거
END;

/
SELECT * FROM HE_STUDENT8;