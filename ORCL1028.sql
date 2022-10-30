/*[2022. 10. 28. 모닝퀴즈]
* 다음 조건에 맞는 테이블을 생성하시오.
* 테이블명 : T_MENU_1028

* 내부 컬럼 (컬럼명은 적절하게 지을 것!)
메뉴 아이디 : 숫자형, 기본키
메뉴 이름 : 128바이트 문자형, Null 이면 안됨!
가격 : 10자리 숫자형, 기본값 0
종류 : 64바이트 문자형, Null 가능
메뉴개발일자 : 날짜타입

* 아래 데이터를 테이블에 저장하시오.

1 싸이버거 6000 완전식품 저장시점
2 콩나물비빔밥 7000 탄수화물 저장시점
3 닭가슴살 3000 단백질 저장시점
4 베트남쌀국수 8000 탄수화물 저장시점
5 라면 2000 밀가루 저장시점

* 베트남쌀국수의 가격을 8500원으로 변경하시오.

* 메뉴에서 라면을 삭제하시오.

* 생성한 해당 데이터를 조회하시오.*/
CREATE TABLE T_MENU_1028
(
    menu_id NUMBER(10) PRIMARY KEY, 
    menu VARCHAR2(32) NOT NULL, --varchar2(128)
    price NUMBER(16) Default 0, --number(10)
    type VARCHAR2(32), --varchar2(128)
    menu_date DATE
);
ALTER TABLE T_MENU_1028 MODIFY price NUMBER(16) Default 0;

INSERT INTO T_MENU_1028 (menu_id, menu, price, type, menu_date)
VALUES(1, '싸이버거',6000, '완전식품', SYSDATE);

INSERT INTO T_MENU_1028 (menu_id, menu, price, type, menu_date)
VALUES(2, '콩나물비빔밥',7000, '탄수화물', SYSDATE);

INSERT INTO T_MENU_1028 (menu_id, menu, price, type, menu_date)
VALUES(3, '닭가슴살',3000, '단백질', SYSDATE);

INSERT INTO T_MENU_1028 (menu_id, menu, price, type, menu_date)
VALUES(4, '베트남쌀국수',8000, '탄수화물', SYSDATE);

INSERT INTO T_MENU_1028 (menu_id, menu,  type, menu_date)
VALUES(5, '라면', '밀가루', SYSDATE);

INSERT INTO T_MENU_1028 (menu_id, menu, price, type, menu_date)
VALUES((SELECT NVL(MAX(menu_id),0)+1 FROM T_MENU_1028), '베트남',8000, '탄수화물', SYSDATE);

UPDATE T_MENU_1028
SET price =8500;
WHERE menu_id = 4;

DELETE 
--SELECT *
FROM T_MENU_1028
WHERE menu_id = 5;

commit;

select * from t_menu_1028;
--------------------------------------------------------------------------------
--10-27-2번 HE_STUDENT,HE_STUDENT2,HE_STUDENT3 모든 정보를 취합해서 보여주는 쿼리문 만들기
select stdno,name,ssn,id,null,reg_date  --컬럼의 개수를 맞춰줘야 한다
from HE_STUDENT
union all
select stdno,name,ssn,id,address,reg_date
from HE_STUDENT2
union all
select stdno,name,ssn,id,address,reg_date
from HE_STUDENT3;
--------------------------------------------------------------------------------
select * from HE_STUDENT;
select * from HE_STUDENT2
ORDER BY STDNO;
select * from HE_STUDENT3;
--2테이블에 데이터 모으기

--테이블 create
--데이터 insert/update/delete
--insert
INSERT INTO HE_STUDENT3
SELECT *  FROM HE_STUDENT2 --VALUE쓸 자리에 다가 SELECT * FROM HE_STUDENT3써서 데이터 합칠 수 있다
WHERE STDNO IN (5,6,7,8,9); -- PK에 걸리면 조건을 걸어서 조건값들만 넣어준다
COMMIT;
--WHERE STDNO IN(10,11) --SAMPLE

--delete
TRUNCATE TABLE HE_STUDENT3; -- 데이터를 전부지운다 -- 그냥 바로 통으로 지우는거 성능적으로 보면 훨씬 빠르단 차이가 있다.
--데이터가 잘렸다고 나옴. ROLLBACK 불가 --바로 자동 COMMIT이 돼버림.
--DDL

DELETE --전체를 지울 수 있다 / 조건에 따라서도 지울 수 있다. 
       -- 행을 돌면서 찾아서 지우는거
       --아직 COMMIT된건 아닌 상태.
       --DML
FROM HE_STUDENT3;



--CREATE/CREATE AS/ALTER/TRUNCATE/DROP
SELECT * FROM HE_STUDENT3;
SELECT * FROM T_MENU_1028;

----------------------------------테이블 지우기
--DROP TABLE 테이블명; --한번에 삭제 롤백 안돼~
DROP TABLE T_MENU_1028;

------------------------테이블 복사하기 -테이블의 구조+내부데이터 복사
SELECT * FROM HE_STUDENT6;

CREATE TABLE  HE_STUDENT3
AS  --복사할땐 AS를 써줘야한다~
SELECT * FROM HE_STUDENT2;

-----------------------기존 테이블 복사 할때 특정 구조+컬럼만 복사하기
CREATE TABLE  HE_STUDENT4
AS  
SELECT stdno,name FROM HE_STUDENT2;

----------------------기존 테이블 복하 살때 특정 구조+컬럼+특정 데이터만 복사하기
CREATE TABLE  HE_STUDENT5
AS  
SELECT stdno,name FROM HE_STUDENT2
where stdno <10;

------------------------기존 테이블 복사 -구조만
CREATE TABLE  HE_STUDENT6
AS  
SELECT * FROM HE_STUDENT2
where 1=2; -- 참이 될수 없는 조건을 걸어버리면 구조만 복사할 수 있다


--------------------테이블 이름 다시 짓기 RENAME 기존이름 TO 새로운이름
RENAME HE_STUDENT6 TO HE_STUDENT7;
--------------------테이블 변경하기 ALTER 테이블의 구조(컬럼)변경
--ALTER TABLE HE_STUDENT6;
          
          --ADD / RENAME COLUMN / MODIFY / DROP COLUMN--;

ALTER TABLE HE_STUDENT7
ADD (UPD_DATE DATE);

ALTER TABLE HE_STUDENT7
ADD (NICKNAME VARCHAR2(32) DEFAULT'별명없음');

ALTER TABLE HE_STUDENT7
RENAME COLUMN id TO stdid;

ALTER TABLE HE_STUDENT7
MODIFY (address VARCHAR2(512));

ALTER TABLE HE_STUDENT7
DROP COLUMN nickname;

SELECT * FROM HE_STUDENT7;

--데이터 CRUD
--테이블 CRUD

-------------------------------------MERGE 병합

CREATE TABLE TABLE_TO
AS
SELECT * FROM TABLE_FROM;
--FROM데이터를 ->TO로 옮겨서 저장
--취합
--전체 직원 현재정보 <--행정직원 <--실무직원 <--계약직 직원

--재직기간 ~10/28
--배치 -주기적으로 실행을 해야하는 것
--배치 매일 00:00 마다 실행한다.
SELECT * FROM TABLE_TO;
SELECT * FROM TABLE_FROM;

INSERT INTO TABLE_TO
SELECT * FROM TABLE_FROM;
---------------------------------MERGE
--병합: 추가할거냐 말거냐
--있으면 수정만, 없으면 추가

MERGE INTO TABLE_TO TT  -- TABLE_TO에 병합하겠다    /TT,TF는 변수명
USING TABLE_FROM TF
ON (TT.ID = TF.ID)
--ON (TT.ID = TF.ID AND TT.NAME=TF.NAME) --ID도 같고,NAME도 같은 경우를 따지는것
--ID가 같은데 NAME이 다르다? 병합실패
WHEN MATCHED THEN --같은게 있는 경우
    UPDATE SET TT.name = TF.name
WHEN NOT MATCHED THEN --같은게 없는 경우를 나눠서 처리함
    INSERT VALUES (TF.ID,TF.NAME);
    
--기본키 설정 -> 특성
--기본키 (PK) / 외래키 (FK)

CREATE TABLE T_PERSON_INFO(
    ID NUMBER(10),
--    ID NUMBER(10) PRIMARY KEY,
    NAME VARCHAR2(24),
    CONSTRAINT T_PERSON_INFO_PK PRIMARY KEY(ID) --제약조건 걸기
);

CREATE TABLE T_HOBBY_LIST(
    ID NUMBER(10),
    NO NUMBER(10),
    HOBBY VARCHAR2(24),
    PREFER NUMBER(2), --CHECK (PREFER BETWEEN 1AND 10), --1~10사이의 숫자만 쓸수있도록 조건걸기
    CONSTRAINT T_HOBBY_LIST PRIMARY KEY(ID,NO) --PK두개 설정 하려면 이렇게 써야함
);

-----------------------제약조건을 추가하겠다
ALTER TABLE T_HOBBY_LIST
ADD CONSTRAINT T_HOBBY_LIST_PF_CHK CHECK(PREFER BETWEEN 1 AND 10);

INSERT INTO T_HOBBY_LIST
VALUES(18,1,'출근',10);

--DELETE T_HOBBY_LIST
--WHERE ID =18;

-----------------------------시퀀스 조회
SELECT * FROM USER_SEQUENCES;
-------------------------------제약조건 조회
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'T_TEAM_INFO_SET';
----------------------------제약조건 삭제
--수정하는건 없고 DROP했다가 다시 추가해야함 
ALTER TABLE T_TEAM_INFO_SET
DROP CONSTRAINT T_TEAM_INFO_SET_FK;


---------------------자동증가 처리할 수 있게 도와주는
---------------------SEQUENCE
CREATE SEQUENCE T_PERSON_INFO_SEQ
INCREMENT BY 1
START WITH 21
--MAXVALUE 100
--MINVALUE 1
--CYCLE --CYCLE/NOCYCLE
--CACHE 20 --기본값이 20이다
;

-----------------------시퀀스 정보 조회하기
SELECT * FROM USER_SEQUENCES
WHERE SEQUENCE_NAME = 'T_PERSON_INFO_SEQ';


SELECT * FROM T_HOBBY_LIST;
SELECT NVL(MAX(ID),0)+1 FROM T_PERSON_INFO;
SELECT T_PERSON_INFO_SEQ.NEXTVAL FROM DUAL;


INSERT INTO T_PERSON_INFO
VALUES(T_PERSON_INFO_SEQ.NEXTVAL,'정혜연'); --위에서 만든 시퀀스 사용

SELECT * FROM T_HOBBY_LIST ORDER BY ID ,NO; 
SELECT * FROM T_PERSON_INFO;

SELECT ID,COUNT(*),COUNT(*)+1 "다음순번",MAX(NO),MAX(NO)+1"다음순번" FROM T_HOBBY_LIST
GROUP BY ID;

--아이디가 주어졌을때! 기본키가 중복되지 않게 하려면
--가장 신경써야 하는 부분은 순번,,,, -> 다음순번이 나오게 쿼리 만들라
INSERT INTO T_HOBBY_LIST
VALUES(21,(SELECT NVL(MAX(NO),0)+1 FROM T_HOBBY_LIST WHERE ID =21),'운동',10);

SELECT MAX(NO)
FROM T_HOBBY_LIST
WHERE ID=18;

----------------------------------------

CREATE TABLE T_TEAM_INFO(
    ID NUMBER(10),
    NO NUMBER(10),
    NAME VARCHAR2(24), --VARCHAR VARCHAR2 기능은 같다 VARCHAR2가 최신이고 권장되는것이다
    PS_ID NUMBER(10) CONSTRAINT T_TEAM_INFO_FK REFERENCES T_PERSON_INFO(ID)--FK참조
--                   제약조건       제약조건명      참조하겠다    어느테이블에(어떤컬럼)
);
SELECT * FROM T_TEAM_INFO;
--FK 제약 ->NULL.   외래키 ->다른 테이블의 식별자(기본키) -> 식별자에 존재하는 값

INSERT INTO T_TEAM_INFO
VALUES(1,1,'1조',18);

INSERT INTO T_TEAM_INFO
VALUES(1,2,'1조',19);

--INSERT INTO T_TEAM_INFO
--VALUES(1,3,'1조',22);    --무결성 제약조건(SCOTT.T_TEAM_INFO_FK)이 위배되었습니다- 부모 키가 없습니다
--  T_PERSON_INFO에 22가 없음.
INSERT INTO T_TEAM_INFO
VALUES(1,3,'1조',NULL);  --부모 키 참조한다 했더라도 NULL은 입력가능

---------------------FK외래키
SELECT * FROM T_PERSON_INFO;
DELETE FROM T_PERSON_INFO WHERE ID =18; --ORA-02292: 무결성 제약조건(SCOTT.T_TEAM_INFO_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다
-----------지우려면
UPDATE T_TEAM_INFO
SET PS_ID=NULL  --자식이 참조하고 있는 값을 먼저 NULL로 바꿔주고나서 지워야함
WHERE PS_ID=18;
--FK 삭제 시, 참조하고 있는 테이블이 있으면 삭제가 원활하지 않음.
--삭제가 안될 경우 해결법
--1. 참조하고 있는 테이블에 해당 데이터를 모두 찾아서 지우고, 데이터 삭제
--2. ON DELETE CASCADE;
--3. ON DELETE SET NULL;
--4. 참조키 설정을 안하고 그냥 쓰거나...
CREATE TABLE T_TEAM_INFO_CAS(
    ID NUMBER(10),
    NO NUMBER(10),
    NAME VARCHAR2(24), 
    PS_ID NUMBER(10) CONSTRAINT T_TEAM_INFO_CAS_FK REFERENCES T_PERSON_INFO(ID) ON DELETE CASCADE--FK참조
);

CREATE TABLE T_TEAM_INFO_SET(
    ID NUMBER(10),
    NO NUMBER(10),
    NAME VARCHAR2(24), 
    PS_ID NUMBER(10) CONSTRAINT T_TEAM_INFO_SET_FK REFERENCES T_PERSON_INFO(ID) ON DELETE SET NULL--FK참조
);
SELECT * FROM T_PERSON_INFO;

SELECT * FROM T_TEAM_INFO_CAS;--참조값 지워지면 참조하던 데이터 같이 지워짐

SELECT * FROM T_TEAM_INFO_SET;  --참조값이 지워지면 데이터가 NULL로 바뀜

DELETE
--SELECT *
FROM T_PERSON_INFO
WHERE ID =22;





-----------------------------시퀀스 조회     *중복*
SELECT * FROM USER_SEQUENCES;
-------------------------------제약조건 조회
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'T_TEAM_INFO_SET';
----------------------------제약조건 삭제
--수정하는건 없고 DROP했다가 다시 추가해야함 
ALTER TABLE T_TEAM_INFO_SET
DROP CONSTRAINT T_TEAM_INFO_SET_FK;