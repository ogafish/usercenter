# 📌 Java 注解完全指南（新手版）

## 🎯 什么是注解？

### 正式名称
**注解（Annotation）** - 以 `@` 开头的特殊标记

### 通俗理解
注解就像是给代码贴的"标签"或"便利贴"，告诉程序或框架：
- "这个类要怎么处理"
- "这个方法有什么特殊功能"
- "这个字段需要什么操作"

---

## 📖 注解的基本概念

### 1. 注解的样子

```java
@注解名称
@注解名称(参数)
@注解名称(参数1 = 值1, 参数2 = 值2)
```

**实际例子：**
```java
@Data                           // 没有参数
@TableName(value = "user")      // 有一个参数
@RequestMapping(value = "/user", method = RequestMethod.POST)  // 多个参数
```

### 2. 注解的位置

注解可以放在不同的地方：

```java
// 1. 类上面
@RestController
@RequestMapping("/user")
public class UserController {
    
    // 2. 方法上面
    @PostMapping("/login")
    public String login() {
        return "success";
    }
    
    // 3. 字段上面
    @TableId(type = IdType.AUTO)
    private Long id;
    
    // 4. 参数上面
    public String test(@RequestBody User user) {
        return "ok";
    }
}
```

---

## 🎓 如何学习注解？

### 学习方法一：按来源分类学习 ⭐ 推荐

Java 中的注解来自不同的地方，分类学习更容易理解：

#### 1️⃣ Java 自带的注解（JDK）

**特点**：Java 语言本身提供的，不需要额外引入

```java
@Override           // 重写父类方法
@Deprecated         // 标记过时的方法
@SuppressWarnings   // 忽略警告
```

**示例：**
```java
public class User {
    private String name;
    
    // @Override 表示这个方法重写了父类的方法
    @Override
    public String toString() {
        return "User: " + name;
    }
}
```

**学习建议**：
- 这些是基础，必须掌握
- 数量不多，容易学
- 看 Java 基础教程就能学会

---

#### 2️⃣ Spring Boot 框架的注解

**特点**：Spring Boot 提供的，用于 Web 开发

**常用注解列表：**

| 注解 | 位置 | 作用 | 示例 |
|------|------|------|------|
| `@RestController` | 类 | 标记这是一个控制器 | 接收 HTTP 请求 |
| `@RequestMapping` | 类/方法 | 映射 URL 路径 | `/user` |
| `@GetMapping` | 方法 | 处理 GET 请求 | 查询数据 |
| `@PostMapping` | 方法 | 处理 POST 请求 | 提交数据 |
| `@RequestBody` | 参数 | 接收 JSON 数据 | 登录信息 |
| `@Service` | 类 | 标记这是服务类 | 业务逻辑 |
| `@Resource` | 字段 | 注入依赖 | 自动赋值 |

**示例：**
```java
@RestController              // 这是一个控制器
@RequestMapping("/user")     // 路径前缀是 /user
public class UserController {
    
    @Resource                // 自动注入 UserService
    private UserService userService;
    
    @PostMapping("/login")   // 处理 POST /user/login 请求
    public String login(@RequestBody UserLoginRequest request) {
        // 处理登录逻辑
        return "success";
    }
}
```

**学习建议**：
- 这是 Web 开发的核心
- 边做项目边学
- 看到一个学一个，不要一次学完

---

#### 3️⃣ MyBatis Plus 框架的注解

**特点**：用于数据库操作

**常用注解列表：**

| 注解 | 位置 | 作用 | 示例 |
|------|------|------|------|
| `@TableName` | 类 | 指定数据库表名 | `@TableName("user")` |
| `@TableId` | 字段 | 标记主键 | `@TableId(type = IdType.AUTO)` |
| `@TableField` | 字段 | 字段配置 | `@TableField(exist = false)` |
| `@TableLogic` | 字段 | 逻辑删除 | `@TableLogic` |

**示例：**
```java
@TableName(value = "user")   // 对应 user 表
public class User {
    
    @TableId(type = IdType.AUTO)  // 主键自增
    private Long id;
    
    private String username;
    
    @TableLogic                   // 逻辑删除字段
    private Integer isDelete;
}
```

**学习建议**：
- 数量不多，容易掌握
- 主要用在实体类上
- 看官方文档学习

---

#### 4️⃣ Lombok 工具的注解

**特点**：简化代码，自动生成方法

**常用注解列表：**

| 注解 | 位置 | 作用 | 生成什么 |
|------|------|------|---------|
| `@Data` | 类 | 全套方法 | getter/setter/toString/equals/hashCode |
| `@Getter` | 类/字段 | 只生成 getter | getId() |
| `@Setter` | 类/字段 | 只生成 setter | setId() |
| `@ToString` | 类 | 生成 toString | toString() |
| `@NoArgsConstructor` | 类 | 无参构造函数 | User() |
| `@AllArgsConstructor` | 类 | 全参构造函数 | User(id, name, ...) |
| `@Slf4j` | 类 | 日志对象 | log.info() |

**示例：**
```java
@Data                    // 自动生成所有方法
@NoArgsConstructor       // 生成无参构造
@AllArgsConstructor      // 生成全参构造
public class User {
    private Long id;
    private String username;
    // 不需要写 getter/setter，Lombok 自动生成
}
```

**学习建议**：
- 非常实用，必须掌握
- 数量不多，容易学
- 看 Lombok 官方文档

---

### 学习方法二：按功能分类学习

#### 1. 标记类型的注解
```java
@RestController    // 标记：这是控制器
@Service          // 标记：这是服务类
@Repository       // 标记：这是数据访问类
```

#### 2. 配置参数的注解
```java
@TableName(value = "user")           // 配置表名
@RequestMapping(value = "/user")     // 配置路径
@TableId(type = IdType.AUTO)         // 配置主键类型
```

#### 3. 自动生成的注解
```java
@Data              // 自动生成方法
@Override          // 自动检查重写
```

#### 4. 依赖注入的注解
```java
@Resource          // 自动注入对象
@Autowired         // 自动注入对象（Spring 的）
```

---

## 📚 学习注解的正确步骤

### 第1步：理解注解的概念 ✅
- 知道注解是什么
- 知道注解的作用
- 知道注解的基本语法

### 第2步：学习常用注解（边用边学）⭐
```
不要一次学完所有注解！
看到一个，学一个，用一个。
```

**推荐学习顺序：**
```
1. Lombok 注解（@Data）
   ↓
2. MyBatis Plus 注解（@TableName, @TableId）
   ↓
3. Spring Boot 注解（@RestController, @PostMapping）
   ↓
4. 其他注解（遇到再学）
```

### 第3步：在项目中实践
```java
// 看到注解就查文档
@TableName(value = "user")  // 这是什么？→ 查 MyBatis Plus 文档
@Data                        // 这是什么？→ 查 Lombok 文档
```

### 第4步：总结归纳
- 把学过的注解记录下来
- 按功能分类
- 经常复习

---

## 🔍 如何查询注解的用法？

### 方法1：看注解的源码（IDEA）

```
1. 把鼠标放在注解上
2. 按住 Ctrl + 点击注解
3. 就能看到注解的定义和说明
```

**示例：**
```java
@Data  // Ctrl + 点击这里
public class User {
    // ...
}

// 会跳转到 Lombok 的源码，看到详细说明
```

### 方法2：查官方文档

| 注解来源 | 官方文档 |
|---------|---------|
| Lombok | https://projectlombok.org/ |
| MyBatis Plus | https://baomidou.com/ |
| Spring Boot | https://spring.io/projects/spring-boot |

### 方法3：问 AI 或搜索

```
搜索关键词：
"Java @Data 注解作用"
"Spring Boot @RestController 用法"
"MyBatis Plus @TableName 详解"
```

---

## 📋 你的项目中用到的注解清单

### User.java 中的注解

```java
@TableName(value = "user")  // MyBatis Plus - 指定表名
@Data                        // Lombok - 自动生成方法
public class User implements Serializable {
    
    @TableId(type = IdType.AUTO)  // MyBatis Plus - 主键自增
    private Long id;
    
    @TableLogic                   // MyBatis Plus - 逻辑删除
    private Integer isDelete;
    
    @TableField(exist = false)    // MyBatis Plus - 不是数据库字段
    private static final long serialVersionUID = 1L;
}
```

### UserController.java 中的注解

```java
@RestController              // Spring Boot - 控制器
@RequestMapping("/user")     // Spring Boot - 路径映射
public class UserController {
    
    @Resource                // Spring Boot - 依赖注入
    private UserService userService;
    
    @PostMapping("/register")  // Spring Boot - POST 请求
    public BaseResponse<Long> userRegister(@RequestBody UserRegisterRequest request) {
        // ...
    }
    
    @GetMapping("/current")    // Spring Boot - GET 请求
    public BaseResponse<User> getCurrentUser(HttpServletRequest request) {
        // ...
    }
}
```

### UserService.java 中的注解

```java
@Service                     // Spring Boot - 服务类
@Slf4j                       // Lombok - 日志对象
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
        implements UserService {
    
    @Resource                // Spring Boot - 依赖注入
    private UserMapper userMapper;
    
    @Override                // Java - 重写方法
    public long userRegister(String userAccount, String userPassword, 
                            String checkPassword, String planetCode) {
        // ...
    }
}
```

---

## 💡 学习建议

### ✅ 推荐做法

1. **边学边用**
   - 看到一个注解，就去查它的作用
   - 理解后，在项目中使用

2. **分类记忆**
   - 按框架分类（Spring、MyBatis、Lombok）
   - 按功能分类（标记、配置、生成）

3. **做笔记**
   - 记录常用注解
   - 写下自己的理解
   - 记录使用场景

4. **多实践**
   - 尝试修改注解参数
   - 看看效果有什么变化
   - 加深理解

### ❌ 不推荐做法

1. **一次学完所有注解**
   - 注解太多，记不住
   - 很多用不到

2. **死记硬背**
   - 不理解原理
   - 容易忘记

3. **不查文档**
   - 只靠猜测
   - 容易出错

---

## 🎯 快速参考表

### 最常用的 20 个注解

| 注解 | 来源 | 作用 | 使用频率 |
|------|------|------|---------|
| `@Data` | Lombok | 生成方法 | ⭐⭐⭐⭐⭐ |
| `@RestController` | Spring | 控制器 | ⭐⭐⭐⭐⭐ |
| `@Service` | Spring | 服务类 | ⭐⭐⭐⭐⭐ |
| `@Resource` | Spring | 注入依赖 | ⭐⭐⭐⭐⭐ |
| `@TableName` | MyBatis Plus | 表名 | ⭐⭐⭐⭐⭐ |
| `@TableId` | MyBatis Plus | 主键 | ⭐⭐⭐⭐⭐ |
| `@PostMapping` | Spring | POST 请求 | ⭐⭐⭐⭐ |
| `@GetMapping` | Spring | GET 请求 | ⭐⭐⭐⭐ |
| `@RequestBody` | Spring | 接收 JSON | ⭐⭐⭐⭐ |
| `@Override` | Java | 重写方法 | ⭐⭐⭐⭐ |
| `@TableLogic` | MyBatis Plus | 逻辑删除 | ⭐⭐⭐ |
| `@Slf4j` | Lombok | 日志 | ⭐⭐⭐ |
| `@RequestMapping` | Spring | 路径映射 | ⭐⭐⭐ |
| `@Autowired` | Spring | 注入依赖 | ⭐⭐⭐ |
| `@TableField` | MyBatis Plus | 字段配置 | ⭐⭐ |

---

## 📖 学习资源推荐

### 1. 官方文档（最权威）
- Lombok: https://projectlombok.org/features/
- MyBatis Plus: https://baomidou.com/pages/223848/
- Spring Boot: https://docs.spring.io/spring-boot/docs/current/reference/html/

### 2. 视频教程
- B站搜索："Spring Boot 注解详解"
- B站搜索："Lombok 使用教程"

### 3. 在线教程
- 菜鸟教程
- 廖雪峰的官方网站

---

## ✅ 学习检查

测试一下你是否理解了：

1. 注解是什么？
2. 注解以什么符号开头？
3. `@Data` 注解来自哪个工具？
4. `@TableName` 注解的作用是什么？
5. 如何查看注解的详细说明？

<details>
<summary>点击查看答案</summary>

1. 注解是给代码贴的标签，告诉程序如何处理
2. `@` 符号
3. Lombok 工具
4. 指定类对应的数据库表名
5. Ctrl + 点击注解，或查官方文档
</details>

---

## 🎓 总结

### 记住这几点：

1. **注解 = 标签**
   - 告诉程序怎么做
   - 简化代码

2. **学习方法**
   - 边用边学
   - 分类记忆
   - 查文档

3. **不要怕**
   - 注解很多，但常用的不多
   - 看到不懂的就查
   - 慢慢积累

4. **重点掌握**
   - Lombok 的 @Data
   - MyBatis Plus 的 @TableName、@TableId
   - Spring Boot 的 @RestController、@Service

---

**现在理解注解了吗？有任何问题随时问我！** 😊
