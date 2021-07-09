 /*
 ������4�����ԣ�
    ԭ���ԣ�Atomicity����һ���ԣ�Consistency���������ԣ�Isolation���Լ��־��ԣ�Durability����
    Ҳ���������ACID���ԡ�
 
        ԭ���ԣ������ڵ����й���Ҫôȫ����ɣ�Ҫôȫ������ɣ�������ֻ��һ������ɵ������
 
        һ���ԣ������ڵ�Ȼ�����������Υ�����ݿ��Ȼ��Լ��������������ʱ���ڲ����ݽṹ����������ȷ�ġ�
 
        �����ԣ�����ֱ�����໥����ģ���������������ͬһ�����ݿ���в����������ȡ�����ݡ�
                �κ�һ�����񿴵�����������Ҫô�������������֮ǰ��״̬��Ҫô�������������֮���״̬��
                һ�����񲻿���������һ��������м�״̬��
 
        �־��ԣ��������֮���������ݿ�ϵͳ��Ӱ���ǳ־õģ���ʹ��ϵͳ������������ϵͳ�󣬸�����Ľ����Ȼ���ڡ�
*/
-----------------------------������-----------------------------
  /*  3�� ������
 
        ����T-SQL������䣺
 
        a�� begin transaction���
 
        ��ʼ���񣬶�@@trancountȫ�ֱ���������¼�������Ŀֵ��1��������@@errorȫ�ֱ�����¼ִ�й����еĴ�����Ϣ�����û�д������ֱ���ύ�����д�����Իع���
 
        b�� commit transaction���
 
        �ع����񣬱�ʾһ����ʽ����ʾ������Ľ����������ݿ��������޸���ʽ��Ч������@@trancount��ֵ��1��
 
        c�� rollback transaction���
 
        �ع�����ִ��rollback tran�������ݻ�ع���begin tran��ʱ���״̬
*/


begin transaction tran_bank;     ---��ʼ����
declare @tran_error int;          ----����һ���������
    set @tran_error = 0;        
        begin try
				update [user] set name = '�̲�' where name = '�̲�';
				 set @tran_error = @tran_error + @@error;
        end try 
       begin catch   
			 print '�����쳣�������ţ�' + convert(varchar, error_number()) + '�� ������Ϣ��' + error_message(); 
			 set @tran_error = @tran_error + 1;
      end catch
		  if (@tran_error > 0)   
			begin        --ִ�г����ع�����        
				rollback tran;       
				print 'ת��ʧ�ܣ�ȡ������';    
			end
		  else   
			 begin        --û���쳣���ύ���� 
				commit tran; 
				print 'ת�˳ɹ�';
			 end

