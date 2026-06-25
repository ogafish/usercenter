# 第1课：User 实体类详解 👤

## � 源代码位置
```
文件路径：
user-center-backend-master/
  user-center-backend-master/
    src/main/java/com/yupi/usercenter/
      model/domain/
        User.java  ← 我们正在学习这个文件
```

**快速打开方式：**
- IDEA：按两次 Shift，输入 "User.java"
- 或者：在项目中找到 `model/domain/User.java`

---

## 📝 什么是实体类？

实体类（Entity）就是用来表示数据库表的 Java 类。
- 一个实体类 = 数据库中的一张表
- 实体类的属性 = 表中的字段
- 实体类的对象 = 表中的一行数据

**简单理解**：User 类就是用户表在 Java 中的映射。

---

## 📖 逐行代码讲解

### 1. 包声明和导入

📍 **位置：User.java 第1行**

```java
package com.yupi.usercenter.model.domain;
```
**解释**：声明这个类属于哪个包（就像文件夹路径）

📍 **位置：User.java 第3-7行**

```java
import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.util.Date;
```
**解释**：导入需要使用的工具类
- `mybatisplus.annotation.*`：MyBatis Plus 的注解
- `lombok.Data`：Lombok 工具，自动生成 getter/setter
- `Serializable`：序列化接口（用于网络传输）
- `Date`：日期类型

---

### 2. 类注解

📍 **位置：User.java 第15行**

```java
@TableName(value = "user")
```
**作用**：告诉 MyBatis Plus 这个类对应数据库的 `user` 表
**如果不写**：默认会把类名转成下划线格式作为表名

📍 **位置：User.java 第16行**

```java
@Data
```
**作用**：Lombok 注解，自动生成以下方法：
- getter 方法（获取属性值）
- setter 方法（设置属性值）
- toString 方法
- equals 和 hashCode 方法

**好处**：不用手写这些重复代码，代码更简洁

---

### 3. 类定义

📍 **位置：User.java 第17行**

```java
public class User implements Serializable {
```

**解释**：
- `public`：公开的，其他类可以访问
- `class User`：定义一个名为 User 的类
- `implements Serializable`：实现序列化接口

**为什么要序列化？**
- 可以把对象保存到文件
- 可以通过网络传输对象
- 可以存储到 Session 中

---

### 4. 主键字段

📍 **位置：User.java 第18-22行**

```java
/**
 * id
 */
@TableId(type = IdType.AUTO)
private Long id;
```

**逐行解释**：
- `/** ... */`：注释，说明这个字段的作用
- `@TableId`：标记这是主键字段
- `type = IdType.AUTO`：主键自动递增
- `private`：私有的，只能在类内部访问
- `Long`：长整型（可以存很大的数字）
- `id`：字段名

**IdType 类型**：
- `AUTO`：数据库自动递增
- `INPUT`：手动输入
- `ASSIGN_ID`：雪花算法生成

---

### 5. 普通字段

📍 **位置：User.java 第24-27行**

```java
/**
 * 用户昵称
 */
private String username;
```

**解释**：
- `String`：字符串类型
- `username`：用户昵称字段
- 没有注解，MyBatis Plus 会自动映射到数据库的 `username` 字段

**其他字段类似**：

📍 **位置：User.java 第29-57行**

```java
private String userAccount;    // 账号（第32行）
private String avatarUrl;      // 头像地址（第37行）
private Integer gender;        // 性别（第42行）
private String userPassword;   // 密码（第47行）
private String phone;          // 手机号（第52行）
private String email;          // 邮箱（第57行）
private Integer userStatus;    // 状态（第62行）
```

---

### 6. 时间字段

📍 **位置：User.java 第64-72行**

```java
/**
 * 创建时间
 */
private Date createTime;

/**
 * 更新时间
 */
private Date updateTime;
```

**解释**：
- `Date`：日期时间类型
- `createTime`：记录创建时间
- `updateTime`：记录最后修改时间

**自动填充**：数据库会自动设置这两个时间

---

### 7. 逻辑删除字段

📍 **位置：User.java 第74-78行**

```java
/**
 * 是否删除
 */
@TableLogic
private Integer isDelete;
```

**重点理解**：
- `@TableLogic`：逻辑删除标记
- `isDelete = 0`：未删除
- `isDelete = 1`：已删除

**什么是逻辑删除？**
- 物理删除：真的从数据库删除数据（DELETE）
- 逻辑删除：只是标记为删除，数据还在

**为什么用逻辑删除？**
- 数据可以恢复
- 保留历史记录
- 更安全

---

### 8. 角色字段

📍 **位置：User.java 第80-84行**

```java
/**
 * 用户角色 0 - 普通用户 1 - 管理员
 */
private Integer userRole;
```

**解释**：
- `0`：普通用户（只能看自己的信息）
- `1`：管理员（可以管理所有用户）

**权限控制**：根据这个字段判断用户能做什么

---

### 9. 序列化版本号

📍 **位置：User.java 第92-93行**

```java
@TableField(exist = false)
private static final long serialVersionUID = 1L;
```

**解释**：
- `@TableField(exist = false)`：这个字段不对应数据库字段
- `static final`：静态常量
- `serialVersionUID`：序列化版本号

**作用**：用于版本控制，确保序列化和反序列化的兼容性

---

## 🎯 完整示例：User 对象的使用

### 创建用户对象

```java
// 创建一个新用户
User user = new User();
user.setUsername("张三");
user.setUserAccount("zhangsan");
user.setUserPassword("12345678");
user.setUserRole(0);  // 普通用户
```

### 获取用户信息

```java
// 获取用户信息
String name = user.getUsername();      // "张三"
String account = user.getUserAccount(); // "zhangsan"
Integer role = user.getUserRole();      // 0
```

### 打印用户对象

```java
System.out.println(user);
// 输出：User(id=1, username=张三, userAccount=zhangsan, ...)
```

---

## 🔍 数据库表与实体类的对应关系

```
数据库表 user                    Java 类 User
┌─────────────────┐            ┌──────────────────┐
│ id (bigint)     │  ←→        │ Long id          │
│ username        │  ←→        │ String username  │
│ user_account    │  ←→        │ String userAccount│
│ avatar_url      │  ←→        │ String avatarUrl │
│ user_password   │  ←→        │ String userPassword│
│ user_role       │  ←→        │ Integer userRole │
│ is_delete       │  ←→        │ Integer isDelete │
│ create_time     │  ←→        │ Date createTime  │
└─────────────────┘            └──────────────────┘
```

**命名规则**：
- 数据库：下划线命名（user_account）
- Java：驼峰命名（userAccount）
- MyBatis Plus 自动转换

---

## 💡 重要知识点总结

### 1. 注解的作用
- `@TableName`：指定表名
- `@TableId`：标记主键
- `@TableLogic`：逻辑删除
- `@TableField`：字段配置
- `@Data`：自动生成方法

### 2. 数据类型选择
- `Long`：ID、大数字
- `String`：文本、账号、密码
- `Integer`：状态、角色、性别
- `Date`：时间

### 3. 为什么用 private？
- 封装性：保护数据
- 通过 getter/setter 访问
- 可以在 setter 中添加校验

---

## 🎓 练习题

### 练习1：理解字段
请说出以下字段的作用：
1. `userAccount` - ?
2. `userRole` - ?
3. `isDelete` - ?

<details>
<summary>点击查看答案</summary>

1. `userAccount` - 用户登录账号
2. `userRole` - 用户角色（0-普通用户，1-管理员）
3. `isDelete` - 逻辑删除标记（0-未删除，1-已删除）
</details>

### 练习2：创建对象
尝试写代码创建一个用户对象，设置以下信息：
- 昵称：李四
- 账号：lisi
- 角色：管理员

<details>
<summary>点击查看答案</summary>

```java
User user = new User();
user.setUsername("李四");
user.setUserAccount("lisi");
user.setUserRole(1);  // 1 表示管理员
```
</details>

---

## 📚 下一课预告

下一课我们将学习：
**第2课：UserMapper - 数据访问层**
- 如何操作数据库
- MyBatis Plus 的常用方法
- 条件查询的使用

准备好了吗？输入"继续"开始下一课！
