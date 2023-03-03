@echo off
echo Syntax: ^<KALIPSO^>^<MSR^> ^<MST^> ^<WORK_FOLDER^> ^<MSS_VERSION^>
set kal="C:\MIS\Kalipso 5.0.0\Designer\Kalipso.exe"
set /P kal="KALIPSO PATH (C:\MIS\Kalipso 5.0.0\Designer\Kalipso.exe): 
set msr="C:\R\Report File\MSSReports.msr"
set /P msr=MSR PATH (C:\M\Report File\MSSReports.msr): 
set mst="C:\R\Report Template\MSSTemplate.mst"
set /P mst=MST PATH (C:\M\Report Template\MSSTemplate.mst): 
set wrf="C:\R" 
set /P wrf=WORKFOLDER PATH (C:\R): 
set /P mss=MSS VERSION: 
%kal% %msr% %mst% %wrf% %mss%