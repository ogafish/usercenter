# 第3课：UserService 业务逻辑层详解

## 📍 在三层架构中的位置

```
Controller 层（控制器）
    ↓ 接收请求，调用 Service
Service 层（业务逻辑）← 👈 我们在这里
    ↓ 处理业务，调用 Mapper
Mapper 层（数据访问）
    ↓ 操作数据库
Database（数据库）
```

Service 层是整个项目的核心，所有业务逻辑都在这里实现。

---

## 📂 涉及的文件

1. **UserService.java**（接口）
   - 位置：`service/UserService.java`
   - 作用：定义业务方法

2. **UserServiceImpl.java**（实现类）
   - 位置：`service/impl/UserServiceImpl.java`
   - 作用：实现具体业务逻辑

---

## 🎯 第一部分：UserService 接口

### 完整代码

```java
// 文件：service/UserService.java
package com.yupi.usercenter.service;

import com.yupi.usercenter.model.domain.User;
import com.baomidou.mybatisplus.extension.service.IService;
import javax.servlet.http.HttpServletRequest;

public interface UserService extends IService<User> {

    // 用户注册
    long userRegister(String userAccount, String userPassword, 
                     String checkPassword, String planetCode);

    // 用户登录
    User userLogin(String userAccount, String userPassword, 
                  HttpServletRequest request);

    // 用户脱敏
    User getSafetyUser(User originUser);

    // 用户注销
    int userLogout(HttpServletRequest request);
}
```

### 逐行讲解

#### 1. 包声明（第1行）
```java
package com.yupi.usercenter.service;
```
- 声明这个类属于 service 包
- 对应文件路径：`src/main/java/com/yupi/usercenter/service/`

#### 2. 导入语句（第3-5行）
```java
import com.yupi.usercenter.model.domain.User;
import com.baomidou.mybatisplus.extension.service.IService;
import javax.servlet.http.HttpServletRequest;
```
- `User`：用户实体类（第1课学过）
- `IService`：MyBatis Plus 的服务接口
- `HttpServletRequest`：HTTP 请求对象（用于获取 Session）

#### 3. 接口声明（第7行）
```java
public interface UserService extends IService<User> {
```

**关键点**：
- `interface`：这是一个接口（只定义方法，不实现）
- `extends IService<User>`：继承 MyBatis Plus 的 IService
- `<User>`：泛型，指定操作 User 类型

**继承的好处**：
```java
// 自动拥有这些方法（不需要自己写）：
save(user)           // 保存
removeById(id)       // 删除
updateById(user)     // 更新
getById(id)          // 查询
list()               // 列表
// ... 还有 20+ 个方法
```

#### 4. 用户注册方法（第9-10行）
```java
long userRegister(String userAccount, String userPassword, 
                 String checkPassword, String planetCode);
```

**参数说明**：
- `userAccount`：用户账号
- `userPassword`：用户密码
- `checkPassword`：确认密码
- `planetCode`：星球编号

**返回值**：
- `long`：新用户的 ID

**在流程图中的位置**：
```
用户注册流程
    ↓
UserController.userRegister()
    ↓
UserService.userRegister() ← 👈 这个方法
    ↓
UserMapper（保存到数据库）
```

#### 5. 用户登录方法（第12-13行）
```java
User userLogin(String userAccount, String userPassword, 
              HttpServletRequest request);
```

**参数说明**：
- `userAccount`：用户账号
- `userPassword`：用户密码
- `request`：HTTP 请求对象（用于保存登录态到 Session）

**返回值**：
- `User`：脱敏后的用户信息

**在流程图中的位置**：
```
用户登录流程
    ↓
UserController.userLogin()
    ↓
UserService.userLogin() ← 👈 这个方法
    ↓
UserMapper（查询数据库）
```

#### 6. 用户脱敏方法（第15行）
```java
User getSafetyUser(User originUser);
```

**作用**：隐藏敏感信息（密码、删除标记等）

**参数**：
- `originUser`：原始用户对象（包含所有字段）

**返回值**：
- `User`：脱敏后的用户对象（只包含安全字段）

**为什么需要脱敏**：
```java
// 原始用户对象（不能直接返回给前端）
{
    "id": 1,
    "userAccount": "yupi",
    "userPassword": "b0dd3697a192885d7c055db46155b26a",  // 密码！
    "isDelete": 0,  // 删除标记
    ...
}

// 脱敏后（可以安全返回给前端）
{
    "id": 1,
    "userAccount": "yupi",
    "username": "鱼皮",
    "avatarUrl": "...",
    // 没有密码和删除标记
}
```

#### 7. 用户注销方法（第17行）
```java
int userLogout(HttpServletRequest request);
```

**作用**：清除登录态

**参数**：
- `request`：HTTP 请求对象

**返回值**：
- `int`：1 表示成功

---

## 🎯 第二部分：UserServiceImpl 实现类

### 类声明和依赖注入

```java
// 文件：service/impl/UserServiceImpl.java（第29-35行）
@Service
@Slf4j
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
        implements UserService {

    @Resource
    private UserMapper userMapper;
```

#### 逐行讲解

**第29行：@Service**
```java
@Service
```
- 作用：标记这是一个 Service 类
- Spring Boot 会自动创建这个类的实例
- 其他类可以通过 `@Resource` 注入使用

**第30行：@Slf4j**
```java
@Slf4j
```
- 作用：自动生成日志对象 `log`
- 来源：Lombok
- 可以直接使用：`log.info("登录成功")`

**第31行：类声明**
```java
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
        implements UserService {
```

**关键点**：
1. `extends ServiceImpl<UserMapper, User>`
   - 继承 MyBatis Plus 的 ServiceImpl
   - `<UserMapper, User>`：指定 Mapper 和实体类型
   - 自动拥有 save、remove、update 等方法

2. `implements UserService`
   - 实现 UserService 接口
   - 必须实现接口中定义的所有方法

**第34-35行：注入 UserMapper**
```java
@Resource
private UserMapper userMapper;
```
- `@Resource`：自动注入 UserMapper
- 用于操作数据库

---

### 常量定义

```java
// 文件：service/impl/UserServiceImpl.java（第40行）
private static final String SALT = "yupi";
```

**作用**：密码加密的盐值

**为什么需要盐值**：
```java
// 没有盐值（不安全）
原始密码: "12345678"
MD5加密: "25d55ad283aa400af464c76d713c07ad"
// 黑客可以通过彩虹表破解

// 有盐值（安全）
原始密码: "12345678"
加盐: "yupi" + "12345678" = "yupi12345678"
MD5加密: "b0dd3697a192885d7c055db46155b26a"
// 黑客无法破解（不知道盐值）
```

---

## 🔍 下一步学习

下节课我们详细讲解：
1. userRegister() 方法的完整实现
2. userLogin() 方法的完整实现
3. getSafetyUser() 方法的实现
4. 每个方法在流程图中的位置

准备好了吗？有问题随时问我！
