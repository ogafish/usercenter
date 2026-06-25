# 第4课 - UserController 控制器层详解

## 课程目标
- 理解 Spring Boot 中 Controller 层的作用和职责
- 掌握 RESTful API 的设计原则
- 学习请求参数接收和响应数据封装
- 了解权限控制和异常处理机制
- 掌握常用的 Spring Web 注解

## 1. Controller 层概述

### 1.1 什么是 Controller 层？
Controller 层是 MVC 架构中的**控制器层**，负责：
- **接收前端请求**：处理 HTTP 请求
- **参数校验**：验证请求参数的合法性
- **调用业务逻辑**：调用 Service 层处理业务
- **返回响应**：将处理结果返回给前端

### 1.2 在三层架构中的位置
```
前端 → Controller 层 → Service 层 → Mapper 层 → 数据库
     ↑                ↑              ↑
   接收请求         业务逻辑        数据访问
```

## 2. UserController 类结构分析

### 2.1 类声明和注解
```java
@RestController
@RequestMapping("/user")
public class UserController {
    
    @Resource
    private UserService userService;
}
```

**注解详解**：
- `@RestController`：组合注解，等于 `@Controller + @ResponseBody`
- `@RequestMapping("/user")`：类级别的路径映射，所有方法的路径都以 `/user` 开头
- `@Resource`：依赖注入，注入 UserService 实例

### 2.2 RESTful API 设计
| HTTP方法 | 路径 | 功能 | 完整URL |
|---------|------|------|---------|
| POST | `/register` | 用户注册 | `/user/register` |
| POST | `/login` | 用户登录 | `/user/login` |
| POST | `/logout` | 用户注销 | `/user/logout` |
| GET | `/current` | 获取当前用户 | `/user/current` |
| GET | `/search` | 搜索用户 | `/user/search` |
| POST | `/delete` | 删除用户 | `/user/delete` |

## 3. 核心方法详解

### 3.1 用户注册接口
```java
@PostMapping("/register")
public BaseResponse<Long> userRegister(@RequestBody UserRegisterRequest userRegisterRequest) {
    // 校验
    if (userRegisterRequest == null) {
        throw new BusinessException(ErrorCode.PARAMS_ERROR);
    }
    String userAccount = userRegisterRequest.getUserAccount();
    String userPassword = userRegisterRequest.getUserPassword();
    String checkPassword = userRegisterRequest.getCheckPassword();
    String planetCode = userRegisterRequest.getPlanetCode();
    if (StringUtils.isAnyBlank(userAccount, userPassword, checkPassword, planetCode)) {
        return null;
    }
    long result = userService.userRegister(userAccount, userPassword, checkPassword, planetCode);
    return ResultUtils.success(result);
}
```

**关键点分析**：
- `@PostMapping("/register")`：映射 POST 请求到 `/user/register`
- `@RequestBody`：将 JSON 请求体转换为 Java 对象
- `UserRegisterRequest`：请求参数封装类
- `BaseResponse<Long>`：统一响应格式，泛型指定数据类型
- `ResultUtils.success(result)`：成功响应工具方法

### 3.2 用户登录接口
```java
@PostMapping("/login")
public BaseResponse<User> userLogin(@RequestBody UserLoginRequest userLoginRequest, HttpServletRequest request) {
    if (userLoginRequest == null) {
        return ResultUtils.error(ErrorCode.PARAMS_ERROR);
    }
    String userAccount = userLoginRequest.getUserAccount();
    String userPassword = userLoginRequest.getUserPassword();
    if (StringUtils.isAnyBlank(userAccount, userPassword)) {
        return ResultUtils.error(ErrorCode.PARAMS_ERROR);
    }
    User user = userService.userLogin(userAccount, userPassword, request);
    return ResultUtils.success(user);
}
```

**关键点分析**：
- 接收两个参数：请求体对象 + HttpServletRequest
- `HttpServletRequest`：用于 Session 管理
- 返回脱敏后的用户信息

### 3.3 获取当前用户接口
```java
@GetMapping("/current")
public BaseResponse<User> getCurrentUser(HttpServletRequest request) {
    Object userObj = request.getSession().getAttribute(USER_LOGIN_STATE);
    User currentUser = (User) userObj;
    if (currentUser == null) {
        throw new BusinessException(ErrorCode.NOT_LOGIN);
    }
    long userId = currentUser.getId();
    // TODO 校验用户是否合法
    User user = userService.getById(userId);
    User safetyUser = userService.getSafetyUser(user);
    return ResultUtils.success(safetyUser);
}
```

**关键点分析**：
- `@GetMapping`：处理 GET 请求
- 从 Session 中获取登录用户信息
- 重新查询数据库获取最新用户信息
- 返回脱敏后的用户信息

## 4. 请求参数封装类

### 4.1 UserRegisterRequest
```java
@Data
public class UserRegisterRequest implements Serializable {
    private static final long serialVersionUID = 3191241716373120793L;
    
    private String userAccount;
    private String userPassword;
    private String checkPassword;
    private String planetCode;
}
```

### 4.2 UserLoginRequest
```java
@Data
public class UserLoginRequest implements Serializable {
    private static final long serialVersionUID = 3191241716373120793L;
    
    private String userAccount;
    private String userPassword;
}
```

**设计优势**：
- **参数封装**：避免方法参数过多
- **类型安全**：编译时检查参数类型
- **可维护性**：参数变更时只需修改一个类
- **序列化支持**：实现 Serializable 接口

## 5. 统一响应格式

### 5.1 BaseResponse 通用返回类
```java
@Data
public class BaseResponse<T> implements Serializable {
    private int code;        // 状态码
    private T data;          // 数据
    private String message;  // 消息
    private String description; // 描述
}
```

### 5.2 ResultUtils 工具类
```java
public class ResultUtils {
    // 成功响应
    public static <T> BaseResponse<T> success(T data) {
        return new BaseResponse<>(0, data, "ok");
    }
    
    // 失败响应
    public static BaseResponse error(ErrorCode errorCode) {
        return new BaseResponse<>(errorCode);
    }
}
```

**统一响应格式的好处**：
- **标准化**：所有接口返回格式一致
- **前端友好**：前端可以统一处理响应
- **错误处理**：统一的错误码和错误信息
- **扩展性**：便于添加新的响应字段

## 6. 权限控制机制

### 6.1 管理员权限检查
```java
private boolean isAdmin(HttpServletRequest request) {
    // 仅管理员可查询
    Object userObj = request.getSession().getAttribute(USER_LOGIN_STATE);
    User user = (User) userObj;
    return user != null && user.getUserRole() == ADMIN_ROLE;
}
```

### 6.2 权限控制应用
```java
@GetMapping("/search")
public BaseResponse<List<User>> searchUsers(String username, HttpServletRequest request) {
    if (!isAdmin(request)) {
        throw new BusinessException(ErrorCode.NO_AUTH, "缺少管理员权限");
    }
    // ... 业务逻辑
}
```

## 7. 异常处理机制

### 7.1 参数校验异常
```java
if (userRegisterRequest == null) {
    throw new BusinessException(ErrorCode.PARAMS_ERROR);
}
```

### 7.2 权限异常
```java
if (!isAdmin(request)) {
    throw new BusinessException(ErrorCode.NO_AUTH, "缺少管理员权限");
}
```

### 7.3 登录状态异常
```java
if (currentUser == null) {
    throw new BusinessException(ErrorCode.NOT_LOGIN);
}
```

## 8. 常用 Spring Web 注解总结

| 注解 | 作用 | 示例 |
|------|------|------|
| `@RestController` | 标记 REST 控制器 | `@RestController` |
| `@RequestMapping` | 映射请求路径 | `@RequestMapping("/user")` |
| `@PostMapping` | 映射 POST 请求 | `@PostMapping("/login")` |
| `@GetMapping` | 映射 GET 请求 | `@GetMapping("/current")` |
| `@RequestBody` | 接收 JSON 请求体 | `@RequestBody UserLoginRequest` |
| `@RequestParam` | 接收请求参数 | `@RequestParam String username` |
| `@PathVariable` | 接收路径变量 | `@PathVariable Long id` |

## 9. 最佳实践建议

### 9.1 参数校验
- 在 Controller 层进行基础参数校验
- 使用专门的请求参数封装类
- 统一的异常处理机制

### 9.2 响应格式
- 使用统一的响应格式
- 合理设计错误码和错误信息
- 返回必要的数据，避免过度暴露

### 9.3 权限控制
- 在需要权限的接口进行权限检查
- 使用统一的权限检查方法
- 明确的权限异常提示

### 9.4 代码组织
- Controller 只负责接收请求和返回响应
- 业务逻辑放在 Service 层
- 保持方法简洁，职责单一

## 10. 课程小结

通过本课学习，我们了解了：
1. **Controller 层的职责**：接收请求、参数校验、调用业务逻辑、返回响应
2. **RESTful API 设计**：合理的 URL 设计和 HTTP 方法使用
3. **请求参数封装**：使用专门的请求类封装参数
4. **统一响应格式**：BaseResponse 和 ResultUtils 的使用
5. **权限控制机制**：基于 Session 的权限检查
6. **异常处理**：统一的异常抛出和处理

Controller 层是前后端交互的桥梁，设计好 Controller 层对整个系统的可维护性和用户体验都非常重要。

---

**下一课预告**：第5课将学习全局异常处理器和统一响应格式的深入应用。