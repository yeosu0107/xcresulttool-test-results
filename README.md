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
- 📝 Writes a Markdown file and appends the report to the GitHub Actions job summary
- ⚠️ **Requires Xcode 16+ (macOS runner only)**

## Usage

```yaml
- uses: yeosu0107/xcresulttool-test-results@v1.2.1
  if: success() || failure()
  with:
    xcresult-path: TestResults.xcresult
    output-md: test-summary.md
```

Add this step after the step that generates the `.xcresult` bundle. The `if` condition lets the report run even when the test step fails.

> **Note:**<br/>
> This action requires a macOS runner with **Xcode 16 or higher** installed.<br/>
> The action will install [jq](https://stedolan.github.io/jq/) if it is not already present.

---

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `xcresult-path` | Yes | — | Path to the `.xcresult` bundle. |
| `output-md` | No | `test-summary.md` | Path to the generated Markdown report. |
| `show-each-test-results` | No | `false` | Set to `true` to include individual test results in the report. |

## Output Example

Open a run from the [build-test workflow](https://github.com/yeosu0107/xcresulttool-test-results/actions/workflows/test.yml) and select **Summary** to see the generated report.
