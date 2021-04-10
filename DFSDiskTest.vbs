Set WshNetwork = WScript.CreateObject("WScript.Network")
Set WshShell = WScript.CreateObject("Shell.Application")


WshNetwork.MapNetworkDrive "n:","\\10.19.54.66\01TechDB"
WshShell.NameSpace("n:\").Self.Name="test"
