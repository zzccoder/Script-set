select top 1 * from dbo.T_Article_Article order by ArticleId desc

select top 1 * from dbo.T_Article_Article
where ArticleId not in (select top 1 ArticleId from dbo.T_Article_Article  order by ArticleId desc)
 order by ArticleId desc

select top 1 * from dbo.T_Article_Article
where ArticleId not in (select top 2 ArticleId from dbo.T_Article_Article  order by ArticleId desc)
 order by ArticleId desc

select top 1 * from dbo.T_Article_Article
where ArticleId not in (select top 3 ArticleId from dbo.T_Article_Article  order by ArticleId desc)
 order by ArticleId desc

select top 1 * from dbo.T_Article_Article
where ArticleId not in (select top 4 ArticleId from dbo.T_Article_Article  order by ArticleId desc)
 order by ArticleId desc

select * from dbo.T_Article_Article order by ArticleId desc