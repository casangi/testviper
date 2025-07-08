#!/bin/bash

# Script to test Allure history preservation locally
# Simulates multiple test runs to demonstrate history accumulation

set -e

echo "🕰️  Testing Allure history preservation locally..."

# Function to create mock test results with different outcomes
create_mock_results() {
    local run_number=$1
    local results_dir=$2
    local test_count=$3
    
    echo "📊 Creating mock results for run #$run_number in $results_dir"
    
    mkdir -p "$results_dir"
    
    # Create varied test results to show history changes
    for ((i=1; i<=test_count; i++)); do
        # Vary test outcomes based on run number to show trends
        local status="passed"
        if [ $((run_number % 3)) -eq 0 ] && [ $i -eq 1 ]; then
            status="failed"
        elif [ $((run_number % 4)) -eq 0 ] && [ $i -eq 2 ]; then
            status="broken"
        elif [ $((run_number % 5)) -eq 0 ] && [ $i -eq 3 ]; then
            status="skipped"
        fi
        
        cat > "$results_dir/test${i}-result.json" << EOF
{
  "uuid": "test-uuid-${run_number}-${i}",
  "name": "test_feature_${i}",
  "fullName": "TestClass::test_feature_${i}",
  "status": "$status",
  "statusDetails": $([ "$status" != "passed" ] && echo '{"message": "Test '"$status"'"}' || echo '{}'),
  "stage": "finished",
  "start": $((1625097600000 + run_number * 1000)),
  "stop": $((1625097601000 + run_number * 1000)),
  "labels": [
    {"name": "suite", "value": "TestSuite"},
    {"name": "testClass", "value": "TestClass"}
  ]
}
EOF
    done
}

# Function to generate report with history preservation
generate_report_with_history() {
    local component=$1
    local results_dir=$2
    local history_dir=$3
    local report_dir=$4
    
    echo "📈 Generating report with history for $component"
    
    # Create history directory if it doesn't exist
    mkdir -p "$history_dir"
    
    # Generate the report
    if command -v allure &> /dev/null; then
        # If we have existing history, copy it to the results directory
        if [ -d "$history_dir" ] && [ "$(ls -A $history_dir 2>/dev/null)" ]; then
            echo "  📂 Found existing history, copying to results..."
            cp -r "$history_dir" "$results_dir/history" 2>/dev/null || true
        fi
        
        # Generate new report
        allure generate "$results_dir" -o "$report_dir" --clean
        
        # Save the new history back to our history directory
        if [ -d "$report_dir/history" ]; then
            echo "  💾 Saving new history..."
            cp -r "$report_dir/history"/* "$history_dir/" 2>/dev/null || true
        fi
    else
        echo "  ⚠️  Allure CLI not found, creating dummy report"
        mkdir -p "$report_dir"
        echo "<html><body><h1>$component Report</h1><p>Allure CLI not available</p></body></html>" > "$report_dir/index.html"
    fi
}

# Function to create coverage files
create_coverage_files() {
    local run_number=$1
    
    mkdir -p coverage
    
    for component in integration toolviper xradio graphviper astroviper; do
        # Vary coverage slightly across runs
        local coverage_pct=$((70 + run_number * 2 + RANDOM % 10))
        local covered_lines=$((coverage_pct * 10))
        local total_lines=$((covered_lines * 100 / coverage_pct))
        
        cat > "coverage/coverage-${component}.json" << EOF
{
  "totals": {
    "covered_lines": $covered_lines,
    "num_statements": $total_lines,
    "percent_covered": $coverage_pct.0
  }
}
EOF
    done
}

# Main function to test history preservation
test_history_preservation() {
    local max_runs=${1:-5}
    
    echo "🚀 Testing history preservation across $max_runs runs..."
    
    # Clean up previous tests
    rm -rf main/ allure-results/ coverage/ history_storage/
    
    # Create directories for history storage
    mkdir -p history_storage/{testviper,toolviper,xradio,graphviper,astroviper}
    
    # Simulate multiple test runs
    for ((run=1; run<=max_runs; run++)); do
        echo ""
        echo "🔄 === Test Run #$run ==="
        
        # Clean current results
        rm -rf allure-results/ main/ coverage/
        mkdir -p allure-results/{integration,toolviper,xradio,graphviper,astroviper}
        mkdir -p main
        
        # Create mock test results with variations
        create_mock_results "$run" "allure-results/integration" 3
        create_mock_results "$run" "allure-results/toolviper" 4
        create_mock_results "$run" "allure-results/xradio" 8
        create_mock_results "$run" "allure-results/graphviper" 2
        create_mock_results "$run" "allure-results/astroviper" 3
        
        # Create coverage files
        create_coverage_files "$run"
        
        # Generate reports with history
        generate_report_with_history "testviper" "allure-results/integration" "history_storage/testviper" "main/testviper"
        generate_report_with_history "toolviper" "allure-results/toolviper" "history_storage/toolviper" "main/toolviper"
        generate_report_with_history "xradio" "allure-results/xradio" "history_storage/xradio" "main/xradio"
        generate_report_with_history "graphviper" "allure-results/graphviper" "history_storage/graphviper" "main/graphviper"
        generate_report_with_history "astroviper" "allure-results/astroviper" "history_storage/astroviper" "main/astroviper"
        
        # Generate summary page
        python scripts/generate_summary_page.py
        
        echo "  ✅ Run #$run completed"
        
        # Show history accumulation
        echo "  📈 History files accumulated:"
        for component in testviper toolviper xradio graphviper astroviper; do
            local history_files=$(find "history_storage/$component" -type f 2>/dev/null | wc -l | xargs)
            echo "    - $component: $history_files files"
        done
        
        # Copy this run's reports for comparison
        cp -r main "run_${run}_reports" 2>/dev/null || true
        
        # Small delay to simulate real execution
        sleep 2
    done
    
    echo ""
    echo "🎉 History preservation test completed!"
    echo ""
    echo "📊 Results:"
    echo "  - Latest reports: main/"
    echo "  - Individual run snapshots: run_*_reports/"
    echo "  - History storage: history_storage/"
    echo ""
    echo "📈 Final history summary:"
    for component in testviper toolviper xradio graphviper astroviper; do
        local history_files=$(find "history_storage/$component" -type f 2>/dev/null | wc -l | xargs)
        local history_size=$(du -sh "history_storage/$component" 2>/dev/null | cut -f1 || echo "0B")
        echo "  - $component: $history_files files ($history_size)"
    done
}

# Function to compare reports across runs
compare_reports() {
    echo ""
    echo "🔍 Comparing reports across runs..."
    
    if [ -d "run_1_reports" ] && [ -d "run_${1}_reports" ]; then
        echo "📊 Report comparison:"
        echo "  - First run: run_1_reports/"
        echo "  - Latest run: run_${1}_reports/"
        echo "  - Current: main/"
        echo ""
        echo "💡 To compare, open these in your browser:"
        echo "  python -m http.server 8000"
        echo "  Then navigate to:"
        echo "    http://localhost:8000/run_1_reports/"
        echo "    http://localhost:8000/run_${1}_reports/"
        echo "    http://localhost:8000/main/"
    fi
}

# Function to show history details
show_history_details() {
    echo ""
    echo "📁 History directory structure:"
    if [ -d "history_storage" ]; then
        find history_storage -type f -name "*.json" | head -20 | while read -r file; do
            echo "  $file"
        done
        
        local total_files=$(find history_storage -type f | wc -l | xargs)
        echo "  ... and $((total_files - 20)) more files (total: $total_files)"
    fi
}

# Main execution
main() {
    local runs=${1:-5}
    
    echo "🧪 Starting Allure history preservation test..."
    echo "📝 This will simulate $runs test runs to demonstrate history accumulation"
    echo ""
    
    # Check if Allure is available
    if ! command -v allure &> /dev/null; then
        echo "⚠️  Allure CLI not found. Installing via Homebrew..."
        if command -v brew &> /dev/null; then
            brew install allure
        else
            echo "❌ Homebrew not found. Please install Allure CLI manually:"
            echo "   https://github.com/allure-framework/allure2/releases"
            exit 1
        fi
    fi
    
    # Run the test
    test_history_preservation "$runs"
    
    # Show comparison info
    compare_reports "$runs"
    
    # Show history details
    show_history_details
    
    echo ""
    echo "🌐 To view the final results:"
    echo "  python -m http.server 8000"
    echo "  Then go to: http://localhost:8000/main/"
    echo ""
    echo "📚 Look for these history features in the reports:"
    echo "  - Trend charts showing test stability over time"
    echo "  - History graphs in the Overview section"
    echo "  - Test duration trends"
    echo "  - Success rate trends"
}

# Run the main function
main "$@"
