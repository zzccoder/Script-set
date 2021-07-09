/*
	TRY...CATCH 使用错误函数来捕获错误信息。
	ERROR_NUMBER() 返回错误号。    
	ERROR_MESSAGE() 返回错误消息的完整文本。
					此文本包括为任何可替换参数（如长度、对象名称或时间）提供的值。    
	ERROR_SEVERITY() 返回错误严重性。    
	ERROR_STATE() 返回错误状态号。    
	ERROR_LINE() 返回导致错误的例程中的行号。    
	ERROR_PROCEDURE() 返回出现错误的存储过程或触发器的名称。
*/





--错误消息存储过程
if (object_id('proc_error_info') is not null)    
	drop procedure proc_error_info
go
create proc proc_error_info
as    
select         
        error_number() '错误编号',
        error_message() '错误消息',        
        error_severity() '严重性',        
        error_state() '状态好',        
        error_line() '错误行号',        
        error_procedure() '错误对象(存储过程或触发器)名称';
        
        
 --异常处理，能处理存储过程（触发器）中（不存在表对象）的错误信息
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