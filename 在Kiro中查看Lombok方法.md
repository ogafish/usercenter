# 🔍 在 Kiro 中查看 Lombok 生成的方法

## 🎯 你现在的情况

你在 Kiro（AI IDE）中查看代码，想看 `@Data` 生成了哪些方法。

---

## ✅ 最简单的方法：直接看使用示例

### 方法1：查看项目中的实际使用

让我们看看项目中是如何使用 User 对象的：

#### 在 UserServiceImpl.java 中的使用

**位置**：`service/impl/UserServiceImpl.java`

```java
// 第 85-90 行：创建用户时使用
User user = new User();
user.setUserAccount(userAccount);      // ← @Data 生成的 setter
user.setUserPassword(encryptPassword); // ← @Data 生成的 setter
user.setPlanetCode(planetCode);        // ← @Data 生成的 setter

this.save(user);
return user.getId();  // ← @Data 生成的 getter
```

**这证明了 @Data 生成了：**
- `setUserAccount(String userAccount)`
- `setUserPassword(String userPassword)`
- `setPlanetCode(String planetCode)`
- `getId()`

#### 在 UserServiceImpl.java 的脱敏方法中

**位置**：`service/impl/UserServiceImpl.java` 第 155-170 行

```java
public User getSafetyUser(User originUser) {
    User safetyUser = new User();
    
    // 使用 @Data 生成的 getter 和 setter
    safetyUser.setId(originUser.getId());                    // ← getter + setter
    safetyUser.setUsername(originUser.getUsername());        // ← getter + setter
    safetyUser.setUserAccount(originUser.getUserAccount());  // ← getter + setter
    safetyUser.setAvatarUrl(originUser.getAvatarUrl());      // ← getter + setter
    safetyUser.setGender(originUser.getGender());            // ← getter + setter
    safetyUser.setPhone(originUser.getPhone());              // ← getter + setter
    safetyUser.setEmail(originUser.getEmail());              // ← getter + setter
    safetyUser.setPlanetCode(originUser.getPlanetCode());    // ← getter + setter
    safetyUser.setUserRole(originUser.getUserRole());        // ← getter + setter
    safetyUser.setUserStatus(originUser.getUserStatus());    // ← getter + setter
    safetyUser.setCreateTime(originUser.getCreateTime());    // ← getter + setter
    
    return safetyUser;
}
```

---

## 📋 @Data 为 User 类生成的完整方法列表

根据 User.java 的字段，`@Data` 生成了以下方法：

### Getter 方法（获取值）

```java
public Long getId()
public String getUsername()
public String getUserAccount()
public String getAvatarUrl()
public Integer getGender()
public String getUserPassword()
public String getPhone()
public String getEmail()
public Integer getUserStatus()
public Date getCreateTime()
public Date getUpdateTime()
public Integer getIsDelete()
public Integer getUserRole()
public String getPlanetCode()
```

### Setter 方法（设置值）

```java
public void setId(Long id)
public void setUsername(String username)
public void setUserAccount(String userAccount)
public void setAvatarUrl(String avatarUrl)
public void setGender(Integer gender)
public void setUserPassword(String userPassword)
public void setPhone(String phone)
public void setEmail(String email)
public void setUserStatus(Integer userStatus)
public void setCreateTime(Date createTime)
public void setUpdateTime(Date updateTime)
public void setIsDelete(Integer isDelete)
public void setUserRole(Integer userRole)
public void setPlanetCode(String planetCode)
```

### 其他方法

```java
public String toString()        // 转成字符串
public boolean equals(Object o) // 比较对象
public int hashCode()           // 计算哈希值
```

---

## 🔍 方法2：搜索使用位置

在 Kiro 中，你可以搜索这些方法的使用：

### 搜索 setUserAccount

```
在项目中搜索：setUserAccount
你会找到很多使用的地方，这证明这个方法存在
```

### 搜索 getId

```
在项目中搜索：getId()
你会找到很多使用的地方
```

---

## 📖 方法3：查看相关文件

让我帮你列出使用了 User 对象方法的文件：

### 1. UserServiceImpl.java

**使用的 setter 方法：**
- `user.setUserAccount()`
- `user.setUserPassword()`
- `user.setPlanetCode()`
- `user.setId()`
- `user.setUsername()`
- `user.setAvatarUrl()`
- `user.setGender()`
- `user.setPhone()`
- `user.setEmail()`
- `user.setUserRole()`
- `user.setUserStatus()`
- `user.setCreateTime()`

**使用的 getter 方法：**
- `user.getId()`
- `user.getUsername()`
- `user.getUserAccount()`
- `user.getAvatarUrl()`
- `user.getGender()`
- `user.getPhone()`
- `user.getEmail()`
- `user.getUserRole()`
- `user.getUserStatus()`
- `user.getCreateTime()`

### 2. UserController.java

**使用的 getter 方法：**
- `currentUser.getId()`
- `user.getUserRole()`

---

## 💡 验证方法：看编译后的文件

如果你想看实际生成的代码，可以查看编译后的文件：

### 步骤

1. **找到编译后的文件**
   ```
   路径：user-center-backend-master/user-center-backend-master/
         target/classes/com/yupi/usercenter/model/domain/User.class
   ```

2. **这个 .class 文件包含了所有生成的方法**

---

## 🎓 总结

### @Data 为 User 类生成了什么？

**每个字段都生成了：**
- getter 方法（如 `getId()`）
- setter 方法（如 `setId(Long id)`）

**额外生成了：**
- `toString()` 方法
- `equals(Object o)` 方法
- `hashCode()` 方法

### 如何验证？

1. **看使用示例**（最简单）
   - 在 UserServiceImpl.java 中看到大量使用
   - 如 `user.setUserAccount()`、`user.getId()`

2. **搜索方法名**
   - 搜索 `setUserAccount`
   - 搜索 `getId`
   - 找到使用的地方

3. **查看编译后的文件**
   - 找到 target/classes 下的 User.class
   - 包含所有生成的方法

---

## 📊 完整的方法对照表

| User.java 字段 | 生成的 Getter | 生成的 Setter |
|---------------|--------------|--------------|
| `private Long id` | `getId()` | `setId(Long id)` |
| `private String username` | `getUsername()` | `setUsername(String username)` |
| `private String userAccount` | `getUserAccount()` | `setUserAccount(String userAccount)` |
| `private String avatarUrl` | `getAvatarUrl()` | `setAvatarUrl(String avatarUrl)` |
| `private Integer gender` | `getGender()` | `setGender(Integer gender)` |
| `private String userPassword` | `getUserPassword()` | `setUserPassword(String userPassword)` |
| `private String phone` | `getPhone()` | `setPhone(String phone)` |
| `private String email` | `getEmail()` | `setEmail(String email)` |
| `private Integer userStatus` | `getUserStatus()` | `setUserStatus(Integer userStatus)` |
| `private Date createTime` | `getCreateTime()` | `setCreateTime(Date createTime)` |
| `private Date updateTime` | `getUpdateTime()` | `setUpdateTime(Date updateTime)` |
| `private Integer isDelete` | `getIsDelete()` | `setIsDelete(Integer isDelete)` |
| `private Integer userRole` | `getUserRole()` | `setUserRole(Integer userRole)` |
| `private String planetCode` | `getPlanetCode()` | `setPlanetCode(String planetCode)` |

**总共：14 个字段 × 2 = 28 个方法 + 3 个额外方法 = 31 个方法！**

---

**现在清楚了吗？** 😊

虽然在 Kiro 中可能看不到 Structure 视图，但通过查看实际使用的代码，你可以清楚地知道 @Data 生成了哪些方法！
