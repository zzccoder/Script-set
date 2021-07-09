
Set-RDVirtualDesktopCollectionConfiguration ¨CCollectionName GZ ¨CCustomRdpProperty ¡°redirectcomports:i:1"


change port \Device\RdpDrPort\COM1=\tsclient\COM1

COM1 = \Device\RdpDrPort\;COM1:2\tsclient\COM1
COM2 = \Device\RdpDrPort\;COM2:2\tsclient\COM2
COM3 = \Device\RdpDrPort\;COM3:2\tsclient\COM3
COM4 = \Device\RdpDrPort\;COM4:2\tsclient\COM4

.p12