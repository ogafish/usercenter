# 🎩 @Data 注解的魔法演示

## 🎯 你的问题

> "User 类里没有 get、set 方法，但是可以用，是因为 @Data 吗？"

**答案：完全正确！** ✅

---

## 🔍 让我们验证一下

### 1. User.java 源代码（你看到的）

```java
@Data  // ← 就是这个注解！
public class User implements Serializable {
    private Long id;
    private String username;
    private String userAccount;
    // ... 其他字段
    
    // 看！这里没有任何 getter/setter 方法
}
```

### 2. 编译后的代码（实际生成的）

当你编译项目后，Lombok 会自动生成这些方法：

```java
public class User implements Serializable {
    private Long id;
    private String username;
    private String userAccount;
    
    // ↓↓↓ 以下方法都是 @Data 自动生成的 ↓↓↓
    
    // getter 方法
    public Long getId() {
        return this.id;
    }
    
    public String getUsername() {
        return this.username;
    }
    
    public String getUserAccount() {
        return this.userAccount;
    }
    
    // setter 方法
    public void setId(Long id) {
        this.id = id;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public void setUserAccount(String userAccount) {
        this.userAccount = userAccount;
    }
    
    // toString 方法
    public String toString() {
        return "User(id=" + this.id + 
               ", username=" + this.username + 
               ", userAccount=" + this.userAccount + "...)";
    }
    
    // equals 方法
    public boolean equals(Object o) {
        if (o == this) return true;
        if (!(o instanceof User)) return false;
        User other = (User) o;
        // ... 比较逻辑
        return true;
    }
    
    // hashCode 方法
    public int hashCode() {
        // ... 哈希计算
        return result;
    }
}
```

---

## 🧪 实际验证

### 在 IDEA 中验证

你可以在 IDEA 中亲自验证：

#### 方法1：查看编译后的 class 文件

```
1. 在 IDEA 中找到 User.java
2. 右键 → Show Bytecode（显示字节码）
3. 或者找到 target/classes/com/yupi/usercenter/model/domain/User.class
4. 双击打开，IDEA 会反编译显示
5. 你会看到所有自动生成的方法！
```

#### 方法2：使用代码提示

```java
// 在任何地方写这段代码
User user = new User();
user.  // ← 输入点号后，按 Ctrl + Space

// 你会看到自动提示：
// - getId()
// - setId()
// - getUsername()
// - setUsername()
// - toString()
// - equals()
// - hashCode()
// ... 等等
```

#### 方法3：直接使用

```java
// 在 UserServiceImpl.java 中就有很多使用例子
User user = new User();

// 使用 setter（@Data 生成的）
user.setUserAccount("zhangsan");     // ✅ 可以用
user.setUserPassword("12345678");    // ✅ 可以用
user.setPlanetCode("1");             // ✅ 可以用

// 使用 getter（@Data 生成的）
String account = user.getUserAccount();  // ✅ 可以用
String password = user.getUserPassword(); // ✅ 可以用
Long id = user.getId();                  // ✅ 可以用
```

---

## 📊 对比：有 @Data vs 没有 @Data

### 没有 @Data（传统写法）

```java
public class User {
    private Long id;
    private String username;
    
    // 必须手写 getter
    public Long getId() {
        return id;
    }
    
    public String getUsername() {
        return username;
    }
    
    // 必须手写 setter
    public void setId(Long id) {
        this.id = id;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    // 必须手写 toString
    @Override
    public String toString() {
        return "User{id=" + id + ", username=" + username + "}";
    }
    
    // 必须手写 equals
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return Objects.equals(id, user.id) &&
               Objects.equals(username, user.username);
    }
    
    // 必须手写 hashCode
    @Override
    public int hashCode() {
        return Objects.hash(id, username);
    }
}

// 总共：50+ 行代码
// 而且每增加一个字段，都要手写对应的 getter/setter
```

### 有 @Data（现代写法）

```java
@Data
public class User {
    private Long id;
    private String username;
}

// 总共：5 行代码
// 增加字段？只需要加一行！
// getter/setter/toString/equals/hashCode 全部自动生成
```

**节省了 90% 的代码！** 🎉

---

## 🔬 深入理解：Lombok 的工作原理

### 编译过程

```
1. 你写代码
   ↓
   @Data
   public class User {
       private Long id;
   }

2. Lombok 在编译时介入
   ↓
   检测到 @Data 注解
   自动生成 getter/setter 等方法

3. 编译成 .class 文件
   ↓
   public class User {
       private Long id;
       public Long getId() { ... }      // 自动生成
       public void setId(Long id) { ... } // 自动生成
       // ... 其他方法
   }

4. 运行时使用
   ↓
   user.getId()  // ✅ 可以用！
```

### 关键点

- **编译时生成**：不是运行时，是编译时就生成了
- **字节码级别**：直接写入 .class 文件
- **完全等价**：和手写的方法完全一样

---

## 💡 实际使用示例

### 在项目中的真实使用

#### 示例1：UserServiceImpl.java（第 85-90 行）

```java
// 创建用户对象
User user = new User();

// 使用 @Data 生成的 setter
user.setUserAccount(userAccount);      // ✅ 自动生成的方法
user.setUserPassword(encryptPassword); // ✅ 自动生成的方法
user.setPlanetCode(planetCode);        // ✅ 自动生成的方法

// 保存到数据库
this.save(user);

// 使用 @Data 生成的 getter
return user.getId();  // ✅ 自动生成的方法
```

#### 示例2：UserServiceImpl.java（第 155-165 行）

```java
// 用户脱敏方法
public User getSafetyUser(User originUser) {
    User safetyUser = new User();
    
    // 使用 @Data 生成的 getter 获取原始数据
    safetyUser.setId(originUser.getId());                    // ✅
    safetyUser.setUsername(originUser.getUsername());        // ✅
    safetyUser.setUserAccount(originUser.getUserAccount());  // ✅
    safetyUser.setAvatarUrl(originUser.getAvatarUrl());      // ✅
    // ... 等等
    
    return safetyUser;
}
```

#### 示例3：UserController.java（第 107 行）

```java
// 获取当前用户
User currentUser = (User) userObj;

// 使用 @Data 生成的 getter
long userId = currentUser.getId();  // ✅ 自动生成的方法
```

---

## 🎓 如何确认 @Data 生成了方法？

### 方法1：在 IDEA 中查看结构

```
1. 打开 User.java
2. 按 Alt + 7（或点击左侧的 Structure）
3. 你会看到：
   ├─ id: Long
   ├─ username: String
   ├─ getId(): Long          ← @Data 生成的
   ├─ setId(Long): void      ← @Data 生成的
   ├─ getUsername(): String  ← @Data 生成的
   ├─ setUsername(String): void ← @Data 生成的
   ├─ toString(): String     ← @Data 生成的
   ├─ equals(Object): boolean ← @Data 生成的
   └─ hashCode(): int        ← @Data 生成的
```

### 方法2：尝试使用

```java
// 在任何地方写测试代码
User user = new User();

// 如果没有 @Data，这些代码会报错
user.setId(1L);           // 如果报错 = 没有生成
String name = user.getUsername(); // 如果报错 = 没有生成

// 如果能正常使用 = @Data 生效了！
```

### 方法3：查看编译后的文件

```
1. 运行项目（mvnw spring-boot:run）
2. 找到 target/classes/com/yupi/usercenter/model/domain/User.class
3. 用 IDEA 打开（会自动反编译）
4. 看到所有生成的方法
```

---

## 📋 @Data 生成的完整方法列表

| 方法类型 | 生成的方法 | 作用 |
|---------|-----------|------|
| **Getter** | `getId()` | 获取 id |
| | `getUsername()` | 获取 username |
| | `getUserAccount()` | 获取 userAccount |
| | ... | 每个字段都有 |
| **Setter** | `setId(Long id)` | 设置 id |
| | `setUsername(String username)` | 设置 username |
| | `setUserAccount(String userAccount)` | 设置 userAccount |
| | ... | 每个字段都有 |
| **toString** | `toString()` | 转成字符串 |
| **equals** | `equals(Object o)` | 比较对象 |
| **hashCode** | `hashCode()` | 计算哈希值 |

---

## ✅ 总结

### 你的理解完全正确！

```
User 类没有写 getter/setter
    ↓
但是有 @Data 注解
    ↓
Lombok 在编译时自动生成
    ↓
所以可以使用 user.getId()、user.setId() 等方法
```

### 关键点

1. **@Data 是 Lombok 提供的注解**
2. **在编译时自动生成方法**
3. **生成的方法和手写的完全一样**
4. **大大减少了代码量**

### 验证方法

- 在 IDEA 中按 Alt + 7 查看结构
- 直接使用 `user.getId()` 等方法
- 查看编译后的 .class 文件

---

## 🎯 练习

试试在代码中使用：

```java
// 创建用户
User user = new User();

// 使用 setter（@Data 生成的）
user.setId(1L);
user.setUsername("张三");
user.setUserAccount("zhangsan");

// 使用 getter（@Data 生成的）
System.out.println(user.getId());        // 输出：1
System.out.println(user.getUsername());  // 输出：张三

// 使用 toString（@Data 生成的）
System.out.println(user);  // 输出：User(id=1, username=张三, ...)
```

---

**现在理解 @Data 的魔法了吗？** 😊

这就是为什么现代 Java 开发都喜欢用 Lombok，因为它让代码更简洁！
