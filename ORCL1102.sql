--[2022. 11. 02. �������]
SELECT empno, ename , e.deptno,(select dname from dept where deptno = e.deptno) dname
FROM emp e;
--emp2 ���̺��� �� ������ ���������� ���� ��� (���� ����)
SELECT e.empno, e.name, e.position,
        (select count(*)
        from emp2
        where level >1
        connect by prior empno = pempno
        start with empno= e.empno)
        "���������� ��" 
        ,(select count(*)
        from emp2
        connect by prior empno = pempno
        start with empno= e.empno)
        "�������� ������ ��" 
FROM emp2 e ;

SELECT empno, name, subcnt, subcnt+1 "��������"
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

--select count(*) --���ۻ������ ������������ ������ ����� ������ ���ϱ� 5
--select count(*) -1

---------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE plus10_point_by_name_and_stdno--�����
--    (v_name IN VARCHAR2)--�Ķ����
        (v_stdno IN NUMBER,
        v_name IN HE_STUDENT8.NAME%TYPE
        )
    IS                                   --�����
    BEGIN   
        --stdno�� name�� �޾Ƽ� �Ķ���� ���� �ش��ϴ�
        --������ point�����͸� 10���� ������Ű�� ���ν���
        
        UPDATE HE_STUDENT8
        SET POINT = POINT +10
        WHERE name = v_name
        or stdno = v_stdno;
        COMMIT;
            --����ó����
    END plus10_point_by_name_and_stdno;
    /
    
    exec plus10_point_by_name_and_stdno(2,'�Ǽ���');
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
EXEC save_person_info('������');
EXEC save_person_info('������');
EXEC save_person_info('�Ǽ���');
EXEC save_person_info('�赿��');
EXEC save_person_info('�����');

/

create or replace procedure save_person_hobby --�̸��� ��̿� ��ȣ���� �޾Ƽ� �����ϴ� ���ν���
(v_name IN t_person_info.name%type,
v_hobby IN t_hobby_list.hobby%type,
v_prefer IN t_hobby_list.prefer%type,
o_result OUT VARCHAR2)

IS
    v_save_id t_person_info.id%type;
    v_next_no t_hobby_list.no%type;
BEGIN
/*
save_person_hobby('������','���ڱ�',10);
select column
into ����
from table
where ����;
*/
    select id
    into v_save_id
    from t_person_info
    where name = v_name;
    
    select nvl(max(no),0)+1 
    into v_next_no
    from t_hobby_list 
    where id=v_save_id;
    
    --���� ������ ������ ���� ���� �����ϰ� insertó���ϴ� ������� �ٲ���
    
    insert into t_hobby_list
--    values (v_save_id,(select nvl(max(no),0)+1 from t_hobby_list where id=v_save_id),v_hobby,v_prefer);
    values (v_save_id,v_next_no,v_hobby,v_prefer);
    
    o_result := v_save_id||'-'||v_next_no||'-'||v_hobby||'-'||v_prefer;
    
    commit;
END save_person_hobby;
    /


SET SERVEROUTPUT ON    -- DBMS_OUTPUT �����ؼ� ��µǵ��� ����

DECLARE 
    out_result varchar2(64);
BEGIN
     save_person_hobby('�赿��','Ŀ��',3,out_result);
     DBMS_OUTPUT.PUT_LINE(out_result);  --println������
END;
/
SELECT * FROM t_person_info;
SELECT * FROM t_hobby_list
order by id,no;

/
------------------------PROCEDURE ����� FUNCTION �Լ�----------------------------

CREATE OR REPLACE FUNCTION fc_sum_num
    (v_num1 IN NUMBER, v_num2 IN NUMBER)
    RETURN NUMBER --�������� ����
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

SELECT empno,ename,sal,comm, FC_SUM_NUM(sal,nvl(comm,0)) �������
from emp;

select id,(select name from t_person_info where id =h1.id),no,hobby,prefer 
from t_hobby_list h1;
/
CREATE OR REPLACE FUNCTION find_person_name_by_id
    (f_id in t_person_info.id%type)
    RETURN VARCHAR2 --�������� ����
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
    RETURN number --�������� ����
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
select empno,name,get_count_slave(empno) "���������� ��" from emp2;

                    ----------------------------
/
CREATE OR REPLACE FUNCTION message_by_prefer
    (v_prefer In t_hobby_list.prefer%type)
    RETURN VARCHAR2
    IS
        v_result VARCHAR2(16);
    BEGIN
        --1~10 --1~4 ���� 5~7 ���� 8~10 ����
        IF(v_prefer BETWEEN 1 AND 4) THEN 
            v_result :='����';
        ELSIF(v_prefer BETWEEN 5 AND 7) THEN 
            v_result :='����';
        ELSIF(v_prefer BETWEEN 8 AND 10) THEN 
            v_result :='����';
        ELSE
            v_result := '��������';
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
----------------------------�ݺ���(for...loop)-------------------------
--while��
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
        
        --��� ������ �����ͼ� ����������� (�ະ��)
        --������� ����
        --�������� ������Ʈ
        --������ �Ҽ� ������ ������Ʈ
    END LOOP;
    
    v_cnt :=1;
    WHILE v_cnt <5 loop
        dbms_output.put_line(v_cnt||' - WHILE��');
        v_cnt := v_cnt +1;
    end loop;
        
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_cnt||' - ���� �׳� LOOP');
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