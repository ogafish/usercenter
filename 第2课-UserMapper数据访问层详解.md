# 第2课：UserMapper 数据访问层详解 🗄️

## 📂 源代码位置
```
文件路径：
user-center-backend-master/
  user-center-backend-master/
    src/main/java/com/yupi/usercenter/
      mapper/
        UserMapper.java  ← 我们正在学习这个文件
```

---

## 🎯 在项目流程中的位置

### 回顾三层架构

```
前端发送请求
    ↓
Controller 层（接收请求）← 第3课会学
    ↓
Service 层（业务逻辑）← 第4课会学
    ↓
Mapper 层（数据访问）← 👈 我们现在在这里（第2课）
    ↓
MySQL 数据库
```

### 在用户注册流程中的位置

```
用户点击"注册"
    ↓
前端发送请求
    ↓
UserController.userRegister()  ← 接收请求
    ↓
UserService.userRegister()     ← 处理业务逻辑
    ↓
UserMapper.insert()            ← 👈 在这里！插入数据到数据库
    ↓
MySQL 数据库
```

---

## 📖 完整源代码

```java
package com.yupi.usercenter.mapper;

import com.yupi.usercenter.model.domain.User;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

/**
 * 用户 Mapper
 */
public interface UserMapper extends BaseMapper<User> {
    // 这里是空的！但是有很多方法可以用
}
```

---

## 🤔 为什么代码这么少？

### 疑问

```java
public interface UserMapper extends BaseMapper<User> {
    // 什么都没写？
}
```

**但是在 Service 中可以这样用：**
```java
userMapper.selectOne(queryWrapper);  // 查询一条
userMapper.selectList(queryWrapper); // 查询多条
userMapper.insert(user);             // 插入
userMapper.updateById(user);         // 更新
userMapper.deleteById(id);           // 删除
```

### 答案：MyBatis Plus 的魔法！

**继承了 `BaseMapper<User>` 就自动拥有了所有常用方法！**

```
UserMapper extends BaseMapper<User>
           ↑                ↑
           |                |
      继承关系          泛型（指定操作 User 表）
```

---

## 🔍 逐行代码讲解

### 1. 包声明

📍 **位置：第1行**

```java
package com.yupi.usercenter.mapper;
```

**解释**：声明这个类属于 mapper 包（数据访问层）

---

### 2. 导入语句

📍 **位置：第3-4行**

```java
import com.yupi.usercenter.model.domain.User;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
```

**解释**：
- `User`：导入用户实体类
- `BaseMapper`：导入 MyBatis Plus 的基础 Mapper

---

### 3. 接口定义

📍 **位置：第12行**

```java
public interface UserMapper extends BaseMapper<User> {
```

**逐个解释**：

#### `public`
- 公开的，其他类可以访问

#### `interface`
- 接口（不是 class）
- 接口只定义方法，不实现方法
- 实现由 MyBatis Plus 自动完成

#### `UserMapper`
- 接口名称
- 命名规范：实体类名 + Mapper

#### `extends BaseMapper<User>`
- 继承 MyBatis Plus 的 BaseMapper
- `<User>` 是泛型，指定操作 User 表

---

## 🎁 BaseMapper 提供的方法

### 继承关系

```
UserMapper
    ↓ extends
BaseMapper<User>
    ↓ 自动提供
30+ 个常用方法
```

### 常用方法列表

#### 1. 插入方法

| 方法 | 作用 | 示例 |
|------|------|------|
| `insert(User user)` | 插入一条记录 | `userMapper.insert(user)` |

#### 2. 删除方法

| 方法 | 作用 | 示例 |
|------|------|------|
| `deleteById(Long id)` | 根据ID删除 | `userMapper.deleteById(1L)` |
| `delete(Wrapper wrapper)` | 根据条件删除 | `userMapper.delete(wrapper)` |
| `deleteBatchIds(List ids)` | 批量删除 | `userMapper.deleteBatchIds(ids)` |

#### 3. 更新方法

| 方法 | 作用 | 示例 |
|------|------|------|
| `updateById(User user)` | 根据ID更新 | `userMapper.updateById(user)` |
| `update(User user, Wrapper wrapper)` | 根据条件更新 | `userMapper.update(user, wrapper)` |

#### 4. 查询方法（最常用）⭐

| 方法 | 作用 | 示例 |
|------|------|------|
| `selectById(Long id)` | 根据ID查询 | `userMapper.selectById(1L)` |
| `selectOne(Wrapper wrapper)` | 查询一条记录 | `userMapper.selectOne(wrapper)` |
| `selectList(Wrapper wrapper)` | 查询多条记录 | `userMapper.selectList(wrapper)` |
| `selectCount(Wrapper wrapper)` | 查询数量 | `userMapper.selectCount(wrapper)` |
| `selectBatchIds(List ids)` | 批量查询 | `userMapper.selectBatchIds(ids)` |

---

## 🔄 在项目中的实际使用

### 示例1：用户注册 - 检查账号是否存在

📍 **位置：UserServiceImpl.java 第 73-77 行**

```java
// 检查账号是否重复
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.eq("userAccount", userAccount);  // WHERE userAccount = ?
long count = userMapper.selectCount(queryWrapper);  // ← 使用 Mapper
if (count > 0) {
    throw new BusinessException(ErrorCode.PARAMS_ERROR, "账号重复");
}
```

**流程图对应位置**：
```
用户注册流程
    ↓
Service 层：检查账号是否存在
    ↓
Mapper 层：userMapper.selectCount()  ← 这里！
    ↓
执行 SQL：SELECT COUNT(*) FROM user WHERE userAccount = 'xxx'
```

**生成的 SQL**：
```sql
SELECT COUNT(*) 
FROM user 
WHERE user_account = 'zhangsan' 
  AND is_delete = 0
```

---

### 示例2：用户登录 - 查询用户

📍 **位置：UserServiceImpl.java 第 133-137 行**

```java
// 查询用户是否存在
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.eq("userAccount", userAccount);
queryWrapper.eq("userPassword", encryptPassword);
User user = userMapper.selectOne(queryWrapper);  // ← 使用 Mapper
```

**流程图对应位置**：
```
用户登录流程
    ↓
Service 层：查询用户
    ↓
Mapper 层：userMapper.selectOne()  ← 这里！
    ↓
执行 SQL：SELECT * FROM user WHERE userAccount = ? AND userPassword = ?
```

**生成的 SQL**：
```sql
SELECT * 
FROM user 
WHERE user_account = 'zhangsan' 
  AND user_password = 'b0dd3697a192885d7c055db46155b26a'
  AND is_delete = 0
```

---

### 示例3：搜索用户 - 查询列表

📍 **位置：UserServiceImpl.java（通过继承的 list 方法）**

```java
// 搜索用户
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
if (StringUtils.isNotBlank(username)) {
    queryWrapper.like("username", username);  // WHERE username LIKE ?
}
List<User> userList = userService.list(queryWrapper);  // ← 内部调用 Mapper
```

**流程图对应位置**：
```
搜索用户流程
    ↓
Service 层：构建查询条件
    ↓
Mapper 层：userMapper.selectList()  ← 这里！
    ↓
执行 SQL：SELECT * FROM user WHERE username LIKE '%xxx%'
```

**生成的 SQL**：
```sql
SELECT * 
FROM user 
WHERE username LIKE '%张%'
  AND is_delete = 0
```

---

## 🎓 QueryWrapper 详解

### 什么是 QueryWrapper？

**作用**：构建查询条件（WHERE 子句）

**比喻**：就像填写搜索表单
- 你填写：账号 = "zhangsan"
- QueryWrapper 转成：WHERE userAccount = 'zhangsan'

### 常用方法

```java
QueryWrapper<User> queryWrapper = new QueryWrapper<>();

// 1. 等于（=）
queryWrapper.eq("userAccount", "zhangsan");
// SQL: WHERE user_account = 'zhangsan'

// 2. 不等于（!=）
queryWrapper.ne("userStatus", 1);
// SQL: WHERE user_status != 1

// 3. 模糊查询（LIKE）
queryWrapper.like("username", "张");
// SQL: WHERE username LIKE '%张%'

// 4. 大于（>）
queryWrapper.gt("id", 10);
// SQL: WHERE id > 10

// 5. 小于（<）
queryWrapper.lt("id", 100);
// SQL: WHERE id < 100

// 6. 多个条件（AND）
queryWrapper.eq("userAccount", "zhangsan")
            .eq("userPassword", "xxx");
// SQL: WHERE user_account = 'zhangsan' AND user_password = 'xxx'

// 7. 或条件（OR）
queryWrapper.eq("userAccount", "zhangsan")
            .or()
            .eq("email", "xxx@qq.com");
// SQL: WHERE user_account = 'zhangsan' OR email = 'xxx@qq.com'
```

---

## 🔗 Mapper 与数据库的映射关系

### 自动映射

```
Java 类                    数据库表
┌─────────────────┐       ┌─────────────────┐
│ UserMapper      │  ←→   │ user 表         │
│                 │       │                 │
│ selectById(1)   │  →    │ SELECT * FROM   │
│                 │       │ user WHERE id=1 │
└─────────────────┘       └─────────────────┘
```

### 字段映射

```
Java 字段              数据库字段
userAccount     ←→    user_account
userName        ←→    user_name
userId          ←→    user_id
```

**规则**：驼峰命名 ←→ 下划线命名（自动转换）

---

## 💡 为什么要用 Mapper 层？

### 传统方式（不用 Mapper）

```java
// 需要手写 SQL
String sql = "SELECT * FROM user WHERE user_account = ?";
PreparedStatement ps = connection.prepareStatement(sql);
ps.setString(1, "zhangsan");
ResultSet rs = ps.executeQuery();

// 需要手动封装结果
User user = new User();
if (rs.next()) {
    user.setId(rs.getLong("id"));
    user.setUsername(rs.getString("username"));
    // ... 每个字段都要手动设置
}

// 总共：20+ 行代码
// 容易出错
// 难以维护
```

### 使用 Mapper（MyBatis Plus）

```java
// 只需要一行代码
User user = userMapper.selectById(1L);

// 完成！
// 自动生成 SQL
// 自动封装结果
// 简单易用
```

---

## 📊 完整的数据流向

### 用户登录的完整流程

```
1. 前端发送请求
   POST /api/user/login
   { userAccount: "zhangsan", userPassword: "12345678" }
   ↓

2. Controller 接收
   UserController.userLogin()
   ↓

3. Service 处理
   UserServiceImpl.userLogin()
   - 密码加密
   - 构建查询条件
   ↓

4. Mapper 查询  ← 👈 我们学的这里
   userMapper.selectOne(queryWrapper)
   ↓

5. MyBatis Plus 生成 SQL
   SELECT * FROM user 
   WHERE user_account = 'zhangsan' 
     AND user_password = 'xxx'
     AND is_delete = 0
   ↓

6. MySQL 执行查询
   返回用户数据
   ↓

7. MyBatis Plus 封装结果
   User user = new User();
   user.setId(1L);
   user.setUsername("张三");
   // ... 自动设置所有字段
   ↓

8. 返回给 Service
   ↓

9. Service 处理后返回给 Controller
   ↓

10. Controller 返回给前端
```

---

## 🎯 重点总结

### 1. UserMapper 是什么？
- 数据访问层接口
- 负责与数据库交互
- 继承 BaseMapper 自动拥有增删改查方法

### 2. 为什么代码这么少？
- 继承了 BaseMapper<User>
- MyBatis Plus 自动实现所有方法
- 不需要写 SQL

### 3. 常用方法
- `selectOne()` - 查询一条
- `selectList()` - 查询多条
- `selectCount()` - 查询数量
- `insert()` - 插入
- `updateById()` - 更新
- `deleteById()` - 删除

### 4. QueryWrapper 的作用
- 构建查询条件
- 代替手写 WHERE 子句
- 类型安全，不易出错

---

## ✅ 学习检查

### 问题1：UserMapper 继承了什么？
<details>
<summary>点击查看答案</summary>

`BaseMapper<User>`
</details>

### 问题2：如何查询 id=1 的用户？
<details>
<summary>点击查看答案</summary>

```java
User user = userMapper.selectById(1L);
```
</details>

### 问题3：如何查询账号为 "zhangsan" 的用户？
<details>
<summary>点击查看答案</summary>

```java
QueryWrapper<User> queryWrapper = new QueryWrapper<>();
queryWrapper.eq("userAccount", "zhangsan");
User user = userMapper.selectOne(queryWrapper);
```
</details>

---

## 📚 下一课预告

**第3课：UserService - 业务逻辑层**
- 如何处理注册逻辑
- 如何处理登录逻辑
- 密码加密
- 用户脱敏

准备好了吗？输入"继续"开始第3课！😊
