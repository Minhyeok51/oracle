--[2022. 10. 26. SQL 모닝퀴즈]

--1. student 테이블
--이름(Firstname)이 대문자로 시작하면서 총 5글자 인 이름을 출력하세요.
SELECT *
FROM student
WHERE REGEXP_LIKE(name, '^[A-Z][a-z]{4} '); 

--2. panmae 테이블
--각 판매일자 별 총 판매한 수량과 총 판매한 금액을 출력하세요.
SELECT p_date"판매일자",SUM(p_qty)"총 판매수량",SUM(p_total)"총 판매금액"
--,p_code GROUP BY에 사용되지 않은 컬럼이라 ->ORA-00979: GROUP BY 표현식이 아닙니다.<-에러 발생
--SELECT *
FROM panmae
GROUP BY p_date
ORDER BY p_date;

--3. panmae 테이블
--판매일자 기준으로 각 상품코드당 총 판매수량과 총 판매금액을 보여주세요.
--판매일자 기준으로 모든 상품의 판매수량과 판매금액의 소계를 출력하고,
--마지막에 전체 판매수량과 판매금액의 합계도 보여주세요.
SELECT p_date"판매일자",p_code"상품코드",SUM(p_qty)"판매수량",SUM(p_total)"판매금액"
FROM panmae
GROUP BY rollup(p_date ,p_code)
ORDER BY p_date;

---------------------------------------------------------------------------------
SELECT s.name 학생이름,p.name "담당 교수이름",deptno
FROM student s JOIN professor p
ON s.profno = p.profno
order by deptno;

--Inner join 데이터가 있는 기준(null이 아닌)으로 붙이는것
SELECT s.name 학생이름,p.name "담당 교수이름",deptno
FROM student s , professor p
where s.profno = p.profno
and s.profno IS NOT NULL;

SELECT *
FROM professor p,student s 
--where조건없이 모든 정보를 조합해버리기 때문에
WHERE p.profno = s.profno;

SELECT s.name 학생이름,p.name "담당 교수이름"
FROM professor p JOIN student s 
ON p.profno = s.profno;

--Outer Join
SELECT s.name 학생이름,p.name "담당 교수이름"
FROM student s, professor p
WHERE s.profno = p.profno(+);

SELECT s.name 학생이름,NVL(p.name,'미지정') "담당 교수이름"
FROM student s LEFT OUTER JOIN professor p --student를 기준으로 잡고 professor를 왼쪽으로(left) 조인하겠다
ON s.profno = p.profno;

--CROSS JOIN
SELECT *
FROM professor p,student s ;
--where조건없이 출력하면 모든 행마다 정보를 조합해버림
--CROSS JOIN과 결과 같음
SELECT *
FROM professor p  cross join student;
-------------------------------------------------------------------------

SELECT *
FROM department;
SELECT *
FROM student;

--조인 시킬 테이블 보고
--테이블 컬럼확인하고
--조인 기준 컬럼 정하고
--Inner/Outer 뭐 쓸지 정하고

--1.학생이름, 전공학과코드(deptno1),학과명
SELECT s.name,s.deptno1,d.dname
FROM student s join department d
on s.deptno1 = d.deptno;

--2.학생이름,부전공코드(deptno2),학과면(있는것만)
SELECT s.name,s.deptno2,d.dname
FROM student s inner join department d
on s.deptno2 = d.deptno;

--3.학생이름,부전공코드(deptno2),학과명 (부전공이 없어도, 학생데이터는 보여주기)
SELECT s.name,s.deptno2,d.dname
FROM student s left outer join department d
on s.deptno2 = d.deptno;

SELECT s.name,s.deptno2,d.dname
FROM student s ,department d
where s.deptno2 = d.deptno(+); --(+)는 outer join 

--4.교수이름,소속학과코드, 학과명(있는것만)
SELECT p.name,p.deptno,d.dname
FROM professor p inner join department d
on p.deptno = d.deptno;

SELECT p.name,p.deptno,d.dname
FROM professor p ,department d
where p.deptno = d.deptno;

--5.교수이름,소속학과코드, 어느학과명의 교수인지(학과없어도 보여주기)
SELECT p.name,p.deptno,d.dname
FROM professor p left outer join department d
on p.deptno = d.deptno;

--6.학생명,전공학과코드,전공학과명, 담당교수번호, 담당교수명(있는것만)
SELECT s.name"학생명",s.deptno1"전공학과코드",d.dname 전공학과명,s.profno 담당교수번호,p.name 담당교수명
FROM student s ,department d,professor p
where s.deptno1 = d.deptno
AND s.profno = p.profno;

SELECT s.name"학생명",s.deptno1"전공학과코드",d.dname 전공학과명,s.profno 담당교수번호,p.name 담당교수명
FROM student s 
    JOIN department d
    ON s.deptno1 = d.deptno
    JOIN professor p
    ON s.profno = p.profno;

--7.학생명,전공학과코드,전공학과명, 담당교수번호, 담당교수명(없는 학생도 보여주기)
SELECT s.name"학생명",s.deptno1"전공학과코드",d.dname 전공학과명,s.profno 담당교수번호,p.name 담당교수명
FROM student s ,department d,professor p
where s.deptno1 = d.deptno
AND s.profno = p.profno(+);

SELECT s.name"학생명",s.deptno1"전공학과코드",d.dname 전공학과명,s.profno 담당교수번호,p.name 담당교수명
FROM student s 
    JOIN department d
    ON s.deptno1 = d.deptno
    LEFT OUTER JOIN professor p
    ON s.profno = p.profno;

--------------------------------------------------------------------------------
--JOIN = 등가조인 NOT = 비등가조인

SELECT *
FROM customer
order by point;

SELECT *
FROM gift;

SELECT c.gname"고객명", c.point"포인트"
,g.gname"상품명" ,g.g_start"포인트start",g.g_end"포인트end"
FROM customer c,gift g
where c.point between g.g_start and g.g_end;
--------------------------------------------------------------------------------

select * from student;
select * from score;
select * from hakjum;
--학생 번호,학생이름,점수,학점
select s.studno"학번",s.name"이름",sc.total"점수",h.grade"학점"
from student s , score sc , hakjum h
where s.studno = sc.studno
and sc.total between h.min_point and h.max_point;

select s.studno"학번",s.grade"학년",s.name"이름",sc.total"점수",h.grade"학점"
from student s
    join score sc 
    on s.studno = sc.studno
    join  hakjum h
    on sc.total between h.min_point and h.max_point
    order by h.grade;
--------------------------------------------------------------------------------

select * from emp2;
select * from p_grade order by s_pay desc;

--NVL(컬럼,NULL인 경우 기본 값)함수
--NVL2(컬럼,NULL이 아닌경우 처리할 내용,NULL 인경우 처리할 내용)함수
--사번, 이름, 전화번호, 급여(270,000,000), 직급(position)(기본 emp2포지션,없으면 p_grade포지션), 최소급여(000,000),최대급여(000,000)

select e.empno"사번",e.name"이름",e.tel"전번",TO_CHAR(e.pay,'999,999,999')"급여",NVL(e.position,p.position)"직급",
TO_CHAR(p.s_pay,'999,999,999')"최소급여",TO_CHAR(p.e_pay,'999,999,999')"최대급여",RANK() OVER(ORDER BY e.pay DESC)"급여순위"
from emp2 e, p_grade p
where e.pay between p.s_pay and p.e_pay --이 부분을 비교해 조인시키기
order by pay desc;

select e.empno"사번",e.name"이름",e.tel"전번",TO_CHAR(e.pay,'999,999,999')"급여",NVL(e.position,p.position)"직급",
TO_CHAR(p.s_pay,'999,999,999')"최소급여",TO_CHAR(p.e_pay,'999,999,999')"최대급여",RANK() OVER(ORDER BY e.pay DESC)"급여순위"
from emp2 e join p_grade p
on e.pay between p.s_pay and p.e_pay
order by pay desc;

--------------------------------------------------------------------------------
--emp2, p_grade
--이름, 태어난년도,기준년도(2010), 한국식 나이, 현재직급(가지고있는 직급),원래나니었다면...직급
select * from emp2;
select * from p_grade;

select e.name,to_char(e.birthday,'YYYY') 생년,'2010' 기준년도, '2011'-to_char(e.birthday,'YYYY') 한국식나이
,NVL(e.position,'직급없음') 현재직급,p.position"원래 나이에 맞는 직급",e.pay"급여",p2.position"급여에 맞는 직급"
--"급여 수준에 맞는 직급 가져오기" self join 해야한다
from emp2 e, p_grade p,p_grade p2
where '2011'-to_char(e.birthday,'YYYY') between p.s_age and p.e_age
and e.pay between p2.s_pay and p2.e_pay
order by e.birthday;

--------------------------------------------------------------------------------
select * from emp;
--사번, 이름, 상사의 사번, 상사의 이름
--SELF JOIN <--자기가 자신을 조인한다.
select e1.empno 사번,e1.ename 이름,e1.mgr "상사의 사번",e2.ename"상사의 이름"
from emp e1, emp e2
where e1.mgr=e2.empno ;

select e.empno 사번,e.ename 이름,e2.mgr "상사의 사번",e2.ename"상사의 이름"
from emp e  join emp e2
on e2.mgr=e.empno ;