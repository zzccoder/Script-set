$VHDName = "V:\serverx.vhd"
#Get the MSVM_ImageManagementService
$VHDService = get-wmiobject -class "Msvm_ImageManagementService" -namespace "root\virtualization" -computername "."
#Now we mount the VHD
$Result = $VHDService.Mount($VHDName)
chkdsk