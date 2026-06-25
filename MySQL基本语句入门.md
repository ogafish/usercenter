# MySQL 基本语句入门

## 📚 SQL 是什么

**SQL**（Structured Query Language）= 结构化查询语言
- 用于操作数据库的语言
- 可以增删改查数据
- 所有关系型数据库都使用 SQL

---

## 🎯 四大基本操作（CRUD）

```
C - Create  （创建/插入）→ INSERT
R - Read    （读取/查询）→ SELECT
U - Update  （更新）     → UPDATE
D - Delete  （删除）     → DELETE
```

---

## 1️⃣ SELECT - 查询数据

### 基本语法

```sql
SELECT 字段名 FROM 表名 WHERE 条件;
```

### SELECT * 的含义

```sql
SELECT * FROM user;
```

**解释**：
- `SELECT`：查询命令
- `*`：星号，表示"所有字段"
- `FROM user`：从 user 表中查询
- 意思：查询 user 表的所有字段

**等价于**：
```sql
SELECT id, username, userAccount, avatarUrl, gender, 
       userPassword, phone, email, userStatus, 
       createTime, updateTime, isDelete, userRole, planetCode
FROM user;
```

### WHERE 的含义

```sql
SELECT * FROM user WHERE username = '张三';
```

**解释**：
- `WHERE`：条件关键字，表示"在什么条件下"
- `username = '张三'`：条件表达式
- 意思：查询 username 等于"张三"的用户

**WHERE 常用条件**：
```sql
-- 等于
WHERE username = '张三'

-- 不等于
WHERE userStatus != 1

-- 大于/小于
WHERE age > 18
WHERE age < 60

-- 模糊查询（LIKE）
WHERE username LIKE '%张%'  -- 包含"张"
WHERE username LIKE '张%'   -- 以"张"开头
WHERE username LIKE '%张'   -- 以"张"结尾
```


### 多个条件（AND / OR）

```sql
-- AND（并且）：所有条件都要满足
SELECT * FROM user 
WHERE username LIKE '%张%' 
  AND userStatus = 0;
-- 意思：查询名字包含"张"并且状态为0的用户

-- OR（或者）：满足任意一个条件即可
SELECT * FROM user 
WHERE username = '张三' 
   OR phone = '13800138000';
-- 意思：查询名字是"张三"或者手机号是"13800138000"的用户
```

### 查询示例

```sql
-- 1. 查询所有用户
SELECT * FROM user;

-- 2. 查询指定字段
SELECT id, username, phone FROM user;

-- 3. 查询单个用户
SELECT * FROM user WHERE id = 1;

-- 4. 查询账号为 yupi 的用户
SELECT * FROM user WHERE userAccount = 'yupi';

-- 5. 查询名字包含"张"的用户
SELECT * FROM user WHERE username LIKE '%张%';

-- 6. 查询正常状态的用户
SELECT * FROM user WHERE userStatus = 0 AND isDelete = 0;

-- 7. 统计用户数量
SELECT COUNT(*) FROM user;

-- 8. 排序查询（最新注册的10个用户）
SELECT * FROM user 
ORDER BY createTime DESC 
LIMIT 10;
```

---

## 2️⃣ INSERT - 插入数据

### 基本语法

```sql
INSERT INTO 表名 (字段1, 字段2, ...) VALUES (值1, 值2, ...);
```

### 插入示例

```sql
-- 插入新用户
INSERT INTO user (userAccount, userPassword, username) 
VALUES ('zhangsan', 'encrypted_password', '张三');

-- 插入多条数据
INSERT INTO user (userAccount, userPassword, username) 
VALUES 
    ('lisi', 'password1', '李四'),
    ('wangwu', 'password2', '王五');
```

---

## 3️⃣ UPDATE - 更新数据

### 基本语法

```sql
UPDATE 表名 SET 字段1=值1, 字段2=值2 WHERE 条件;
```

### 更新示例

```sql
-- 更新用户名
UPDATE user SET username = '张三丰' WHERE id = 1;

-- 更新多个字段
UPDATE user 
SET username = '张三丰', 
    phone = '13800138000' 
WHERE id = 1;

-- ⚠️ 注意：没有 WHERE 会更新所有记录！
UPDATE user SET userStatus = 1;  -- 危险！会更新所有用户
```

---

## 4️⃣ DELETE - 删除数据

### 基本语法

```sql
DELETE FROM 表名 WHERE 条件;
```

### 删除示例

```sql
-- 删除指定用户
DELETE FROM user WHERE id = 1;

-- 删除多个用户
DELETE FROM user WHERE userStatus = 1;

-- ⚠️ 注意：没有 WHERE 会删除所有记录！
DELETE FROM user;  -- 危险！会删除所有用户
```

### 逻辑删除（推荐）

```sql
-- 不真正删除，只是标记为已删除
UPDATE user SET isDelete = 1 WHERE id = 1;

-- 查询时排除已删除的数据
SELECT * FROM user WHERE isDelete = 0;
```

---

## 🔍 项目中的实际使用

### 示例1：用户注册

```sql
-- Java 代码
user.setUserAccount("zhangsan");
user.setUserPassword("encrypted_password");
this.save(user);

-- 生成的 SQL
INSERT INTO user (userAccount, userPassword, createTime, updateTime) 
VALUES ('zhangsan', 'encrypted_password', NOW(), NOW());
```

### 示例2：用户登录

```sql
-- Java 代码
QueryWrapper<User> qw = new QueryWrapper<>();
qw.eq("userAccount", "yupi");
qw.eq("userPassword", "encrypted_password");
User user = userMapper.selectOne(qw);

-- 生成的 SQL
SELECT * FROM user 
WHERE userAccount = 'yupi' 
  AND userPassword = 'encrypted_password'
  AND isDelete = 0
LIMIT 1;
```

### 示例3：检查账号是否存在

```sql
-- Java 代码
QueryWrapper<User> qw = new QueryWrapper<>();
qw.eq("userAccount", "zhangsan");
long count = userMapper.selectCount(qw);

-- 生成的 SQL
SELECT COUNT(*) FROM user 
WHERE userAccount = 'zhangsan' 
  AND isDelete = 0;
```

### 示例4：搜索用户

```sql
-- Java 代码
QueryWrapper<User> qw = new QueryWrapper<>();
qw.like("username", "张");
List<User> users = userMapper.selectList(qw);

-- 生成的 SQL
SELECT * FROM user 
WHERE username LIKE '%张%' 
  AND isDelete = 0;
```

---

## 📝 SQL 关键字总结

| 关键字 | 作用 | 示例 |
|--------|------|------|
| SELECT | 查询 | SELECT * FROM user |
| FROM | 指定表 | FROM user |
| WHERE | 条件 | WHERE id = 1 |
| INSERT | 插入 | INSERT INTO user (...) VALUES (...) |
| UPDATE | 更新 | UPDATE user SET ... |
| DELETE | 删除 | DELETE FROM user WHERE ... |
| AND | 并且 | WHERE age > 18 AND age < 60 |
| OR | 或者 | WHERE name = '张三' OR phone = '...' |
| LIKE | 模糊查询 | WHERE name LIKE '%张%' |
| ORDER BY | 排序 | ORDER BY createTime DESC |
| LIMIT | 限制数量 | LIMIT 10 |
| COUNT | 统计 | SELECT COUNT(*) FROM user |

---

## 💡 学习建议

1. **先理解基本语句**：SELECT、INSERT、UPDATE、DELETE
2. **多看项目中的 SQL**：看 MyBatis Plus 生成的 SQL
3. **动手练习**：在数据库客户端执行 SQL
4. **理解 WHERE 条件**：这是最常用的部分
5. **注意安全**：UPDATE 和 DELETE 一定要加 WHERE

---

## 🎯 下一步

学习完 SQL 基础后，你会更容易理解：
- QueryWrapper 如何生成 SQL
- Mapper 如何操作数据库
- Service 层的业务逻辑

有问题随时问我！
