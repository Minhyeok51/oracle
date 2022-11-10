CREATE TABLE t_person_info2(
    id number(4),
    name varchar2(24)
);
select * from t_person_info2;
--delete from t_person_info2 where id =25;

SELECT NVL(max(id),0) +1 from t_person_info2;

INSERT INTO t_person_info2 VALUES(1,'강시은');
INSERT INTO t_person_info2 VALUES(2,'강수림');
INSERT INTO t_person_info2 VALUES(3,'권성민');
INSERT INTO t_person_info2 VALUES(4,'김동하');
INSERT INTO t_person_info2 VALUES(5,'김승현');
INSERT INTO t_person_info2 VALUES(6,'배고운');
INSERT INTO t_person_info2 VALUES(7,'빙예은');
INSERT INTO t_person_info2 VALUES(8,'신동호');
INSERT INTO t_person_info2 VALUES(9,'안시현');
INSERT INTO t_person_info2 VALUES(10,'윤서연');
INSERT INTO t_person_info2 VALUES(11,'이광민');
INSERT INTO t_person_info2 VALUES(12,'이다연');
INSERT INTO t_person_info2 VALUES(13,'이다정');
INSERT INTO t_person_info2 VALUES(14,'이민준');
INSERT INTO t_person_info2 VALUES(15,'이민혁');
INSERT INTO t_person_info2 VALUES(16,'이정현');
INSERT INTO t_person_info2 VALUES(17,'이주혁');
INSERT INTO t_person_info2 VALUES(18,'임규진');
INSERT INTO t_person_info2 VALUES(19,'정혜린');
INSERT INTO t_person_info2 VALUES(20,'정혜연');
INSERT INTO t_person_info2 VALUES(21,'조은결');
INSERT INTO t_person_info2 VALUES(22,'최정우');
INSERT INTO t_person_info2 VALUES(23,'한혁주');
INSERT INTO t_person_info2 VALUES(24,'홍준표');