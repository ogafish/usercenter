# 🗺️ 用户中心项目功能流程图（Part 1）

## 📋 目录

1. [项目整体架构](#项目整体架构)
2. [用户注册流程](#用户注册流程)
3. [用户登录流程](#用户登录流程)
4. [获取当前用户流程](#获取当前用户流程)

---

## 🏗️ 项目整体架构

### 三层架构图

```
┌─────────────────────────────────────────────────────────┐
│                      前端（React）                        │
│                   http://localhost:8000                  │
│                                                          │
│  页面：登录页、注册页、用户管理页                          │
└─────────────────────────────────────────────────────────┘
                            ↓ HTTP 请求
┌─────────────────────────────────────────────────────────┐
│                Controller 层（控制器）                     │
│                   接收 HTTP 请求                          │
│                                                          │
│  文件：UserController.java                               │
│  位置：controller/UserController.java                    │
│  作用：接收请求、参数校验、调用 Service                    │
└─────────────────────────────────────────────────────────┘
                            ↓ 调用方法
┌─────────────────────────────────────────────────────────┐
│                 Service 层（业务逻辑）                     │
│                   处理业务逻辑                            │
│                                                          │
│  接口：UserService.java                                  │
│  实现：UserServiceImpl.java                              │
│  位置：service/impl/UserServiceImpl.java                 │
│  作用：注册逻辑、登录逻辑、密码加密等                       │
└─────────────────────────────────────────────────────────┘
                            ↓ 调用方法
┌─────────────────────────────────────────────────────────┐
│                 Mapper 层（数据访问）                      │
│                   操作数据库                              │
│                                                          │
│  文件：UserMapper.java                                   │
│  位置：mapper/UserMapper.java                            │
│  作用：增删改查数据库                                      │
└─────────────────────────────────────────────────────────┘
                            ↓ SQL 语句
┌─────────────────────────────────────────────────────────┐
│                    MySQL 数据库                           │
│                   存储用户数据                            │
│                                                          │
│  数据库：yupi                                             │
│  表：user                                                │
└─────────────────────────────────────────────────────────┘
```

---

## 📝 用户注册流程

### 流程图

```
用户在前端填写注册信息
    ↓
点击"注册"按钮
    ↓
前端发送 POST 请求到 /api/user/register
    ↓
┌─────────────────────────────────────────────┐
│ 1. UserController.java                      │
│    方法：userRegister()                      │
│    位置：第 48 行                             │
│                                             │
│    接收参数：                                 │
│    - userAccount（账号）                     │
│    - userPassword（密码）                    │
│    - checkPassword（确认密码）               │
│    - planetCode（星球编号）                  │
│                                             │
│    做什么：                                   │
│    ✓ 检查参数是否为空                         │
│    ✓ 调用 userService.userRegister()        │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 2. UserServiceImpl.java                     │
│    方法：userRegister()                      │
│    位置：第 50 行                             │
│                                             │
│    做什么：                                   │
│    ✓ 校验账号长度 >= 4                       │
│    ✓ 校验密码长度 >= 8                       │
│    ✓ 检查账号是否包含特殊字符                 │
│    ✓ 检查密码和确认密码是否一致               │
│    ✓ 查询账号是否已存在                      │
│    ✓ 查询星球编号是否重复                    │
│    ✓ 密码加密（MD5 + 盐值）                  │
│    ✓ 调用 this.save(user) 保存到数据库       │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 3. UserMapper.java（自动调用）               │
│    继承：BaseMapper<User>                    │
│    位置：mapper/UserMapper.java              │
│                                             │
│    做什么：                                   │
│    ✓ 执行 INSERT SQL 语句                    │
│    ✓ 插入新用户到 user 表                    │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 4. MySQL 数据库                              │
│    表：user                                  │
│                                             │
│    执行：                                     │
│    INSERT INTO user (userAccount,            │
│                      userPassword, ...)      │
│    VALUES ('zhangsan', '加密后的密码', ...)  │
└─────────────────────────────────────────────┘
    ↓
返回新用户的 ID
    ↓
前端显示"注册成功"
```

### 涉及的文件清单

| 序号 | 文件 | 路径 | 作用 |
|------|------|------|------|
| 1 | UserController.java | controller/ | 接收注册请求 |
| 2 | UserRegisterRequest.java | model/domain/request/ | 注册请求参数 |
| 3 | UserService.java | service/ | 注册业务接口 |
| 4 | UserServiceImpl.java | service/impl/ | 注册业务实现 |
| 5 | UserMapper.java | mapper/ | 数据库操作 |
| 6 | User.java | model/domain/ | 用户实体类 |
| 7 | BaseResponse.java | common/ | 统一返回结果 |
| 8 | ErrorCode.java | common/ | 错误码定义 |

### 关键代码位置

```java
// 1. Controller 接收请求
// 文件：UserController.java（第 48-62 行）
@PostMapping("/register")
public BaseResponse<Long> userRegister(@RequestBody UserRegisterRequest request) {
    // 校验参数
    String userAccount = request.getUserAccount();
    String userPassword = request.getUserPassword();
    String checkPassword = request.getCheckPassword();
    String planetCode = request.getPlanetCode();
    
    // 调用 Service
    long result = userService.userRegister(userAccount, userPassword, 
                                          checkPassword, planetCode);
    return ResultUtils.success(result);
}

// 2. Service 处理业务
// 文件：UserServiceImpl.java（第 50-95 行）
@Override
public long userRegister(String userAccount, String userPassword, 
                        String checkPassword, String planetCode) {
    // 1. 校验参数
    if (StringUtils.isAnyBlank(userAccount, userPassword, checkPassword, planetCode)) {
        throw new BusinessException(ErrorCode.PARAMS_ERROR, "参数为空");
    }
    
    // 2. 检查账号是否重复
    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("userAccount", userAccount);
    long count = userMapper.selectCount(queryWrapper);
    if (count > 0) {
        throw new BusinessException(ErrorCode.PARAMS_ERROR, "账号重复");
    }
    
    // 3. 密码加密
    String encryptPassword = DigestUtils.md5DigestAsHex(
        (SALT + userPassword).getBytes()
    );
    
    // 4. 插入数据
    User user = new User();
    user.setUserAccount(userAccount);
    user.setUserPassword(encryptPassword);
    user.setPlanetCode(planetCode);
    this.save(user);
    
    return user.getId();
}
```

---

## 🔐 用户登录流程

### 流程图

```
用户在前端输入账号密码
    ↓
点击"登录"按钮
    ↓
前端发送 POST 请求到 /api/user/login
    ↓
┌─────────────────────────────────────────────┐
│ 1. UserController.java                      │
│    方法：userLogin()                         │
│    位置：第 71 行                             │
│                                             │
│    接收参数：                                 │
│    - userAccount（账号）                     │
│    - userPassword（密码）                    │
│    - request（HTTP 请求对象）                │
│                                             │
│    做什么：                                   │
│    ✓ 检查参数是否为空                         │
│    ✓ 调用 userService.userLogin()           │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 2. UserServiceImpl.java                     │
│    方法：userLogin()                         │
│    位置：第 115 行                            │
│                                             │
│    做什么：                                   │
│    ✓ 校验账号长度 >= 4                       │
│    ✓ 校验密码长度 >= 8                       │
│    ✓ 检查账号是否包含特殊字符                 │
│    ✓ 密码加密（MD5 + 盐值）                  │
│    ✓ 查询数据库（账号 + 加密密码）            │
│    ✓ 用户脱敏（隐藏敏感信息）                 │
│    ✓ 保存登录态到 Session                    │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 3. UserMapper.java（自动调用）               │
│    方法：selectOne()                         │
│                                             │
│    做什么：                                   │
│    ✓ 执行 SELECT SQL 语句                    │
│    ✓ 查询匹配的用户                          │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 4. MySQL 数据库                              │
│    表：user                                  │
│                                             │
│    执行：                                     │
│    SELECT * FROM user                        │
│    WHERE userAccount = 'zhangsan'            │
│      AND userPassword = '加密后的密码'        │
└─────────────────────────────────────────────┘
    ↓
找到用户 → 用户脱敏 → 保存到 Session
    ↓
返回用户信息（脱敏后）
    ↓
前端保存用户信息，跳转到主页
```

### 涉及的文件清单

| 序号 | 文件 | 路径 | 作用 |
|------|------|------|------|
| 1 | UserController.java | controller/ | 接收登录请求 |
| 2 | UserLoginRequest.java | model/domain/request/ | 登录请求参数 |
| 3 | UserService.java | service/ | 登录业务接口 |
| 4 | UserServiceImpl.java | service/impl/ | 登录业务实现 |
| 5 | UserMapper.java | mapper/ | 数据库查询 |
| 6 | User.java | model/domain/ | 用户实体类 |
| 7 | UserConstant.java | constant/ | 常量定义 |

### 关键代码位置

```java
// 1. Controller 接收请求
// 文件：UserController.java（第 71-84 行）
@PostMapping("/login")
public BaseResponse<User> userLogin(@RequestBody UserLoginRequest request, 
                                   HttpServletRequest httpRequest) {
    String userAccount = request.getUserAccount();
    String userPassword = request.getUserPassword();
    
    // 调用 Service
    User user = userService.userLogin(userAccount, userPassword, httpRequest);
    return ResultUtils.success(user);
}

// 2. Service 处理登录
// 文件：UserServiceImpl.java（第 115-145 行）
@Override
public User userLogin(String userAccount, String userPassword, 
                     HttpServletRequest request) {
    // 1. 校验参数
    if (StringUtils.isAnyBlank(userAccount, userPassword)) {
        return null;
    }
    
    // 2. 密码加密
    String encryptPassword = DigestUtils.md5DigestAsHex(
        (SALT + userPassword).getBytes()
    );
    
    // 3. 查询用户
    QueryWrapper<User> queryWrapper = new QueryWrapper<>();
    queryWrapper.eq("userAccount", userAccount);
    queryWrapper.eq("userPassword", encryptPassword);
    User user = userMapper.selectOne(queryWrapper);
    
    if (user == null) {
        log.info("user login failed");
        return null;
    }
    
    // 4. 用户脱敏
    User safetyUser = getSafetyUser(user);
    
    // 5. 记录登录态
    request.getSession().setAttribute(USER_LOGIN_STATE, safetyUser);
    
    return safetyUser;
}
```

继续查看 Part 2...
