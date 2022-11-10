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
select * from t_covid19_status where status_date = '22/11/09';

SELECT NVL(MAX(no),0) +1 FROM t_covid19_status
WHERE TO_CHAR(mmddhh,'YYYY-MM-DD') =TO_CHAR(sysdate,'YYYY-MM-DD');
--delete from t_covid19_status ;

drop table t_covid19_status;

--추가 옵션용
create table t_covid19_status(
status_date date ,
cnt_deaths number,
cnt_severe_symptoms number,
cnt_hospitalizations number,
cnt_confirmations number,
no number
);

select * from t_covid19_status2;

create table t_covid19_status2(
status_date date ,
cnt_deaths number,
cnt_severe_symptoms number,
cnt_hospitalizations number,
cnt_confirmations number,
CONSTRAINT PK_t_covid19_status PRIMARY KEY(status_date)
);

update t_covid19_status2 set cnt_deaths =0 , cnt_severe_symptoms=0 , cnt_hospitalizations =0
				,cnt_confirmations =0
				where status_date = to_char(sysdate,'YY-MM-DD');
                
select to_char(status_date, 'YYYYMMDD HHMISS') from t_covid19_status2;
                
MERGE 
 INTO t_covid19_status2 c
USING dual 
   ON (c.status_date = to_char(sysdate,'YY-MM-DD'))--'22-11-10'
 WHEN MATCHED THEN
      UPDATE
         SET c.cnt_deaths =120 , c.cnt_severe_symptoms=440 , c.cnt_hospitalizations =540
				,c.cnt_confirmations =70
 WHEN NOT MATCHED THEN
      INSERT (c.status_date,c.cnt_deaths , c.cnt_severe_symptoms , c.cnt_hospitalizations 
				,c.cnt_confirmations )
      VALUES ('22/11/10', 130, 120,256,55);
      
select * from t_covid19_status2;

delete from t_covid19_status2 where status_date = '22/11/09';