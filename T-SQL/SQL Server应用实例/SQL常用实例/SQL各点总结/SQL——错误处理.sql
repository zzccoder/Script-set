/*
	TRY...CATCH ʹ�ô����������������Ϣ��
	ERROR_NUMBER() ���ش���š�    
	ERROR_MESSAGE() ���ش�����Ϣ�������ı���
					���ı�����Ϊ�κο��滻�������糤�ȡ��������ƻ�ʱ�䣩�ṩ��ֵ��    
	ERROR_SEVERITY() ���ش��������ԡ�    
	ERROR_STATE() ���ش���״̬�š�    
	ERROR_LINE() ���ص��´���������е��кš�    
	ERROR_PROCEDURE() ���س��ִ���Ĵ洢���̻򴥷��������ơ�
*/





--������Ϣ�洢����
if (object_id('proc_error_info') is not null)    
	drop procedure proc_error_info
go
create proc proc_error_info
as    
select         
        error_number() '������',
        error_message() '������Ϣ',        
        error_severity() '������',        
        error_state() '״̬��',        
        error_line() '�����к�',        
        error_procedure() '�������(�洢���̻򴥷���)����';
        
        
 --�쳣�����ܴ���洢���̣����������У������ڱ���󣩵Ĵ�����Ϣ
 if (object_id('proc_select') is not null)    
		drop procedure proc_select
 go
 create proc proc_select
	as    
	select * from [user];
 go
 begin 
 try    
	exec proc_select;
 end try
 
 begin  
 catch        
	exec proc_error_info;
 end catchgo