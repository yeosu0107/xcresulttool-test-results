#!/bin/bash
set -e

TEST_RESULTS_JSON="$1"
OUTPUT_MD="$2"

{
  echo -e "\n ---\n"
  echo -e "\n## Test Results"
  echo -e "| Test | Total | ✅ | ❌ | ⏭ | ❎ |"
  echo -e "|---|---:|---:|---:|---:|---:|"
} >> "$OUTPUT_MD"

jq -r '
  .testNodes[].children[] |
    .children[]? |
      select(.nodeType == "Test Suite") |
      {
        name: .name,
        total: (.children | length),
        passed: ([.children[] | select(.result == "Passed")] | length),
        failed: ([.children[] | select(.result == "Failed")] | length),
        skipped: ([.children[] | select(.result == "Skipped")] | length),
        expected: ([.children[] | select(.result == "Expected Failure")] | length)
      } |
      "| \(.name) | \(.total) | \(.passed) | \(.failed) | \(.skipped) | \(.expected) |"
' "$TEST_RESULTS_JSON" >> "$OUTPUT_MD"
