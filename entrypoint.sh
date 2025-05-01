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
TEST_PLAN=$(jq -r '.devicesAndConfigurations[0].testPlanConfiguration.configurationName' "$SUMMARY_JSON")
START_TIME=$(jq '.startTime' "$SUMMARY_JSON")
FINISH_TIME=$(jq '.finishTime' "$SUMMARY_JSON")
DURATION=$(echo "$FINISH_TIME - $START_TIME" | bc)
DURATION_FMT=$(printf "%.2f" "$DURATION")

cat <<EOF > "$OUTPUT_MD"
## 🧪 Test Summary: $TITLE

| Result | Total | ✅ Passed | ❌ Failed | ⏭️ Skipped | ❎ Expected Fail | ⏱️ Time (s) |
|--------|-------|--------|--------|---------|--------------|----------|
| $RESULT | $TOTAL | $PASSED | $FAILED | $SKIPPED | $EXPECTED_FAIL | $DURATION_FMT |

---

## 🖥️ Test Environment

- **Environment**: $ENV_DESC
- **Test Plan**: $TEST_PLAN

---

## 📋 Device Results

| Device Name | OS Version | Arch   | Passed | Failed | Skipped | Expected Fail | Time (s) | Total |
|-------------|-----------|--------|--------|--------|---------|--------------|----------|-------|
EOF

len=$(jq '.devicesAndConfigurations | length' "$SUMMARY_JSON")
for ((i=0; i<$len; i++)); do
  deviceName=$(jq -r ".devicesAndConfigurations[$i].device.deviceName" "$SUMMARY_JSON")
  osVersion=$(jq -r ".devicesAndConfigurations[$i].device.osVersion" "$SUMMARY_JSON")
  arch=$(jq -r ".devicesAndConfigurations[$i].device.architecture" "$SUMMARY_JSON")
  passed=$(jq -r ".devicesAndConfigurations[$i].passedTests" "$SUMMARY_JSON")
  failed=$(jq -r ".devicesAndConfigurations[$i].failedTests" "$SUMMARY_JSON")
  skipped=$(jq -r ".devicesAndConfigurations[$i].skippedTests" "$SUMMARY_JSON")
  expectedFail=$(jq -r ".devicesAndConfigurations[$i].expectedFailures" "$SUMMARY_JSON")
  startTime=$(jq ".devicesAndConfigurations[$i].startTime // empty" "$SUMMARY_JSON")
  finishTime=$(jq ".devicesAndConfigurations[$i].finishTime // empty" "$SUMMARY_JSON")
  if [[ -n "$startTime" && -n "$finishTime" ]]; then
    duration=$(echo "$finishTime - $startTime" | bc)
    duration_fmt=$(printf "%.2f" "$duration")
  else
    duration_fmt="-"
  fi
  total=$((passed + failed + skipped + expectedFail))
  echo "| $deviceName | $osVersion | $arch | $passed | $failed | $skipped | $expectedFail | $duration_fmt | $total |" >> "$OUTPUT_MD"
done
