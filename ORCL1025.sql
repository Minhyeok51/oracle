--[2022. 10. 25. 모닝퀴즈]

/*emp2 테이블을 기준으로 아래 정보를 출력
사원들 중에 70년대 생이면서 지역번호를 기준으로 서울(02), 경기도(031)에 거주하는 사원들의 정보를 아래와 같이 출력하시오.
사번, 이름, 생년월일, 취미, 급여(pay), 성과급(급여의 150%)
, 직원분류(단, 가족과 같은 직원이라서 family로 표기)
,전화번호, 급여수준
(단, 급여수준은 아래와 같이 분류)
3500만 1원 ~ 4500만 : '하'
4500만 1원 ~ 6천만 : '중"
6000만 1원 이상 : '상'
그 외... : '화이팅'
*/
SELECT empno"사번",name"이름",birthday"생년월일",hobby"취미",pay"급여",pay*1.5"성과급",REPLACE(emp_type,'employee','familly')"직원 분류",tel
, CASE WHEN pay BETWEEN 35000001 AND 45000000 THEN '하' 
WHEN pay BETWEEN 45000001 AND 60000000 THEN '중'
WHEN pay >60000000 THEN '상'
ELSE '화이팅'
END AS "급여수준"
FROM emp2
WHERE birthday like '7%' and 
SUBSTR(tel,1,INSTR(tel,')',1,1)-1) in (02,031);

/* 해설
SELECT empno"사번",name"이름",birthday"생년월일",hobby"취미",pay"급여",pay*1.5"성과급",REPLACE(emp_type,'employee','familly')"직원 분류",tel
,CASE WHEN pay BETWEEN 35000001 AND 45000000 THEN '하' 
      WHEN pay BETWEEN 45000001 AND 60000000 THEN '중'
      WHEN pay >=60000001 THEN '상'
      ELSE '화이팅'
      END AS "급여수준"
FROM emp2
WHERE TO_CHAR(birthday,'YY') BETWEEN 70 AND 79
AND SUBSTR(tel,1,INSTR(tel, ')',1,1)-1) IN(02,031);*/


--Group처리 함수들....
SELECT hiredate,TO_CHAR(hiredate,'YY-MM')
FROM emp;

--COUNT() 함수: 개수 세기
--SUM() 함수 : 총 합
--AVG() 함수 : 평균
SELECT COUNT(*)
FROM emp;

SELECT COUNT(*) --COUNT체크 시, NULL은 제외
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT COUNT(*),SUM(sal),SUM(comm),AVG(sal),AVG(NVL(comm,0)) --NULL인경우도 포함하기 위해 NVL사용
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--SUM() 함수 : 총 합
SELECT SUM(sal)
FROM emp;
--WHERE sal BETWEEN 1000 AND 2000

--MAX() /MIN() 함수 --최대/최소
SELECT MAX(sal), MIN(sal),MAX(comm),MIN(comm)
,MAX(hiredate),MIN(hiredate)
FROM emp;

SELECT STDDEV(sal)"표준편차", VARIANCE(sal)"분산"
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT deptno,job,ROUND(AVG(sal),2) as "급여의 평균"--group by 를 썼기 때문에 같이 출력 가능. 그룹바이 기준에 들어가는 것만 같이 쓸수 있음
--SELECT *
FROM emp --emp 전체 데이터 대상 급여 평균
--WHERE deptno in(10,20)
GROUP BY deptno,job --부서번호 기준으로 묶어서(그룹화해서)
ORDER BY deptno DESC;        --부서번호 기준으로 내림차순 정렬

--집계(그룹)함수 제외한 일반 컬럼인 경우는 GROUP By에 포함되어 있어야 SELECT에 사용가능 

--student 각 학년 별, 평균키와 평균 몸무게
--전공 101 102 201 202
SELECT grade"학년", AVG(height)평균키 ,AVG(weight)평균몸무게
--SELECT *
FROM student
WHERE deptno1 IN(101,102,201,202)
--AND height>=170 --애초에 계산 대상이 170이상인 사람들만 데리고 계산
GROUP BY grade --GROUP BY, HAVING
HAVING AVG(height)>=170 -- GROUP BY 집계함수 들에 대한 조건을 넣는 경우 HAVING사용
ORDER BY grade  DESC;
--평균 키가 170이상인 학년들의 정보만 보겠다.

--EMP테이블 부서별 총연봉(SAL*12+COMM)기준  2000이상인 부서들의 부서별 평균 급여를 보여라
SELECT deptno,TO_CHAR(AVG(sal*12+NVL(comm,0)),'999,999.99')"평균 연봉"
--SELECT *
FROM emp
GROUP BY deptno
HAVING AVG(sal*12+NVL(comm,0))>=0
ORDER BY deptno;
--HAVING AVG(sal)>2000

--1.부서와 직업별 평균 급여 및 사원수
SELECT deptno,job,AVG(sal),COUNT(*)
FROM emp
GROUP BY deptno,job
ORDER BY deptno, job;
--2. 부서별 평균 급여와 사원 수
SELECT deptno,ROUND(AVG(sal),2),COUNT(*)
FROM emp
GROUP BY deptno;
--3. 전체 사원의 평균 급여와 사원 수
SELECT COUNT(*)"사원수",ROUND(AVG(sal),2)
FROM emp;


--ROLLUP() ///위에 1,2,3번 문제 결과 합침

--  UI(Front) <-> Java(Server) <-> Database(Oracle)
--  통계보여줘 <->통계데이터를 확보<-> DB Query소계형태를 만들어서 반환
--  통계보여줘 <->통계데이터를 확보(받은 데이터를 소계형태로 변형)<-> DB Query그냥 베이스 평균/개수 데이터 반환 //이런식으로도 자바에서 처리해도 된다

SELECT deptno,job,ROUND(AVG(sal),0),COUNT(*)
FROM emp
--GROUP BY ROLLUP((deptno,job)) --최종 합만 추가하는 경우
--GROUP BY ROLLUP(deptno,job)
GROUP BY deptno, ROLLUP(job) --job기준으로 Rollup수행
ORDER BY deptno, job;
--ROLLUP()소계 처리 기준
--GROUP BY deptno,job 된 데이터를 기준
--소계처리는 ROLLUP()
--GROUP BY ROLLUP(deptno,job) 괄호 오른쪽부터 하나씩 지우면서 소계
--deptno,job    (부서별,직업별)소계
--deptno        (부서별)소계
--              (전체)소계

--교수테이블
--(각 부서(deptno)와 직급별(position)) 평균급여와 교수의 수
--1)부서별 소계(평균급여와 교수의 수)의 합까지 출력
SELECT deptno,position,AVG(pay)평균급여,COUNT(*)"교수 수"
--SELECT *
FROM professor
--GROUP BY deptno,ROLLUP(position)

ORDER BY deptno;

--2)부서별/직급별/전체 소계 함께 보이도록
SELECT position,deptno,AVG(pay)평균급여,COUNT(*)"교수 수"
--SELECT *
FROM professor
GROUP BY ROLLUP( position,deptno)
--GROUP BY CUBE(position,deptno) --CUBE내부에있는 요소들 별로 소계+총합 이 다 나옴
--GROUP BY GROUPING SETS(position,deptno) --GROUPING SETS()내부에 있는 각 요소들별 소계만 보여줌
ORDER BY position ;


--월별 매출액 데이터
--전전월 매출액 -전월 매출액 - 당월 매출액 - 다음 월 매출액
--LAG() /LEAD() 함수(이전,이후)
--LAG/LEAD(데이터,몇번째앞/뒤,null인경우 기본값) OVER(정렬기준)
SELECT empno,ename,sal
    ,LAG(sal, 2,0) OVER(ORDER BY sal)"전전" --이전전 행 데이터
    ,LAG(sal,1,0) OVER(ORDER BY sal) "전"--이전 행 데이터
    ,LEAD(sal,1,0) OVER(ORDER BY sal)"후"--이후 행 데이터를 참고하겠다
    ,LEAD(sal,2,0) OVER(ORDER BY sal)"후후"--이후에 이후 행 데이터를 참고하겠다
FROM emp
ORDER BY sal;

--학생들 키순으로 정렬해서
--큰 순서대로 (내림차순) 정렬하고
--내 이전, 이후 키의 데이터도 같이 보여라
--학번,이름,학년,키(내 앞사람 키,뒷사람 키)--값 없으면 기본키 100
SELECT studno,name,grade,height
    ,LAG(height,1,100) OVER(ORDER BY height DESC)"앞사람 키"    --앞 데이터
    ,LEAD(height,1,100) OVER(ORDER BY height DESC)"뒷사람 키"   --뒤 데이터
    ,RANK() OVER(ORDER BY height DESC) "랭크" --정렬기준에 맞는 내 순위 (중복을 수로 간주)
    ,DENSE_RANK() OVER(ORDER BY height DESC)"덴스랭크"  --정렬기준에 맞는 내 순위 (중복을 수에서 제외)
FROM student
ORDER BY height DESC;

--RANK(), DENSE_RANK
--RANK()/DENSE_RANK() OVER(정렬기준)

--emp테이블 10,20번 부서에 속한 직원들의
--부서,이름,급여,급여순위를 출력하세요
SELECT deptno,ename,sal
,DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC)||'등'"급여 순위" --(PARTITION BY)부서별로 구분해서 그안에서 순위를 매기겠다
--,RANK() OVER(PARTITION BY deptno ORDER BY sal DESC)||'등'"급여 순위" --(PARTITION BY)부서별로 구분해서 그안에서 순위를 매기겠다
FROM emp
--WHERE deptno IN(10,20)
ORDER BY deptno,sal DESC;

--rownum (Default로 만들어주는 행번호)/ ROW_NUMBER() (의도해서 만들수 있는 행 번호)
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
--      사번 /이름 /부서번호 /부서이름
--                (       dept    )

SELECT e.empno,e.ename,e.deptno,d.dname -- e. 안적어도 되지만 같이 적어주는게 좋다
FROM emp e,dept d   --JOIN 테이블 emp,dept
WHERE e.deptno =d.deptno;   --JOIN 기준 deptno가 같은 경우
--JOIN ON
SELECT e.empno,e.ename,d.dname
--JOIN 을 쓸땐 WHERE대신에 ON
--FROM emp e JOIN dept d
FROM emp e INNER JOIN dept d --INNER / OUTER JOIN 이 있다
ON e.deptno =d.deptno;

SELECT s.name 학생이름,p.name "담당 교수이름",deptno
FROM student s JOIN professor p
ON s.profno = p.profno
order by deptno;

SELECT * FROM professor;
SELECT * FROM student;