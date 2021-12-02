---
author: 95
title: Win 10 Configuration Tweaks
date: 2021-07-09
lastmod: 2021-09-18
toc: true
tags: [windows, regedit, sys_hack]
---

Useful tips for tweaking Win system and other application (95s Ver.)
<!--more-->

## System pre-installed

### disable [Group Policy Client(gpsvc)] service

**CAN NOT be modified by Services app even in Safe Mode*  
- Use `regedit.exe` to hard-Hack  
    > HKLM\SYSTEM\ControlSet001\Services\gpsvc  

1. change owner of reg folder  
2. change DWORD [Start] value to [4]  `1=Auto(delayed)  2=Auto  3=Manual  4=Disabled`



### disable/remove SCCM client

1. services  
    > SMS Agent Host  
    > ccmsetup
2. directory & files (pe)  
    > \windows\ccm  
    > \windows\ccmsetup  
    > \windows\ccmcache  
    > \windows\SMSCFG.INI  
    > \windows\sms*.mif  

8. registry  
    > HKLM\software\Microsoft\ccm
    > HKLM\software\Microsoft\CCMSETUP
    > HKLM\software\Microsoft\SMS

13. Task Scheduler  
    > "Microsoft"--"Configuration Manager" folder and any tasks within it  

14. Certificates  
    > SMS\certificates folder

### remove EDGE/IE & other icon always Appeared in TASKBAR 

- mod file  
    > %LOCALAPPDATA%\Microsoft\Windows\Shell\LayoutModification.xml  
```xml
  </DefaultLayoutOverride>
    <CustomTaskbarLayoutCollection PinListPlacement="Replace">
    <defaultlayout:TaskbarLayout>
      <taskbar:TaskbarPinList>
   -- items were here - removed
      </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
  </CustomTaskbarLayoutCollection>
```

## Application Trick

### Outlook Autoforward use VBA

Press `ALT + F11` to open VBA for OUTLOOK

```vb
Sub ALLForward(Item As Outlook.MailItem)

Set myForward = Item.Forward
myForward.Subject = Item.Subject
myForward.Recipients.Add "your@mail.com"
myForward.DeleteAfterSubmit = True

myForward.Send

End Sub
```

### remove Cloud Drive icon in MY PC

`regedit.exe`

> HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace

### replace Notepad.exe

`regedit.exe`

> HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\notepad.exe

- CREATE Debugger value (REG_SZ)  
    `"C:\Program Files\Notepad2.exe" /z`

### Cisco AnyConnect Agent
- stop & set all related services to manual  
- minimum start script  
```bat
@ echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c "^&chr(34)^&"%~0"^&chr(34)^&" ::","%cd%","runas",1)(window.close)&&exit
net start acnvmagent
net start vpnagent
start "" "C:\path\to\Cisco AnyConnect Secure Mobility Client\vpnui.exe"
::pause
exit
```
- Profile [Ref]
    `C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Profile\Employee.xml `

### Chrome/Firefox managed by organization
- find related registry values and restart browser  

> HKLM\SOFTWARE\Policies\Google\Chrome (Mozilla\Firefox)
> HKCU\Software\Policies\Google\Chrome (Mozilla\Firefox)


## Enjoy your hacking ~
