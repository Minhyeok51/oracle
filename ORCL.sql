SELECT * 
FROM dept;

-- 콜롬이름 알았으니 선택해서 보기
SELECT DNAME , DEPTNO 
FROM dept;

DESC dept;
--WHERE

--사람이름과 급여 보기
--AS는 생략이 가능
--1. '하나 출력하려면 ''두개써라 2.q'[i'm fine]'
SELECT EMPNO "사번",ENAME  "이름",SAL AS "급여", 'i''m fine' "보너스컬럼"
        ,q'[i'm fine]' as "대답"
FROM emp;
--distinct 중복제거

--전화번호 010-123-1234
--번호1||번호2||번호3
--010 123 1234
select distinct deptno from emp;

select GNO, point, 'gno='||gno||'포인트는 '||point "마"
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
--작은 따옴표를 써야함
--WHERE ename ='KING';

SELECT ename,sal+500 as "sal bonus"
from emp;

SELECT ename, job, sal, hiredate
FROM emp
WHERE hiredate BETWEEN '81/03/01' AND '81/12/01';
--WHERE sal BETWEEN 2000 AND 3000;
--WHERE sal>=2000 and sal<=3000;    and로 연결하기
--and or not

SELECT *
FROM emp
WHERE deptno  NOT IN( 10,20); 
--IN , NOT IN
--DEPTNO 안에(IN) 10,과20인 데이터
--WHERE deptno !=10 and deptno<> 20;   10이 아니고 20이 아니다. <>도 not의 의미

SELECT *
FROM emp
--IS (NOT) ---
--NULL인 애들만 찾겠다
WHERE comm IS  NULL;

SELECT name
FROM student
WHERE name LIKE '%o%';
--대문자 D로 시작하는 사람만 나온다. ----LIKE 키워드 사용 + D%
--o로 끝나는 사람 %o
--%o% o가 들어있으면 찾겠다

SELECT *
FROM student
WHERE id LIKE 'C___%';
-- 'C___' = 아이디가 C로 시작하면서 뒤에___3자리 가 있는사람. '_'는 자리수를 뜻함

SELECT *
FROM student
WHERE id like '%b_in%';
--WHERE id LIKE '%in%';
--WHERE id LIKE '%in'

SELECT *
FROM emp
ORDER BY sal DESC;--정렬 / desc는 내림차순 / asc는 오름차순인데 그냥 기본값임

--직원들중에 81년 01월 01일 이후로 입사한 직원들 가운데에
--부서가 10번부서가 아닌 부서에 다니는 직원들의 정보를
--급여가 높은 순서대로 보여주세요(사번,이름,입사일자,급여,부서번호).
SELECT empno "사번",ename "이름",hiredate "입사일자",sal"급여",deptno"부서번호"
FROM emp
WHERE hiredate >= '81/01/01' AND deptno NOT IN(10) 
ORDER BY sal DESC;


SELECT *
FROM student
ORDER BY grade DESC,height desc;

select studno,name,grade ,0
from student 
where grade =4
UNION ALL   --두개 합칠때 콜럼의 수 맞춰야함  합집합
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
--intersect -- 교집합
minus --차집합
select studno,name
from student
where deptno2 = 201;

--comm <-상여/성과/보너스
--회사직원들중에 보너스 금액이 null이 아닌 직원들을 직업/직무(job)순으로 정렬
--직무순으로 정렬 이후에는 이름 내림차순으로 정렬

select *
from emp
where comm is not null
order by job ,ename desc;

--      첫글자를 대문자
select initcap(ename),lower(ename),upper('abc')
from emp;
                --영어는 한자당 1byte 한글은 2or3 byte
select job ,length(job), lengthb(job), length('퇴근'),lengthb('퇴근')
from emp;

select concat('a','b') , concat(ename ,job)
from emp;

select concat('a','b')
--dual은 임시로 쓰는 테이블
from dual;

select substr('abc1234',4,4)
from dual;
select substr('abc1234',-5,2)
from dual;

select 
substr(jumin,1,6)||'-'||substr(jumin,7) as "주민번호"
from student;

--student중에서 75년생과 76년생의 모든 정보를 출력
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