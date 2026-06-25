@echo off
chcp 65001
echo ====================================
echo 数据库初始化脚本
echo ====================================
echo.

set /p MYSQL_USER="请输入MySQL用户名 (默认: root): "
if "%MYSQL_USER%"=="" set MYSQL_USER=root

set /p MYSQL_PASSWORD="请输入MySQL密码: "

echo.
echo 正在连接MySQL并执行初始化脚本...
echo.

mysql -u %MYSQL_USER% -p%MYSQL_PASSWORD% < user-center-backend-master\user-center-backend-master\sql\create_table.sql

if %errorlevel% equ 0 (
    echo.
    echo ====================================
    echo 数据库初始化成功！
    echo 数据库名: yupi
    echo 已创建用户表并插入示例数据
    echo ====================================
) else (
    echo.
    echo ====================================
    echo 数据库初始化失败！
    echo 请检查：
    echo 1. MySQL服务是否启动
    echo 2. 用户名和密码是否正确
    echo 3. MySQL命令是否在系统PATH中
    echo ====================================
)

echo.
pause
