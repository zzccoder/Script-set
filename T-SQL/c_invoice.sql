USE Cloud
SELECT  * FROM c_invoice a INNER JOIN dbo.SYS_OrgUnit b ON a.OUCode=b.OUCode WHERE b.OUName LIKE '%½ð¶¦%'
