# ogafish 用户中心

## 项目简介

用户中心后端项目，实现了用户注册、登录、查询、管理等基础功能。

## 技术栈

- Java 8
- Spring Boot 2.6.4
- MyBatis Plus 3.5.1
- MySQL

## 功能

- 用户注册（含账号密码校验）
- 用户登录 / 注销
- 获取当前登录用户
- 用户搜索（管理员）
- 用户删除（管理员）

## 快速开始

1. 创建数据库：执行 `sql/create_table.sql`
2. 修改 `src/main/resources/application.yml` 中的数据库连接配置
3. 运行 `UserCenterApplication.java` 启动项目
4. 接口基础路径：`http://localhost:8080/api`

## 部署

```bash
docker build -t user-center-backend .
docker run -p 8080:8080 user-center-backend
```
