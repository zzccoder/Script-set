val456.准备金过程表201712_test5030
val456.准备金过程表2017125030

BEL,风险边际,剩余边际,实际准备金

select top 10 BEL,风险边际,剩余边际,实际准备金 from val456.准备金过程表2017125030

select top 10 BEL,风险边际,剩余边际,实际准备金 from val456.准备金过程表201712_test5030




select top 10 BEL,风险边际,剩余边际,实际准备金 from val456.准备金过程表2017125030

select top 10 BEL,风险边际,剩余边际,实际准备金 from val456.准备金过程表2017125030  
except
 select top 10 BEL AS BEL_test,风险边际 as 风险边际test,剩余边际 as 剩余边际test,实际准备金 as 实际准备金test from val456.准备金过程表201712_test5030 
 
 union all
  (select top 1 BEL,风险边际,剩余边际,实际准备金 from val456.准备金过程表201712_test5030 
  except
   select top 1 BEL,风险边际,剩余边际,实际准备金 from val456.准备金过程表2017125030)

