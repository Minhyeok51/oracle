CREATE TABLE t_person_info2(
    id number(4),
    name varchar2(24)
);
select * from t_person_info2;
--delete from t_person_info2 where id =25;

SELECT NVL(max(id),0) +1 from t_person_info2;

INSERT INTO t_person_info2 VALUES(1,'������');
INSERT INTO t_person_info2 VALUES(2,'������');
INSERT INTO t_person_info2 VALUES(3,'�Ǽ���');
INSERT INTO t_person_info2 VALUES(4,'�赿��');
INSERT INTO t_person_info2 VALUES(5,'�����');
INSERT INTO t_person_info2 VALUES(6,'����');
INSERT INTO t_person_info2 VALUES(7,'������');
INSERT INTO t_person_info2 VALUES(8,'�ŵ�ȣ');
INSERT INTO t_person_info2 VALUES(9,'�Ƚ���');
INSERT INTO t_person_info2 VALUES(10,'������');
INSERT INTO t_person_info2 VALUES(11,'�̱���');
INSERT INTO t_person_info2 VALUES(12,'�̴ٿ�');
INSERT INTO t_person_info2 VALUES(13,'�̴���');
INSERT INTO t_person_info2 VALUES(14,'�̹���');
INSERT INTO t_person_info2 VALUES(15,'�̹���');
INSERT INTO t_person_info2 VALUES(16,'������');
INSERT INTO t_person_info2 VALUES(17,'������');
INSERT INTO t_person_info2 VALUES(18,'�ӱ���');
INSERT INTO t_person_info2 VALUES(19,'������');
INSERT INTO t_person_info2 VALUES(20,'������');
INSERT INTO t_person_info2 VALUES(21,'������');
INSERT INTO t_person_info2 VALUES(22,'������');
INSERT INTO t_person_info2 VALUES(23,'������');
INSERT INTO t_person_info2 VALUES(24,'ȫ��ǥ');