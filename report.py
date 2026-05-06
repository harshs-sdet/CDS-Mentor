from robot.api import ExecutionResult
import re

# Load test results
result = ExecutionResult('output.xml')

# Define tag match pattern (e.g., starts with A- or B-)
pattern = re.compile(r'^(CZ-)\d+$')

# Dictionary to count matched tags
tag_counts = {}

# Iterate through tests
for test in result.suite.tests:
    for tag in test.tags:
        if pattern.match(tag):
            tag_counts[tag] = tag_counts.get(tag, 0) + 1

# Output matched tag counts
print("Filtered Tag Counts:")
for tag, count in tag_counts.items():
    print(f"{tag}: {count}")

# Optional: total matched tags
total_matched = sum(tag_counts.values())
print(f"\nTotal matched tags (duplicate tests allowed): {total_matched}")