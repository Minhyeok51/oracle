--[2022. 11. 04. 모닝퀴즈]

/*
아래 두 개의 테이블을 생성하시오.
CREATE TABLE high_hobby_list
(
NAME VARCHAR2(24),
HOBBY VARCHAR2(24),
ETC VARCHAR2(24)
);

CREATE TABLE low_hobby_list
(
NAME VARCHAR2(24),
HOBBY VARCHAR2(24),
ETC VARCHAR2(24)
);

※추가 조건 : 프로시저 내에 CURSOR를 활용하여 작성하시오.

save_hobby_split 프로시저를 생성 한 후 수행해서 결과를 확인하시오.
* 선호도 점수에 따라서 각각 다른 테이블에 필요한 데이터를 저장하는 프로시저.
* 아래 조건에 만족하도록 생성하시오.
* 참조 테이블 : t_hobby_list, t_person_info

취미 목록을 가지고 있는 t_hobby_list 에서 선호도(prefer) 점수를 기준으로
1~5 점은 low_hobby_list 에 저장하고
6~10 점은 high_hobby_list 에 저장하시오.

name : 해당 hobby를 가진 사람(ID)의 이름
hobby : 취미 문자 그대로
etc : 취미 중 순번이 1번째인 취미인 경우 '1순위' 로 저장
그 외(1순위가 아닌경우는 ) 그냥 null 로 저장
*/

create or replace PROCEDURE save_hobby_split
IS
    CURSOR hobby_list IS 
                (SELECT (SELECT name 
                               FROM t_person_info 
                               where id = hl.id) name
                               ,no ,hobby ,prefer
                               FROM t_hobby_list hl);
                               
    v_etc varchar2(24);
    v_name t_person_info.name%TYPE;
    v_no t_hobby_list.no%TYPE;
    v_hobby t_hobby_list.hobby%TYPE;
    v_prefer t_hobby_list.prefer%TYPE;
BEGIN
    --처리할 로직. 2번. insert into select from
--    INSERT INTO high_hobby_list
--    SELECT (SELECT name 
--     FROM t_person_info 
--       where id = hl.id) name
--       ,hobby, DECODE(no, 1, '1순위', null) etc
--       FROM t_hobby_list hl
--       WHERE prefer BETWEEN 6 AND 10;
--
--    INSERT INTO low_hobby_list
--    SELECT (SELECT name 
--     FROM t_person_info 
--       where id = hl.id) name
--       ,hobby, DECODE(no, 1, '1순위', null) etc
--       FROM t_hobby_list hl
--       WHERE prefer BETWEEN 1 AND 5;


    --처리할 로직. 1번 FOR문 활용
    --서브쿼리
--    FOR hobby_item IN (SELECT (SELECT name 
--                               FROM t_person_info 
--                               where id = hl.id) name
--                               ,no ,hobby ,prefer
--                               FROM t_hobby_list hl) LOOP
        --3번. CURSOR 사용
--        FOR hobby_item IN hobby_list LOOP
--        --반복문 수행 쿼리 부분
--        IF hobby_item.no = 1 THEN
--            v_etc := '1순위';
--        ELSE
--            v_etc := '';
--        END IF;
--        
--        IF hobby_item.prefer BETWEEN 6 AND 10 THEN
--            INSERT INTO high_hobby_list --6~10 prefer
--            VALUES(hobby_item.name, hobby_item.hobby, v_etc);
--        ELSE
--            INSERT INTO low_hobby_list --1~5 prefer
--            VALUES(hobby_item.name, hobby_item.hobby, v_etc);
--        END IF;
        
        --4번. CURSOR 사용 + FETCH LOOP
        OPEN hobby_list;
            LOOP
                FETCH hobby_list INTO v_name, v_no, v_hobby, v_prefer;
                EXIT WHEN hobby_list%NOTFOUND;
                
                --반복문 수행 쿼리 부분
                IF v_no = 1 THEN
                    v_etc := '1순위';
                ELSE
                    v_etc := '';
                END IF;
                
                IF v_prefer BETWEEN 6 AND 10 THEN
                    INSERT INTO high_hobby_list --6~10 prefer
                    VALUES(v_name, v_hobby, v_etc);
                ELSE
                    INSERT INTO low_hobby_list --1~5 prefer
                    VALUES(v_name, v_hobby, v_etc);
                END IF;
            END LOOP;
        CLOSE hobby_list;
    

--    COMMIT;
--    --함수까지 활용
--    SELECT find_person_name_by_id(id) name, no, hobby, prefer
--    FROM t_hobby_list;
--    
--    --조인
--    SELECT pi.name, hl.no, hl.hobby, hl.prefer
--    FROM t_hobby_list hl, t_person_info pi
--    WHERE hl.id = pi.id;
END save_hobby_split;
/

CREATE TABLE t_arrive_list(
    name varchar2(24),
    ariv_date Date,
    ariv_ts Timestamp
);

/
select * from t_arrive_list;
select * from t_hobby_list;

--arrivedao
--persondao
--panmaedao