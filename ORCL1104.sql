--[2022. 11. 04. �������]

/*
�Ʒ� �� ���� ���̺��� �����Ͻÿ�.
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

���߰� ���� : ���ν��� ���� CURSOR�� Ȱ���Ͽ� �ۼ��Ͻÿ�.

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
    --ó���� ����. 2��. insert into select from
--    INSERT INTO high_hobby_list
--    SELECT (SELECT name 
--     FROM t_person_info 
--       where id = hl.id) name
--       ,hobby, DECODE(no, 1, '1����', null) etc
--       FROM t_hobby_list hl
--       WHERE prefer BETWEEN 6 AND 10;
--
--    INSERT INTO low_hobby_list
--    SELECT (SELECT name 
--     FROM t_person_info 
--       where id = hl.id) name
--       ,hobby, DECODE(no, 1, '1����', null) etc
--       FROM t_hobby_list hl
--       WHERE prefer BETWEEN 1 AND 5;


    --ó���� ����. 1�� FOR�� Ȱ��
    --��������
--    FOR hobby_item IN (SELECT (SELECT name 
--                               FROM t_person_info 
--                               where id = hl.id) name
--                               ,no ,hobby ,prefer
--                               FROM t_hobby_list hl) LOOP
        --3��. CURSOR ���
--        FOR hobby_item IN hobby_list LOOP
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
        
        --4��. CURSOR ��� + FETCH LOOP
        OPEN hobby_list;
            LOOP
                FETCH hobby_list INTO v_name, v_no, v_hobby, v_prefer;
                EXIT WHEN hobby_list%NOTFOUND;
                
                --�ݺ��� ���� ���� �κ�
                IF v_no = 1 THEN
                    v_etc := '1����';
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