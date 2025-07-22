#!/bin/bash

echo "🚀 Starting TestViper ReportPortal Setup..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml not found. Make sure you're in the dashboard/reportportal directory."
    exit 1
fi

# Start ReportPortal
echo "🐳 Starting ReportPortal services..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Check if services are running
echo "🔍 Checking service status..."
docker-compose ps

# Test connection
echo "🔗 Testing connection to ReportPortal..."
for i in {1..10}; do
    if curl -f -s http://localhost:8080 > /dev/null; then
        echo "✅ ReportPortal is running!"
        echo "🌐 Access it at: http://localhost:8080"
        echo "👤 Default login: superadmin / erebus"
        echo ""
        echo "📝 Next steps:"
        echo "1. Login to ReportPortal"
        echo "2. Create 'testviper' project"
        echo "3. Generate API token"
        echo "4. Run: python3 ../scripts/test_connection.py"
        exit 0
    else
        echo "⏳ Waiting for ReportPortal... (attempt $i/10)"
        sleep 10
    fi
done

echo "❌ ReportPortal is not responding after 100 seconds. Check logs:"
docker-compose logs
