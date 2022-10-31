/*[2022. 10. 31. 모닝퀴즈]

1. 다음 두 명령어는 어떤 기능을 수행하는 명령어인지 작성하고,
두 기능의 차이점이 있다면 설명하시오.
DELETE FROM 테이블명;
TRUNCATE TABLE 테이블명;*/

--delete
TRUNCATE TABLE 테이블명; -- 데이터를 전부지운다 -- 그냥 바로 통으로 지우는거 성능적으로 보면 훨씬 빠르단 차이가 있다.
--데이터가 잘렸다고 나옴. ROLLBACK 불가 --바로 자동 COMMIT이 돼버림.
--DDL

DELETE --전체를 지울 수 있다 / 조건에 따라서도 지울 수 있다. 
       -- 행을 돌면서 찾아서 지우는거
       --아직 COMMIT된건 아닌 상태. ROLLBACK 가능
       --DML
FROM 테이블명;
/*
2. 다음 조건에 따라 테이블을 생성하시오.
테이블명 : T_MEMBER_POINT

*내부 컬럼
ID : 숫자형 6자리
순번 : 숫자형 6자리
멤버ID : 문자형 24바이트, Null 안됨.
점수 : 숫자형 3자리, 점수는 0점부터 100점까지만 입력 가능함.
채점일시 : 날짜형, 단 입력된 값이 없을 경우 입력시간을 기본값으로 설정
※ 기본키(PK) : ID와 순번의 조합
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
3. 다음 조건에 맞는 시퀀스를 생성하시오.
시퀀스명 : T_MEMBER_POINT_PK_SEQ
*상세조건
1부터 시작하며 1씩 증가한다.
값의 범위는 1~999999
순환하지 않도록 한다.*/
CREATE SEQUENCE T_MEMBER_POINT_PK_SEQ
INCREMENT BY 1
START WITH 1
MAXVALUE 999999
MINVALUE 1
NOCYCLE; 
/*
4. 생성한 시퀀스의 값을 불러서 사용하는 방법을 작성하시오.
*/
INSERT INTO T_MEMBER_POINT(id,no,meber_id,score)
VALUES(T_MEMBER_POINT_PK_SEQ.nextval,T_MEMBER_POINT_PK_SEQ.nextval,'hell',30);

select *  from T_MEMBER_POINT;
--------------------------------------------------------------------------------

----------------인덱스(INDEX)
----------------ORACLA index(어느 위치에 있는가?)
--검색을 빠르게 하기위한 별도의 관리를 하느냐

select *
from he_student4;

CREATE TABLE HE_STUDENT8
(
    STDNO NUMBER(4),
    NAME VARCHAR2(24)
);
SELECT * FROM HE_STUDENT8;

--STDNO,NAME 2개 있는 HE_STUDENT8
--조회(SELECT) WHERE 조건
--데이터가 20만개 있다치면 WHERE조건 -> 시간이 많이 소모됨
--WHERE 조건 INDEX가 걸려있는 컴럼 기준으로 조건만들면 -> 시간이 빨라진다->1초, 2초
--전체 데이터의 15% 정도를 내가 조회하는 CASE.
--데이터가 굉장히 적은경우, INDEX 거는것이 오히려 손해일수 있다 (INDEX가 사용하는 공간때문에)

--HE_STUDENT8 테이블 + 데이터
--INDEX -> INDEX 관리를 별도로. -> 데이터 조회가 빨라진다

-- 1~10     WHERE 1~4;
--1 2 3 4 5 ... 10
/*
            기준
        1~5     6~10
    1~3   4,5  6,8   8~10
*/
--INDEX --> PRIMARY KEY -> INDEX ->인덱스 지정시, 정렬기준 .ASC DESC
--INDEX : PK, NOT NULL, UNIQUE인 애들한테 거는게 좋음.
--1000BYTE가 넘는 것을 INDEX로 정하는건 손해다

INSERT INTO HE_STUDENT8
VALUES(1,'강수림');

INSERT INTO HE_STUDENT8
VALUES(2,'강시은');

INSERT INTO HE_STUDENT8
VALUES(5,'김승현');

INSERT INTO HE_STUDENT8
VALUES(4,'김동하');

INSERT INTO HE_STUDENT8
VALUES(3,'권성민');

SELECT * FROM HE_STUDENT8
WHERE STDNO <10; --기본키가 조회조건에 들어가면 기본키 기준 정렬이 된다.
--ORDER BY STDNO;
ALTER TABLE HE_STUDENT8
ADD CONSTRAINT HE_STUDENT8_PK PRIMARY KEY(STDNO);

--ORDER BY가 없으면 정렬은 보장하지 않는다. -->조회를 하려면 ORDER BY 써야한다
--ORDER BY 없으면 기본정렬은? INSERT INTO 한 순서 처럼 보이지만 그렇진 않다
--테이블 데이터 공간 -> 들어간 위치 순서 --> ㅁ ㅁ ㅁ ㅁ 
--WHERE 기본키가 조건에 들어가면 기본키 기준 정렬된다.(PRIMARY KEY, INDEX가 같이 걸려서)
--NULL가능한애들은 INDEX로 설정하는거 피해주는게 좋다

-------------------------별도로 인덱스를 지정하는 방법!
--CREATE INDEX 인덱스이름
--ON 테이블 (컬럼 ASC/DESC);

--DROP INDEX 인덱스이름;

--CREATE UNIQUE INDEX HE_STUDENT8_IDX_NAME;
--INDEX

-----------------------인덱스 만들기
CREATE INDEX HE_STUDENT8_IDX_NAME
ON HE_STUDENT8 (NAME ASC);
-----------------------인덱스 삭제하기
DROP INDEX HE_STUDENT8_IDX_NAME;

SELECT * FROM HE_STUDENT8
WHERE NAME NOT LIKE '김%';

--COM_CODE 회사코드 : 10 --인덱스 때문에 조회가 더 빨라진다
SELECT * FROM HE_STUDENT8
--WHERE COM_CODE =10
AND STDNO<10
AND NAME LIKE '김%'; 

-------------------------------------뷰(View) 보여주고싶은 것만 보여줄 때 사용
--Table 데이터 관리(30개)  -> 보고 싶은것/ 보여주고 싶은것 별도로 View를 사용해 지정

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

--------------------------VIEW 지우기
DROP VIEW V_HE_STD8;
SELECT * FROM V_EMP_DEPT;

--MASTER테이블 - 총괄 / DETAIL테이블 - 부분부분
--정보(공개/비공개) - 접근가능여부

--각 계정은 권한이 있는 범위에서 사용가능.
--A테이블에 컬럼이 30개있다. 15개는 공개가능 15개는 비공개
--공개가능한 15개를 VIEW로 만든다

-----------------------VIEW 쿼리로 조회하기
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_INDEXES;
SELECT * FROM USER_SEQUENCES;
SELECT * FROM USER_CONSTRAINTS;

-----------------------------------SUB QUERY 서브쿼리(중첩된) --SELECT
SELECT * FROM EMP;

SELECT * FROM DEPT;
--WHERE DEPTNO =20;

--서브쿼리
SELECT /*QUERY 스칼라 서브쿼리*/
FROM/*QUERY 인라인 뷰*/
WHERE; /*QUERY 서브 쿼리*/


                    /*QUERY 스칼라 서브쿼리*/
 SELECT EMPNO,ENAME,JOB,DEPTNO,
    (SELECT DNAME 
    FROM DEPT D 
    WHERE D.DEPTNO= E.DEPTNO) AS "부서이름"
FROM EMP E; --JOIN

                    /*QUERY 인라인 뷰*/
SELECT *
FROM EMP E, 
    (SELECT DEPTNO,DNAME
    FROM DEPT 
    WHERE DEPTNO IN (10,20)
    ) D
WHERE E.DEPTNO = D.DEPTNO;

                    /*QUERY 서브 쿼리*/
SELECT * 
FROM EMP e
WHERE e.DEPTNO = (SELECT DEPTNO FROM DEPT WHERE DNAME = 'SALES');

SELECT * FROM DEPT;

--------------------------------------------------------------------------------
SELECT * FROM emp2;
SELECT * FROM dept2;

--1.emp2 에 있는 사번, 이름, 부서코드를 보여주기.
--단, 부서의 지역이 서울에 있는 부서인 경우만 보여주기.
--*제한사항 : JOIN 금지. SUB-QUERY 활용
SELECT e.empno,e.name,e.deptno
FROM emp2 e,(SELECT dcode FROM dept2  WHERE area LIKE 'Seoul%' or area LIKE 'Busan%') d
WHERE e.deptno = d.dcode;
                            ------

SELECT empno,name,deptno
FROM emp2
WHERE deptno IN(SELECT dcode FROM dept2
                WHERE area LIKE 'Seoul%');
                
-----2.
--Table : professor, department --sub-query 활용
--Meg Ryan 교수보다 늦게 입사한 사람들의 이름/입사일/학과명 출력
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
--주전공(deptno1)이 101이거나 201인 학생들의 평균키보다 큰 학생들의 학번/이름/키 출력
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

----4. emp2테이블.
--전체 직원들 중에서 (section head직급 중 최소 연봉을 받는 사람의 연봉)기준으로 보다 높은 사람들의 
--이름/직급/연봉 출력 (연봉은 000,000,형태로 나오도록)
select name,position,to_char(pay,'999,999,999')
from emp2
where pay>(select min(pay)
from emp2
where position ='Section head'
);

----5. student테이블.
--(2학년 학생들 중 체중이 가장 많이 나가는 학생의 몸부게보다 )
--전체 학생들 중 몸무게가 적게 나가는 학생의 이름/몸무게/학년 출력
select name,weight,grade 
from student
where weight <(select max(weight) from student where grade =2);

----------각 학년별, 최대 몸무게인 학생들의 정보만 출력
--최대몸무게 학년 정보에 일치하는 학생 정보만 출력
--(SUB-QUERY 조건 비교 - 다중 컬럼)
SELECT * 
FROM student
WHERE (grade,weight) IN (SELECT grade,max(weight)
FROM student
group by grade);

--학년별 최대몸무게
SELECT grade,max(weight)
FROM student
group by grade; --그룹바이에 들어간 컬럼은 셀렉트문에 쓸수 있다.

--전공별 몸무게 많이 나가는 사람
SELECT * 
FROM student
WHERE (deptno1,weight) IN (SELECT deptno1,max(weight)
FROM student
group by deptno1);

SELECT deptno , (SELECT dname FROM dept d WHERE e.deptno = d.deptno)
FROM emp e;

--사번 기준 조회 ->이름  UNIQUE ->어떤사람 이름이 하나만.
--SUBQUERY SELECT MAX(이름) FROM 사원 WHERE 사번 ='';
--사번 - 이름이 2개 - 직급(사원,대리)