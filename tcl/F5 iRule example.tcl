#======================================#   
#    几个BigIP F5 iRule的习作           #   
# Author: BrokenStone                  #   
# mail: wdmsyf@yahoo.co                #   
# 2006.11.30                           #   
#======================================#   
  
 
iRule name: Redirect_when_Busi_Down    
#当业务功能Pool里没有活动成员时，则转向到信息发布Pool   
when LB_FAILED {   
  #如果当前Pool中没有active的成员时才进行转换   
  if { [active_members BUSI_HTTP_POOL] == 0 } {   
    set DEBUG 1   
    set internal_host "145.24.216.106";       #网站内网地址    
     set external_host "www.shineauto.cn";  #网站域名    
     set msg_url "/common/xtwh.do";            #错误提示URL   
    set internal_IP "145.24.216";             #认为是内网地址的关键字   
     set cip [IP::client_addr];                #客户端IP    
    set host $external_host;                  #要转向的服务器地址    
  
    #如果客户端IP包含 $internal_IP (内部IP)，则使用内部IP进行转向;   
    #否则认为是外部用户，使用域名进行转向   
     if { $cip starts_with $internal_IP }{   
      set host $internal_host   
    } else {   
      set host $external_host   
    }   
    if { $DEBUG } {   
      log local0. "URL:  http://$host/$msg_url"   
    }   
    HTTP::fallback "http://$host/$msg_url"   
  } else {   
    #如果当前Pool中还有Active的member，则重新选择   
    LB::reselect   
  }   
}   
#这是测试rule   
when HTTP_REQUEST {   
  set DEBUG 1   
  if { $DEBUG } {   
    set internal_IP "145.24.216";             #认为是内网地址的关键字   
    set cip [IP::client_addr];                #客户端IP    
    if { $cip starts_with $internal_IP } {   
      log local0. "From internal..."   
    } else {   
      log local0. "From external..."   
    }   
  }   
}   
  
##====================================   
iRule name: Insert_ClientIP_to_header   
#在往服务器上提交的Http请求头中增加客户端实际IP地址，   
#在应用中可以这样取客户端IP(java代码):   
#String clientIP = request.getHeader("Client-IP");   
when HTTP_REQUEST {   
  HTTP::header insert Client-IP [IP::client_addr];   
}   
#when HTTP_RESPONSE {   
#  #HTTP::header insert Server-IP [IP::server_addr]   
#  clientside { HTTP::header replace Host [IP::server_addr] }   
#}   
  
##====================================   
iRule name: Select_Pool_By_Query_String   
#根据URI中的关键字选择相应的POOL   
when HTTP_REQUEST {   
  #报表报送功能转向到报表专用POOL   
  if { [HTTP::uri] starts_with "/bbbs" } {   
    pool REPORT_HTTP_POOL   
  }   
  #其他要特殊处理的情况   
  #elsif {} {}   
}   
  
##======================================   
iRule name: Replace_Host_String_For_External    
#对于外部访问的请求，把页面中本地地址替换成域名   
when HTTP_RESPONSE_DATA  {   
  set find "145.24.216.106"   
  set replace "www.shineauto.cn"   
  set payload [HTTP::payload]   
  set cip "[IP::client_addr]"   
  #if { not ( [IP::addr [IP::remote_addr] equals 145.24.0.0 netmask 255.255.248.0] ) } {   
  #  if {[regsub -all $find $payload $replace new_response] > 0} {   
  #    HTTP::payload replace 0 [HTTP::payload len] $new_response    
  #  }   
  #}   
  
  #下面是测试时内部地址时使用的   
  #if { [ $cip starts_with 145.24.32] } {   
    if {[regsub -all $find $payload $replace new_response] > 0} {   
      HTTP::payload replace 0 [HTTP::payload len] $new_response    
    }   
  #}   
}   
  
##========================================   
iRule name: Check_Client_IP_Select_POOL    
#根据客户端IP选择不同的Pool   
when CLIENT_ACCEPTED {   
  if { [IP::addr [IP::remote_addr] equals 145.24.32.0/255.255.248.0] } {   
    pool BUSI_HTTP_POOL   
  } else {   
    pool CMS_HTTP_POOL   
  }   
}   
  
##========================================   
##替换Server返回页面中的所有匹配内容, 好像别的产品都没法做到吧   
when HTTP_RESPONSE_DATA {   
  set find "145.24.216.212"   
  set replace "==It's bad(服务器信息)==145.24.216.212"   
  set payload [HTTP::payload]   
  if {[regsub -all $find $payload $replace new_response] > 0} {   
    HTTP::payload replace 0 [HTTP::payload len] $new_response    
  }   
}