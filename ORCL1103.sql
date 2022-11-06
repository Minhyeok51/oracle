/*
[2022. 11. 03. �������]


�Ʒ� �� ���� ���̺��� ���� �����ϰ� �����Ͻÿ�.
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

save_hobby_split ���ν����� ���� �� �� �����ؼ� ����� Ȯ���Ͻÿ�.
* ��ȣ�� ������ ���� ���� �ٸ� ���̺� �ʿ��� �����͸� �����ϴ� ���ν���.
* �Ʒ� ���ǿ� �����ϵ��� �����Ͻÿ�.
* ���� ���̺� : t_hobby_list, t_person_info

��� ����� ������ �ִ� t_hobby_list ���� ��ȣ��(prefer) ������ ��������
1~5 ���� low_hobby_list �� �����ϰ�
6~10 ���� high_hobby_list �� �����Ͻÿ�.

name : �ش� hobby�� ���� ���(ID)�� �̸�
hobby : ��� ���� �״��
etc : ��� �� ������ 1��°�� ����� ��� '1����' �� ����
�� ��(1������ �ƴѰ��� ) �׳� null �� ����
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
    --ó���� ����. 2��. insert into select from
    INSERT INTO high_hobby_list
    SELECT (SELECT name 
     FROM t_person_info 
       where id = hl.id) name
       ,hobby, DECODE(no, 1, '1����', null) etc
       FROM t_hobby_list hl
       WHERE prefer BETWEEN 6 AND 10;
    
    INSERT INTO low_hobby_list
    SELECT (SELECT name 
     FROM t_person_info 
       where id = hl.id) name
       ,hobby, DECODE(no, 1, '1����', null) etc
       FROM t_hobby_list hl
       WHERE prefer BETWEEN 1 AND 5;


    --ó���� ����. 1�� FOR�� Ȱ��
    --��������
--    FOR hobby_item IN (SELECT (SELECT name 
--                               FROM t_person_info 
--                               where id = hl.id) name
--                               ,no ,hobby ,prefer
--                               FROM t_hobby_list hl) LOOP
--        --�ݺ��� ���� ���� �κ�
--        IF hobby_item.no = 1 THEN
--            v_etc := '1����';
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
--    --�Լ����� Ȱ��
--    SELECT find_person_name_by_id(id) name, no, hobby, prefer
--    FROM t_hobby_list;
--    
--    --����
--    SELECT pi.name, hl.no, hl.hobby, hl.prefer
--    FROM t_hobby_list hl, t_person_info pi
--    WHERE hl.id = pi.id;
END save_hobby_split;
/
exec save_hobby_split;
/
------------------------------------------------------------------------------
create or replace NONEDITIONABLE procedure save_person_hobby --�̸��� ��̿� ��ȣ���� �޾Ƽ� �����ϴ� ���ν���
(v_name IN t_person_info.name%type,
v_hobby IN t_hobby_list.hobby%type,
v_prefer IN t_hobby_list.prefer%type,
o_result OUT VARCHAR2)

IS
    v_save_id t_person_info.id%type;
    v_next_no t_hobby_list.no%type;
    prefer_error EXCEPTION;--EXCEPTION ���� (����� ���� ����)
    input_null_error EXCEPTION;
    invalid_value_input_error EXCEPTION;
BEGIN
/*
save_person_hobby('������','���ڱ�',10);
select column
into ����
from table
where ����;
*/
    IF NOT V_PREFER BETWEEN 1 AND 10 THEN
        DBMS_OUTPUT.PUT_LINE('V_PREFER �� 1~10�� �����մϴ�.');
--        RETURN;
        RAISE prefer_error;
--        RAISE_APPLICATION_ERROR(-20001,'V_PREFER �� 1~10�� �����մϴ�.');
    END IF;
    
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
    
    exception 
        when no_data_found then --������ ��ã����
            ROLLBACK;
            dbms_output.put_line('no_data_found ����');
        when too_many_rows then -- ã���� ������ �ʹ� ������..
            ROLLBACK;
            dbms_output.put_line('too_many_rows ����');
        WHEN PREFER_ERROR THEN 
        DBMS_OUTPUT.PUT_LINE('V_PREFER �� 1~10�� �����մϴ�.');
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001,'V_PREFER �� 1~10�� �����մϴ�.');
        --20000~20999 ���� ����� ���� �ڵ�
        WHEN input_null_error THEN
        ROLLBACK;
        when others then --�� �ܿ� ���̽���
            ROLLBACK;
            dbms_output.put_line('others ����');
            
END save_person_hobby;
/
--EXCEPTION
--�����
--�����
--����ó����
select * from t_hobby_list;
select * from t_person_info;
SET SERVEROUTPUT ON; 
declare
    out_result varchar2(24);
begin
--    save_person_hobby('����','��',1,out_result); --no_data_found ����
    save_person_hobby('�����','�ܹ����Ա�',20,out_result); --others ����
    dbms_output.put_line(out_result);
end;
/
 select id
    from t_person_info
    where name = :v_name;   --���ν��� ���ο� �ִ� ������ ���� ������ ������Ѻ���
                        --������ ������־� ���� �ȵǴ� = ���� : �� ���̸� �˻�â�� ������ �� �ִ�.
                        

                            ---------------------------
                            
CREATE OR REPLACE PROCEDURE CURSOR_TEST --�����
--() �Ķ���� �����
IS --���������
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
BEGIN --�����
    
    OPEN hobby_list; --fetch ����  open/close �����
        LOOP
        --fetch �� Ŀ����(���̺��ִ�?) �ִ� ������ ���� ��Ƽ� �Ѱ���
        FETCH hobby_list INTO v_name,v_no,v_hobby,v_prefer;
        DBMS_OUTPUT.PUT_LINE(v_name||v_no||v_hobby||v_prefer);
        EXIT WHEN hobby_list%NOTFOUND; -- loopŻ��
        END LOOP;
    CLOSE hobby_list;
    
     DBMS_OUTPUT.PUT_LINE('');
     
        FOR hobby_item IN hobby_list LOOP
            DBMS_OUTPUT.PUT_LINE(hobby_item.name||hobby_item.no||hobby_item.hobby||hobby_item.prefer);
        END LOOP;
--EXCEPTION ����ó����
END CURSOR_TEST;

/
exec CURSOR_TEST;
/
--emp ���̺� empno,ename,job  -> cursor��Ƽ�
--�ݺ��ϸ鼭 dbms����ϴ� cursor_test2 ���ν���
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