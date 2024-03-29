Import-Module ActiveDirectory

  #This srcipt is created by  Microsoft
  #Please don't use this script for private desirability
  #This script 's date is 2016-10-22
 
  
  # The following is the configuration for the file and  path definition
  # You could change them if you want set it as other file or path
   
    
    #$file= "c:\temp\outputfile.txt"

    $ou_str = "c:\temp\ou.txt"
    $output_file= "C:\temp\outputpermit.csv";
  
    #-------------------------------------------
    #the following is the code of the script
    #

    #please do not change them
    #-------------------------------------------



if(test-path c:\temp)
{ 
}
else
{
  New-Item c:\temp
}

if(test-path $output_file)
{
    remove-item $output_file
}

$tempObjs=@()
$ou_list = Get-Content $ou_str

if($ou_list){

    foreach($eou in $ou_list){
        $base = Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$eou'";

        if($base){
            #get all sub OUs in a given ou, results will include the given OU
            $allSubOUs = Get-ADOrganizationalUnit -SearchBase $base -SearchScope Subtree -Filter *;

            foreach($eeou in $allSubOUs){
                
                #"-------------------------------------------" >> $output_file
                #"OU name is  $eeou    "  >> $output_file              
                $aa=Get-Acl -Path "AD:\$eeou" | Select-Object -ExpandProperty Access | where{$_.IsInherited -eq $false}
                
                if($aa){
                        
                    foreach($b in $aa){
                   # $b >> c:\temp\test.txt
                        #$aa >> $output_file
                        $obj = New-Object -TypeName PSObject -Property @{
                            OUName = $eeou
                            IdentityReference = $b.IdentityReference
                            AccessControlType = $b.AccessControlType
                            Permissions = $b.ActiveDirectoryRights
                        }
                        
                        $tempObjs += $obj;
                     }

                   }

                    #"                                           " >> $output_file
                   # "                                           " >> $output_file
                    #"                                           " >> $output_file
                    #"                                           " >> $output_file
                    #"                                           " >> $output_file
                    #"-------------------------------------------" >> $output_file
                   
                }


               

               
        }
    }

}

#Write-host $tempObjs
if($tempObjs){
#Write-host 11
    $tempObjs | Export-Csv $output_file -Encoding UTF8 -NoTypeInformation
}