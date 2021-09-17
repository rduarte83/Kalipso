@echo off
adb kill-server
adb tcpip 5555
set /P ip=Enter IP: 
adb connect %ip%
PAUSE