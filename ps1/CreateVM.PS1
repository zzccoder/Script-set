#hyper-V宿主虚拟机根路径
$HyperVRootPath="E:\HyperV\"
#hyper-v虚拟机相同名称
$NodeName="10.1.1."
#建立虚拟机数量
$FlagVM=11
#虚拟机网卡名称
$NetworkName="VM_LOCAL_14"
#虚拟机cpu核数
$LogicPrecesserCount=4
#虚拟机内存
$MomeryCount=4GB
#模板位置
$MasterDiskPath="D:\Template\DXT-VHCS1-Win2003.vhdx"
$NodeNameFullName=""
$VMName=""
$IPID=100
for($i=9;$i -le $FlagVM;$i++){
$IPend = $IPID + $i
$FolderPath = $HyperVRootPath + $NodeName + $IPend
#Create VM Sub-Folder
mkdir $FolderPath
#Create VM Disk
$NodeNameFullName = $NodeName + $IPend + ".vhdx"
$VMNodePath = $FolderPath + "\" + $NodeNameFullName
Write-Host $VMNodePath
#New-VHD -ParentPath $MasterDiskPath -Path $VMNodePath -Differencing
Copy-Item $MasterDiskPath $VMNodePath
#Configure VM
$VMName = $NodeName + $IPend
New-VM -Name $VMName -path $FolderPath -MemoryStartupBytes $MomeryCount -VHDPath $VMNodePath -SwitchName $NetworkName
Set-VMProcessor $VMName -Count $LogicPrecesserCount
Set-VMNetworkAdapter $VMName -RouterGuard On
#Start VM
#Start-VM -Name $VMName
}