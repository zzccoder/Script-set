@echo off
title 软件缘 桌面快捷方式创建工具！

if /i "%PROCESSOR_IDENTIFIER:~0,3%" == "X86"  goto inx86
if /i "%PROCESSOR_IDENTIFIER:~0,3%" NEQ "X86" goto inx64

:inx86

mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\Windows Update MiniTool.lnk""):b.TargetPath=""%~dp0WUMT\wumt_x86.exe"":b.WorkingDirectory=""%~dp0"":b.Save:close")

:inx64

mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\Windows Update MiniTool.lnk""):b.TargetPath=""%~dp0WUMT\wumt_x64.exe"":b.WorkingDirectory=""%~dp0"":b.Save:close")