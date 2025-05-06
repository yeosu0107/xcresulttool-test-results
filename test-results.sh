#!/bin/bash
set -e

TEST_RESULTS_JSON="$1"
OUTPUT_MD="$2"

echo -e "\n ---\n" >> "$OUTPUT_MD"
echo -e "\n## 📝 Test Results" >> "$OUTPUT_MD"
echo -e "| Test Suite | Total | ✅ | ❌ | ⏭ | ⛔️ |" >> "$OUTPUT_MD"
echo -e "|------------|-------|----|----|----|----|" >> "$OUTPUT_MD"

# jq로 표 내용 추출해서 md 파일에 추가
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
        error: ([.children[] | select(.result == "Error")] | length)
      } |
      "| \(.name) | \(.total) | \(.passed) | \(.failed) | \(.skipped) | \(.error) |"
' "$TEST_RESULTS_JSON" >> "$OUTPUT_MD"
