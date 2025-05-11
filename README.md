# xcresulttool-test-results

[![build-test](https://github.com/yeosu0107/xcresulttool-test-results/actions/workflows/test.yml/badge.svg)](https://github.com/yeosu0107/xcresulttool-test-results/actions/workflows/test.yml)

Generate a markdown summary report from an `.xcresult` bundle using `xcresulttool` (Xcode 16+).

> **Note:**<br/>
> Starting with Xcode 16, Apple changed the .xcresult file format and introduced a new xcresulttool get test-results summary command to extract test results.<br/>
> This GitHub Action is designed specifically to work with the new format and tools introduced in Xcode 16

This GitHub Action parses your test results and creates a clear, readable markdown report, including overall and per-device statistics, ready for GitHub Actions Job Summary or PR comments.

## Features

- 📋 Summarizes total, passed, failed, skipped, expected failures, and duration
- 📱 Lists detailed results for each device configuration
- 📝 Outputs a markdown file for easy inclusion in GitHub Actions Job Summary or PR comments
- ⚠️ **Requires Xcode 16+ (macOS runner only)**

## Usage

```yaml
  uses: yeosu0107/xcresulttool-test-results@v1
  with:
    xcresult-path: TestResults.xcresult
    output-md: test-summary.md
  if: success() || failure()
  # ^ This ensures the action runs regardless of whether the previous test step passes or fails,
  # so that test results are always processed and reported.
```

> **Note:**<br/>
> This action must be run on a `macos-latest` runner with **Xcode 16 or higher** installed.<br/>
> The action will install [jq](https://stedolan.github.io/jq/) if it is not already present.

---

## Inputs

| Name         | Required | Default           | Description                                      |
|--------------|----------|-------------------|--------------------------------------------------|
| summary-path | ✅       | -                 | Path to the xcresulttool summary JSON file       |
| output-md    | ❌       | test-summary.md   | Output markdown file name                        |
show-each-test-results | ❌ | false | If true, print each test results |

## Output Example

See the [build-test action summary](https://github.com/yeosu0107/xcresulttool-test-results/actions/runs/14956712317) for an output example.