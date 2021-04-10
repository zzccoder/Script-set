<#
文件：Roles.ps1
用途：用于测试的Roles功能脚本
创建：2016-08-23
修改：
 #>
<# Roles说明
#Active Directory Rights Management Services
ADRMS
#Active Directory 权限管理服务器				
ADRMS-Server
#联合身份验证支持								
ADRMS-Identity
#Active Directory 联合身份验证服务					
AD-Federation-Services
#联合身份验证服务								
ADFS-Federation
#联合身份验证服务代理								
ADFS-Proxy
#AD FS Web 代理							
ADFS-Web-Agents
#声明感知代理								
ADFS-Claims
#基于 Windows 令牌的代理					
ADFS-Windows-Token
#Active Directory 轻型目录服务					
ADLDS
#Active Directory 域服务						
AD-Domain-Services
#Active Directory 域控制器					
ADDS-Domain-Controller
#UNIX 标识管理								
ADDS-Identity-Mgmt
#网络信息服务的服务器							
ADDS-NIS
#密码同步								
ADDS-Password-Sync
#管理工具								
ADDS-IDMU-Tools
#Active Directory 证书服务						
AD-Certificate
#证书颁发机构									
ADCS-Cert-Authority
#证书颁发机构 Web 注册							
ADCS-Web-Enrollment
#联机响应程序									
ADCS-Online-Cert
#网络设备注册服务								
ADCS-Device-Enrollment
#证书注册 Web 服务							
ADCS-Enroll-Web-Svc
#证书注册策略 Web 服务							
ADCS-Enroll-Web-Pol
#DHCP 服务器									
DHCP
#DNS 服务器									
DNS
#Hyper-V									
Hyper-V
#Web 服务器(IIS)								
Web-Server
#Web 服务器								
Web-WebServer
#常见 HTTP 功能							
Web-Common-Http
#静态内容							
Web-Static-Content
#默认文档							
Web-Default-Doc
#目录浏览							
Web-Dir-Browsing
#HTTP 错误						
Web-Http-Errors
#HTTP 重定向						
Web-Http-Redirect
#WebDAV 发布						
Web-DAV-Publishing
#应用程序开发								
Web-App-Dev
#ASP.NET						
Web-Asp-Net
#.NET 扩展性						
Web-Net-Ext
#ASP							
Web-ASP
#CGI							
Web-CGI
#ISAPI 扩展						
Web-ISAPI-Ext
#ISAPI 筛选器						
Web-ISAPI-Filter
#在服务器端的包含文件						
Web-Includes
#健康和诊断								
Web-Health
#HTTP 日志记录						
Web-Http-Logging
#日志记录工具							
Web-Log-Libraries
#请求监视							
Web-Request-Monitor
#跟踪								
Web-Http-Tracing
#自定义日志记录						
Web-Custom-Logging
#ODBC 日志记录						
Web-ODBC-Logging
#安全性								
Web-Security
#基本身份验证							
Web-Basic-Auth
#Windows 身份验证					
Web-Windows-Auth
#摘要式身份验证						
Web-Digest-Auth
#客户端证书映射身份验证					
Web-Client-Auth
#IIS 客户端证书映射身份验证				
Web-Cert-Auth
#URL 授权							
Web-Url-Auth
#请求筛选							
Web-Filtering
#IP 和域限制						
Web-IP-Security
#性能									
Web-Performance
#静态内容压缩							
Web-Stat-Compression
#动态内容压缩							
Web-Dyn-Compression
#管理工具									
Web-Mgmt-Tools
#IIS 管理控制台							
Web-Mgmt-Console
#IIS 管理脚本和工具						
Web-Scripting-Tools
#管理服务								
Web-Mgmt-Service
#IIS 6 管理兼容性						
Web-Mgmt-Compat
#IIS 6 元数据库兼容性					
Web-Metabase
#IIS 6 WMI 兼容性					
Web-WMI
#IIS 6 脚本工具						
Web-Lgcy-Scripting
#IIS 6 管理控制台					
Web-Lgcy-Mgmt-Console
#FTP 服务器								
Web-Ftp-Server
#FTP Service						
Web-Ftp-Service
#FTP 扩展								
Web-Ftp-Ext
#IIS 可承载 Web 核心							
Web-WHC
#Windows Server Update Services				
OOB-WSUS
#Windows 部署服务								
WDS
#部署服务器									
WDS-Deployment
#传输服务器									
WDS-Transport
#传真服务器										
Fax
#打印和文件服务									
Print-Services
#打印服务器									
Print-Server
#LPD 服务									
Print-LPD-Service
#Internet 打印							
Print-Internet
#分布式扫描服务器								
Print-Scan-Server
#网络策略和访问服务									
NPAS
#网络策略服务器								
NPAS-Policy-Server
#路由和远程访问服务								
NPAS-RRAS-Services
#远程访问服务								
NPAS-RRAS
#路由									
NPAS-Routing
#健康注册机构									
NPAS-Health
#主机凭据授权协议								
NPAS-Host-Cred
#文件服务										
File-Services
#文件服务器									
FS-FileServer
#分布式文件系统								
FS-DFS
#DFS 命名空间							
FS-DFS-Namespace
#DFS 复制								
FS-DFS-Replication
#文件服务器资源管理器								
FS-Resource-Manager
#网络文件系统服务								
FS-NFS-Services
#Windows Search 服务						
FS-Search-Service
#Windows Server 2003 文件服务				
FS-Win2003-Services
#索引服务								
FS-Indexing-Service
#网络文件 BranchCache						
FS-BranchCache
#应用程序服务器									
Application-Server
#.NET Framework 3.5.1					
AS-NET-Framework
#Web 服务器(IIS)支持							
AS-Web-Support
#COM+ 网络访问								
AS-Ent-Services
#TCP 端口共享								
AS-TCP-Port-Sharing
#Windows 进程激活服务支持						
AS-WAS-Support
#HTTP 激活							
AS-HTTP-Activation
#消息队列激活								
AS-MSMQ-Activation
#TCP 激活								
AS-TCP-Activation
#命名管道激活								
AS-Named-Pipes
#分布式事务									
AS-Dist-Transaction
#传入远程事务处理							
AS-Incoming-Trans
#传出远程事务处理							
AS-Outgoing-Trans
#WS-Atomic 事务处理						
AS-WS-Atomic
#远程桌面服务										
Remote-Desktop-Services
#远程桌面会话主机								
RDS-RD-Server
#远程桌面虚拟化主机								
RDS-Virtualization
#核心服务								
RDS-Virtualization-Core
#RemoteFX							
RDS-RemoteFX
#远程桌面授权									
RDS-Licensing
#远程桌面连接代理								
RDS-Connection-Broker
#远程桌面网关									
RDS-Gateway
#远程桌面 Web 访问							
RDS-Web-Access
#.NET Framework 3.5.1 功能					
NET-Framework
#.NET Framework 3.5.1					
NET-Framework-Core
#WCF 激活									
NET-Win-CFAC
#HTTP 激活							
NET-HTTP-Activation
#非 HTTP 激活							
NET-Non-HTTP-Activ
#BitLocker 驱动器加密							
BitLocker
#BranchCache								
BranchCache
#DirectAccess 管理控制台							
DAMC
#HTTP 代理上的 RPC								
RPC-over-HTTP-Proxy
#Internet 存储命名服务器							
ISNS
#Internet 打印客户端								
Internet-Print-Client
#LPR 端口监视器									
LPR-Port-Monitor
#SAN 存储管理器									
Storage-Mgr-SANS
#SMTP 服务器									
SMTP-Server
#SNMP 服务									
SNMP-Services
#SNMP 服务								
SNMP-Service
#SNMP WMI 提供程序							
SNMP-WMI-Provider
#Telnet 服务器									
Telnet-Server
#Telnet 客户端									
Telnet-Client
#TFTP 客户端									
TFTP-Client
#Windows Biometric Framework				
Biometric-Framework
#Windows PowerShell 集成脚本环境(ISE)				
PowerShell-ISE
#Windows Server Backup 功能					
Backup-Features
#Windows Server Backup					
Backup
#命令行工具									
Backup-Tools
#Windows Server 迁移工具						
Migration
#Windows TIFF IFilter						
TIFF-IFilter
#Windows 进程激活服务								
WAS
#进程模型									
WAS-Process-Model
#.NET 环境								
WAS-NET-Environment
#配置 API									
WAS-Config-APIs
#Windows 内部数据库								
Windows-Internal-DB
#Windows 系统资源管理器							
WSRM
#WinRM IIS 扩展								
WinRM-IIS-Ext
#WINS 服务器									
WINS-Server
#XPS 查看器									
XPS-Viewer
#对等名称解析协议									
PNRP
#多路径 I/O									
Multipath-IO
#故障转移群集										
Failover-Clustering
#后台智能传送服务(BITS)								
BITS
#Compact 服务器							
BITS-Compact-Server
#IIS 服务器扩展								
BITS-IIS-Ext
#基于 UNIX 的应用程序子系统							
Subsystem-UNIX-Apps
#简单 TCP/IP 服务								
Simple-TCPIP
#连接管理器管理工具包									
CMAK
#墨迹和手写服务									
Ink-Handwriting
#墨迹支持									
IH-Ink-Support
#手写识别									
IH-Handwriting
#网络负载平衡										
NLB
#无线 LAN 服务									
Wireless-Networking
#消息队列										
MSMQ
#消息队列服务									
MSMQ-Services
#消息队列服务器							
MSMQ-Server
#目录服务集成								
MSMQ-Directory
#消息队列触发器							
MSMQ-Triggers
#HTTP 支持							
MSMQ-HTTP-Support
#多播支持								
MSMQ-Multicasting
#路由服务								
MSMQ-Routing
#消息队列 DCOM 代理							
MSMQ-DCOM
#优质 Windows 音频视频体验							
qWave
#远程差分压缩										
RDC
#远程服务器管理工具									
RSAT
#角色管理工具									
RSAT-Role-Tools
#Active Directory 证书服务工具			
RSAT-ADCS
#证书颁发机构工具						
RSAT-ADCS-Mgmt
#联机响应程序工具						
RSAT-Online-Responder
#AD DS 和 AD LDS 工具					
RSAT-AD-Tools
#AD DS 工具						
RSAT-ADDS
#AD DS 管理单元和命令行工具			
RSAT-ADDS-Tools
#Active Directory 管理中心		
RSAT-AD-AdminCenter
#用于 NIS 工具的服务器				
RSAT-SNIS
#AD LDS 管理单元和命令行工具				
RSAT-ADLDS
#Windows PowerShell 的 Active Director... 
RSAT-AD-PowerShell
#Active Directory Rights Management Servi... 
RSAT-RMS
#DHCP 服务器工具							
RSAT-DHCP
#DNS 服务器工具							
RSAT-DNS-Server
#传真服务器工具							
RSAT-Fax
#文件服务工具								
RSAT-File-Services
#分布式文件系统工具						
RSAT-DFS-Mgmt-Con
#文件服务器资源管理器工具					
RSAT-FSRM-Mgmt
#网络文件系统服务工具						
RSAT-NFS-Admin
#Hyper-V 工具							
RSAT-Hyper-V
#网络策略和访问服务工具						
RSAT-NPAS
#打印和文件服务工具							
RSAT-Print-Services
#远程桌面服务工具							
RSAT-RDS
#远程桌面会话主机工具						
RSAT-RDS-RemoteApp
#远程桌面网关工具						
RSAT-RDS-Gateway
#远程桌面授权工具						
RSAT-RDS-Licensing
#远程桌面连接代理工具						
RSAT-RDS-Conn-Broker
#Web 服务器(IIS)工具						
RSAT-Web-Server
#Windows 部署服务工具						
RSAT-WDS
#功能管理工具									
RSAT-Feature-Tools
#BitLocker 驱动器加密管理实用程序				
RSAT-BitLocker
#BitLocker 驱动器加密工具				
RSAT-Bitlocker-DriveEnc
#BitLocker 恢复密码查看器				
RSAT-Bitlocker-RecPwd
#BITS 服务器扩展工具						
RSAT-Bits-Server
#故障转移群集工具							
RSAT-Clustering
#网络负载平衡工具							
RSAT-NLB
#SMTP 服务器工具							
RSAT-SMTP
#WINS 服务器工具							
RSAT-WINS
#远程协助										
Remote-Assistance
#桌面体验										
Desktop-Experience
#组策略管理										
GPMC

#>

#KMS Active
Slmgr-skmsw15kms.sinopec.com
Slmgr-ato



#Install Framework
$OSPath='d:\Sources\Sxs'
Install-WindowsFeature NET-Framework,NET-Framework-Core -source $OSPath

#Install IIS Web Server
Install-WindowsFeature Web-WebServer,
Web-Common-Http,
Web-Static-Content,
Web-Default-Doc,
Web-Dir-Browsing,
Web-Http-Errors,
Web-Http-Redirect,
Web-DAV-Publishing,
Web-App-Dev,
Web-Asp-Net,
Web-Net-Ext,
Web-ASP,
Web-CGI,
Web-ISAPI-Ext,
Web-ISAPI-Filter,
Web-Includes,
Web-Health,
Web-Http-Logging,
Web-Log-Libraries,
Web-Request-Monitor,
Web-Http-Tracing,
Web-Custom-Logging,
Web-ODBC-Logging,
Web-Security,
Web-Basic-Auth,
Web-Windows-Auth,
Web-Digest-Auth,
Web-Client-Auth,
Web-Cert-Auth,
Web-Url-Auth,
Web-Filtering,
Web-IP-Security,
Web-Performance,
Web-Stat-Compression,
Web-Dyn-Compression,
Web-Mgmt-Tools,
Web-Mgmt-Console,
Web-Scripting-Tools,
Web-Mgmt-Service,
Web-Mgmt-Compat,
Web-Metabase,
Web-WMI,
Web-Lgcy-Scripting,
Web-Lgcy-Mgmt-Console,
Web-Ftp-Server,
Web-Ftp-Service,
Web-Ftp-Ext,
Web-WHC

#Install WSFC
Install-WindowsFeature  Multipath-IO,Failover-Clustering,RSAT-Clustering

