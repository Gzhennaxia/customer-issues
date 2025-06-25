# 客户问题系统 (Customer Issue System)

## 项目简介

客户问题系统是一个基于AI语义检索的智能客服解决方案，主要用于收集、管理和检索客户问题及其解决方案。系统通过向量数据库和DeepSeek API实现智能问题匹配，帮助快速定位和解决客户问题。

## 核心功能

### 1. 问题管理功能
- 问题录入：支持文本和图片上传
- 解决方案管理：记录详细的排查步骤
- 分类管理：支持多维度问题分类
- 标签系统：便于问题快速检索

### 2. 智能检索功能
- 语义相似度匹配：基于DeepSeek API进行智能匹配
- 多模态检索：支持文本+图片的综合检索
- 结果排序：按相似度和历史成功率排序
- 快速响应：毫秒级检索响应

## 技术架构

### 前端技术栈
- **框架**: Vue 3.x
- **UI库**: Element Plus
- **状态管理**: Pinia
- **路由**: Vue Router
- **HTTP客户端**: Axios
- **构建工具**: Vite

### 后端技术栈
- **框架**: Spring Boot 3.x
- **数据访问**: MyBatis Plus
- **数据库**: MySQL 8.0
- **向量数据库**: Chroma
- **AI服务**: DeepSeek API
- **文件存储**: 本地文件系统/OSS
- **API文档**: Swagger/OpenAPI

### 基础设施
- **容器化**: Docker & Docker Compose
- **反向代理**: Nginx
- **监控**: Spring Boot Actuator

## 项目结构

```
customer-issues/
├── frontend/                    # 前端Vue项目
│   ├── src/
│   │   ├── components/         # 通用组件
│   │   ├── views/             # 页面组件
│   │   ├── api/               # API接口
│   │   ├── store/             # 状态管理
│   │   ├── router/            # 路由配置
│   │   └── utils/             # 工具函数
│   ├── public/                # 静态资源
│   ├── package.json
│   └── vite.config.js
├── backend/                     # 后端Spring Boot项目
│   ├── src/main/java/
│   │   └── com/customerissue/
│   │       ├── controller/     # 控制器层
│   │       ├── service/        # 业务逻辑层
│   │       ├── mapper/         # 数据访问层
│   │       ├── entity/         # 实体类
│   │       ├── dto/            # 数据传输对象
│   │       ├── config/         # 配置类
│   │       └── utils/          # 工具类
│   ├── src/main/resources/
│   │   ├── mapper/             # MyBatis XML映射文件
│   │   ├── application.yml     # 应用配置
│   │   └── db/migration/       # 数据库迁移脚本
│   └── pom.xml
├── database/
│   └── init.sql               # 数据库初始化脚本
├── docker/
│   ├── docker-compose.yml     # Docker编排文件
│   ├── nginx.conf             # Nginx配置
│   └── Dockerfile.*           # 各服务Dockerfile
├── docs/                      # 项目文档
│   ├── api.md                 # API文档
│   ├── deployment.md          # 部署文档
│   └── architecture.md        # 架构文档
├── .gitignore
└── README.md
```

## 数据库设计

### 主要数据表

#### 1. issues (问题表)
```sql
CREATE TABLE issues (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL COMMENT '问题标题',
    description TEXT COMMENT '问题描述',
    category_id BIGINT COMMENT '分类ID',
    tags JSON COMMENT '标签',
    images JSON COMMENT '相关图片',
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') COMMENT '优先级',
    status ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') COMMENT '状态',
    vector_id VARCHAR(255) COMMENT '向量数据库ID',
    created_by BIGINT COMMENT '创建人',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### 2. solutions (解决方案表)
```sql
CREATE TABLE solutions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    issue_id BIGINT NOT NULL COMMENT '关联问题ID',
    title VARCHAR(255) NOT NULL COMMENT '解决方案标题',
    content TEXT NOT NULL COMMENT '解决步骤详情',
    success_rate DECIMAL(5,2) COMMENT '成功率',
    avg_time_minutes INT COMMENT '平均解决时间(分钟)',
    tools_required JSON COMMENT '需要的工具(ClickVisual,SQL,Redis等)',
    created_by BIGINT COMMENT '创建人',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES issues(id)
);
```

#### 3. categories (分类表)
```sql
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '分类名称',
    parent_id BIGINT COMMENT '父分类ID',
    description TEXT COMMENT '分类描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 4. search_logs (搜索日志表)
```sql
CREATE TABLE search_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    query_text TEXT COMMENT '搜索查询',
    query_images JSON COMMENT '查询图片',
    results JSON COMMENT '搜索结果',
    selected_solution_id BIGINT COMMENT '用户选择的解决方案ID',
    feedback ENUM('HELPFUL', 'NOT_HELPFUL') COMMENT '用户反馈',
    search_time_ms INT COMMENT '搜索耗时',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 核心功能实现

### 1. 语义检索流程
1. **向量化**: 使用DeepSeek API将问题文本转换为向量
2. **存储**: 将向量存储在Chroma数据库中
3. **检索**: 根据查询向量在Chroma中进行相似度搜索
4. **排序**: 结合相似度分数和历史成功率进行结果排序
5. **返回**: 返回最匹配的解决方案

### 2. 多模态处理
- **图片处理**: 使用OCR提取图片中的文本信息
- **特征提取**: 提取图片的视觉特征
- **融合检索**: 将文本和图片特征进行融合检索

### 3. 智能推荐算法
- **相似度加权**: similarity_score * 0.7
- **成功率加权**: success_rate * 0.2  
- **时效性加权**: time_relevance * 0.1

## 部署指南

### 1. 环境要求
- Docker & Docker Compose
- MySQL 8.0+
- Node.js 16+
- Java 17+
- Python 3.8+ (Chroma)

### 2. 快速启动
```bash
# 克隆项目
git clone <repository-url>
cd customer-issues

# 启动所有服务
docker-compose up -d

# 初始化数据库
docker exec -i mysql mysql -u root -p < database/init.sql

# 访问应用
# 前端: http://localhost:3000
# 后端API: http://localhost:8080
# API文档: http://localhost:8080/swagger-ui.html
```

### 3. 开发环境配置

#### 后端开发
```bash
cd backend
mvn spring-boot:run
```

#### 前端开发
```bash
cd frontend
npm install
npm run dev
```

### 4. 生产环境部署
参考 `docs/deployment.md` 文档进行生产环境配置。

## API 接口说明

### 问题管理接口
- `POST /api/issues` - 创建问题
- `GET /api/issues` - 查询问题列表
- `GET /api/issues/{id}` - 获取问题详情
- `PUT /api/issues/{id}` - 更新问题
- `DELETE /api/issues/{id}` - 删除问题

### 解决方案接口
- `POST /api/solutions` - 创建解决方案
- `GET /api/solutions/issue/{issueId}` - 获取问题的解决方案
- `PUT /api/solutions/{id}` - 更新解决方案

### 智能检索接口
- `POST /api/search/semantic` - 语义检索
- `POST /api/search/multimodal` - 多模态检索
- `POST /api/search/feedback` - 搜索结果反馈

## 配置说明

### DeepSeek API 配置
```yaml
deepseek:
  api-key: ${DEEPSEEK_API_KEY}
  base-url: https://api.deepseek.com
  model: deepseek-chat
```

### Chroma 配置
```yaml
chroma:
  host: localhost
  port: 8000
  collection-name: customer-issues
```

## 开发指南

### 1. 代码规范
- Java: 遵循Google Java Style Guide
- Vue: 遵循Vue.js Style Guide
- 提交信息: 遵循Conventional Commits规范

### 2. 测试策略
- 单元测试覆盖率 > 80%
- 集成测试覆盖核心业务流程
- E2E测试覆盖关键用户场景

### 3. 性能优化
- 数据库索引优化
- 缓存策略(Redis)
- 异步处理长耗时操作
- 分页查询优化

## 监控和运维

### 1. 应用监控
- Spring Boot Actuator健康检查
- 自定义业务指标监控
- 日志收集和分析

### 2. 性能监控
- API响应时间监控
- 数据库查询性能监控
- 向量检索性能监控

## 常见问题

### Q: 如何提高检索准确率？
A: 
1. 优化问题描述的质量和完整性
2. 增加训练数据量
3. 调整相似度阈值
4. 使用用户反馈进行模型优化

### Q: 如何处理大量并发检索请求？
A: 
1. 使用连接池管理数据库连接
2. 实现Chroma客户端连接复用
3. 添加Redis缓存层
4. 考虑异步处理和消息队列

## 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 联系方式

如有问题或建议，请通过以下方式联系：
- 邮箱: [your-email@example.com]
- 项目地址: [GitHub Repository URL]

---

**注意**: 本系统处理敏感的客户数据，请确保在生产环境中实施适当的安全措施，包括数据加密、访问控制和审计日志。 