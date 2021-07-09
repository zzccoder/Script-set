#从文件读取网络设置
$IpData = Get-Content "C:\Users\libao\ip.txt" | ConvertFrom-Json
 
#筛选网卡
$adapter = Get-NetAdapter |
 Where-Object { $_.Status -eq 'Up'} | # 如果有多张网卡，可以通过Name继续过滤
 Select-Object -First 1
 
$IPType = "IPv4"
#如果检测到网络设置，先清除
If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
 $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}
 # 配置IP和网关
$adapter | New-NetIPAddress `
 -AddressFamily $IPType `
 -IPAddress $IpData.ipaddr `
 -PrefixLength ($IpData.netmask -split '/' | select -Last 1)
