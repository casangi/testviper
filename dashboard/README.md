# TestViper Dashboard (Phase 2: ReportPortal Integration)

This dashboard integrates ReportPortal with pytest for the TestViper integration tests.

## Quick Start

1. **Start ReportPortal**
   ```bash
   cd dashboard/reportportal
   ./setup.sh
   ```
2. **Access ReportPortal**
   - Open: http://localhost:8080
   - Login: superadmin / erebus
3. **Create Project and API Token**
   - Create a project named `testviper` in the UI
   - Go to Profile → API Keys and generate a token
4. **Configure Environment**
   - Update `.env` in the project root with your API token
   - Set `RP_API_KEY=your_token_here`
5. **Install dependencies**
   ```bash
   # For macOS (required for xradio)
   conda install -c conda-forge python-casacore
   
   # Install Python requirements
   pip install -r requirements/base.txt
   
   # Build VIPER components
   make build-main
   ```
6. **Run tests with ReportPortal integration**
   ```bash
   # Recommended: Use ReportPortal integration script
   python dashboard/run_tests_with_reportportal.py
   
   # Check connection and environment
   python dashboard/run_tests_with_reportportal.py --check-only
   
   # Run specific tests
   python dashboard/run_tests_with_reportportal.py --test-path tests/integration/test_specific.py
   ```

## Analytics Tools

The dashboard includes analytics tools to supplement the ReportPortal web interface:

### Quick Analytics
```bash
# Show quick status
python dashboard/quick_analytics.py status

# Show detailed analytics summary
python dashboard/quick_analytics.py

# Generate analytics report
python dashboard/quick_analytics.py report
```

### Advanced Analytics
The analytics system provides:
- **Flaky Test Detection**: Identifies tests with inconsistent results
- **Performance Trend Analysis**: Tracks test execution time changes
- **Failure Pattern Recognition**: Analyzes failure patterns across test runs
- **Local Session Analysis**: Detailed analysis of local test execution data

## How It Works

1. **ReportPortal Integration**: Tests are sent to ReportPortal for storage and web dashboard viewing
2. **Enhanced Local Reporting**: Additional metrics and artifacts are captured locally
3. **Analytics Processing**: Advanced analytics analyze both ReportPortal and local data
4. **Supplementary Reports**: Generated reports provide insights beyond the standard ReportPortal dashboard

## Key Features

- ✅ **ReportPortal Web Dashboard**: Native ReportPortal interface at http://localhost:8080
- 🔍 **Advanced Analytics**: Flaky test detection, performance trends, failure analysis
- 📊 **Supplementary Reports**: JSON and HTML reports with detailed insights
- 🚀 **Simple Integration**: One-command test execution with full reporting
- 🔧 **Environment Validation**: Automatic checks for proper configuration

## CI Integration
- See `.github/workflows/python-test-reportportal.yml` for automated ReportPortal reporting.

## Security Note
- **Never commit your real `.env` with secrets to the repository.**
- Use `.env.example` as a template and add `.env` to `.gitignore`.

## Troubleshooting
- Ensure the API token is valid and the project exists in ReportPortal.
- Check the ReportPortal UI for launches and logs.
- Use `python dashboard/run_tests_with_reportportal.py --check-only` to verify setup.
