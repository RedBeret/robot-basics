# Robot Framework Basics

![Robot Framework](https://img.shields.io/badge/Robot_Framework-green?logo=robotframework&logoColor=white) ![License: MIT](https://img.shields.io/badge/License-MIT-green) ![GitHub stars](https://img.shields.io/github/stars/RedBeret/robot-basics?style=social)


Learn Robot Framework fundamentals through practical, runnable test examples. No Docker or VMs needed — just Python and Robot Framework.

## What You'll Learn

| Suite | Topic | Key Concepts |
|-------|-------|-------------|
| 01_basics | First tests | Test cases, assertions, setup/teardown |
| 02_variables | Variables | Scalars, lists, dicts, environment vars |
| 03_keywords | Custom keywords | User keywords, arguments, return values, resource files |
| 04_api | API testing | HTTP requests against a public REST API |
| 05_data_driven | Data-driven tests | Template tests, test data from files |

## Requirements

- Python 3.10+
- Robot Framework 7.x

## Quick Start

```bash
# Clone
git clone https://github.com/RedBeret/robot-basics.git
cd robot-basics

# Create virtual environment and install dependencies
python3 -m venv venv
source venv/bin/activate    # Windows: venv\Scripts\activate
pip install -r requirements.txt

# Run all tests
robot --outputdir results tests/

# Run a specific suite
robot --outputdir results tests/01_basics/

# Run tests by tag
robot --outputdir results --include smoke tests/

# Run with verbose output
robot --outputdir results --loglevel DEBUG tests/
```

## Project Structure

```
robot-basics/
├── tests/
│   ├── 01_basics/          # First test cases
│   ├── 02_variables/       # Variable types and scoping
│   ├── 03_keywords/        # Custom keyword creation
│   ├── 04_api/             # REST API testing fundamentals
│   └── 05_data_driven/     # Template and data-driven tests
├── resources/
│   ├── common.resource      # Shared keywords and variables
│   └── api_keywords.resource # API-specific keywords
├── requirements.txt
└── README.md
```

## Reports

After running tests, open `results/report.html` in your browser for a detailed test report with logs, statistics, and timing.

## Tags

Tests are tagged for selective execution:

| Tag | Purpose |
|-----|---------|
| `smoke` | Quick validation tests |
| `regression` | Full regression suite |
| `api` | API-related tests |
| `negative` | Negative/error path tests |

## Next Steps

Once comfortable with these basics, move on to:
- [robot-intermediate](https://github.com/RedBeret/robot-intermediate) — Browser testing, page objects, databases, custom libraries, parallel execution
- [robot-advanced](https://github.com/RedBeret/robot-advanced) — Custom frameworks, API/GraphQL testing, Docker, CI/CD, BDD, performance testing

## License

MIT
