# 🗺️ 用户中心项目功能流程图（Part 2）

## 📋 目录

5. [搜索用户流程](#搜索用户流程)
6. [删除用户流程](#删除用户流程)
7. [用户注销流程](#用户注销流程)
8. [完整调用链路图](#完整调用链路图)

---

## 🔍 搜索用户流程（管理员功能）

### 流程图

```
管理员在用户管理页面输入搜索条件
    ↓
点击"搜索"按钮
    ↓
前端发送 GET 请求到 /api/user/search?username=xxx
    ↓
┌─────────────────────────────────────────────┐
│ 1. UserController.java                      │
│    方法：searchUsers()                       │
│    位置：第 120 行                            │
│                                             │
│    接收参数：                                 │
│    - username（用户昵称，可选）              │
│    - request（HTTP 请求对象）                │
│                                             │
│    做什么：                                   │
│    ✓ 检查是否是管理员（isAdmin）             │
│    ✓ 如果不是管理员，抛出异常                 │
│    ✓ 调用 userService.list() 查询           │
│    ✓ 对结果进行脱敏处理                      │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 2. UserServiceImpl.java                     │
│    方法：list()（继承自 MyBatis Plus）       │
│                                             │
│    做什么：                                   │
│    ✓ 构建查询条件（QueryWrapper）            │
│    ✓ 如果有 username，添加模糊查询           │
│    ✓ 调用 userMapper.selectList()           │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 3. UserMapper.java（自动调用）               │
│    方法：selectList()                        │
│                                             │
│    做什么：                                   │
│    ✓ 执行 SELECT SQL 语句                    │
│    ✓ 返回用户列表                            │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 4. MySQL 数据库                              │
│    表：user                                  │
│                                             │
│    执行：                                     │
│    SELECT * FROM user                        │
│    WHERE username LIKE '%xxx%'               │
│      AND is_delete = 0                       │
└─────────────────────────────────────────────┘
    ↓
返回用户列表（脱敏后）
    ↓
前端显示用户列表
```

### 权限检查逻辑

```java
// 文件：UserController.java（第 137-142 行）
private boolean isAdmin(HttpServletRequest request) {
    // 从 Session 获取当前用户
    Object userObj = request.getSession().getAttribute(USER_LOGIN_STATE);
    User user = (User) userObj;
    
    // 检查是否是管理员（userRole == 1）
    return user != null && user.getUserRole() == ADMIN_ROLE;
}
```

---

## 🗑️ 删除用户流程（管理员功能）

### 流程图

```
管理员点击"删除"按钮
    ↓
前端发送 POST 请求到 /api/user/delete
    ↓
┌─────────────────────────────────────────────┐
│ 1. UserController.java                      │
│    方法：deleteUser()                        │
│    位置：第 131 行                            │
│                                             │
│    接收参数：                                 │
│    - id（用户ID）                            │
│    - request（HTTP 请求对象）                │
│                                             │
│    做什么：                                   │
│    ✓ 检查是否是管理员                         │
│    ✓ 检查 id 是否有效（> 0）                 │
│    ✓ 调用 userService.removeById(id)        │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 2. UserServiceImpl.java                     │
│    方法：removeById()（继承自 MyBatis Plus） │
│                                             │
│    做什么：                                   │
│    ✓ 因为有 @TableLogic 注解                 │
│    ✓ 执行逻辑删除（不是真删除）               │
│    ✓ 调用 userMapper.updateById()           │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 3. UserMapper.java（自动调用）               │
│    方法：updateById()                        │
│                                             │
│    做什么：                                   │
│    ✓ 执行 UPDATE SQL 语句                    │
│    ✓ 设置 is_delete = 1                      │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 4. MySQL 数据库                              │
│    表：user                                  │
│                                             │
│    执行：                                     │
│    UPDATE user                               │
│    SET is_delete = 1                         │
│    WHERE id = xxx                            │
└─────────────────────────────────────────────┘
    ↓
返回删除结果（true/false）
    ↓
前端刷新用户列表
```

### 逻辑删除说明

```java
// User.java 中的逻辑删除字段
@TableLogic  // 这个注解让删除变成逻辑删除
private Integer isDelete;

// 效果：
// 调用 removeById(1) 时
// 不会执行：DELETE FROM user WHERE id = 1
// 而是执行：UPDATE user SET is_delete = 1 WHERE id = 1

// 查询时自动过滤已删除的数据
// SELECT * FROM user WHERE is_delete = 0
```

---

## 👋 用户注销流程

### 流程图

```
用户点击"退出登录"
    ↓
前端发送 POST 请求到 /api/user/logout
    ↓
┌─────────────────────────────────────────────┐
│ 1. UserController.java                      │
│    方法：userLogout()                        │
│    位置：第 93 行                             │
│                                             │
│    接收参数：                                 │
│    - request（HTTP 请求对象）                │
│                                             │
│    做什么：                                   │
│    ✓ 检查 request 是否为空                   │
│    ✓ 调用 userService.userLogout()          │
└─────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│ 2. UserServiceImpl.java                     │
│    方法：userLogout()                        │
│    位置：第 185 行                            │
│                                             │
│    做什么：                                   │
│    ✓ 从 Session 中移除登录态                 │
│    ✓ request.getSession()                   │
│      .removeAttribute(USER_LOGIN_STATE)     │
└─────────────────────────────────────────────┘
    ↓
返回成功（1）
    ↓
前端清除用户信息，跳转到登录页
```

---

## 🔄 完整调用链路图

### 以"用户登录"为例的完整链路

```
┌──────────────────────────────────────────────────────────┐
│                    前端（React）                          │
│  文件：src/pages/user/Login/index.tsx                    │
│                                                          │
│  用户操作：输入账号密码，点击登录                          │
│  发送请求：POST /api/user/login                          │
│  请求体：{ userAccount: "xxx", userPassword: "xxx" }     │
└──────────────────────────────────────────────────────────┘
                            ↓ HTTP 请求
┌──────────────────────────────────────────────────────────┐
│              Controller 层（接收请求）                     │
│  文件：UserController.java                               │
│  位置：controller/UserController.java                    │
│  行号：第 71-84 行                                        │
│                                                          │
│  @PostMapping("/login")                                  │
│  public BaseResponse<User> userLogin(                    │
│      @RequestBody UserLoginRequest request,              │
│      HttpServletRequest httpRequest) {                   │
│                                                          │
│      // 1. 获取参数                                       │
│      String userAccount = request.getUserAccount();      │
│      String userPassword = request.getUserPassword();    │
│                                                          │
│      // 2. 参数校验                                       │
│      if (StringUtils.isAnyBlank(...)) {                  │
│          return ResultUtils.error(...);                  │
│      }                                                   │
│                                                          │
│      // 3. 调用 Service                                  │
│      User user = userService.userLogin(                  │
│          userAccount, userPassword, httpRequest);        │
│                                                          │
│      // 4. 返回结果                                       │
│      return ResultUtils.success(user);                   │
│  }                                                       │
└──────────────────────────────────────────────────────────┘
                            ↓ 调用方法
┌──────────────────────────────────────────────────────────┐
│              Service 层（业务逻辑）                        │
│  文件：UserServiceImpl.java                              │
│  位置：service/impl/UserServiceImpl.java                 │
│  行号：第 115-145 行                                      │
│                                                          │
│  @Override                                               │
│  public User userLogin(String userAccount,               │
│                       String userPassword,               │
│                       HttpServletRequest request) {      │
│                                                          │
│      // 1. 参数校验                                       │
│      if (账号长度 < 4) return null;                       │
│      if (密码长度 < 8) return null;                       │
│      if (包含特殊字符) return null;                       │
│                                                          │
│      // 2. 密码加密                                       │
│      String encryptPassword =                            │
│          DigestUtils.md5DigestAsHex(                     │
│              (SALT + userPassword).getBytes());          │
│                                                          │
│      // 3. 查询数据库                                     │
│      QueryWrapper<User> queryWrapper = new ...;          │
│      queryWrapper.eq("userAccount", userAccount);        │
│      queryWrapper.eq("userPassword", encryptPassword);   │
│      User user = userMapper.selectOne(queryWrapper);     │
│                                                          │
│      // 4. 用户不存在                                     │
│      if (user == null) {                                 │
│          log.info("user login failed");                  │
│          return null;                                    │
│      }                                                   │
│                                                          │
│      // 5. 用户脱敏                                       │
│      User safetyUser = getSafetyUser(user);              │
│                                                          │
│      // 6. 保存登录态                                     │
│      request.getSession()                                │
│             .setAttribute(USER_LOGIN_STATE, safetyUser); │
│                                                          │
│      return safetyUser;                                  │
│  }                                                       │
└──────────────────────────────────────────────────────────┘
                            ↓ 调用方法
┌──────────────────────────────────────────────────────────┐
│              Mapper 层（数据访问）                         │
│  文件：UserMapper.java                                   │
│  位置：mapper/UserMapper.java                            │
│  行号：第 15-17 行                                        │
│                                                          │
│  public interface UserMapper                             │
│      extends BaseMapper<User> {                          │
│      // 继承 MyBatis Plus 的 BaseMapper                  │
│      // 自动拥有 selectOne、selectList 等方法            │
│  }                                                       │
│                                                          │
│  调用：userMapper.selectOne(queryWrapper)                │
│  生成 SQL：                                              │
│  SELECT * FROM user                                      │
│  WHERE user_account = 'xxx'                              │
│    AND user_password = 'xxx'                             │
│    AND is_delete = 0                                     │
└──────────────────────────────────────────────────────────┘
                            ↓ 执行 SQL
┌──────────────────────────────────────────────────────────┐
│                    MySQL 数据库                           │
│  数据库：yupi                                             │
│  表：user                                                │
│                                                          │
│  执行查询，返回用户数据                                    │
└──────────────────────────────────────────────────────────┘
                            ↓ 返回数据
                    逐层返回到前端
                            ↓
                    前端显示登录成功
```

---

## 📊 所有功能涉及的文件汇总

### 核心文件（必须理解）

| 文件 | 路径 | 作用 | 重要程度 |
|------|------|------|---------|
| User.java | model/domain/ | 用户实体类 | ⭐⭐⭐⭐⭐ |
| UserController.java | controller/ | 接收请求 | ⭐⭐⭐⭐⭐ |
| UserService.java | service/ | 业务接口 | ⭐⭐⭐⭐⭐ |
| UserServiceImpl.java | service/impl/ | 业务实现 | ⭐⭐⭐⭐⭐ |
| UserMapper.java | mapper/ | 数据访问 | ⭐⭐⭐⭐⭐ |

### 辅助文件（需要了解）

| 文件 | 路径 | 作用 | 重要程度 |
|------|------|------|---------|
| UserLoginRequest.java | model/domain/request/ | 登录请求 | ⭐⭐⭐⭐ |
| UserRegisterRequest.java | model/domain/request/ | 注册请求 | ⭐⭐⭐⭐ |
| BaseResponse.java | common/ | 统一返回 | ⭐⭐⭐⭐ |
| ErrorCode.java | common/ | 错误码 | ⭐⭐⭐⭐ |
| ResultUtils.java | common/ | 结果工具 | ⭐⭐⭐ |
| UserConstant.java | constant/ | 常量定义 | ⭐⭐⭐ |
| BusinessException.java | exception/ | 业务异常 | ⭐⭐⭐ |
| GlobalExceptionHandler.java | exception/ | 异常处理 | ⭐⭐⭐ |

---

## 🎯 学习建议

### 按功能学习顺序

```
1. 用户注册流程 ✅
   - 最简单
   - 涉及完整的三层架构
   - 理解数据流向

2. 用户登录流程 ✅
   - 理解 Session 机制
   - 理解密码加密
   - 理解用户脱敏

3. 获取当前用户 ✅
   - 理解登录态获取
   - 理解权限校验

4. 搜索用户 ✅
   - 理解条件查询
   - 理解管理员权限

5. 删除用户 ✅
   - 理解逻辑删除
   - 理解权限控制
```

### 学习方法

1. **看流程图** → 理解整体流程
2. **找文件** → 在 IDEA 中打开对应文件
3. **看代码** → 对照流程图看代码
4. **打断点** → 用 Debug 模式跟踪执行
5. **做笔记** → 记录自己的理解

---

**现在你对整个项目的流程清楚了吗？** 😊

可以选择一个功能，我带你详细看代码！
