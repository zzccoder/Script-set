with tableA as
(
     select '201309' ym,'张三' name,'01' nameid,'济南' adress from dual union all
     select '201309' ym,'丢丢' name,'02' nameid,'北京' adress from dual 
),tableB as
(
     select '201308' ym,'李四' name,'01' nameid,'南京' adress from dual union all
     select '201308' ym,'豆豆' name,'02' nameid,'北京' adress from dual 
)
 
select ym,nameid,'A' tbCode,'name' fdCode,n1 last,n2 end
from (select a.nameid,a.ym,a.name n1,b.name n2 from tableA a left join tableB b on a.nameid = b.nameid
where a.name<>b.name )	
union all
select ym,nameid,'A' tbCode,'adress' fdCode,a1 last,a2 end
from (select a.nameid,a.ym,a.adress a1,b.adress a2 from tableA a left join tableB b on a.nameid = b.nameid
where a.adress<>b.adress)


     ym   nameid   tbCode  fdCode  last  end
-----------------------------------------------------------
1    201309    01    A    name    张三    李四
2    201309    02    A    name    丢丢    豆豆
3    201309    01    A    adress    济南    南京