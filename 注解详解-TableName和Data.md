# 📌 注解详解：@TableName 和 @Data

## 什么是注解？

**注解（Annotation）** 就像是给代码贴的"标签"或"说明书"。

```java
// 没有注解的类
public class User {
    private Long id;
    // 需要手写 getter/setter...
}

// 有注解的类
@TableName(value = "user")  // 标签1：告诉框架这是user表
@Data                        // 标签2：自动生成方法
public class User {
    private Long id;
    // 不用写 getter/setter，@Data会自动生成
}
```

**比喻**：就像快递包裹上的标签
- `@TableName` = "这个包裹要送到user表"
- `@Data` = "自动拆包装"

---

## 第一个注解：@TableName(value = "user")

### 📍 完整代码
```java
@TableName(value = "user")
public class User implements Serializable {
    // ...
}
```

### 🎯 作用
告诉 MyBatis Plus：**这个 Java 类对应数据库的哪张表**

### 📊 对应关系

```
Java 类                    数据库表
┌─────────────┐           ┌─────────────┐
│ User.java   │  ←────→   │ user 表     │
│             │           │             │
│ @TableName  │           │ CREATE      │
│ (value=     │           │ TABLE user  │
│  "user")    │           │ (...)       │
└─────────────┘           └─────────────┘
```

### 💡 详细解释

**1. 为什么需要这个注解？**

```java
// 情况1：类名和表名一样（可以不写注解）
public class User { }  // 对应 user 表 ✅

// 情况2：类名和表名不一样（必须写注解）
@TableName(value = "sys_user")  // 必须指定
public class User { }  // 对应 sys_user 表 ✅
```

**2. 如果不写会怎样？**

```java
// 没有 @TableName
public class User { }

// MyBatis Plus 会自动推测：
// 类名 User → 转成小写 → user 表
// 如果数据库里没有 user 表，就会报错！
```

**3. 参数说明**

```java
@TableName(value = "user")
           ↑      ↑
           |      |
         参数名  参数值（表名）
```

- `value`：指定数据库表名
- `"user"`：实际的表名（必须和数据库一致）

### 🔍 实际例子

**数据库中的表：**
```sql
CREATE TABLE user (
    id bigint,
    username varchar(256),
    ...
);
```

**Java 中的类：**
```java
@TableName(value = "user")  // 告诉框架：我对应 user 表
public class User {
    private Long id;
    private String username;
    ...
}
```

**当你执行查询时：**
```java
// Java 代码
userMapper.selectById(1);

// MyBatis Plus 自动生成 SQL
SELECT * FROM user WHERE id = 1;
                  ↑
            这里的表名来自 @TableName
```

---

## 第二个注解：@Data

### 📍 完整代码
```java
@Data
public class User implements Serializable {
    private Long id;
    private String username;
    // 不需要写 getter/setter，@Data 会自动生成
}
```

### 🎯 作用
**自动生成常用方法**，让代码更简洁

### 📋 @Data 会生成什么？

```java
// 有 @Data 的类（简洁）
@Data
public class User {
    private Long id;
    private String username;
}

// 等价于（繁琐）
public class User {
    private Long id;
    private String username;
    
    // getter 方法
    public Long getId() {
        return id;
    }
    
    public String getUsername() {
        return username;
    }
    
    // setter 方法
    public void setId(Long id) {
        this.id = id;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    // toString 方法
    @Override
    public String toString() {
        return "User{id=" + id + ", username=" + username + "}";
    }
    
    // equals 方法
    @Override
    public boolean equals(Object o) {
        // ... 比较逻辑
    }
    
    // hashCode 方法
    @Override
    public int hashCode() {
        // ... 哈希计算
    }
}
```

### 💡 详细解释

**1. 自动生成的方法列表**

| 方法类型 | 作用 | 示例 |
|---------|------|------|
| **getter** | 获取属性值 | `user.getId()` |
| **setter** | 设置属性值 | `user.setId(1L)` |
| **toString** | 转成字符串 | `System.out.println(user)` |
| **equals** | 比较对象 | `user1.equals(user2)` |
| **hashCode** | 计算哈希值 | `map.put(user, value)` |

**2. 使用示例**

```java
// 创建用户对象
User user = new User();

// 使用 setter（@Data 自动生成）
user.setId(1L);
user.setUsername("张三");
user.setUserAccount("zhangsan");

// 使用 getter（@Data 自动生成）
Long id = user.getId();           // 1
String name = user.getUsername(); // "张三"

// 使用 toString（@Data 自动生成）
System.out.println(user);
// 输出：User(id=1, username=张三, userAccount=zhangsan, ...)
```

**3. 为什么要用 @Data？**

```java
// 没有 @Data：需要写 100+ 行代码
public class User {
    private Long id;
    private String username;
    private String userAccount;
    // ... 还有 10 个字段
    
    // 需要手写 20+ 个 getter/setter
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    // ... 还要写 18 个
    
    // 还要写 toString、equals、hashCode
    // 总共 100+ 行代码
}

// 有 @Data：只需要 5 行代码
@Data
public class User {
    private Long id;
    private String username;
    private String userAccount;
    // ... 还有 10 个字段
    // 完成！@Data 自动生成所有方法
}
```

**节省了 95% 的代码！** 🎉

---

## 🔗 两个注解的配合使用

```java
@TableName(value = "user")  // 1. 告诉框架：对应 user 表
@Data                        // 2. 自动生成 getter/setter 等方法
public class User implements Serializable {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String username;
    private String userAccount;
    // ...
}
```

### 工作流程

```
1. 程序启动
   ↓
2. MyBatis Plus 扫描到 User 类
   ↓
3. 看到 @TableName(value = "user")
   → 知道这个类对应 user 表
   ↓
4. 看到 @Data
   → 自动生成 getter/setter 等方法
   ↓
5. 可以使用了！
   userMapper.selectById(1);  // 查询 user 表
   user.getUsername();         // 使用自动生成的 getter
```

---

## 🎓 实战演示

### 场景：从数据库查询用户

```java
// 1. 查询数据库
User user = userMapper.selectById(1);
// SQL: SELECT * FROM user WHERE id = 1
//                      ↑
//              @TableName 指定的表名

// 2. 获取用户信息（使用 @Data 生成的 getter）
String name = user.getUsername();
String account = user.getUserAccount();
Integer role = user.getUserRole();

// 3. 修改用户信息（使用 @Data 生成的 setter）
user.setUsername("新名字");
user.setUserRole(1);

// 4. 保存到数据库
userMapper.updateById(user);
// SQL: UPDATE user SET username='新名字', user_role=1 WHERE id=1
//             ↑
//      @TableName 指定的表名
```

---

## 📚 知识点总结

### @TableName(value = "user")

| 项目 | 说明 |
|------|------|
| **作用** | 指定类对应的数据库表名 |
| **来自** | MyBatis Plus 框架 |
| **必需吗** | 如果类名和表名一致可以不写 |
| **参数** | value = "表名" |

### @Data

| 项目 | 说明 |
|------|------|
| **作用** | 自动生成 getter/setter/toString 等方法 |
| **来自** | Lombok 工具 |
| **必需吗** | 不是必需，但强烈推荐 |
| **生成方法** | getter、setter、toString、equals、hashCode |

---

## 💡 常见问题

### Q1: 如果不写 @TableName 会怎样？
**A:** MyBatis Plus 会把类名转成小写作为表名
```java
public class User { }  // 默认对应 user 表
public class SysUser { }  // 默认对应 sys_user 表（驼峰转下划线）
```

### Q2: 如果不写 @Data 会怎样？
**A:** 需要手动写所有的 getter/setter 方法，代码会很长很繁琐

### Q3: @Data 是 Spring Boot 自带的吗？
**A:** 不是，是 Lombok 工具提供的。需要在 pom.xml 中引入依赖：
```xml
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
</dependency>
```

### Q4: 可以只用其中一个注解吗？
**A:** 可以！
- 只用 `@TableName`：需要手写 getter/setter
- 只用 `@Data`：表名必须和类名一致

### Q5: 还有其他类似的注解吗？
**A:** 有！Lombok 还提供了：
- `@Getter`：只生成 getter
- `@Setter`：只生成 setter
- `@ToString`：只生成 toString
- `@Data` = `@Getter` + `@Setter` + `@ToString` + `@EqualsAndHashCode`

---

## 🎯 记忆口诀

```
@TableName 连数据库，
@Data 省代码。
一个管映射，
一个管方法。
```

---

## ✅ 理解检查

看看你是否真的理解了：

1. `@TableName(value = "user")` 的作用是什么？
2. `@Data` 会自动生成哪些方法？
3. 如果没有 `@Data`，要怎么获取 user 的 id？

<details>
<summary>点击查看答案</summary>

1. 告诉 MyBatis Plus 这个类对应数据库的 user 表
2. getter、setter、toString、equals、hashCode
3. 需要手动写 `public Long getId() { return id; }` 方法
</details>

---

**理解了吗？有任何疑问随时问我！** 😊
