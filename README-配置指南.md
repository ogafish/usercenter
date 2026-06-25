# 🚀 用户中心项目 - 快速配置指南

## 📋 项目简介

这是一个完整的用户中心全栈项目，包含：
- **后端**：Spring Boot + MyBatis Plus + MySQL
- **前端**：React + Ant Design Pro + Umi

## ⚡ 快速开始（3步启动）

### 第1步：环境检查
双击运行 `环境检查.bat`，确保以下环境已安装：
- ✅ Java 1.8
- ✅ Node.js 14+
- ✅ MySQL 5.7+

### 第2步：配置数据库
1. 启动 MySQL 服务
2. 双击运行 `初始化数据库.bat`
3. 输入 MySQL 用户名和密码
4. 修改后端配置文件中的数据库密码：
   - 文件位置：`user-center-backend-master/user-center-backend-master/src/main/resources/application.yml`
   - 修改 `password: 你的数据库密码`

### 第3步：启动项目
1. 双击运行 `启动后端.bat` - 后端将在 http://localhost:8080/api 启动
2. 双击运行 `启动前端.bat` - 前端将在 http://localhost:8000 启动

## 📁 项目结构

```
.
├── user-center-backend-master/     # 后端项目
│   └── user-center-backend-master/
│       ├── src/                    # 源代码
│       ├── sql/                    # 数据库脚本
│       ├── pom.xml                 # Maven配置
│       └── application.yml         # 应用配置
│
├── user-center-frontend-master/    # 前端项目
│   └── user-center-frontend-master/
│       ├── src/                    # 源代码
│       ├── package.json            # npm配置
│       └── config/                 # 配置文件
│
├── 环境检查.bat                    # 环境检查脚本
├── 初始化数据库.bat                # 数据库初始化脚本
├── 启动后端.bat                    # 后端启动脚本
├── 启动前端.bat                    # 前端启动脚本
└── 配置说明.md                     # 详细配置文档
```

## 🔧 详细配置步骤

### 一、后端配置

#### 1. 数据库配置
编辑 `application.yml`：
```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/yupi?useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: 你的密码  # 修改这里
```

#### 2. 手动启动后端（可选）
```bash
cd user-center-backend-master/user-center-backend-master
mvnw.cmd spring-boot:run
```

#### 3. 验证后端
访问：http://localhost:8080/api

### 二、前端配置

#### 1. 安装依赖（首次运行）
```bash
cd user-center-frontend-master/user-center-frontend-master
npm install
```

#### 2. 启动前端
```bash
npm run start
```

#### 3. 访问前端
浏览器自动打开：http://localhost:8000

## 🎯 测试账号

数据库初始化后会自动创建测试账号：
- **账号**：yupi
- **密码**：需要查看数据库中的加密密码（或注册新账号）

## 🛠️ 技术栈

### 后端技术
- Spring Boot 2.6.4
- MyBatis Plus 3.5.1
- MySQL 数据库
- Lombok
- Apache Commons Lang3

### 前端技术
- React 17
- Ant Design 4.17
- Ant Design Pro
- Umi 3.5
- TypeScript

## 📝 主要功能

- ✅ 用户注册
- ✅ 用户登录
- ✅ 用户管理（查询、修改、删除）
- ✅ 用户注销
- ✅ 权限管理（普通用户/管理员）
- ✅ Session 会话管理

## ❓ 常见问题

### 1. 后端启动失败
**问题**：端口被占用
```bash
# 查看8080端口占用
netstat -ano | findstr 8080
# 结束进程
taskkill /F /PID [进程ID]
```

**问题**：数据库连接失败
- 检查 MySQL 服务是否启动
- 检查用户名密码是否正确
- 检查数据库 `yupi` 是否已创建

### 2. 前端启动失败
**问题**：依赖安装失败
```bash
# 清除缓存重新安装
npm cache clean --force
rm -rf node_modules
npm install
```

**问题**：端口被占用
- 修改端口：编辑 `.umirc.ts` 或 `config/config.ts`

### 3. 前后端联调失败
- 确认后端已启动（http://localhost:8080/api）
- 检查浏览器控制台是否有跨域错误
- 检查前端代理配置

## 🔍 端口说明

- **后端端口**：8080
- **前端端口**：8000
- **MySQL端口**：3306

## 📚 学习资源

- [Spring Boot 官方文档](https://spring.io/projects/spring-boot)
- [MyBatis Plus 官方文档](https://baomidou.com/)
- [Ant Design Pro 官方文档](https://pro.ant.design/)
- [React 官方文档](https://react.dev/)

## 🎓 项目学习路径

1. **第一阶段**：环境搭建 + 项目启动
2. **第二阶段**：理解项目结构和代码组织
3. **第三阶段**：学习用户注册登录流程
4. **第四阶段**：学习前后端交互和API设计
5. **第五阶段**：扩展功能开发

## 💡 开发建议

- 使用 IntelliJ IDEA 开发后端
- 使用 VSCode 开发前端
- 安装相关插件提高开发效率
- 学习使用 Git 进行版本控制
- 阅读项目源码理解业务逻辑

## 📞 获取帮助

如果遇到问题：
1. 查看控制台错误日志
2. 检查配置文件是否正确
3. 参考 `配置说明.md` 详细文档
4. 搜索相关技术文档

---

**祝你学习愉快！🎉**
