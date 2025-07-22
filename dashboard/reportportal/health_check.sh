#!/bin/bash

echo "🔍 Checking ReportPortal health..."

# Check if services are running
if ! docker-compose ps | grep -q "Up"; then
    echo "❌ Some services are not running!"
    docker-compose ps
    exit 1
fi

# Check API endpoint
if curl -f -s http://localhost:8080/api/health > /dev/null; then
    echo "✅ ReportPortal API is healthy"
else
    echo "❌ ReportPortal API is not responding"
    exit 1
fi

# Check UI
if curl -f -s http://localhost:8080 > /dev/null; then
    echo "✅ ReportPortal UI is accessible"
else
    echo "❌ ReportPortal UI is not accessible"
    exit 1
fi

echo "✅ All ReportPortal services are healthy!"
