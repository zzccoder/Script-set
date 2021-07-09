echo [Version]>gp1.inf
       echo [Unicode]>>gp1.inf
       echo Unicode=yes>>gp1.inf
       echo [Event Audit]>>gp1.inf
       echo AuditSystemEvents=3 >>gp1.inf
       echo AuditLogonEvents=3 >>gp1.inf
       echo AuditPolicyChange=3 >>gp1.inf
       echo AuditAccountManage=3 >>gp1.inf
       echo AuditAccountLogon=3 >>gp1.inf
       echo AuditObjectAccess = 1 >>gp1.inf
       echo AuditPrivilegeUse = 3 >>gp1.inf
       echo AuditProcessTracking = 3 >>gp1.inf
       echo AuditDSAccess = 3 >>gp1.inf
       echo [Version]>>gp1.inf
       echo signature="$CHICAGO$">>gp1.inf
       echo Revision=1>>gp1.inf

       secedit /configure /db gp1.sdb /cfg gp1.inf /log gp.log
       del gp1.*
       secpol.msc
