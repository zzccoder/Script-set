 /*
 事务有4个属性：
    原子性（Atomicity）、一致性（Consistency）、隔离性（Isolation）以及持久性（Durability），
    也称作事务的ACID属性。
 
        原子性：事务内的所有工作要么全部完成，要么全部不完成，不存在只有一部分完成的情况。
 
        一致性：事务内的然后操作都不能违反数据库的然后约束或规则，事务完成时有内部数据结构都必须是正确的。
 
        隔离性：事务直接是相互隔离的，如果有两个事务对同一个数据库进行操作，比如读取表数据。
                任何一个事务看到的所有内容要么是其他事务完成之前的状态，要么是其他事务完成之后的状态。
                一个事务不可能遇到另一个事务的中间状态。
 
        持久性：事务完成之后，它对数据库系统的影响是持久的，即使是系统错误，重新启动系统后，该事务的结果依然存在。
*/
-----------------------------事务处理-----------------------------
  /*  3、 事务处理
 
        常用T-SQL事务语句：
 
        a、 begin transaction语句
 
        开始事务，而@@trancount全局变量用来记录事务的数目值加1，可以用@@error全局变量记录执行过程中的错误信息，如果没有错误可以直接提交事务，有错误可以回滚。
 
        b、 commit transaction语句
 
        回滚事务，表示一个隐式或显示的事务的结束，对数据库所做的修改正式生效。并将@@trancount的值减1；
 
        c、 rollback transaction语句
 
        回滚事务，执行rollback tran语句后，数据会回滚到begin tran的时候的状态
*/


begin transaction tran_bank;     ---开始事务
declare @tran_error int;          ----声明一个错误变量
    set @tran_error = 0;        
        begin try
				update [user] set name = '继波' where name = '继波';
				 set @tran_error = @tran_error + @@error;
        end try 
       begin catch   
			 print '出现异常，错误编号：' + convert(varchar, error_number()) + '， 错误消息：' + error_message(); 
			 set @tran_error = @tran_error + 1;
      end catch
		  if (@tran_error > 0)   
			begin        --执行出错，回滚事务        
				rollback tran;       
				print '转账失败，取消交易';    
			end
		  else   
			 begin        --没有异常，提交事务 
				commit tran; 
				print '转账成功';
			 end

