set isa=CreateObject("FPC.Root")
set tprange=isa.GetContainingArray.ArrayPolicy.WebProxy.TunnelPortRanges
set tmp=tprange.AddRange("SSL 110", 110, 110)
tprange.Save


set isa=CreateObject("FPC.Root")
set tprange=isa.GetContainingArray.ArrayPolicy.WebProxy.TunnelPortRanges
set tmp=tprange.AddRange("SSL 25", 25, 25)
tprange.Save

set isa=CreateObject("FPC.Root")
set tprange=isa.GetContainingArray.ArrayPolicy.WebProxy.TunnelPortRanges
set tmp=tprange.AddRange("SSL 143", 143, 143)
tprange.Save