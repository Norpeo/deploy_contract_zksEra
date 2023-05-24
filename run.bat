@mode con cols=120 lines=40 & color 0A
@title By Norpeo
@echo off
chcp 65001 > nul

set filename=Disclaimers.txt
set filepath=%~dp0%filename%

if exist "%filepath%" (
  type %filename% 
) else (
  echo Disclaimers not load successfully 
)

echo 如果你认同上述内容请按任意键继续，如果不认同，请关闭 & pause > nul

set "nodeVersion=v14.18.1"  :: 替换为您想要安装的 Node.js 版本号
set "installerUrl=https://nodejs.org/dist/%nodeVersion%/node-%nodeVersion%-x64.msi"

set "installerFile=nodeinstaller.msi"
set "nodeExe=node"
set "npmExe=npm"
set "yarnExe=yarn"

:: 检查是否已安装 Node.js
echo 检查 Node.js 安装...
where %nodeExe% > nul 2>&1
if %errorlevel% equ 0 (
  echo Node.js 已安装。跳过安装过程。
  goto :VerifyInstallation
)

:: 下载 Node.js 安装程序
echo 正在下载 Node.js 安装程序...
powershell -Command "(New-Object Net.WebClient).DownloadFile('%installerUrl%', '%installerFile%')"

:: 安装 Node.js
echo 正在安装 Node.js...
msiexec /i %installerFile% /qn
if %errorlevel% neq 0 (
  echo 安装失败。请检查安装程序。
  goto :Cleanup
)

:: 删除原来环境变量中的 Node.js 变量
echo 删除原来环境变量中的 Node.js 变量...
set "regKey=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
reg delete "%regKey%" /v "NodePath" /f > nul 2>&1
reg delete "%regKey%" /v "NODE_HOME" /f > nul 2>&1

:: 添加 Node.js 可执行文件路径到系统环境变量
echo 添加 Node.js 可执行文件路径到系统环境变量...
set "nodePath=%ProgramFiles%\nodejs"
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name 'Path' -Value ((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name 'Path').Path + ';' + '%nodePath%')"

:: 等待一段时间，让环境变量生效
timeout /t 2 > nul


:VerifyInstallation
:: 验证 Node.js 是否安装
echo 验证 Node.js 安装...
node -v
if %errorlevel% neq 0 (
  echo 验证安装失败。请重新安装 Node.js。
  goto :Cleanup
)

echo Node.js 安装完成。


:: 安装 npm
echo 安装 npm...
where %npmExe% > nul 2>&1
if %errorlevel% equ 0 (
  echo npm 已安装。
  goto :Cleanup
)


echo npm 未安装。开始安装 npm...
:: 下载安装脚本
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.npmjs.com/install.bat', 'npm-install.bat')"

:: 执行安装脚本
call npm-install.bat
if %errorlevel% neq 0 (
  echo npm 安装失败。请检查安装过程。
  goto :Cleanup
)

:: 等待一段时间，让环境变量生效
timeout /t 2 > nul

:: 验证 npm 安装
npm -v
if %errorlevel% neq 0 (
  echo 验证安装失败。请重新安装 npm。
  goto :Cleanup
)

:Cleanup
::清理临时文件
echo 清理临时文件...
del %installerFile% > nul 2>&1
del npm-install.bat > nul 2>&1

::安装 yarn
echo 安装 yarn...
where %yarnExe% > nul 2>&1
if %errorlevel% equ 0 (
  echo yarn 已安装。
  goto :continue
)

::调用yarn安装
call Iyarn.bat

:continue
echo yarn安装成功
cd ts

::安装需要的包
call Ryarn.bat
::编译合约
call compile.bat
::运行
call run.bat


:End
pause

