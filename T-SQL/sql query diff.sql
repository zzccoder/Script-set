val456.׼������̱�201712_test5030
val456.׼������̱�2017125030

BEL,���ձ߼�,ʣ��߼�,ʵ��׼����

select top 10 BEL,���ձ߼�,ʣ��߼�,ʵ��׼���� from val456.׼������̱�2017125030

select top 10 BEL,���ձ߼�,ʣ��߼�,ʵ��׼���� from val456.׼������̱�201712_test5030




select top 10 BEL,���ձ߼�,ʣ��߼�,ʵ��׼���� from val456.׼������̱�2017125030

select top 10 BEL,���ձ߼�,ʣ��߼�,ʵ��׼���� from val456.׼������̱�2017125030  
except
 select top 10 BEL AS BEL_test,���ձ߼� as ���ձ߼�test,ʣ��߼� as ʣ��߼�test,ʵ��׼���� as ʵ��׼����test from val456.׼������̱�201712_test5030 
 
 union all
  (select top 1 BEL,���ձ߼�,ʣ��߼�,ʵ��׼���� from val456.׼������̱�201712_test5030 
  except
   select top 1 BEL,���ձ߼�,ʣ��߼�,ʵ��׼���� from val456.׼������̱�2017125030)

