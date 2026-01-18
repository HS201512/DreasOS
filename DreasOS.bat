@echo off
if "%1"=="/?" goto parhelp
if /i "%2"=="/g" echo DreasOS Graphic Display File > %homedrive%\DreasOS\GRAPDISPLAY
if exist %homedrive%\DreasOS\ONERUN goto startlogon1

cls
title DreasOS 预运行阶段
echo DreasOS 全新设置体验
echo.
echo 欢迎使用 DreasOS for Command-line！
echo.
echo 接下来我们需要花几分钟时间来配置 DreasOS
echo.
echo 按任意键继续
pause >nul
cls
echo 初次使用 DreasOS 需要部署目录
echo.
echo 按任意键部署目录
pause >nul
md %homedrive%\DreasOS
md %homedrive%\DreasOS\USER

:terminalname
cls
echo 请为终端取一个名字吧
echo.
echo 名字中不能包含 ^|、^&、^>
echo.
set /p terminalname=输入名称：
if %terminalname%=="" goto terminalname
echo %terminalname% > %homedrive%\DreasOS\TERNAME.NAM
cls
echo 即将启动 用户管理器 以来配置您的帐户
echo.
echo 按任意键启动用户管理器
pause >nul
goto usermgr

:usermgr
cls
set usermgrchoice=
echo DreasOS 用户管理器
echo.
if exist %homedrive%\DreasOS\user.txt echo 当前已有的账户：
if exist %homedrive%\DreasOS\user.txt type %homedrive%\DreasOS\user.txt
if exist %homedrive%\DreasOS\user.txt echo.
echo 您想做什么？
echo.
echo 1. 新建账户
echo 2. 删除账户
echo 3. 退出
echo.
set /p usermgrchoice=选项：
if %usermgrchoice% equ 3 goto exit
if %usermgrchoice% equ 2 goto deluser
if %usermgrchoice% equ 1 goto newuser

:newuser
cls
set newuser=
set userpwd=
echo DreasOS 用户管理器
echo.
set /p newuser=输入新用户的名称：
if %newuser%=="" goto usermgr
echo %newuser% >> %homedrive%\DreasOS\user.txt
echo %newuser% >> %homedrive%\DreasOS\USER\%newuser%.USR
echo.

:pwdset
set userpwd=
set userpwd1=
set /p userpwd=设定 %newuser% 的密码：
if "%userpwd%"=="" goto usermgr
md %homedrive%\DreasOS\USER\%newuser%-PASSWORD
echo %userpwd% > %homedrive%\DreasOS\USER\%newuser%-PASSWORD\%userpwd%.PWD
goto usermgr

:deluser
cls
set deluser=
echo DreasOS 用户管理器
echo.
set /p deluser=输入要删除的用户名称：
if "%deluser%"=="" goto usermgr
if not exist %homedrive%\DreasOS\USER\%deluser%.USR echo.&echo 用户不存在&echo.&echo 按任意键返回&pause >nul&goto deluser
if exist %homedrive%\DreasOS\USER\%dreaslogon%-PASSWORD\%inputpwd%.PWD (
    set /p deluserpwd=输入 %deluser% 的密码：
    if not exist %homedrive\DreasOS\USER\%dreaslogon%-PASSWORD\%deluserpwd%.PWD echo 密码错误&echo 按任意键返回&pause >nul&goto deluser
    echo 已删除的用户：%deluser% >> %homedrive%\DreasOS\user.txt
    del %homedrive%\DreasOS\USER\%deluser%.USR
    rd /s /q %homedrive%\DreasOS\USER\%deluser%-PASSWORD
    goto usermgr
) else (
    echo 已删除的用户：%deluser% >> %homedrive%\DreasOS\user.txt
    del %homedrive%\DreasOS\USER\%deluser%.USR
    goto usermgr
)

:exit
if not exist %homedrive%\DreasOS\ONERUN (
    goto settings
) else (
    goto main
)

:settings
cls
echo 恭喜您！
echo.
echo 您已经完成 DreasOS 的设置
echo.
echo 按任意键进入 DreasOS！
pause >nul
goto onerun

:onerun
cls
title DreasOS
if not exist %homedrive%\DreasOS\ONERUN echo 这是 DreasOS 的运行验证文件 > %homedrive%\DreasOS\ONERUN

:startlogon1
title DreasOS
cls
echo 欢迎使用 DreasOS
echo.

:startlogon
set dreaslogon=
set inputpwd=
set /p dreaslogon=输入要登录的账户：
if not exist %homedrive%\DreasOS\USER\%dreaslogon%.USR goto userlogonerror
if exist %homedrive%\DreasOS\USER\%dreaslogon%-PASSWORD\*.PWD goto passwordunlock
goto main1

:userlogonerror
echo 账户不存在
if exist %homedrive%\DreasOS\GRAPDISPLAY msg %username% 登录失败：账户不存在
goto startlogon

:passwordunlock
echo.
set /p inputpwd=输入 %dreaslogon% 的密码：
if not exist %homedrive%\DreasOS\USER\%dreaslogon%-PASSWORD\%inputpwd%.PWD (
    if exist %homedrive%\DreasOS\GRAPDISPLAY msg %username% 登录失败：密码错误
    echo 密码错误
    echo 按任意键返回
    pause >nul
    goto startlogon
) else (
    goto main1
)

:main1
cls
if not exist %homedrive%\DreasOS\GRAPDISPLAY echo DreasOS 0.02 for Command-line (Alpha Release)
if exist %homedrive%\DreasOS\GRAPDISPLAY echo DreasOS 0.02 for Graphic Display Mode (Alpha Release)&msg %username% 欢迎 %dreaslogon% 使用 DreasOS！
echo.
echo 当前登录的账户：%dreaslogon%
goto main

:main
title DreasOS
echo.
set input=
type %homedrive%\DreasOS\TERNAME.NAM
set /p input=%dreaslogon%:
if "%input%"=="" goto inputspace
if /i "%input%"=="ver" goto verinfo
if /i "%input%"=="exit" exit
if /i "%input%"=="usermgr" goto usermgr 
if /i "%input%"=="edit" goto basicedit
if /i "%input%"=="logout" goto startlogon1
if /i "%input%"=="uninstall" goto uninstall
if /i "%input%"=="help" goto helps
if /i "%input%"=="cmd" start cmd&goto main
if /i "%input%"=="time" echo.&echo %time%&goto main
if /i "%input%"=="date" echo.&echo %date%&goto main
if /i "%input%"=="startgrapdisplay" echo DreasOS Graphic Display File > %homedrive%\DreasOS\GRAPDISPLAY&goto main
if /i "%input%"=="stopgrapdisplay" del %homedrive%\DreasOS\GRAPDISPLAY&goto main

:error
echo.
echo 错误：%input%不是正确的命令
if exist %homedrive%\DreasOS\GRAPDISPLAY msg %username% 错误：%input%不是正确的命令
goto main

:inputspace
if exist %homedrive%\DreasOS\GRAPDISPLAY (
    msg %username% 输入 help 获取帮助，输入 exit 退出
    goto main
) else (
    goto main
)

:verinfo
echo.
if exist %homedrive%\DreasOS\GRAPDISPLAY msg %username% DreasOS 0.02 Alpha Release
echo DreasOS 0.02 Alpha
goto main

:basicedit
title BasicEdit 0.02a for DreasOS
cls
echo BasicEdit
echo.
set /p txtdir=输入要编辑的文件路径 (例如 %homedrive%\text.txt) :
if "%txtdir%"=="" exit

:startedit
cls
echo ============================= BasicEdit Launcher ==============================
echo.
echo -------------------------- 当前编辑的文件: %txtdir% ---------------------------
echo.
set lnone=
set lntwo=
set lnthr=
set lnfur=
set lnfiv=
set lnsix=
set lnsvn=
set lnegt=
set lnnin=
set lnten=
if exist %txtdir% type %txtdir%
set /p lnone=内容:
set /p lntwo=内容:
set /p lnthr=内容:
set /p lnfur=内容:
set /p lnfiv=内容:
set /p lnsix=内容:
set /p lnsvn=内容:
set /p lnegt=内容:
set /p lnnin=内容:
set /p lnten=内容:
echo.
set /p choice1=要保存到 %txtdir% 吗？(Y/N) :
if /i "%choice1%"=="Y" echo %lnone% >> %txtdir%&echo %lntwo% >> %txtdir%&echo %lnthr% >> %txtdir%&echo %lnfur% >> %txtdir%&echo %lnfiv% >> %txtdir%&echo %lnsix% >> %txtdir%&echo %lnsvn% >> %txtdir%&echo %lnegt% >> %txtdir%&echo %lnnin% >> %txtdir%&echo %lnten% >> %txtdir%
if /i "%choice1%"=="N" goto main
set /p basicedit=要继续编辑 %txtdir% 吗? (Y/N) :
if /i "%basicedit%"=="Y" goto startedit
if /i "%basicedit%"=="N" goto main

:uninstall
cls
set uninstall=
echo DreasOS 卸载向导
echo.
set /p uninstall=确实要卸载 DreasOS 吗？(Y/N) ：
if /i "%uninstall%"=="Y" goto continue
if /i "%uninstall%"=="N" goto main
goto main

:continue
echo.
set two=
set /p two=请问要卸载此批处理吗？(Y/N) ：
if /i "%two%"=="Y" rd /s /q %homedrive%\DreasOS&del %~dp0DreasOS.bat&goto continue1
if /i "%two%"=="N" rd /s /q %homedrive%\DreasOS&goto continue1
goto main

:continue1
if exist %homedrive%\DreasOS\GRAPDISPLAY msg %username% DreasOS 已被成功卸载
echo.
echo DreasOS 已经被成功卸载
echo.
echo 按任意键退出
pause >nul
exit

:helps
echo.
echo DreasOS 帮助
echo.
echo 以下是 DreasOS 的命令：
echo help 显示此帮助
echo usermgr 启动 DreasOS 用户管理器
echo edit 启动 BasicEdit
echo uninstall 卸载 DreasOS 或只卸载配置文件以重新配置 DreasOS
echo logout 注销 %dreaslogon%
echo exit 关闭 DreasOS 的窗口
echo ver 显示 DreasOS 的版本
echo time 显示现在的时间
echo date 显示现在的日日期
echo cmd 启动一个新的命令提示符窗口
goto main

:parhelp
echo.
echo 运行 DreasOS
echo.
echo 参数：
echo         ^/g 直接用图形化模式输出
echo.



