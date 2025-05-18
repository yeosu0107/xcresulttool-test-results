#!/bin/bash
set -e

TEST_RESULTS_JSON="$1"
OUTPUT_MD="$2"

{
cat <<EOF
---

## Test Results
<table width="800px" style="table-layout: fixed;">
  <tr>
    <th style="text-align: center;">Test</th>
    <th style="text-align: center;">Total</th>
    <th style="width: 10%; text-align: center;">✅</th>
    <th style="width: 10%; text-align: center;">❌</th>
    <th style="width: 10%; text-align: center;">⏭</th>
    <th style="width: 10%; text-align: center;">❎</th>
  </tr>
EOF
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
      "  <tr>\n    <td style=\"text-align: left;\">\(.name)</td>\n    <td style=\"text-align: right;\">\(.total)</td>\n    <td style=\"text-align: right;\">\(.passed)</td>\n    <td style=\"text-align: right;\">\(.failed)</td>\n    <td style=\"text-align: right;\">\(.skipped)</td>\n    <td style=\"text-align: right;\">\(.expected)</td>\n  </tr>"
' "$TEST_RESULTS_JSON" >> "$OUTPUT_MD"

echo "</table>" >> "$OUTPUT_MD"

