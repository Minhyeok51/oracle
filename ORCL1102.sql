--[2022. 11. 02. 모닝퀴즈]
SELECT empno, ename , e.deptno,(select dname from dept where deptno = e.deptno) dname
FROM emp e;
--emp2 테이블에서 각 직원별 부하직원의 수를 출력 (본인 제외)
SELECT e.empno, e.name, e.position,
        (select count(*)
        from emp2
        where level >1
        connect by prior empno = pempno
        start with empno= e.empno)
        "부하직원의 수" 
        ,(select count(*)
        from emp2
        connect by prior empno = pempno
        start with empno= e.empno)
        "본인포함 구성원 수" 
FROM emp2 e ;

SELECT empno, name, subcnt, subcnt+1 "본인포함"
FROM
(
SELECT e.empno, e.name
    ,(select count(*)
        from emp2
        WHERE level > 1
        CONNECT BY PRIOR empno = pempno
        START WITH empno = e.empno) subcnt
FROM emp2 e
);

select * from dept;

--select count(*) --시작사람부터 부하직원들의 계층을 만들고 개수를 세니까 5
--select count(*) -1

---------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE plus10_point_by_name_and_stdno--선언부
--    (v_name IN VARCHAR2)--파라미터
        (v_stdno IN NUMBER,
        v_name IN HE_STUDENT8.NAME%TYPE
        )
    IS                                   --선언부
    BEGIN   
        --stdno와 name을 받아서 파라미터 값에 해당하는
        --각각의 point데이터를 10점씩 증가시키는 프로시저
        
        UPDATE HE_STUDENT8
        SET POINT = POINT +10
        WHERE name = v_name
        or stdno = v_stdno;
        COMMIT;
            --예외처리부
    END plus10_point_by_name_and_stdno;
    /
    
    exec plus10_point_by_name_and_stdno(2,'권성민');
    /
    SELECT * FROM HE_STUDENT8;
    
SELECT * FROM t_person_info;
SELECT * FROM t_hobby_list;
--
--delete FROM t_team_info;
--delete FROM t_person_info;
--delete FROM t_hobby_list;
select tname from tab;
/
create or replace procedure save_person_info
(v_name IN t_person_info.name%type)
IS
BEGIN
    INSERT INTO t_person_info
    VALUES (T_PERSON_INFO_SEQ.nextval,v_name);
    COMMIT;
END save_person_info;
/
EXEC save_person_info('강수림');
EXEC save_person_info('강시은');
EXEC save_person_info('권성민');
EXEC save_person_info('김동하');
EXEC save_person_info('김승현');

/

create or replace procedure save_person_hobby --이름과 취미와 선호도를 받아서 저장하는 프로시저
(v_name IN t_person_info.name%type,
v_hobby IN t_hobby_list.hobby%type,
v_prefer IN t_hobby_list.prefer%type,
o_result OUT VARCHAR2)

IS
    v_save_id t_person_info.id%type;
    v_next_no t_hobby_list.no%type;
BEGIN
/*
save_person_hobby('강수림','잠자기',10);
select column
into 변수
from table
where 조건;
*/
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
END save_person_hobby;
    /


SET SERVEROUTPUT ON    -- DBMS_OUTPUT 실행해서 출력되도록 세팅

DECLARE 
    out_result varchar2(64);
BEGIN
     save_person_hobby('김동하','커피',3,out_result);
     DBMS_OUTPUT.PUT_LINE(out_result);  --println같은거
END;
/
SELECT * FROM t_person_info;
SELECT * FROM t_hobby_list
order by id,no;

/
------------------------PROCEDURE 비슷한 FUNCTION 함수----------------------------

CREATE OR REPLACE FUNCTION fc_sum_num
    (v_num1 IN NUMBER, v_num2 IN NUMBER)
    RETURN NUMBER --리턴형은 뭐다
    IS
        v_result NUMBER;
    BEGIN
        SELECT v_num1 + v_num2
        INTO v_result
        FROM dual;
        RETURN v_result;
    END; 

/
SELECT fc_sum_num(5,9) FROM dual;

SELECT empno,ename,sal,comm, FC_SUM_NUM(sal,nvl(comm,0)) 덧셈결과
from emp;

select id,(select name from t_person_info where id =h1.id),no,hobby,prefer 
from t_hobby_list h1;
/
CREATE OR REPLACE FUNCTION find_person_name_by_id
    (f_id in t_person_info.id%type)
    RETURN VARCHAR2 --리턴형은 뭐다
    IS
        v_result VARCHAR2(24);
--        v_result t_person_info.name%type;
    BEGIN
        SELECT name
        INTO v_result
        FROM t_person_info
        where id = f_id;
        RETURN v_result;
    END; 

/

--1.
select find_person_name_by_id(41) from dual; 

select id,
find_person_name_by_id(h1.id) name
,no,hobby,prefer 
from t_hobby_list h1;


/
CREATE OR REPLACE FUNCTION get_count_slave
    (v_empno in emp2.empno%type)
    RETURN number --리턴형은 뭐다
    IS
        v_result number;
    BEGIN
        SELECT count(*)
        INTO v_result
        FROM emp2 
        where level > 1 
        connect by prior empno = pempno
        start with empno = v_empno;
        RETURN v_result;
    END; 

/
--2.
select empno,name,get_count_slave(empno) "부하직원의 수" from emp2;

                    ----------------------------
/
CREATE OR REPLACE FUNCTION message_by_prefer
    (v_prefer In t_hobby_list.prefer%type)
    RETURN VARCHAR2
    IS
        v_result VARCHAR2(16);
    BEGIN
        --1~10 --1~4 별로 5~7 적정 8~10 좋음
        IF(v_prefer BETWEEN 1 AND 4) THEN 
            v_result :='별로';
        ELSIF(v_prefer BETWEEN 5 AND 7) THEN 
            v_result :='적정';
        ELSIF(v_prefer BETWEEN 8 AND 10) THEN 
            v_result :='좋음';
        ELSE
            v_result := '아주좋음';
        END IF;
        --ELSE IF = ELSIF
        RETURN v_result;
    END;
/

select id,find_person_name_by_id(id) name
        ,no,hobby,prefer
        ,message_by_prefer(prefer) msg
from t_hobby_list
order by id,no;

/
----------------------------반복문(for...loop)-------------------------
--while문
--loop

CREATE OR REPLACE PROCEDURE test_plsql
IS
    v_cnt number;
BEGIN
    FOR cnt IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('cnt : ' || cnt);
    END LOOP;
    
    FOR person_info IN (select id,name from t_person_info) LOOP
        DBMS_OUTPUT.PUT_LINE('id : ' || person_info.id || ' name : ' || person_info.name);
        
        --사람 정보를 가져와서 사람정보별로 (행별로)
        --출근정보 저장
        --재직정보 업데이트
        --오늘자 소속 데이터 업데이트
    END LOOP;
    
    v_cnt :=1;
    WHILE v_cnt <5 loop
        dbms_output.put_line(v_cnt||' - WHILE문');
        v_cnt := v_cnt +1;
    end loop;
        
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_cnt||' - 여긴 그냥 LOOP');
        v_cnt := v_cnt +1;
        
        EXIT WHEN v_cnt >=10;
    END LOOP;
    
    FOR HOBBY IN (SELECT * FROM T_HOBBY_LIST ORDER BY ID,NO) LOOP
        DBMS_OUTPUT.PUT_LINE('ID : '||HOBBY.ID||' NO : '||HOBBY.NO
        ||' HOBBY : '||HOBBY.HOBBY||' PREFER : '||HOBBY.PREFER);
        
    END LOOP;
END test_plsql;
/
exec test_plsql;