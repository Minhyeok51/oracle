--기본 insert용
create table t_covid19_status(
mmddhh varchar2(24),
cnt_deaths number(5),
cnt_severe_symptoms number(10),
cnt_hospitalizations number(10),
cnt_confirmations number(10)
);

alter table t_covid19_status
modify mmddhh  date;

select to_char(mmddhh,'YYYY-MM-DD HH24:MI:SS') from t_covid19_status;
select * from t_covid19_status;

SELECT NVL(MAX(no),0) +1 FROM t_covid19_status
WHERE TO_CHAR(mmddhh,'YYYY-MM-DD') =TO_CHAR(sysdate,'YYYY-MM-DD');
--delete from t_covid19_status ;

drop table t_covid19_status;

--추가 옵션용
create table t_covid19_status(
mmddhh date,
cnt_deaths number,
cnt_severe_symptoms number,
cnt_hospitalizations number,
cnt_confirmations number,
no date
);