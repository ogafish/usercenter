# 🎩 Lombok 完全指南（新手版）

## 🎯 什么是 Lombok？

### 简单理解

**Lombok** 是一个 Java 工具库，可以自动生成重复的代码。

**比喻**：
- 就像洗碗机 🍽️ - 你不用手洗碗，机器帮你洗
- 就像自动驾驶 🚗 - 你不用自己开车，车自己开

**在编程中**：
- 你不用写 getter/setter
- Lombok 自动帮你生成

---

## 📖 Lombok 的作用

### 问题：传统 Java 代码太繁琐

```java
// 传统写法：需要写 100+ 行代码
public class User {
    private Long id;
    private String username;
    private String email;
    
    // 必须手写 getter（3个字段 = 15行代码）
    public Long getId() {
        return id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public String getEmail() {
        return email;
    }
    
    // 必须手写 setter（3个字段 = 15行代码）
    public void setId(Long id) {
        this.id = id;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    // 必须手写 toString（10行代码）
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
    
    // 必须手写 equals（20行代码）
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return Objects.equals(id, user.id) &&
               Objects.equals(username, user.username) &&
               Objects.equals(email, user.email);
    }
    
    // 必须手写 hashCode（10行代码）
    @Override
    public int hashCode() {
        return Objects.hash(id, username, email);
    }
}

// 总共：70+ 行代码
// 如果有 10 个字段？200+ 行代码！
```

### 解决方案：使用 Lombok

```java
// 使用 Lombok：只需要 6 行代码
@Data
public class User {
    private Long id;
    private String username;
    private String email;
}

// 完成！Lombok 自动生成所有方法
// 节省了 90% 的代码！
```

---

## 🔧 Lombok 是如何工作的？

### 工作流程

```
1. 你写代码
   ↓
   @Data
   public class User {
       private Long id;
   }

2. 编译时（javac）
   ↓
   Lombok 插件介入
   检测到 @Data 注解
   自动生成代码

3. 生成 .class 文件
   ↓
   public class User {
       private Long id;
       public Long getId() { ... }
       public void setId(Long id) { ... }
       public String toString() { ... }
       // ... 等等
   }

4. 运行程序
   ↓
   user.getId()  // 可以用！
   user.setId(1L) // 可以用！
```

### 关键点

- **编译时生成**：不是运行时，是编译时
- **字节码级别**：直接写入 .class 文件
- **完全透明**：使用者感觉不到区别

---

## 📦 Lombok 在项目中的配置

### 1. Maven 依赖（pom.xml）

你的项目已经配置好了：

```xml
<!-- 文件：pom.xml（第 45-49 行）-->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <optional>true</optional>
</dependency>
```

### 2. IDEA 插件

IDEA 需要安装 Lombok 插件才能识别注解：

**检查是否已安装：**
```
1. 打开 IDEA
2. File → Settings（或 Ctrl + Alt + S）
3. 左侧选择：Plugins
4. 搜索：Lombok
5. 如果显示 "Installed" = 已安装 ✅
6. 如果没有 = 需要安装
```

**如何安装：**
```
1. 在 Plugins 页面
2. 搜索：Lombok
3. 点击 "Install"
4. 重启 IDEA
```

---

## 🎓 Lombok 常用注解

### 1. @Data（最常用）⭐⭐⭐⭐⭐

**作用**：生成所有常用方法

```java
@Data
public class User {
    private Long id;
    private String username;
}

// 自动生成：
// - getId()
// - setId()
// - getUsername()
// - setUsername()
// - toString()
// - equals()
// - hashCode()
```

### 2. @Getter / @Setter

**作用**：只生成 getter 或 setter

```java
@Getter  // 只生成 getter
@Setter  // 只生成 setter
public class User {
    private Long id;
}

// 生成：
// - getId()
// - setId()
```

### 3. @ToString

**作用**：生成 toString 方法

```java
@ToString
public class User {
    private Long id;
    private String username;
}

// 生成：
// public String toString() {
//     return "User(id=" + id + ", username=" + username + ")";
// }
```

### 4. @NoArgsConstructor / @AllArgsConstructor

**作用**：生成构造函数

```java
@NoArgsConstructor   // 无参构造
@AllArgsConstructor  // 全参构造
public class User {
    private Long id;
    private String username;
}

// 生成：
// public User() { }  // 无参构造
// public User(Long id, String username) {  // 全参构造
//     this.id = id;
//     this.username = username;
// }
```

### 5. @Slf4j（日志）

**作用**：自动创建日志对象

```java
@Slf4j
public class UserServiceImpl {
    public void test() {
        log.info("这是日志");  // 可以直接用 log
    }
}

// 等价于：
// private static final Logger log = 
//     LoggerFactory.getLogger(UserServiceImpl.class);
```

---

## 🔍 如何查看 Lombok 生成的方法？

### 方法1：使用 IDEA 的 Structure 视图

**Windows/Linux：**
```
1. 打开 User.java
2. 点击菜单：View → Tool Windows → Structure
3. 或者按：Alt + 7
4. 如果没反应，试试：Fn + Alt + 7
```

**Mac：**
```
按：Command + 7
```

**或者用鼠标：**
```
1. 打开 User.java
2. 看 IDEA 左侧边栏
3. 找到 "Structure" 标签
4. 点击它
```

### 方法2：直接在代码中测试

```java
// 在任何地方写这段代码
User user = new User();
user.  // ← 输入点号后，按 Ctrl + Space

// 会弹出提示，显示所有可用的方法：
// - getId()
// - setId()
// - getUsername()
// - setUsername()
// - toString()
// - equals()
// - hashCode()
```

### 方法3：查看编译后的文件

```
1. 运行项目（让它编译）
2. 找到项目目录下的 target 文件夹
3. 进入：target/classes/com/yupi/usercenter/model/domain/
4. 找到 User.class 文件
5. 用 IDEA 打开（会自动反编译）
6. 看到所有生成的方法
```

### 方法4：使用 Delombok（反编译）

```
1. 右键点击 User.java
2. 选择：Refactor → Delombok → @Data
3. Lombok 会把生成的代码显示出来
4. （这只是预览，不会真的修改文件）
```

---

## 💡 实际使用示例

### 在你的项目中

#### User.java（实体类）

```java
@TableName(value = "user")
@Data  // ← Lombok 注解
public class User implements Serializable {
    private Long id;
    private String username;
    // ... 其他字段
}
```

#### UserServiceImpl.java（使用）

```java
@Service
@Slf4j  // ← Lombok 注解（日志）
public class UserServiceImpl {
    
    public long userRegister(...) {
        // 使用 @Data 生成的方法
        User user = new User();
        user.setUserAccount(userAccount);     // ← setter
        user.setUserPassword(encryptPassword); // ← setter
        user.setPlanetCode(planetCode);        // ← setter
        
        this.save(user);
        
        return user.getId();  // ← getter
    }
    
    public User getSafetyUser(User originUser) {
        User safetyUser = new User();
        
        // 使用 @Data 生成的 getter/setter
        safetyUser.setId(originUser.getId());
        safetyUser.setUsername(originUser.getUsername());
        // ...
        
        return safetyUser;
    }
    
    public void test() {
        // 使用 @Slf4j 生成的 log 对象
        log.info("用户登录成功");  // ← 日志
    }
}
```

---

## 🎯 Lombok 的优缺点

### ✅ 优点

1. **代码简洁**
   - 减少 90% 的重复代码
   - 文件更短，更易读

2. **减少错误**
   - 不用手写，不会写错
   - 自动生成，保证正确

3. **易于维护**
   - 添加字段？只需一行
   - 不用修改 getter/setter

4. **提高效率**
   - 写代码更快
   - 专注业务逻辑

### ❌ 缺点

1. **需要插件**
   - IDEA 需要安装 Lombok 插件
   - 否则会报错

2. **学习成本**
   - 新手需要理解注解
   - 需要知道生成了什么

3. **调试困难**
   - 生成的代码看不到
   - 需要反编译查看

---

## 🔧 常见问题

### Q1: IDEA 报错：找不到 getId() 方法

**原因**：Lombok 插件未安装或未启用

**解决**：
```
1. File → Settings → Plugins
2. 搜索 Lombok
3. 安装并重启 IDEA
4. 确保启用了 "Enable annotation processing"
   Settings → Build → Compiler → Annotation Processors
   勾选 "Enable annotation processing"
```

### Q2: 编译失败

**原因**：pom.xml 中没有 Lombok 依赖

**解决**：
```xml
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
</dependency>
```

### Q3: 看不到生成的方法

**原因**：正常现象，方法是编译时生成的

**解决**：
- 直接使用即可：`user.getId()`
- 或者查看编译后的 .class 文件

---

## 📚 学习建议

### 1. 先理解概念
```
Lombok = 代码生成工具
@Data = 自动生成 getter/setter 等方法
```

### 2. 实际使用
```
在项目中直接用：
user.getId()
user.setId(1L)
```

### 3. 查看效果
```
- 用 Structure 视图查看
- 或者直接用代码提示（Ctrl + Space）
```

### 4. 不要过度依赖
```
- 理解它生成了什么
- 知道什么时候用，什么时候不用
```

---

## 🎓 总结

### Lombok 是什么？
- Java 代码生成工具
- 通过注解自动生成重复代码
- 让代码更简洁

### 常用注解
- `@Data` - 生成所有方法（最常用）
- `@Getter/@Setter` - 只生成 getter/setter
- `@Slf4j` - 生成日志对象
- `@NoArgsConstructor/@AllArgsConstructor` - 生成构造函数

### 如何使用？
1. 在 pom.xml 中添加依赖（已有）
2. 在 IDEA 中安装插件
3. 在类上加注解（如 @Data）
4. 直接使用生成的方法

### 如何查看生成的方法？
- Structure 视图（Alt + 7 或点击左侧标签）
- 代码提示（Ctrl + Space）
- 查看编译后的 .class 文件

---

**现在理解 Lombok 了吗？** 😊

如果 Alt + 7 没反应，试试：
1. 点击 IDEA 左侧的 "Structure" 标签
2. 或者菜单：View → Tool Windows → Structure
3. 或者直接在代码中输入 `user.` 然后按 Ctrl + Space 看提示
