/*

  ϵͳ�Խ�����������ʹ��T_sql��䴴�����ʱ��ʹ��PRIMARY KEY��UNIQUEԼ��ʱ��
  ���ڱ����Զ�����һ��Ωһ�������Զ��������������޷�ɾ���ġ�
  
 */
create table ABC
( 
    empID int PRIMARY KEY,
    firstname varchar(50) UNIQUE,    
    lastname varchar(50) UNIQUE,
) 

drop table ABC
/*
       Ψһ������
				��������ȷ�������в������ظ���ֵ
				�����ö���У�������������ȷ����������ÿ��ֵ��϶���Ψһ��
	
*/

--�﷨�� create unique index ������д���������� on ����(Ҫ�������ֶ�)


/*
         1���ۼ�������
				���д洢�����ݰ���������˳��洢������Ч�ʱ���ͨ�����ߣ�����ռ��Ӳ��
				�洢�ռ�С��1%���ң���������������/�޸�/ɾ�����ٶ�Ӱ��Ƚϴ󣨽��ͣ���
				 �ص㣺
                  (1) ����������������
                  (2) ������������������ͬ�� 
                  (3) ���ݻ������������˳��������������
                  (4) һ����ֻ����һ������
                  (5) Ҷ�ڵ��ָ��ָ�������Ҳ��ͬһλ�ô洢
                  
       clustered   �ؼ���
  */
  
----�﷨��  create CLUSTERED INDEX ������д���������� ON ����(Ҫ�������ֶ�)

/*
	�Ǿۼ�������
		��Ӱ����е����ݴ洢˳�򣬼���Ч�ʱȾۼ������ͣ�
		����ռ��Ӳ�̴洢�ռ��30%~40%����
		����������/�޸�/ɾ����Ӱ����١�
         �ص㣺
               (1) һ������������Դ���249���Ǿۼ�����
               (2) �Ƚ��ۼ��������ܴ����Ǿۼ�����
               (3) �Ǿۼ�����������������ͬ��
               (4) ������Ǿۼ������ڲ�ͬλ��
               (5) �Ǿۼ�������Ҷ�ڵ��ϴ洢����Ҷ�ڵ�����һ����ָ�롱ֱ��ָ��Ҫ��ѯ����������
               (6) ���ݲ�����ݷǾۼ���������˳��������������
               
		nonclustered   �Ǿۼ�����
         
         fillfactor    װ��ϵ��
         
        �﷨��create NONCLUSTERED INDEX ������д���������� ON ����(Ҫ�������ֶ�)   
       
  */
		
  /*--����Ƿ���ڸ�����(���������ϵͳ��sysindexes��)----*/
  
  
IF EXISTS (SELECT name FROM sysindexes 
          WHERE name = 'IX_stuMarks_writtenExam')
          
          
          
   DROP INDEX [user].IndexUser  --ɾ������
   
   
   
   /*-�û��д����ۼ�����:�������Ϊ30��--*/
CREATE NONCLUSTERED INDEX IndexUser
   ON [user](name)
	   WITH FILLFACTOR= 30
	   GO
SELECT * FROM [user] 
 with (INDEX=IndexUser) 
    WHERE name like '��%';     ------ִ������
    
    --create nonclustered indexx indexuser
    --on [user](name)
    --with fillfactor
  
    --create 
    
    create clustered Index indexPages    ---�����ۼ�����
	on Page(createTime)
    
