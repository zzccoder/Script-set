select wp.product_id ��Ʒ���,wp.confirm_bname ����,wp.price ���� ,wp.author ����,wp.ori_pubtime ����ʱ��,
       wp.pclass_simple ��������, wp.pline_simple ����С��,lev �����ȼ�,
       case is_sed when '1' then '��ͨ��' else 'δͨ��' end ���沿������,bf.sed_datetime ���沿���ʱ��, 
       case is_thir when '1' then '��ͨ��' else 'δͨ��' end ӡ�Ʋ�������,bf.thir_datetime ӡ�Ʋ�������,
       case uploadSiteTime when null then 'δ���' else '�����' end �г����Ƿ���� ,wp.uploadSiteTime �г������ʱ��from bw_flow bf inner join wz_product wp
     on bf.id=wp.product_id  
where bf.mark = 'wz_product' 