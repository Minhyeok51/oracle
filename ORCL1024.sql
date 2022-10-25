select studno"번호",name"이름",id"아이디"
from student
where height >=160 and height <=175
union all
select profno,name,id
from professor
--where deptno between 101 and 201
where deptno in(101,102,103,201)
and bonus is null;

select '이름:' ||name "이름",'아이디:'||id"아이디",'주민번호:'||substr(jumin,1,6)||'-'||substr(jumin,7) as "주민번호"
from student;

--SUBSTR(대상컬럼,시작위치,길이) SUBSTRB(대상컬럼,시작위치,길이)
SELECT SUBSTR(jumin, 1,6), SUBSTRB(jumin,1,6), SUBSTR('한글',1,1),SUBSTRB('한글',1,3)
FROM student;

--INSTR(대상컬럼,찾을문자,시작위치,몇번째에 나오는?)
SELECT tel,INSTR(tel,'-',1,1),INSTR(tel,')',1,1),SUBSTR(tel,INSTR(tel,'-',1,1)+1,4)
FROM student;

SELECT 'A-B-C-D', INSTR('A-B-C-D','-' ,1, 1)
,INSTR('A-B-C-D','-' ,1, 3)
,INSTR('A-B-C-D','-' ,3, 2)
FROM dual;

--학생테이블에서 각 학생의 이름/전화번호/전화번호의 지역번호만 출력
--055)381-2158
--   4
--SUBSTR(1,3)
SELECT name,tel,
SUBSTR(tel,1,INSTR(tel,')',1,1)-1) 지역번호,
SUBSTR(tel,INSTR(tel,')',1,1)+1,INSTR(tel,'-',1,1)-(INSTR(tel,')',1,1)+1)) 전화번호앞자리,
SUBSTR(tel,INSTR(tel,'-',1,1)+1,4)전화번호뒤4자리
FROM student;

--INSTR(대상컬럼,찾을문자,시작위치,찾을문자가 몇번째 나온 윛치를 찾을거냐)
--SUBSTR(대상컬럼,시작위치,길이)
SELECT 'AB-C-D+E+F=ADEF'
    ,SUBSTR('AB-C-D+E+F=ADEF',6,5)
    ,SUBSTR('AB-C-D+E+F=ADEF',12,4)
    ,INSTR('AB-C-D+E+F=ADEF','-',1,1)
    ,INSTR('AB-C-D+E+F=ADEF','-',1,2)
    ,INSTR('AB-C-D+E+F=ADEF','+',1,1)
FROM dual;

--LPAD(컴럼(문자),자리수(몇자리로 보겠다),빈칸에 채울것) --왼쪽
--RPAD(컴럼(문자),자리수(몇자리로 보겠다),빈칸에 채울것) --오른쪽
SELECT grade ,LPAD(grade,2,'0'),RPAD(grade,4,'*')
FROM student;

SELECT LPAD(SUBSTR(jumin,7),13,'*')
FROM student;

--TRIM
--LTRIM,RTRIM
--(문자열/컬럼,지울 문자)

SELECT '*abcd*',LTRIM('*abcd*','*'),RTRIM('*abcd*','*')
FROM dual;
--TRIM 앞뒤로 쓸모없는 띄어쓰기 없애기 (제일 많이 쓰는거)
SELECT ' this is computer ',TRIM(' this is computer ')
FROM dual;

--REPLACE
--REPLACE(컬럼/문자열, old문자를 ,new문자로 바꾸겠다)
SELECT 'ABCD',REPLACE('ABCD','C','H')
FROM dual;

--1.emp테이블에 있는 이름에서 2번째 3번째 문자를 **로 바꾸기
SELECT REPLACE(ename,SUBSTR(ename,2,1),'*')
FROM emp;

--2.student테이블 주민번호 뒤 7자리를 *로 바꾸기. rpad -x replace사용
SELECT REPLACE(jumin,SUBSTR(jumin,7),'*******')
FROM student;

--3.student 테이블 tel 전화번호에서 전화번호 뒷자리를 *로바꾸기
--051)345-****
SELECT tel,REPLACE(tel,SUBSTR(tel,INSTR(tel,'-',1,1)+1,4),'****'),
substr(tel,-4,4)
FROM student;

-------------------------숫자함수

--ROUND(처리대상숫자,출력자리수)

SELECT ROUND(123.4),ROUND(123.5,0)
,ROUND(123.46,1),ROUND(123.49,1)
,ROUND(123.46,2),ROUND(123.49,2)
,ROUND(126.55,0)
,ROUND(126.55,1)
-- . 앞의 수를 반올림 시켜버림
,ROUND(126.55,-1)
FROM dual;

--TRUNC(처리대상숫자, 자리수) -버림처리
SELECT TRUNC(123.4),TRUNC(123.5,0)
,TRUNC(123.46,1),TRUNC(123.49,1)
,TRUNC(123.46,2),TRUNC(123.49,2)
,TRUNC(126.55,0)
,TRUNC(126.55,1)
-- . 앞의 수를 버려버림
,TRUNC(126.55,-1)
FROM dual;

SELECT TRUNC(51217,-2)
FROM dual;

--MOD -나머지연산
SELECT MOD(10,2),MOD(9,2),MOD(10,4)
FROM dual;

--CEIL(가장 가까운 큰 정수),FLOOR(가장 가까운 작은 정수)
SELECT rownum,ename,CEIL(rownum/3) "TEAMNO"
FROM emp;
--WHERE rownum<=5

--POWER 제곱(숫자,제곱)
SELECT POWER(10,3),POWER(2,10)
FROM dual;

--날짜 함수
--현재 날짜,시간
SELECT SYSDATE
FROM dual;

--create user, create date, update user, update date
--생성한 사용자,생성일시      ,수정 사용한,  수정일시

--LAST_DAY 해당 달의 마지막 날짜
SELECT LAST_DAY(SYSDATE),LAST_DAY('2022-02-01')
FROM dual;

--사용요금조회( EX.카드사 프로그램,이번달에 사용한 요금 조회)
SELECT '2022-10-01' ,LAST_DAY('2022-10-01')
FROM dual;

--ADD_MONTHS(날짜, 더할 개월 수) 함수
SELECT '2022-10-01', LAST_DAY(ADD_MONTHS('2022-10-01',2)) --10월1일~12월 말일
FROM dual;

--ROUND반올림, TRUNC내림/버림
SELECT
TO_CHAR(ROUND(SYSDATE),'YYYY-MM-DD HH24:MI:SS'),
TO_CHAR(TRUNC(SYSDATE),'YYYY-MM-DD HH24:MI:SS')
FROM dual;

--형변환함수
--TO_NUMBER(숫자처럼생긴문자)
SELECT 2+2+'4'+TO_NUMBER('18')
FROM dual;

--TO_CHAR문자형태로 바꾸는 함수
SELECT SYSDATE, TO_CHAR(SYSDATE,'YYYY')
, TO_CHAR(SYSDATE,'YYYY-MM-DD') --DATA타입을 형식에 맞게 출력하기 년/월/일
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH:MI:SS')--년/월/일 시:분:초
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS')--년/월/일 시:분:초 24시간 표기법
FROM dual;

--Ex
SELECT TO_CHAR(birthday,'YYYY-MM-DD HH24:MI:SS')
,TO_CHAR(birthday,'MM')
,TO_CHAR(birthday,'DD')
FROM student;

desc student;

--Ex
--직원테이블 직원들 중에 1~3월에 입사한 사람들 정보만 보여주라
SELECT * 
FROM emp
WHERE TO_CHAR(hiredate,'MM') BETWEEN 01 AND 03;

--다른수 말고 9써야되네?
SELECT 50000,TO_CHAR(50000,'99,999')
,TO_CHAR(50000,'99,999.99')
,TO_CHAR(50000,'099,999.99')
,TO_CHAR(4444450000,'FM999,999,999,999') --3자리마다 콤마를 찍고 싶은 경우, 서로 수가 안맞으면 공백 생김.
--앞에 공백 지우고 싶다면 FM 을 앞부분에 추가
FROM dual;

--1.progessor 테이블을 조회하여 201번 학과에 근무하는 교수들의 이름과
--급여, 보너스,연봉을 124,556같이 출력. 단, 연봉은(pay*12)+bonus로 계산
SELECT name"이름",pay"급여",NVL(bonus,0),TO_CHAR((pay*12)+NVL(bonus,0),'FM999,999,999,999,999')"연봉"
FROM professor
WHERE deptno IN(201);

--2.emp테이블 조회, comm값을 가지고 있는 사람들의
--empno,ename,hiredate,총연봉, 15%인상 후 연봉을 출력
--단 총연봉은 (sal*12)+comm으로 계산하고
--15%인상한 값은 총연봉의 15%인상 값
SELECT empno,ename,hiredate,TO_CHAR((sal*12)+NVL(comm,0),'999,999')"총연봉",TO_CHAR(((sal*12)+NVL(comm,0))*1.15,'999,999')"15%인상 후 연봉"
FROM emp;
--WHERE comm IS NOT NULL;

--1.progessor 테이블을 조회하여 201번 학과에 근무하는 교수들의 이름과
--급여, 보너스,연봉을 124,556같이 출력. 단, 연봉은(pay*12)+bonus로 계산
SELECT *
FROM professor
WHERE deptno IN(201);

--NVL()함수
--NULL인 값을 만나면 사용할 다른 값
--NVL(컬럼,바꿀 값)
SELECT pay ,NVL(bonus,0)
FROM professor
WHERE deptno IN(201);

--NVL(컬럼,NULL인 경우 기본 값)함수
--NVL2(컬럼,NULL이 아닌경우 처리할 내용,NULL 인경우 처리할 내용)함수

SELECT ename,sal,comm, NVL2(comm,comm+100,500)as "추가 보너스"
FROM emp;

--ex)
--emp테이블에서 deptno가 30번인 사원들을 조회하여 comm값이 있을 경우'Exist'를 출력하고
--comm값이 null일 경우 'Empty'를 출력
SELECT empno,ename,comm,NVL(comm,0),NVL2(comm,'Exist','Empty')
FROM emp
WHERE deptno =30;


--DECODE()함수
--(a==b) ? a:b;
--DECODE(A,B,'ture','false'); A가 B가 맞으면 'true'부분,아니면'false'
SELECT deptno
,DECODE(deptno,'10','좋은학과')
,DECODE(deptno,'10','좋은학과','안좋은학과')
,DECODE(deptno,'10','좋은학과','20','괜찮은 학과','30','안좋은학과','그외등등')
,DECODE(deptno,'10',DECODE(ename,'CLARK','일잘하더라','놀고먹더라'),'일못하더라')
FROM emp;

--ex1)
--student테이블을 사용하여
--제 1전공(deptno1)이 101번인 학과 학생들의 이름과 주민번호,성별을 출력하되
--성별은 주민번호(jumin)컬럼을 이용하여 7번째 숫자가 1일경우 '남자',2일경우'여자'로 출력하세요
SELECT name,jumin,DECODE(SUBSTR(jumin,7,1),'1','남자','여자')"성별"
FROM student
WHERE deptno1 =101;
--ex2)
--student테이블에서 1전공이(deptno1) 101번인 학생의 이름과 연락처와 지역을 출력
--단,지역번호가 02는 '서울',031은 '경기',051은'부산',나머지는'그 외'
SELECT name,tel,DECODE(SUBSTR(tel,1,INSTR(tel,')',1,1)-1),'02','서울','031','경기','051','부산','그 외')"지역"
FROM student;
--WHERE deptno1=101;

--CASE 문 WHEN (SWITCH CASE)
--CASE 조건 WHEN 결과 THEN 출력
--         WHEN 결과 THEN 출력
--          ELSE 출력
--          END
SELECT name,tel,SUBSTR(tel,1,INSTR(tel,')',1,1)-1)"지역번호"
,CASE(SUBSTR(tel,1,INSTR(tel,')',1,1)-1)) WHEN '02'THEN'서울'
                                        WHEN '031'THEN'경기'
                                        WHEN '051'THEN'부산'
                                        ELSE '그 외'
                                        END AS"지역"
FROM student;

SELECT name ,jumin,SUBSTR(jumin,3,2)"월"
,CASE WHEN SUBSTR(jumin,3,2) IN ('01','02','03') THEN '1분기'
    WHEN SUBSTR(jumin,3,2) IN ('04','05','06') THEN '2분기'
    WHEN SUBSTR(jumin,3,2) BETWEEN 07 AND 09 THEN '3분기'
    ELSE '4분기'
    END AS"분기 구분"
FROM student;

--CASE WHEN
--emp테이블을 조회하여 empno,ename,sal,level(급여등급)을 출력
--단 급여등급은 sal을 기준으로
-- 1-1000이면 Level 1,
-- 1001-2000 이면 Level 2,
-- 2001-3000이면 level 3,
-- 3001 - 4000이면 level 4,
-- 4001보다 많으면 level5로 출력
SELECT empno,ename,sal,
CASE WHEN sal between 1 and 1000 THEN 'Level 1'
WHEN sal between 1001 and 2000 THEN 'Level 2'
WHEN sal between 2001 and 3000 THEN 'Level 3'
WHEN sal between 3001 and 4000 THEN 'Level 4'
ELSE 'Level 5'
END AS "LEVEL"
FROM emp;

--정규식 (Regular Expression)
--정규식 기준 ->JS,Java,SQL
SELECT *
FROM t_reg;

--REGEXP_LIKE(대상컬럼,정규식) 함수
SELECT *
FROM t_reg
WHERE text like 'A%' OR text like 'a%';

SELECT *
FROM t_reg
--WHERE REGEXP_LIKE(text,'[a-z]'); --소문자가 있나?
--WHERE REGEXP_LIKE(text,'[A-Z]'); --대문자가 있나?
--WHERE REGEXP_LIKE(text,'[a-zA-Z]'); --소문자든 대문자든 있나?
--WHERE REGEXP_LIKE(text,'[0-9]'); --숫자가 있나?
--WHERE REGEXP_LIKE(text,'[a-z] [0-9]');--소문자^숫자(소문자띄고숫자 인 케이스가 있나?
--WHERE REGEXP_LIKE(text,'[a-z]  [0-9]');--소문자^^숫자(소문자띄고숫자 인 케이스가 있나?
--WHERE REGEXP_LIKE(text, '[[:space:]]'); --띄어쓰기가 포함되어있나
--WHERE REGEXP_LIKE(text,'[A-Z]{2}'); --대문자가 2개 붙어있는 케이스가 있나
--WHERE REGEXP_LIKE(text,'[A-Z]{3}'); --대문자가 3개 붙어있는 케이스가 있나
--WHERE REGEXP_LIKE(text,'[A-Z]{4}'); --대문자가 4개 붙어있는 케이스가 있나
--WHERE REGEXP_LIKE(text, '[0-9]{3}'); --숫자가 3개 붙어있는 케이스가 있나
--WHERE REGEXP_LIKE(text, '[A-Z][0-9]{3}'); --대문자 있고 숫자가 3개 붙어있는 케이스가 있나
--WHERE REGEXP_LIKE(text, '[0-9][a-z]{3}'); -- 숫자가 있고 소문자 3개 붙어있는 케이스가 있나
--WHERE REGEXP_LIKE(text, '^[A-Z]'); --첫 글자가 대문자로 시작하는 케이스가 있나
--WHERE REGEXP_LIKE(text, '^[a-z]'); --첫 글자가 소문자로 시작하는 케이스가 있나
--WHERE REGEXP_LIKE(text, '^[a-zA-Z]'); --첫 글자가 소문자든 대문자든 시작하는 케이스가 있나
--WHERE REGEXP_LIKE(text, '^[0-9]'); --첫 글자가 숫자로 시작하는 케이스가 있나

--WHERE REGEXP_LIKE(text, '[a-zA-Z]$'); --마지막 글자가 소문자든 대문자든 시작하는 케이스가 있나
--WHERE REGEXP_LIKE(text, '[0-9]$'); --마지막 글자가 숫자로 시작하는 케이스가 있나
--WHERE REGEXP_LIKE(text, '[0-9a-z]$'); --마지막 글자가 숫자/소문자 시작하는 케이스가 있나
--WHERE REGEXP_LIKE(text, '^[^a-z]'); --첫 글자가 소문자로 시작하지 않는 케이스
--WHERE REGEXP_LIKE(text, '^[^0-9]'); --첫 글자가 숫자가 아닌걸로 시작하는 케이스
--WHERE REGEXP_LIKE(text, '^[^0-9a-z]'); --첫 글자가 숫자나 소문자가 아닌걸로 시작하는 케이스
--WHERE REGEXP_LIKE(text, '[^a-z]'); --소문자'만' 들어있지 않는 케이스
WHERE NOT REGEXP_LIKE(text, '[a-z]'); --NOT(소문자가 포함된 케이스를 찾아서) : 소문자가 없는 케이스

SELECT tel
FROM student
--WHERE REGEXP_LIKE(tel, '^02\)[0-9]{3}-') --02)로 시작하는 케이스 ')'쓰려면 앞에 \넣어야함
--WHERE REGEXP_LIKE(tel, '^02\)[0-9]{3,4}-') --{3,4} 3자리 또는 4자리
WHERE REGEXP_LIKE(tel, '^01([0|1|6|7|8|9])-?{[0-9]{3,4}}-?{[0-9]{4}}$') 
--휴대폰 번호를 식별하는 정규식
-- -? 는 -있을거나 없거나
--010-1234-5678
--01012345678
--010 011 016 017 018 019