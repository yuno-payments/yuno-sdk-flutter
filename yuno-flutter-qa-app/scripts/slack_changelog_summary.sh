#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

VERSION_BITRISE=$1

print_message $BLUE "🏷️ Version: $VERSION_BITRISE"

if [ -z "$VERSION_BITRISE" ]; then
    print_message $RED "❌ Version parameter is required"
    print_message $YELLOW "💡 Usage: ./slack_changelog_summary.sh <version>"
    print_message $YELLOW "💡 Example: ./slack_changelog_summary.sh 1.0.12"
    exit 1
fi

if [ -z "$SLACK_BOTH_API_TOKEN" ]; then
    print_message $RED "❌ SLACK_BOTH_API_TOKEN environment variable is not set"
    print_message $YELLOW "💡 Set it with: export SLACK_BOTH_API_TOKEN='your-slack-token'"
    exit 1
fi

print_message $BLUE "📄 Running summarize_changelog.sh with version $VERSION_BITRISE..."
if ! ./summarize_changelog.sh "$VERSION_BITRISE"; then
    print_message $RED "❌ Failed to generate changelog summary"
    exit 1
fi

SUMMARY_FILE="RELEASE_SUMMARY.md"
if [ ! -f "$SUMMARY_FILE" ]; then
    print_message $RED "❌ Summary file not found: $SUMMARY_FILE"
    exit 1
fi

CHANGELOG_SUMMARY=$(cat "$SUMMARY_FILE")
print_message $GREEN "📝 Changelog summary generated successfully"
SLACK_SUMMARY=$(echo "$CHANGELOG_SUMMARY" | sed 's/\*\*/*/g')

SLACK_CHANNEL="new-releases-product"
MESSAGE="New Flutter SDK version released: $VERSION_BITRISE"

ESCAPED_SUMMARY=$(echo "$SLACK_SUMMARY" | sed 's/"/\\"/g; s/$/\\n/' | tr -d '\n')

print_message $BLUE "📤 Sending changelog summary to Slack..."

SLACK_PAYLOAD=$(cat <<EOF
{
  "channel": "$SLACK_CHANNEL",
  "text": "$MESSAGE",
  "attachments": [
    {
      "title": "📋 Release Notes - Version $VERSION_BITRISE",
      "text": "$ESCAPED_SUMMARY",
      "color": "#2196F3",
      "mrkdwn_in": ["text"]
    }
  ]
}
EOF
)

RESPONSE=$(curl -s -X POST https://slack.com/api/chat.postMessage \
    -H "Authorization: Bearer $SLACK_BOTH_API_TOKEN" \
    -H "Content-type: application/json" \
    --data "$SLACK_PAYLOAD")

if echo "$RESPONSE" | grep -q '"ok":true'; then
    print_message $GREEN "✅ Changelog summary sent to Slack successfully!"
else
    print_message $RED "❌ Failed to send message to Slack"
    print_message $YELLOW "Response: $RESPONSE"
    exit 1
fi

print_message $GREEN "🎉 Process completed successfully!"
