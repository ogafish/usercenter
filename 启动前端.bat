@echo off
chcp 65001
echo ====================================
echo 用户中心前端启动脚本
echo ====================================
echo.

cd user-center-frontend-master\user-center-frontend-master

echo 检查依赖是否已安装...
if not exist "node_modules" (
    echo 首次运行，正在安装依赖...
    echo 这可能需要几分钟时间，请耐心等待...
    call npm install
)

echo.
echo 正在启动前端服务...
echo 启动后将自动打开浏览器访问 http://localhost:8000
echo.

call npm run start

pause
