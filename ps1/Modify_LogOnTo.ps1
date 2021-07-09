#www.sivarajan.com
#blogs.sivarajan.com
#You can use this PowerShell script to update or modify the Log On To (userWorkstations) attribute in Active Directory.  
Import-CSV C:\Scripts\input.csv | % { 
    $UserN = $_.UserName
    $ComputerN = $_.ComputerName
    $ObjFilter = "(&(objectCategory=person)(objectCategory=User)(samaccountname=$UserN))" 
    $objSearch = New-Object System.DirectoryServices.DirectorySearcher 
    $objSearch.PageSize = 15000 
    $objSearch.Filter = $ObjFilter  
    $objSearch.SearchRoot = "LDAP://dc=infralab,dc=local" 
    $AllObj = $objSearch.findOne()
    $user = [ADSI] $AllObj.path
    $user.psbase.invokeSet("userWorkstations",$_.ComputerName)
    $user.setinfo() 
    }
    