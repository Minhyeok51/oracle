/*
[2022. 11. 03. 모닝퀴즈]


아래 두 개의 테이블을 먼저 생성하고 진행하시오.
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

select * from high_hobby_list;
select * from low_hobby_list;
select * from t_hobby_list;
select * from t_person_info;
/
CREATE OR REPLACE PROCEDURE save_hobby_split
IS
    v_etc varchar2(24);
BEGIN
    --처리할 로직. 2번. insert into select from
    INSERT INTO high_hobby_list
    SELECT (SELECT name 
     FROM t_person_info 
       where id = hl.id) name
       ,hobby, DECODE(no, 1, '1순위', null) etc
       FROM t_hobby_list hl
       WHERE prefer BETWEEN 6 AND 10;
    
    INSERT INTO low_hobby_list
    SELECT (SELECT name 
     FROM t_person_info 
       where id = hl.id) name
       ,hobby, DECODE(no, 1, '1순위', null) etc
       FROM t_hobby_list hl
       WHERE prefer BETWEEN 1 AND 5;


    --처리할 로직. 1번 FOR문 활용
    --서브쿼리
--    FOR hobby_item IN (SELECT (SELECT name 
--                               FROM t_person_info 
--                               where id = hl.id) name
--                               ,no ,hobby ,prefer
--                               FROM t_hobby_list hl) LOOP
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
--    END LOOP;
    
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
exec save_hobby_split;
/
------------------------------------------------------------------------------
create or replace NONEDITIONABLE procedure save_person_hobby --이름과 취미와 선호도를 받아서 저장하는 프로시저
(v_name IN t_person_info.name%type,
v_hobby IN t_hobby_list.hobby%type,
v_prefer IN t_hobby_list.prefer%type,
o_result OUT VARCHAR2)

IS
    v_save_id t_person_info.id%type;
    v_next_no t_hobby_list.no%type;
    prefer_error EXCEPTION;--EXCEPTION 정의 (사용자 정의 예외)
    input_null_error EXCEPTION;
    invalid_value_input_error EXCEPTION;
BEGIN
/*
save_person_hobby('강수림','잠자기',10);
select column
into 변수
from table
where 조건;
*/
    IF NOT V_PREFER BETWEEN 1 AND 10 THEN
        DBMS_OUTPUT.PUT_LINE('V_PREFER 는 1~10만 가능합니다.');
--        RETURN;
        RAISE prefer_error;
--        RAISE_APPLICATION_ERROR(-20001,'V_PREFER 는 1~10만 가능합니다.');
    END IF;
    
    select id
    into v_save_id
    from t_person_info
    where name = v_name;

    select nvl(max(no),0)+1 
    into v_next_no
    from t_hobby_list 
    where id=v_save_id;

    --다음 순번도 변수로 만들어서 값을 저장하고 insert처리하는 방식으로 바꾸자

    insert into t_hobby_list
--    values (v_save_id,(select nvl(max(no),0)+1 from t_hobby_list where id=v_save_id),v_hobby,v_prefer);
    values (v_save_id,v_next_no,v_hobby,v_prefer);

    o_result := v_save_id||'-'||v_next_no||'-'||v_hobby||'-'||v_prefer;

    commit;
    
    exception 
        when no_data_found then --데이터 못찾으면
            ROLLBACK;
            dbms_output.put_line('no_data_found 예외');
        when too_many_rows then -- 찾은게 여러행 너무 많으면..
            ROLLBACK;
            dbms_output.put_line('too_many_rows 예외');
        WHEN PREFER_ERROR THEN 
        DBMS_OUTPUT.PUT_LINE('V_PREFER 는 1~10만 가능합니다.');
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001,'V_PREFER 는 1~10만 가능합니다.');
        --20000~20999 까지 사용자 정의 코드
        WHEN input_null_error THEN
        ROLLBACK;
        when others then --그 외에 케이스들
            ROLLBACK;
            dbms_output.put_line('others 예외');
            
END save_person_hobby;
/
--EXCEPTION
--선언부
--실행부
--예외처리부
select * from t_hobby_list;
select * from t_person_info;
SET SERVEROUTPUT ON; 
declare
    out_result varchar2(24);
begin
--    save_person_hobby('배고운','밥',1,out_result); --no_data_found 예외
    save_person_hobby('김승현','단백질먹기',20,out_result); --others 예외
    dbms_output.put_line(out_result);
end;
/
 select id
    from t_person_info
    where name = :v_name;   --프로시저 내부에 있는 쿼리문 따로 가져와 실행시켜볼때
                        --변수로 선언돼있어 실행 안되니 = 옆에 : 을 붙이면 검색창을 실행할 수 있다.
                        

                            ---------------------------
                            
CREATE OR REPLACE PROCEDURE CURSOR_TEST --선언부
--() 파라미터 선언부
IS --변수선언부
    CURSOR hobby_list IS
        SELECT (SELECT name
                        FROM t_person_info
                        where id = h1.id) name
                        ,no, hobby,prefer
                        from t_hobby_list h1;
                        
    v_name t_person_info.name%type;
    v_no t_hobby_list.no%type;
    v_hobby t_hobby_list.hobby%type;
    v_prefer t_hobby_list.prefer%type;
BEGIN --실행부
    
    OPEN hobby_list; --fetch 쓸땐  open/close 써야함
        LOOP
        --fetch 가 커서에(테이블에있는?) 있는 데이터 한줄 담아서 넘겨줌
        FETCH hobby_list INTO v_name,v_no,v_hobby,v_prefer;
        DBMS_OUTPUT.PUT_LINE(v_name||v_no||v_hobby||v_prefer);
        EXIT WHEN hobby_list%NOTFOUND; -- loop탈출
        END LOOP;
    CLOSE hobby_list;
    
     DBMS_OUTPUT.PUT_LINE('');
     
        FOR hobby_item IN hobby_list LOOP
            DBMS_OUTPUT.PUT_LINE(hobby_item.name||hobby_item.no||hobby_item.hobby||hobby_item.prefer);
        END LOOP;
--EXCEPTION 예외처리부
END CURSOR_TEST;

/
exec CURSOR_TEST;
/
--emp 테이블에 empno,ename,job  -> cursor담아서
--반복하면서 dbms출력하는 cursor_test2 프로시저
select empno,ename,job from emp;

CREATE OR REPLACE PROCEDURE CURSOR_TEST2
IS
    CURSOR emp_info IS
    select empno,ename,job from emp;
    
    v_empno emp.empno%type;
    v_ename emp.ename%type;
    v_job emp.job%type;
BEGIN
    FOR info IN emp_info LOOP
        DBMS_OUTPUT.PUT_LINE(info.empno||'-'||info.ename||'-'||info.job);
    END LOOP;
    
     DBMS_OUTPUT.PUT_LINE('');
    
    OPEN emp_info;
        LOOP
            FETCH emp_info INTO v_empno,v_ename,v_job;
            EXIT WHEN emp_info%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_empno||'-'||v_ename||'-'||v_job);
        END LOOP;
    CLOSE emp_info;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    FOR info IN ( select empno,ename,job from emp) LOOP
        DBMS_OUTPUT.PUT_LINE(info.empno||'-'||info.ename||'-'||info.job);
    END LOOP;
END CURSOR_TEST2;
/
EXEC CURSOR_TEST2;