#!/bin/bash

# 客户问题系统启动脚本
# Customer Issue System Start Script

echo "🎯 客户问题系统启动脚本"
echo "=================================="

# 检查Docker和Docker Compose是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker未安装，请先安装Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose未安装，请先安装Docker Compose"
    exit 1
fi

# 设置DeepSeek API Key（如果未设置）
if [ -z "$DEEPSEEK_API_KEY" ]; then
    echo "⚠️  DeepSeek API Key未设置"
    echo "请设置环境变量 DEEPSEEK_API_KEY 或在启动后在系统设置中配置"
    read -p "是否继续启动？(y/N): " continue_start
    if [[ ! $continue_start =~ ^[Yy]$ ]]; then
        echo "启动已取消"
        exit 0
    fi
fi

echo "🚀 正在启动服务..."

# 进入docker目录
cd docker

# 启动所有服务
docker-compose up -d

echo "⏳ 等待服务启动..."
sleep 30

# 检查服务状态
echo "📊 检查服务状态..."
docker-compose ps

echo ""
echo "✅ 服务启动完成！"
echo ""
echo "🌐 访问地址："
echo "   前端：http://localhost:3000"
echo "   后端API：http://localhost:8080"
echo "   API文档：http://localhost:8080/swagger-ui.html"
echo "   数据库监控：http://localhost:8080/druid"
echo ""
echo "📝 默认登录信息："
echo "   用户名：admin"
echo "   密码：admin123"
echo ""
echo "🔧 管理命令："
echo "   查看日志：docker-compose -f docker/docker-compose.yml logs -f [服务名]"
echo "   停止服务：docker-compose -f docker/docker-compose.yml down"
echo "   重启服务：docker-compose -f docker/docker-compose.yml restart [服务名]"
echo ""
echo "📋 注意事项："
echo "   1. 首次启动可能需要较长时间下载镜像"
echo "   2. 请确保端口 80, 3000, 6379, 8000, 8080 未被占用"
echo "   3. 如需配置DeepSeek API，请访问系统设置页面"
echo ""

# 可选：打开浏览器
if command -v xdg-open &> /dev/null; then
    read -p "是否打开浏览器访问系统？(y/N): " open_browser
    if [[ $open_browser =~ ^[Yy]$ ]]; then
        xdg-open http://localhost:3000
    fi
elif command -v open &> /dev/null; then
    read -p "是否打开浏览器访问系统？(y/N): " open_browser
    if [[ $open_browser =~ ^[Yy]$ ]]; then
        open http://localhost:3000
    fi
fi

echo "🎉 启动完成！" 