USE BD_1110A
GO
/*
   ʹ���α������ֻ����Ĳ���:�����αꡢ���αꡢ��ȡ���ݡ��ر��αꡣ 
   
һ 1�������α�Ļ�����ʽ��

	DECLARE �α����� [INSENSITIVE] [SCROLL]
    CURSOR FOR select��� 
   [FOR{READ ONLY|UPDATE[OF �����ֱ�]}]
	
   2���������:
	
	insensitive ѡ��: ˵����������α���ʹ��select����ѯ����Ŀ���,
					���α�Ĳ��������ڸÿ�������,���,���ڼ���α�
					������������޸Ĳ��ܷ�ӳ���α���,�����α�Ҳ������ͨ�����޸Ļ���������ݡ�
					
	scrollѡ�ָ�����α�������е��α����ݶ�λ������ȡ���ݣ�
				�α궨λ��������
				prior�����ȵģ���first����һ����last����󣩡�
				absolute�����Եģ� n ��relative����ԣ� n ѡ��
				
	Select��䣺Ϊ��׼��select��ѯ��䣬���ѯ���Ϊ�α�����ݼ��ϣ�
				�����α����ݼ��ϵ�һ������������α�Ļ���
				���α���������У�����������֮һʱ��
				ϵͳ�Զ����α궨��Ϊ��insensitive���α꣺
				SELECT�����ʹ����
				��distinct�����Եģ�����union�����ϵģ�����GROUP BY�����飩�� ��HAVING�����У��ȹؼ��֣�
				 ��һ���α�����в�����Ψһ������
	read only ѡ�˵������ֻ���αꡣ
	
	update [OF �����ֱ�]ѡ������α���޸ĵ��С����ʹ��OF �����ֱ�ѡ�
	                          ˵��ֻ�����޸���ָ�����У����������о����޸ġ� 
	  
 */
 
declare authors_cursor cursor for
select name from [user]
where name like '��%'
order by name

open authors_cursor     --���α�  �ڴ�ʱ������һ����ʱ����������α����ݼ��ϴ�������п��������� 

-----------�α�򿪺󣬿��Դ�ȫ�ֱ���@@CURSOR_ROWS�ж�ȡ�α��������е�������
 
 
/*
 �� 1�����α����еĵ�ǰԪ��
 
		 FETCH [[NEXT|PRIOR|FIRST|LAST| ABSOLUTE n| RELATIVE n]  
		 FROM  �α���
		 [INTO @����1, @����2, ��.]
		 
	2��	�������:
	
	 NEXT��˵����ȡ�α��е���һ�У�
	       ��һ�ζ��α�ʵ�ж�ȡ����ʱ��
	       NEXT���ؽ�������еĵ�һ�С�
	       
	PRIOR��FIRST��LAST��ABSOLUTE n ��RELATIVE n ѡ��ֻ������SCROLL�αꡣ
			   fetch first; ��ȡ��һ��
 
             fetch next; ��ȡ��һ��
 
             fetch prior; ��ȡ��һ��
 
             fetch last; ��ȡ���һ��
 
             fetch absolute n; ��ȡĳһ��
	 
					���nΪ�����������ȡ��n����¼
	 
					���nΪ������������ȡ��n����¼
	 
					���nΪ���򲻶�ȡ�κμ�¼
 
             fetch pelative n
 
					���nΪ�����������ȡ�ϴζ�ȡ��¼֮���n����¼
	 
					���nΪ���������ȡ�ϴζ�ȡ��¼֮ǰ��n����¼
	 
					���nΪ�����ȡ�ϴζ�ȡ�ļ�¼

			
	INTO�Ӿ� ˵������ȡ�����ݴ�ŵ�ָ���ľֲ������У�
			ÿһ����������������Ӧ���α������ص����������ϸ�ƥ�䣬
			���򽫲�������		 
*/

 

fetch next from authors_cursor  ---��ȡ�α�
FETCH RELATIVE 2 FROM authors_cursor

/*
�� 1�� �����α��޸�����
		update����delete���Ҳ֧���α������
		���ǿ���ͨ���α��޸Ļ�ɾ���α�����еĵ�ǰ�����С�
		
	UPDATE���ĸ�ʽΪ��
		 UPDATE table_name
		 SET ����=���ʽ}[,��n]
		 WHERE CURRENT OF authors_cursor
		 DELETE���ĸ�ʽΪ��
		 DELETE FROM table_name
		 WHERE CURRENT OF authors_cursor
		 
	2�� ������⣺
		
		CURRENT OF authors_cursor��
				��ʾ��ǰ�α�ָ����ָ�ĵ�ǰ�����ݡ�
				CURRENT OF ֻ����UPDATE��DELETE�����ʹ�á�  
*/
use BD_1110A
CLOSE authors_cursor    --close �ر��α�
DEALLOCATE authors_cursor  ----ɾ���α�
Go

create procedure [pro_cusor]    ----�����洢����
as
begin
declare mycusor cursor for
select  name from [user] 
open mycusor 
declare @name nvarchar(10)
fetch next from mycusor into @name
while(@@FETCH_STATUS=0)
begin
	DELETE FROM NewUser WHERE Name =@name
     fetch next from mycusor into @name
end 
close mycusor
deallocate mycusor
end
-------------------���洴��һ�����α�Ĵ洢����---------------
exec  pro_cusor    -----ִ�д洢����


select * from NewUser
select * from [user]

  --����һ���α�
	declare cursor_stu cursor scroll for
	select [sid], sname, age from student;
	--���α�
	open cursor_stu;
	--�洢��ȡ��ֵ
	declare	@id int, 
			@sname varchar(20),
	        @age int;
	--��ȡ��һ����¼
	fetch first from cursor_stu into @id, @sname, @age;
	--ѭ����ȡ�α��¼
	print '��ȡ���������£�';
	--ȫ�ֱ���
	while (@@fetch_status = 0)
	begin    
	print  @sname
	--������ȡ��һ����¼    
	fetch next from cursor_stu into @id, @sname, @age;
	end
	--�ر��α�
	close cursor_stu;
	--ɾ���α�--
	deallocate cursor_stu;



