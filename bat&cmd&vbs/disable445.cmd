netsh firewall set opmode enable
netsh advfirewall firewall add rule name="deny445" dir=in protocol=tcp localport=445 action=block
netsh firewall set portopening protocol=TCP port=445 mode=disable name=deny445