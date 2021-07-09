'<begin script sample> 
  
  
'This script provides high availability for IIS websites 
'By default, it monitors the "Default Web Site" and "DefaultAppPool" 
'To monitor another web site, change the SITE_NAME below 
'To monitor another application pool, change the APP_POOL_NAME below 
'More thorough and application-specific health monitoring logic can be added to the script if needed 
  
Option Explicit 
  
DIM SITE_NAME 
DIM APP_POOL_NAME 
Dim START_WEB_SITE 
Dim START_APP_POOL 
Dim SITES_SECTION_NAME 
Dim APPLICATION_POOLS_SECTION_NAME 
Dim CONFIG_APPHOST_ROOT 
Dim STOP_WEB_SITE 
  
  
'Note: 
'Replace this with the site and application pool you want to configure high availability for 
'Make sure that the same web site and application pool in the script exist on all cluster nodes. Note that the names are case-sensitive. 
SITE_NAME = "Default Web Site" '网站名称 
APP_POOL_NAME = "DefaultAppPool" '应用程序池名 
  
START_WEB_SITE = 0 
START_APP_POOL = 0 
STOP_WEB_SITE  = 1 
SITES_SECTION_NAME = "system.applicationHost/sites"
APPLICATION_POOLS_SECTION_NAME = "system.applicationHost/applicationPools"
CONFIG_APPHOST_ROOT = "MACHINE/WEBROOT/APPHOST"
  
'Helper script functions 
  
  
'Find the index of the website on this node 
Function FindSiteIndex(collection, siteName) 
  
    Dim i 
  
    FindSiteIndex = -1     
  
    For i = 0 To (CInt(collection.Count) - 1) 
        If collection.Item(i).GetPropertyByName("name").Value = siteName Then
            FindSiteIndex = i 
            Exit For
        End If       
    Next
  
End Function
  
  
'Find the index of the application pool on this node 
Function FindAppPoolIndex(collection, appPoolName) 
  
    Dim i 
  
    FindAppPoolIndex = -1     
  
    For i = 0 To (CInt(collection.Count) - 1) 
        If collection.Item(i).GetPropertyByName("name").Value = appPoolName Then
            FindAppPoolIndex = i 
            Exit For
        End If       
    Next
  
End Function
  
'Get the state of the website 
Function GetWebSiteState(adminManager, siteName) 
  
    Dim sitesSection, sitesSectionCollection, siteSection, index, siteMethods, startMethod, executeMethod 
    Set sitesSection = adminManager.GetAdminSection(SITES_SECTION_NAME, CONFIG_APPHOST_ROOT) 
    Set sitesSectionCollection = sitesSection.Collection 
  
    index = FindSiteIndex(sitesSectionCollection, siteName) 
    If index = -1 Then
        GetWebSiteState = -1 
    End If      
  
    Set siteSection = sitesSectionCollection(index) 
  
    GetWebSiteState = siteSection.GetPropertyByName("state").Value 
  
End Function
  
'Get the state of the ApplicationPool 
Function GetAppPoolState(adminManager, appPool) 
  
    Dim configSection, index, appPoolState 
  
    set configSection = adminManager.GetAdminSection(APPLICATION_POOLS_SECTION_NAME, CONFIG_APPHOST_ROOT) 
    index = FindAppPoolIndex(configSection.Collection, appPool) 
  
    If index = -1 Then
        GetAppPoolState = -1 
    End If      
  
    GetAppPoolState = configSection.Collection.Item(index).GetPropertyByName("state").Value 
End Function
  
  
'Start the w3svc service on this node 
Function StartW3SVC() 
  
    Dim objWmiProvider 
    Dim objService 
    Dim strServiceState 
    Dim response 
  
    'Check to see if the service is running 
    set objWmiProvider = GetObject("winmgmts:/root/cimv2") 
    set objService = objWmiProvider.get("win32_service='w3svc'") 
    strServiceState = objService.state 
  
    If ucase(strServiceState) = "RUNNING" Then
        StartW3SVC = True
    Else
        'If the service is not running, try to start it 
        response = objService.StartService() 
  
        'response = 0  or 10 indicates that the request to start was accepted 
        If ( response <> 0 ) and ( response <> 10 ) Then
            StartW3SVC = False
        Else
            StartW3SVC = True
        End If
    End If
      
End Function
  
  
'Start the application pool for the website 
Function StartAppPool() 
  
    Dim ahwriter, appPoolsSection, appPoolsCollection, index, appPool, appPoolMethods, startMethod, callStartMethod 
    Set ahwriter = CreateObject("Microsoft.ApplicationHost.WritableAdminManager") 
  
    Set appPoolsSection = ahwriter.GetAdminSection(APPLICATION_POOLS_SECTION_NAME, CONFIG_APPHOST_ROOT)        
    Set appPoolsCollection = appPoolsSection.Collection 
  
    index = FindAppPoolIndex(appPoolsCollection, APP_POOL_NAME) 
    Set appPool = appPoolsCollection.Item(index) 
      
    'See if it is already started 
    If appPool.GetPropertyByName("state").Value = 1 Then
        StartAppPool = True
        Exit Function
    End If
  
    'Try To start the application pool 
    Set appPoolMethods = appPool.Methods 
    Set startMethod = appPoolMethods.Item(START_APP_POOL) 
    Set callStartMethod = startMethod.CreateInstance() 
    callStartMethod.Execute() 
      
    'If started return true, otherwise return false 
    If appPool.GetPropertyByName("state").Value = 1 Then
        StartAppPool = True
    Else
        StartAppPool = False
    End If
  
End Function
  
  
'Start the website 
Function StartWebSite() 
  
    Dim ahwriter, sitesSection, sitesSectionCollection, siteSection, index, siteMethods, startMethod, executeMethod 
    Set ahwriter = CreateObject("Microsoft.ApplicationHost.WritableAdminManager") 
    Set sitesSection = ahwriter.GetAdminSection(SITES_SECTION_NAME, CONFIG_APPHOST_ROOT) 
    Set sitesSectionCollection = sitesSection.Collection 
  
    index = FindSiteIndex(sitesSectionCollection, SITE_NAME) 
    Set siteSection = sitesSectionCollection(index) 
  
    if siteSection.GetPropertyByName("state").Value = 1 Then
        'Site is already started 
        StartWebSite = True
        Exit Function
    End If
  
    'Try to start site 
    Set siteMethods = siteSection.Methods 
    Set startMethod = siteMethods.Item(START_WEB_SITE) 
    Set executeMethod = startMethod.CreateInstance() 
    executeMethod.Execute() 
  
    'Check to see if the site started, if not return false 
    If siteSection.GetPropertyByName("state").Value = 1 Then
        StartWebSite = True
    Else
        StartWebSite = False
    End If
  
End Function
  
  
'Stop the website 
Function StopWebSite() 
  
    Dim ahwriter, sitesSection, sitesSectionCollection, siteSection, index, siteMethods, startMethod, executeMethod, autoStartProperty 
    Set ahwriter = CreateObject("Microsoft.ApplicationHost.WritableAdminManager") 
    Set sitesSection = ahwriter.GetAdminSection(SITES_SECTION_NAME, CONFIG_APPHOST_ROOT) 
    Set sitesSectionCollection = sitesSection.Collection 
  
    index = FindSiteIndex(sitesSectionCollection, SITE_NAME) 
    Set siteSection = sitesSectionCollection(index) 
  
    'Stop the site 
    Set siteMethods = siteSection.Methods 
    Set startMethod = siteMethods.Item(STOP_WEB_SITE) 
    Set executeMethod = startMethod.CreateInstance() 
    executeMethod.Execute() 
  
End Function
  
  
  
'Cluster resource entry points. More details here: 
'http://msdn.microsoft.com/en-us/library/aa372846(VS.85).aspx 
  
'Cluster resource Online entry point 
'Make sure the website and the application pool are started 
Function Online( ) 
  
    Dim bOnline 
    'Make sure w3svc is started 
    bOnline = StartW3SVC() 
  
    If bOnline <> True Then
        Resource.LogInformation "The resource failed to come online because w3svc could not be started."
        Online = False
        Exit Function
    End If
  
  
    'Make sure the application pool is started 
    bOnline = StartAppPool() 
    If bOnline <> True Then
        Resource.LogInformation "The resource failed to come online because the application pool could not be started."
        Online = False
        Exit Function
    End If
  
  
    'Make sure the website is started 
    bOnline = StartWebSite() 
    If bOnline <> True Then
        Resource.LogInformation "The resource failed to come online because the web site could not be started."
        Online = False
        Exit Function
    End If
  
    Online = true  
  
End Function
  
   
'Cluster resource offline entry point 
'Stop the website 
Function Offline( ) 
  
    StopWebSite() 
    Offline = true 
  
End Function
  
  
'Cluster resource LooksAlive entry point 
'Check for the health of the website and the application pool 
Function LooksAlive( ) 
  
    Dim adminManager, appPoolState, configSection, i, appPoolName, appPool, index 
  
    i = 0 
    Set adminManager  = CreateObject("Microsoft.ApplicationHost.AdminManager") 
    appPoolState = -1 
  
    'Get the state of the website 
    if GetWebSiteState(adminManager, SITE_NAME) <> 1 Then
        Resource.LogInformation "The resource failed because the " & SITE_NAME & " web site is not started."
        LooksAlive = false 
        Exit Function
    End If
  
  
    'Get the state of the Application Pool 
     if GetAppPoolState(adminManager, APP_POOL_NAME) <> 1 Then
         Resource.LogInformation "The resource failed because Application Pool " & APP_POOL_NAME & " is not started."
         LooksAlive = false   
     Exit Function
     end if 
  
     '  Web site and Application Pool state are valid return true 
     LooksAlive = true 
End Function
  
  
'Cluster resource IsAlive entry point 
'Do the same health checks as LooksAlive 
'If a more thorough than what we do in LooksAlive is required, this should be performed here 
Function IsAlive()    
  
    IsAlive = LooksAlive 
  
End Function
  
  
'Cluster resource Open entry point 
Function Open() 
  
    Open = true 
  
End Function
  
  
'Cluster resource Close entry point 
Function Close() 
  
    Close = true 
  
End Function
  
  
'Cluster resource Terminate entry point 
Function Terminate() 
  
    Terminate = true 
  
End Function
'<end script sample> 
