@echo off
chcp 65001
echo ====================================
echo 环境检查工具
echo ====================================
echo.

echo [1] 检查 Java 环境...
java -version 2>nul
if %errorlevel% equ 0 (
    echo ✓ Java 已安装
    java -version
) else (
    echo ✗ Java 未安装或未配置环境变量
    echo   请安装 JDK 1.8 并配置 JAVA_HOME
)
echo.

echo [2] 检查 Maven 环境...
call mvn -version 2>nul
if %errorlevel% equ 0 (
    echo ✓ Maven 已安装
) else (
    echo ✗ Maven 未安装（项目自带 mvnw，可以不安装）
)
echo.

echo [3] 检查 Node.js 环境...
node -v 2>nul
if %errorlevel% equ 0 (
    echo ✓ Node.js 已安装
    node -v
) else (
    echo ✗ Node.js 未安装
    echo   请安装 Node.js 14+ 版本
)
echo.

echo [4] 检查 npm 环境...
call npm -v 2>nul
if %errorlevel% equ 0 (
    echo ✓ npm 已安装
    npm -v
) else (
    echo ✗ npm 未安装
)
echo.

echo [5] 检查 MySQL 环境...
mysql --version 2>nul
if %errorlevel% equ 0 (
    echo ✓ MySQL 已安装
    mysql --version
) else (
    echo ✗ MySQL 未安装或未配置环境变量
    echo   请安装 MySQL 5.7+ 并配置环境变量
)
echo.

echo ====================================
echo 环境检查完成
echo ====================================
echo.
echo 必需环境：
echo - Java 1.8 (必需)
echo - Node.js 14+ (必需)
echo - MySQL 5.7+ (必需)
echo - Maven (可选，项目自带 mvnw)
echo.

pause
