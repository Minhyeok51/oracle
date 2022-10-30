--[2022. 10. 27. SQL 모닝퀴즈]
/*  맞췄다@
참조 테이블 : panmae, product, gift
출력 데이터 : 상품명, 상품가, 구매수량, 총금액,
적립포인트, 새해2배적립포인트, 사은품명, 포인트 범위

- panmae 테이블을 기준으로 포인트를 보여준다.
- 포인트는 구매한 금액 1원당 100의 포인트를 부여한다.
(단, 01월 01인 경우는 새해 이벤트로 인해 1원당 200의 포인트를 부여한다.)
- 적립포인트와 새해2배적립포인트를 모두 보여준다.
(이 경우, 이벤트 날인 01월 01일을 제외하고는 포인트가 동일 할 것이다.)
- 새해2배적립포인트를 기준으로 해당 포인트 기준으로 받을수 있는 사은품을 보여준다.
- 사은품 명 옆에 해당 사은품을 받을 수 있는 포인트의 범위를 함께 보여준다.

* 출력 양식과 컬럼 헤더에 표기되는 이름 확인!
*/
select * from panmae;
select * from product;
select * from gift;
select SUBSTR(pan.p_date,1,4)||'-'||SUBSTR(pan.p_date,5,2)||'-'||SUBSTR(pan.p_date,7,2)"판매일자"
--,TO_CHAR(TO_DATE(pan.p_date),'YYYY-MM-DD')"판매일자" 
-- p_date의 타입이 VARCHAR2(스트링타입)으로 되어있어서 TO_DATE로 숫자형식으로 바꾼후 TO_CHAR써야함
,pan.p_code"상품코드"
,p.p_name"상품명"
,TO_CHAR(p.p_price,'999,999')"상품가"
,pan.p_qty"구매수량",TO_CHAR(pan.p_total,'999,999')"총금액",TO_CHAR(pan.p_total*100,'999,999')"적립포인트"
,DECODE(SUBSTR(pan.p_date,5,4),'0101',TO_CHAR(pan.p_total*200,'999,999'),TO_CHAR(pan.p_total*100,'999,999'))"새해2배적립포인트"
--,CASE WHEN(SUBSTR(pan.p_date,5,4) ='0101') THEN pan.p_total*200
--      ELSE pan.p_total*100
--      END"새해2배적립포인트"
,g.gname"사은품명"
,TO_CHAR(g.g_start,'999,999')"포인트START"
,TO_CHAR(g.g_end,'999,999')"포인트END"
from panmae pan,product p,gift g
where pan.p_code = p.p_code
and DECODE(SUBSTR(pan.p_date,5,4),'0101',pan.p_total*200,pan.p_total*100) between g.g_start and g.g_end 
--and CASE WHEN(SUBSTR(pan.p_date,5,4) ='0101') THEN pan.p_total*200
--      ELSE pan.p_total*100
--      END between g.g_start and g.g_end 
order by pan.p_date ;
--------------------------------------------------------------------------------

--COMMIT;
--ROLLBACK;
/*
Data Type
VARCHAR2	문자형
NUMBER	숫자형
DATE	날짜
*/
--HE_STUDENT 학생정보
--학번 : NUMBER
--이름  : VARCHAR2
--주민번호 : VARCHAR2
--ID : VARCHAR2
--등록 일시 : DATE
--stdno NUMBER(10,5) -- 12345.12345

----------------------------테이블 생성------------------------------------------
CREATE TABLE HE_STUDENT
(
    stdno NUMBER(10), -- 12345.12345 -- 12345
    name VARCHAR2(32), -- 이름
    ssn VARCHAR2(16), --221122-1222457
    id VARCHAR2(32), --아이디
    reg_date DATE
);

--------------------------------------------------------------------------------
----------------------------테이블에 데이터를 저장---------------------------------

INSERT INTO HE_STUDENT (stdno, name, ssn, id, reg_date)
VALUES(1, '강수림','1111111111111', 'bed', SYSDATE);

INSERT INTO HE_STUDENT -- 5개에 대한 정보 모두를 넣을거면 생략가능
VALUES(2, '강시은','1111111111112', 'kse', SYSDATE);

INSERT INTO HE_STUDENT (stdno, name, ssn, id, reg_date)
VALUES(3, '권성민','1111111111113', 'ksm', SYSDATE);

INSERT INTO HE_STUDENT (stdno, name, ssn, id, reg_date)
VALUES(4, '김동하','1111111111114', '', SYSDATE);
commit;
--------------------------------------------------------------------------------
----------------------------업데이트---------------------------------------------
--업데이트나 딜리트 하기전 먼저 주석 처리하고 셀렉트로 값 먼저 확인한 후에 시행해라~
--학번 2번,3번 대상으로 ID를 변경 he_추가.
UPDATE HE_STUDENT
SET id='he_'||id--바꿀컬럼=바꿀 내용
--SELECT * FROM HE_STUDENT
WHERE stdno in (2,3);--바꿀 대상에 대한 조건

--id 가 null 인 사람의 id를 id_none이라고 저장
UPDATE HE_STUDENT
SET id='id_none'
WHERE id IS NULL;

--테이블 내에 모든 데이터에 stdno가 100씩 증가
UPDATE HE_STUDENT
SET stdno=100+stdno;
commit;
select * from HE_STUDENT;
--------------------------------------------------------------------------------
---------------------------------데이터 지우기------------------------------------
--DELETE 
SELECT *
FROM HE_STUDENT;
--WHERE stdno = 102;
--------------------------------------------------------------------------------

--테이블 만들기 2
CREATE TABLE HE_STUDENT2
(
    stdno NUMBER(10) NOT NULL, -- 12345.12345 -- 12345
    name VARCHAR2(32) NOT NULL, -- 이름
    ssn VARCHAR2(16), --221122-1222457
    id VARCHAR2(32) Default 'id_empty', --아이디
    address VARCHAR2(256), --주소
    reg_date DATE
);

INSERT INTO HE_STUDENT2 (stdno, name, ssn, id,address, reg_date)
VALUES(5, '김승현','1111111111115', 'health','헬스장바로옆', SYSDATE);

INSERT INTO HE_STUDENT2 (stdno, name, ssn, id,address, reg_date)
VALUES(6, '배고운','1111111111116', 'bae','천안버스30분', SYSDATE);

INSERT INTO HE_STUDENT2 (stdno, name, ssn, id,address, reg_date)
VALUES(7, '빙예은','1111111111117', 'bingfinite','성정두정', SYSDATE);

INSERT INTO HE_STUDENT2 (stdno, name, ssn, id,address, reg_date)
VALUES(8, '신동호','1111111111118', null,'대한민국', SYSDATE);

INSERT INTO HE_STUDENT2 (stdno, name, ssn, address, reg_date)
VALUES(9, '안시현','1111111111119', '아산지각할거리', SYSDATE);

SELECT * FROM HE_STUDENT2;

UPDATE HE_STUDENT2
SET id ='leon'
WHERE ID IS NULL;
--------------------------------------------------------------------------------

--테이블 만들기 3
CREATE TABLE HE_STUDENT3
(
    stdno NUMBER(10) PRIMARY KEY, -- 12345.12345 -- 12345
    name VARCHAR2(32) NOT NULL, -- 이름
    ssn VARCHAR2(16), --221122-1222457
    id VARCHAR2(32) UNIQUE, --아이디
    address VARCHAR2(256), --주소
    reg_date DATE
);

INSERT INTO HE_STUDENT3 (stdno, name, ssn, address, reg_date)
VALUES(10, '윤서연','1111111111110', '늦지않을거리', SYSDATE);

INSERT INTO HE_STUDENT3 (stdno, name, ssn, address, reg_date)
VALUES(11, '이광민','1111111111211', '가끔늦을거리', SYSDATE);

INSERT INTO HE_STUDENT3 (stdno, name, ssn, address, reg_date)
VALUES((SELECT NVL(MAX(stdno),0)+1 FROM HE_STUDENT3), '이다연','1111111111212', '아산차타고', SYSDATE);
--최초 값이 NULL로 되어있기 때문에 NVL로 방지해준다.

SELECT max(stdno)+1 FROM HE_STUDENT;    --->다음 stdno 105
SELECT stdno FROM HE_STUDENT2;  ---->10
SELECT NVL(max(stdno),0)+1 FROM HE_STUDENT3; ---->12

--1번 HE_STUDENT ->stdno 1 2 3 4로 원상복구시키기
UPDATE HE_STUDENT
SET stdno = stdno-100;
commit;
--2번 HE_STUDENT,HE_STUDENT2,HE_STUDENT3 모든 정보를 취합해서 보여주는 쿼리문 만들기
select stdno,name,ssn,id,null,reg_date 
from HE_STUDENT
union all
select stdno,name,ssn,id,address,reg_date
from HE_STUDENT2
union all
select stdno,name,ssn,id,address,reg_date
from HE_STUDENT3;