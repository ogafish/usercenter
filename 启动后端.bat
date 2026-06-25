@echo off
chcp 65001
echo ====================================
echo 用户中心后端启动脚本
echo ====================================
echo.

cd user-center-backend-master\user-center-backend-master

echo 正在启动后端服务...
echo 请确保已经：
echo 1. 安装了 JDK 1.8
echo 2. 配置了 MySQL 数据库
echo 3. 修改了 application.yml 中的数据库密码
echo.

call mvnw.cmd spring-boot:run

pause
