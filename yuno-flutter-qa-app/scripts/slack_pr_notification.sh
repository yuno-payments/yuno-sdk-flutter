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

VERSION=$1
PR_URL=$2

print_message $BLUE "🔗 Sending PR notification for version: $VERSION"

if [ -z "$VERSION" ] || [ -z "$PR_URL" ]; then
    print_message $RED "❌ Version and PR URL parameters are required"
    print_message $YELLOW "💡 Usage: ./slack_pr_notification.sh <version> <pr_url>"
    print_message $YELLOW "💡 Example: ./slack_pr_notification.sh 1.0.12 'https://github.com/yuno-payments/yuno-docs/pull/123'"
    exit 1
fi

if [ -z "$SLACK_BOTH_API_TOKEN" ]; then
    print_message $RED "❌ SLACK_BOTH_API_TOKEN environment variable is not set"
    print_message $YELLOW "💡 Set it with: export SLACK_BOTH_API_TOKEN='your-slack-token'"
    exit 1
fi

SLACK_CHANNEL="yuno-docs"
MESSAGE="📖 Flutter SDK Documentation Updated - Version $VERSION"

print_message $BLUE "📤 Sending PR notification to Slack..."

SLACK_PAYLOAD=$(cat <<EOF
{
  "channel": "$SLACK_CHANNEL",
  "text": "$MESSAGE",
  "attachments": [
    {
      "title": "📋 Documentation Pull Request Created",
      "text": "Flutter SDK release notes have been updated in the documentation repository.\n\n🔗 <$PR_URL|View Pull Request>",
      "color": "#28a745",
      "mrkdwn_in": ["text"],
      "fields": [
        {
          "title": "Version",
          "value": "$VERSION",
          "short": true
        },
        {
          "title": "Repository",
          "value": "yuno-docs",
          "short": true
        }
      ]
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
    print_message $GREEN "✅ PR notification sent to Slack successfully!"
else
    print_message $RED "❌ Failed to send PR notification to Slack"
    print_message $YELLOW "Response: $RESPONSE"
    exit 1
fi

print_message $GREEN "🎉 PR notification process completed successfully!"
