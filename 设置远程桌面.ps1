function Set-RemoteDesktop
{
  while($InNumber -ne 6)
  {
  Write-Host " ##########################################################" -ForegroundColor Green
  Write-Host " # 1、自定义远程桌面端口；                                #" 
  Write-Host " # 2、开启远程桌面；                                      #"
  Write-Host " # 3、开启防火墙远程桌面出入端口；                        #"
  Write-Host " # 4、恢复系统默认的远程桌面端口；                        #"
  Write-Host " # 5、禁用远程桌面；                                      #"
  Write-Host " # 6、退出菜单；                                          #"
  Write-Host " # ########################################################" -ForegroundColor Green
  $InNumber = Read-Host "输入编号进行操作"

      switch ($InNumber)
      {
          1 {
              $PortNumber = Read-Host "请输入修改远程桌面端口号"
              Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber' -Value $PortNumber
              $PortResult = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber'
              if($PortResult.PortNumber -eq $PortNumber)
                  {
                    Write-Host "已经成功修改端口为$PortNumber" -ForegroundColor Green
                  }
                  else
                  {
                    Write-Error "端口修改失败，请重试...." 
                  }
          }
          2 {
              Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
              Write-Host 正在重启 Remote Desktop Services ... -ForegroundColor DarkYellow 
              Set-Service TermService -StartupType Automatic -Status Running -PassThru              
          }
          3 {
              $Check = New-NetFirewallRule -DisplayName "Allow RDP" -Direction Inbound -Protocol TCP -LocalPort $PortNumber -Action Allow
              if($Check.PrimaryStatus -eq 'OK') 
                { 
                    Write-Host "成功设置防火墙策略" -ForegroundColor Green 
                } 
                else 
                { 
                    Write-Error "防火墙策略设置失败,请重试..."
                } 

          }
          4 {
              Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber' -Value 3389              
              $PortResult = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber'
              if($PortResult.PortNumber -eq 3389)
                  {
                    Write-Host "已经成功恢复系统默认设置" -ForegroundColor Green
                  }
                  else
                  {
                    Write-Error "恢复失败，请重试...." 
                  }
      
          }
          5 {
            
              Write-Host 正在停止 Remote Desktop Services ... -ForegroundColor DarkYellow 
              Set-Service TermService -StartupType Disabled -Status Stopped -PassThru
              Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 1
          }
          6 {}
          Default { Write-Error "请输入1-5编号"}
      }
    Start-Sleep 2
    Invoke-Command {cls}
    }
}



