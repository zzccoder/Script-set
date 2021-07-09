select wp.product_id 产品编号,wp.confirm_bname 书名,wp.price 单价 ,wp.author 作者,wp.ori_pubtime 出版时间,
       wp.pclass_simple 所属大类, wp.pline_simple 所属小类,lev 审批等级,
       case is_sed when '1' then '已通过' else '未通过' end 出版部审核情况,bf.sed_datetime 出版部审核时间, 
       case is_thir when '1' then '已通过' else '未通过' end 印制部审核情况,bf.thir_datetime 印制部审核情况,
       case uploadSiteTime when null then '未审核' else '已审核' end 市场部是否审核 ,wp.uploadSiteTime 市场部审核时间from bw_flow bf inner join wz_product wp
     on bf.id=wp.product_id  
where bf.mark = 'wz_product' 