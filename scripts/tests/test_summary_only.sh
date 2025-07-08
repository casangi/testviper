#!/bin/bash

# Quick test script to test just the summary page generation
# This creates mock test data and generates the summary page

echo "🧪 Testing summary page generation with mock data..."

# Clean up and create structure
rm -rf allure-results/ main/ coverage/
mkdir -p allure-results/integration
mkdir -p allure-results/toolviper
mkdir -p allure-results/xradio
mkdir -p allure-results/graphviper
mkdir -p allure-results/astroviper
mkdir -p coverage

# Create mock Allure result files
echo "📄 Creating mock test results..."

# Mock integration test result
cat > allure-results/integration/test1-result.json << 'EOF'
{
  "uuid": "test-uuid-1",
  "name": "test_integration_basic",
  "status": "passed",
  "statusDetails": {},
  "stage": "finished",
  "start": 1625097600000,
  "stop": 1625097601000
}
EOF

# Mock toolviper test results
cat > allure-results/toolviper/test2-result.json << 'EOF'
{
  "uuid": "test-uuid-2",
  "name": "test_toolviper_feature",
  "status": "passed",
  "statusDetails": {},
  "stage": "finished",
  "start": 1625097600000,
  "stop": 1625097601000
}
EOF

cat > allure-results/toolviper/test3-result.json << 'EOF'
{
  "uuid": "test-uuid-3",
  "name": "test_toolviper_edge_case",
  "status": "failed",
  "statusDetails": {"message": "Test failed"},
  "stage": "finished",
  "start": 1625097600000,
  "stop": 1625097601000
}
EOF

# Mock xradio test results
for i in {1..5}; do
cat > allure-results/xradio/test$i-result.json << EOF
{
  "uuid": "test-uuid-xradio-$i",
  "name": "test_xradio_feature_$i",
  "status": "passed",
  "statusDetails": {},
  "stage": "finished",
  "start": 1625097600000,
  "stop": 1625097601000
}
EOF
done

# Mock coverage files
cat > coverage/coverage-integration.json << 'EOF'
{
  "totals": {
    "covered_lines": 85,
    "num_statements": 100,
    "percent_covered": 85.0
  }
}
EOF

cat > coverage/coverage-toolviper.json << 'EOF'
{
  "totals": {
    "covered_lines": 92,
    "num_statements": 120,
    "percent_covered": 76.7
  }
}
EOF

cat > coverage/coverage-xradio.json << 'EOF'
{
  "totals": {
    "covered_lines": 1200,
    "num_statements": 1500,
    "percent_covered": 80.0
  }
}
EOF

cat > coverage/coverage-graphviper.json << 'EOF'
{
  "totals": {
    "covered_lines": 45,
    "num_statements": 60,
    "percent_covered": 75.0
  }
}
EOF

cat > coverage/coverage-astroviper.json << 'EOF'
{
  "totals": {
    "covered_lines": 300,
    "num_statements": 400,
    "percent_covered": 75.0
  }
}
EOF

# Generate summary page
echo "📝 Generating summary page..."
python scripts/generate_summary_page.py

echo "✅ Summary page test completed!"
echo ""
echo "🎉 Generated:"
echo "  - Summary page: main/index.html"
echo ""
echo "🌐 To view the summary page:"
echo "  1. Open main/index.html in your browser"
echo "  2. Or run: python -m http.server 8000"
echo "     Then go to: http://localhost:8000/main/"
echo ""
echo "📊 Mock test data summary:"
echo "├── Integration Tests: $(find allure-results/integration -name "*-result.json" | wc -l | xargs) tests"
echo "├── ToolViper Tests: $(find allure-results/toolviper -name "*-result.json" | wc -l | xargs) tests"
echo "├── XRadio Tests: $(find allure-results/xradio -name "*-result.json" | wc -l | xargs) tests"
echo "├── GraphViper Tests: $(find allure-results/graphviper -name "*-result.json" | wc -l | xargs) tests"
echo "└── AstroViper Tests: $(find allure-results/astroviper -name "*-result.json" | wc -l | xargs) tests"
