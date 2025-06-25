-- 客户问题系统数据库初始化脚本
-- 创建数据库
CREATE DATABASE IF NOT EXISTS customer_issues_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE customer_issues_db;

-- 1. 分类表
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '分类名称',
    parent_id BIGINT COMMENT '父分类ID',
    description TEXT COMMENT '分类描述',
    sort_order INT DEFAULT 0 COMMENT '排序',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_parent_id (parent_id),
    INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB COMMENT='问题分类表';

-- 2. 问题表
CREATE TABLE issues (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL COMMENT '问题标题',
    description TEXT COMMENT '问题描述',
    category_id BIGINT COMMENT '分类ID',
    tags JSON COMMENT '标签',
    images JSON COMMENT '相关图片路径',
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') DEFAULT 'MEDIUM' COMMENT '优先级',
    status ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') DEFAULT 'OPEN' COMMENT '状态',
    vector_id VARCHAR(255) COMMENT '向量数据库ID',
    view_count INT DEFAULT 0 COMMENT '查看次数',
    solution_count INT DEFAULT 0 COMMENT '解决方案数量',
    created_by BIGINT COMMENT '创建人',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_category_id (category_id),
    INDEX idx_status (status),
    INDEX idx_priority (priority),
    INDEX idx_created_at (created_at),
    INDEX idx_vector_id (vector_id),
    FULLTEXT INDEX ft_title_description (title, description)
) ENGINE=InnoDB COMMENT='问题表';

-- 3. 解决方案表
CREATE TABLE solutions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    issue_id BIGINT NOT NULL COMMENT '关联问题ID',
    title VARCHAR(255) NOT NULL COMMENT '解决方案标题',
    content TEXT NOT NULL COMMENT '解决步骤详情',
    success_rate DECIMAL(5,2) DEFAULT 0.00 COMMENT '成功率',
    avg_time_minutes INT DEFAULT 0 COMMENT '平均解决时间(分钟)',
    tools_required JSON COMMENT '需要的工具(ClickVisual,SQL,Redis等)',
    difficulty_level ENUM('EASY', 'MEDIUM', 'HARD') DEFAULT 'MEDIUM' COMMENT '难度级别',
    usage_count INT DEFAULT 0 COMMENT '使用次数',
    success_count INT DEFAULT 0 COMMENT '成功次数',
    created_by BIGINT COMMENT '创建人',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES issues(id) ON DELETE CASCADE,
    INDEX idx_issue_id (issue_id),
    INDEX idx_success_rate (success_rate),
    INDEX idx_difficulty_level (difficulty_level),
    FULLTEXT INDEX ft_title_content (title, content)
) ENGINE=InnoDB COMMENT='解决方案表';

-- 4. 搜索日志表
CREATE TABLE search_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    query_text TEXT COMMENT '搜索查询',
    query_images JSON COMMENT '查询图片',
    results JSON COMMENT '搜索结果',
    result_count INT DEFAULT 0 COMMENT '结果数量',
    selected_solution_id BIGINT COMMENT '用户选择的解决方案ID',
    feedback ENUM('HELPFUL', 'NOT_HELPFUL', 'PARTIALLY_HELPFUL') COMMENT '用户反馈',
    search_time_ms INT COMMENT '搜索耗时',
    search_type ENUM('SEMANTIC', 'MULTIMODAL', 'FULLTEXT') DEFAULT 'SEMANTIC' COMMENT '搜索类型',
    client_ip VARCHAR(45) COMMENT '客户端IP',
    user_agent TEXT COMMENT '用户代理',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (selected_solution_id) REFERENCES solutions(id) ON DELETE SET NULL,
    INDEX idx_created_at (created_at),
    INDEX idx_search_type (search_type),
    INDEX idx_selected_solution_id (selected_solution_id)
) ENGINE=InnoDB COMMENT='搜索日志表';

-- 5. 用户表（简单用户管理）
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
    full_name VARCHAR(100) COMMENT '全名',
    role ENUM('ADMIN', 'OPERATOR', 'VIEWER') DEFAULT 'VIEWER' COMMENT '角色',
    status ENUM('ACTIVE', 'INACTIVE', 'LOCKED') DEFAULT 'ACTIVE' COMMENT '状态',
    last_login_at TIMESTAMP NULL COMMENT '最后登录时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB COMMENT='用户表';

-- 6. 问题反馈表
CREATE TABLE issue_feedback (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    issue_id BIGINT NOT NULL COMMENT '问题ID',
    solution_id BIGINT COMMENT '解决方案ID',
    feedback_type ENUM('LIKE', 'DISLIKE', 'REPORT') NOT NULL COMMENT '反馈类型',
    feedback_text TEXT COMMENT '反馈内容',
    is_resolved BOOLEAN DEFAULT FALSE COMMENT '是否已解决问题',
    resolution_time_minutes INT COMMENT '解决耗时(分钟)',
    client_ip VARCHAR(45) COMMENT '客户端IP',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issue_id) REFERENCES issues(id) ON DELETE CASCADE,
    FOREIGN KEY (solution_id) REFERENCES solutions(id) ON DELETE CASCADE,
    INDEX idx_issue_id (issue_id),
    INDEX idx_solution_id (solution_id),
    INDEX idx_feedback_type (feedback_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB COMMENT='问题反馈表';

-- 7. 系统配置表
CREATE TABLE system_config (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    config_key VARCHAR(100) NOT NULL UNIQUE COMMENT '配置键',
    config_value TEXT COMMENT '配置值',
    config_type ENUM('STRING', 'NUMBER', 'BOOLEAN', 'JSON') DEFAULT 'STRING' COMMENT '配置类型',
    description TEXT COMMENT '配置描述',
    is_encrypted BOOLEAN DEFAULT FALSE COMMENT '是否加密',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_config_key (config_key)
) ENGINE=InnoDB COMMENT='系统配置表';

-- 插入初始分类数据
INSERT INTO categories (name, parent_id, description, sort_order) VALUES
('系统问题', NULL, '系统相关问题', 1),
('数据库问题', NULL, '数据库相关问题', 2),
('网络问题', NULL, '网络连接相关问题', 3),
('性能问题', NULL, '系统性能相关问题', 4),
('用户界面问题', NULL, '前端界面相关问题', 5),
('登录认证', 1, '登录和认证相关问题', 11),
('权限管理', 1, '权限和访问控制问题', 12),
('数据同步', 1, '数据同步相关问题', 13),
('MySQL问题', 2, 'MySQL数据库问题', 21),
('Redis问题', 2, 'Redis缓存问题', 22),
('连接超时', 3, '网络连接超时问题', 31),
('响应缓慢', 4, '系统响应缓慢问题', 41),
('内存溢出', 4, '内存使用问题', 42),
('页面加载', 5, '页面加载相关问题', 51);

-- 插入初始用户数据（密码为 admin123，实际使用时应该加密）
INSERT INTO users (username, email, password_hash, full_name, role) VALUES
('admin', 'admin@example.com', '$2a$10$rQ8QVQ7ZQ9ZQ9ZQ9ZQ9ZQeJ', '系统管理员', 'ADMIN'),
('operator', 'operator@example.com', '$2a$10$rQ8QVQ7ZQ9ZQ9ZQ9ZQ9ZQeK', '系统操作员', 'OPERATOR');

-- 插入示例问题数据
INSERT INTO issues (title, description, category_id, tags, priority, vector_id) VALUES
('系统登录失败', '用户反馈无法正常登录系统，提示用户名或密码错误', 1, '["登录", "认证", "错误"]', 'HIGH', 'vec_login_001'),
('数据库连接超时', 'ClickVisual查询时出现数据库连接超时错误', 2, '["数据库", "超时", "ClickVisual"]', 'CRITICAL', 'vec_db_001'),
('页面加载缓慢', '用户反馈系统页面加载速度很慢，影响使用体验', 4, '["性能", "页面", "缓慢"]', 'MEDIUM', 'vec_perf_001'),
('Redis缓存失效', 'Redis缓存服务器连接异常，导致数据读取缓慢', 2, '["Redis", "缓存", "连接"]', 'HIGH', 'vec_redis_001');

-- 插入示例解决方案数据
INSERT INTO solutions (issue_id, title, content, success_rate, avg_time_minutes, tools_required, difficulty_level) VALUES
(1, '检查用户账户状态', '1. 登录系统管理后台\n2. 查询用户账户状态\n3. 检查账户是否被锁定\n4. 重置用户密码\n5. 通知用户使用新密码登录', 95.50, 15, '["系统后台", "用户管理"]', 'EASY'),
(1, '清除浏览器缓存', '1. 指导用户清除浏览器缓存\n2. 清除Cookie\n3. 重新访问登录页面\n4. 使用正确的用户名密码登录', 85.30, 5, '["浏览器"]', 'EASY'),
(2, '检查数据库连接池', '1. 登录服务器\n2. 检查数据库连接池状态\n3. 重启数据库连接池\n4. 验证ClickVisual连接\n5. 测试查询功能', 90.00, 20, '["SSH", "数据库管理", "ClickVisual"]', 'MEDIUM'),
(3, '优化数据库查询', '1. 分析慢查询日志\n2. 检查SQL执行计划\n3. 添加必要索引\n4. 优化查询语句\n5. 测试性能改善', 88.75, 45, '["MySQL", "性能分析工具"]', 'HARD'),
(4, '重启Redis服务', '1. 登录Redis服务器\n2. 检查Redis服务状态\n3. 重启Redis服务\n4. 验证连接\n5. 清理过期数据', 92.10, 10, '["SSH", "Redis"]', 'MEDIUM');

-- 插入系统配置数据
INSERT INTO system_config (config_key, config_value, config_type, description) VALUES
('deepseek.api.key', '', 'STRING', 'DeepSeek API密钥'),
('deepseek.api.base_url', 'https://api.deepseek.com', 'STRING', 'DeepSeek API基础URL'),
('deepseek.model', 'deepseek-chat', 'STRING', 'DeepSeek模型名称'),
('chroma.host', 'localhost', 'STRING', 'Chroma数据库主机'),
('chroma.port', '8000', 'NUMBER', 'Chroma数据库端口'),
('chroma.collection_name', 'customer-issues', 'STRING', 'Chroma集合名称'),
('search.similarity_threshold', '0.7', 'NUMBER', '相似度阈值'),
('search.max_results', '10', 'NUMBER', '最大搜索结果数'),
('file.upload.max_size', '10485760', 'NUMBER', '文件上传最大大小(bytes)'),
('file.upload.allowed_types', '["jpg", "jpeg", "png", "gif", "pdf", "doc", "docx"]', 'JSON', '允许上传的文件类型');

-- 创建全文索引（需要MySQL 5.7+）
-- ALTER TABLE issues ADD FULLTEXT(title, description);
-- ALTER TABLE solutions ADD FULLTEXT(title, content);

-- 创建视图：问题统计视图
CREATE VIEW issue_stats AS
SELECT 
    c.name as category_name,
    COUNT(i.id) as issue_count,
    AVG(i.solution_count) as avg_solutions_per_issue,
    SUM(CASE WHEN i.status = 'RESOLVED' THEN 1 ELSE 0 END) as resolved_count,
    SUM(CASE WHEN i.status = 'OPEN' THEN 1 ELSE 0 END) as open_count
FROM categories c
LEFT JOIN issues i ON c.id = i.category_id
GROUP BY c.id, c.name;

-- 创建视图：解决方案效果统计
CREATE VIEW solution_effectiveness AS
SELECT 
    s.id,
    s.title,
    s.success_rate,
    s.usage_count,
    s.success_count,
    CASE 
        WHEN s.usage_count > 0 THEN (s.success_count * 100.0 / s.usage_count)
        ELSE 0
    END as actual_success_rate,
    i.title as issue_title,
    c.name as category_name
FROM solutions s
JOIN issues i ON s.issue_id = i.id
LEFT JOIN categories c ON i.category_id = c.id;

-- 创建存储过程：更新解决方案统计
DELIMITER //
CREATE PROCEDURE UpdateSolutionStats(IN solution_id BIGINT, IN is_success BOOLEAN)
BEGIN
    UPDATE solutions 
    SET 
        usage_count = usage_count + 1,
        success_count = success_count + IF(is_success, 1, 0),
        success_rate = CASE 
            WHEN (usage_count + 1) > 0 THEN ((success_count + IF(is_success, 1, 0)) * 100.0 / (usage_count + 1))
            ELSE 0
        END
    WHERE id = solution_id;
END //
DELIMITER ;

-- 创建触发器：自动更新问题的解决方案数量
DELIMITER //
CREATE TRIGGER update_issue_solution_count 
AFTER INSERT ON solutions
FOR EACH ROW
BEGIN
    UPDATE issues 
    SET solution_count = (
        SELECT COUNT(*) FROM solutions WHERE issue_id = NEW.issue_id
    )
    WHERE id = NEW.issue_id;
END //
DELIMITER ;

-- 插入一些搜索日志示例数据
INSERT INTO search_logs (query_text, result_count, search_time_ms, search_type, client_ip) VALUES
('登录失败怎么办', 5, 120, 'SEMANTIC', '192.168.1.100'),
('数据库连接超时', 3, 95, 'SEMANTIC', '192.168.1.101'),
('页面加载很慢', 4, 110, 'SEMANTIC', '192.168.1.102'),
('Redis连接问题', 2, 85, 'SEMANTIC', '192.168.1.103');

-- 创建索引优化查询性能
CREATE INDEX idx_issues_composite ON issues(status, priority, created_at);
CREATE INDEX idx_solutions_composite ON solutions(success_rate DESC, usage_count DESC);
CREATE INDEX idx_search_logs_composite ON search_logs(created_at DESC, search_type);

COMMIT; 