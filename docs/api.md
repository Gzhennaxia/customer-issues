# 客户问题系统 API 文档

## 基础信息

- **API 版本**: v1.0
- **Base URL**: `http://localhost:8080`
- **认证方式**: JWT Token
- **数据格式**: JSON

## 通用响应格式

### 成功响应
```json
{
  "code": 200,
  "message": "success",
  "data": {},
  "timestamp": "2023-12-01T10:00:00Z"
}
```

### 错误响应
```json
{
  "code": 400,
  "message": "错误信息",
  "data": null,
  "timestamp": "2023-12-01T10:00:00Z"
}
```

## 认证接口

### 用户登录

**POST** `/api/auth/login`

#### 请求参数
```json
{
  "username": "admin",
  "password": "admin123"
}
```

#### 响应示例
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "refresh_token_here",
    "userInfo": {
      "id": 1,
      "username": "admin",
      "fullName": "系统管理员",
      "role": "ADMIN",
      "email": "admin@example.com"
    }
  }
}
```

### 刷新Token

**POST** `/api/auth/refresh`

#### 请求头
```
Authorization: Bearer <refresh_token>
```

## 问题管理接口

### 获取问题列表

**GET** `/api/issues`

#### 查询参数
- `page`: 页码 (默认: 1)
- `size`: 每页大小 (默认: 10)
- `status`: 问题状态 (OPEN, IN_PROGRESS, RESOLVED, CLOSED)
- `priority`: 优先级 (LOW, MEDIUM, HIGH, CRITICAL)
- `categoryId`: 分类ID
- `keyword`: 关键词搜索

#### 响应示例
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "records": [
      {
        "id": 1,
        "title": "系统登录失败",
        "description": "用户反馈无法正常登录系统",
        "status": "OPEN",
        "priority": "HIGH",
        "categoryId": 1,
        "categoryName": "系统问题",
        "tags": ["登录", "认证"],
        "images": ["/uploads/images/login_error.png"],
        "viewCount": 15,
        "solutionCount": 2,
        "createdBy": 1,
        "createdByName": "admin",
        "createdAt": "2023-12-01T09:00:00Z",
        "updatedAt": "2023-12-01T10:00:00Z"
      }
    ],
    "total": 100,
    "current": 1,
    "size": 10,
    "pages": 10
  }
}
```

### 创建问题

**POST** `/api/issues`

#### 请求参数
```json
{
  "title": "问题标题",
  "description": "问题描述",
  "categoryId": 1,
  "priority": "MEDIUM",
  "tags": ["标签1", "标签2"],
  "images": ["/uploads/images/screenshot.png"]
}
```

### 获取问题详情

**GET** `/api/issues/{id}`

#### 路径参数
- `id`: 问题ID

### 更新问题

**PUT** `/api/issues/{id}`

#### 请求参数
```json
{
  "title": "更新后的标题",
  "description": "更新后的描述",
  "status": "IN_PROGRESS",
  "priority": "HIGH"
}
```

### 删除问题

**DELETE** `/api/issues/{id}`

## 解决方案接口

### 获取解决方案列表

**GET** `/api/solutions`

#### 查询参数
- `issueId`: 问题ID (必填)
- `page`: 页码
- `size`: 每页大小

### 创建解决方案

**POST** `/api/solutions`

#### 请求参数
```json
{
  "issueId": 1,
  "title": "解决方案标题",
  "content": "详细的解决步骤...",
  "difficultyLevel": "MEDIUM",
  "avgTimeMinutes": 30,
  "toolsRequired": ["SSH", "MySQL", "ClickVisual"]
}
```

### 更新解决方案统计

**POST** `/api/solutions/{id}/feedback`

#### 请求参数
```json
{
  "isSuccess": true,
  "timeSpent": 25,
  "feedback": "解决方案很有效"
}
```

## 智能检索接口

### 语义检索

**POST** `/api/search/semantic`

#### 请求参数
```json
{
  "query": "用户登录失败怎么办",
  "maxResults": 10,
  "similarityThreshold": 0.7
}
```

#### 响应示例
```json
{
  "code": 200,
  "message": "检索成功",
  "data": {
    "results": [
      {
        "issueId": 1,
        "issueTitle": "系统登录失败",
        "solutionId": 1,
        "solutionTitle": "检查用户账户状态",
        "content": "1. 登录系统管理后台...",
        "similarity": 0.95,
        "successRate": 95.5,
        "avgTime": 15,
        "difficultyLevel": "EASY",
        "toolsRequired": ["系统后台", "用户管理"]
      }
    ],
    "searchTime": 120,
    "totalResults": 5
  }
}
```

### 多模态检索

**POST** `/api/search/multimodal`

#### 请求参数 (FormData)
- `query`: 文本查询
- `images`: 图片文件 (可多个)
- `maxResults`: 最大结果数

### 检索反馈

**POST** `/api/search/feedback`

#### 请求参数
```json
{
  "searchLogId": 123,
  "selectedSolutionId": 1,
  "feedback": "HELPFUL",
  "comment": "解决了问题"
}
```

## 分类管理接口

### 获取分类树

**GET** `/api/categories/tree`

#### 响应示例
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "name": "系统问题",
      "parentId": null,
      "description": "系统相关问题",
      "sortOrder": 1,
      "issueCount": 25,
      "children": [
        {
          "id": 6,
          "name": "登录认证",
          "parentId": 1,
          "description": "登录和认证相关问题",
          "sortOrder": 11,
          "issueCount": 10,
          "children": []
        }
      ]
    }
  ]
}
```

### 创建分类

**POST** `/api/categories`

#### 请求参数
```json
{
  "name": "分类名称",
  "parentId": 1,
  "description": "分类描述",
  "sortOrder": 10
}
```

## 文件上传接口

### 上传图片

**POST** `/api/files/upload/image`

#### 请求参数 (FormData)
- `file`: 图片文件
- `type`: 文件类型 (issue, solution, avatar)

#### 响应示例
```json
{
  "code": 200,
  "message": "上传成功",
  "data": {
    "fileName": "screenshot_20231201_100000.png",
    "filePath": "/uploads/images/2023/12/01/screenshot_20231201_100000.png",
    "fileSize": 1024576,
    "fileType": "image/png",
    "uploadTime": "2023-12-01T10:00:00Z"
  }
}
```

## 数据统计接口

### 仪表盘统计

**GET** `/api/analytics/dashboard`

#### 响应示例
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "totalIssues": 500,
    "resolvedIssues": 350,
    "avgResolutionTime": 45.5,
    "topCategories": [
      {
        "categoryName": "系统问题",
        "issueCount": 150
      }
    ],
    "recentTrends": {
      "dates": ["2023-11-24", "2023-11-25", "2023-11-26"],
      "newIssues": [5, 8, 3],
      "resolvedIssues": [7, 6, 9]
    }
  }
}
```

### 搜索统计

**GET** `/api/analytics/search`

#### 查询参数
- `startDate`: 开始日期
- `endDate`: 结束日期

## 系统配置接口

### 获取系统配置

**GET** `/api/config`

### 更新系统配置

**PUT** `/api/config`

#### 请求参数
```json
{
  "deepseekApiKey": "new_api_key",
  "similarityThreshold": 0.8,
  "maxSearchResults": 15
}
```

## 状态码说明

| 状态码 | 说明 |
|--------|------|
| 200 | 请求成功 |
| 201 | 创建成功 |
| 400 | 请求参数错误 |
| 401 | 未授权/Token无效 |
| 403 | 权限不足 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

## 错误码说明

| 错误码 | 说明 |
|--------|------|
| 1001 | 用户名或密码错误 |
| 1002 | Token已过期 |
| 1003 | 权限不足 |
| 2001 | 问题不存在 |
| 2002 | 分类不存在 |
| 3001 | 文件上传失败 |
| 3002 | 文件格式不支持 |
| 4001 | DeepSeek API调用失败 |
| 4002 | Chroma数据库连接失败 |

## 请求头说明

### 认证请求头
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

### 文件上传请求头
```
Authorization: Bearer <jwt_token>
Content-Type: multipart/form-data
```

## 限流说明

- 登录接口：每分钟最多 10 次请求
- 搜索接口：每分钟最多 100 次请求
- 文件上传：每分钟最多 20 次请求
- 其他接口：每分钟最多 1000 次请求

## Webhook通知

系统支持在特定事件发生时发送Webhook通知：

### 支持的事件
- 新问题创建
- 问题状态变更
- 新解决方案添加
- 高优先级问题创建

### Webhook配置
**POST** `/api/webhooks`

```json
{
  "url": "https://your-webhook-url.com/notify",
  "events": ["issue.created", "issue.status.changed"],
  "secret": "webhook_secret"
}
``` 