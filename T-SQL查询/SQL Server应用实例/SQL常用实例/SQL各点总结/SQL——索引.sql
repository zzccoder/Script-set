/*

  系统自建的索引：在使用T_sql语句创建表的时候使用PRIMARY KEY或UNIQUE约束时，
  会在表上自动创建一个惟一索引，自动创建的索引是无法删除的。
  
 */
create table ABC
( 
    empID int PRIMARY KEY,
    firstname varchar(50) UNIQUE,    
    lastname varchar(50) UNIQUE,
) 

drop table ABC
/*
       唯一索引：
				索引可以确保索引列不包含重复的值
				可以用多个列，但是索引可以确保索引列中每个值组合都是唯一的
	
*/

--语法： create unique index 这里填写索引器名称 on 表名(要索引的字段)


/*
         1、聚集索引：
				表中存储的数据按照索引的顺序存储，检索效率比普通索引高，索引占用硬盘
				存储空间小（1%左右），但对数据新增/修改/删除的速度影响比较大（降低）。
				 特点：
                  (1) 无索引，数据无序
                  (2) 有索引，数据与索引同序 
                  (3) 数据会根据索引键的顺序重新排列数据
                  (4) 一个表只能有一个索引
                  (5) 叶节点的指针指向的数据也在同一位置存储
                  
       clustered   关键字
  */
  
----语法：  create CLUSTERED INDEX 这里填写索引器名称 ON 表名(要索引的字段)

/*
	非聚集索引：
		不影响表中的数据存储顺序，检索效率比聚集索引低，
		索引占用硬盘存储空间大（30%~40%），
		对数据新增/修改/删除的影响很少。
         特点：
               (1) 一个表可以最多可以创建249个非聚集索引
               (2) 先建聚集索引才能创建非聚集索引
               (3) 非聚集索引数据与索引不同序
               (4) 数据与非聚集索引在不同位置
               (5) 非聚集索引在叶节点上存储，在叶节点上有一个“指针”直接指向要查询的数据区域
               (6) 数据不会根据非聚集索引键的顺序重新排列数据
               
		nonclustered   非聚集索引
         
         fillfactor    装填系数
         
        语法：create NONCLUSTERED INDEX 这里填写索引器名称 ON 表名(要索引的字段)   
       
  */
		
  /*--检测是否存在该索引(索引存放在系统表sysindexes中)----*/
  
  
IF EXISTS (SELECT name FROM sysindexes 
          WHERE name = 'IX_stuMarks_writtenExam')
          
          
          
   DROP INDEX [user].IndexUser  --删除索引
   
   
   
   /*-用户列创建聚集索引:填充因子为30％--*/
CREATE NONCLUSTERED INDEX IndexUser
   ON [user](name)
	   WITH FILLFACTOR= 30
	   GO
SELECT * FROM [user] 
 with (INDEX=IndexUser) 
    WHERE name like '李%';     ------执行索引
    
    --create nonclustered indexx indexuser
    --on [user](name)
    --with fillfactor
  
    --create 
    
    create clustered Index indexPages    ---创建聚集索引
	on Page(createTime)
    
