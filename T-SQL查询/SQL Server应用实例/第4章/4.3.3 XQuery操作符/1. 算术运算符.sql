DECLARE @x xml
SET @x=''
SELECT @x.query('<arithmetic>
<addition>{3 + 2}</addition>
<subtration>{3 - 2}</subtration>
<multiplication>{3 * 2}</multiplication>
<division>{3 div 2}</division>
<mod>{3 mod 2}</mod>
</arithmetic>')
