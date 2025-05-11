#!/bin/bash
set -e

SUMMARY_JSON="$1"
OUTPUT_MD="${2:-test-summary.md}"

PASSED=$(jq '.passedTests' "$SUMMARY_JSON")
FAILED=$(jq '.failedTests' "$SUMMARY_JSON")
SKIPPED=$(jq '.skippedTests' "$SUMMARY_JSON")
EXPECTED_FAIL=$(jq '.expectedFailures' "$SUMMARY_JSON")
TOTAL=$(jq '.totalTestCount' "$SUMMARY_JSON")
RESULT=$(jq -r '.result' "$SUMMARY_JSON")
TITLE=$(jq -r '.title' "$SUMMARY_JSON")
ENV_DESC=$(jq -r '.environmentDescription' "$SUMMARY_JSON")
START_TIME=$(jq '.startTime' "$SUMMARY_JSON")
FINISH_TIME=$(jq '.finishTime' "$SUMMARY_JSON")
DURATION=$(echo "$FINISH_TIME - $START_TIME" | bc)
DURATION_FMT=$(printf "%.2f" "$DURATION")

cat <<EOF > "$OUTPUT_MD"
## Summary: $TITLE

| Result | Total | ✅ Passed | ❌ Failed | ⏭️ Skipped | ❎ Expected Fail | ⏱️ Time (s) |
|:---:|---:|---:|---:|---:|---:|---:|
| $RESULT | $TOTAL | $PASSED | $FAILED | $SKIPPED | $EXPECTED_FAIL | $DURATION_FMT |

---

## Environment

### Build Environment

- Environment: $ENV_DESC

### Device Environment

| Device Name | OS Version | Arch | SDK |
|---:|---:|---:|---:|
EOF

jq -c '.devicesAndConfigurations[]' "$SUMMARY_JSON" | while read -r item; do
  deviceName=$(echo "$item" | jq -r '.device.deviceName')
  osVersion=$(echo "$item" | jq -r '.device.osVersion')
  osBuildNumber=$(echo "$item" | jq -r '.device.osBuildNumber')
  arch=$(echo "$item" | jq -r '.device.architecture')
  platform=$(echo "$item" | jq -r '.device.platform')
  echo "| $deviceName | $osVersion ($osBuildNumber) | $arch | $platform |" >> "$OUTPUT_MD"
done
