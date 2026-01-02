#!/bin/bash

# Source environment variables from .claude/env if it exists
ENV_FILE="$(dirname "$(dirname "$0")")/env"
if [ -f "$ENV_FILE" ]; then
  source "$ENV_FILE"
fi

# Get Slack Webhook URL from environment variable
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"

# Check if SLACK_WEBHOOK_URL is set
if [ -z "$SLACK_WEBHOOK_URL" ]; then
  echo "Error: SLACK_WEBHOOK_URL environment variable is not set" >&2
  exit 1
fi

# Read JSON input from stdin
INPUT=$(cat)

# Parse relevant information
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "Unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // "Unknown"')
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "Unknown"')

# Get project name from CWD
PROJECT_NAME=$(basename "$CWD")

# Get timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Create Slack message with rich formatting
SLACK_MESSAGE=$(cat <<EOF
{
  "blocks": [
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "✅ Claude Code - 작업 완료",
        "emoji": true
      }
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*Project:*\n$PROJECT_NAME"
        },
        {
          "type": "mrkdwn",
          "text": "*Session:*\n\`${SESSION_ID:0:8}\`"
        }
      ]
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*Completed At:*\n$TIMESTAMP"
        },
        {
          "type": "mrkdwn",
          "text": "*Event:*\n$HOOK_EVENT"
        }
      ]
    },
    {
      "type": "context",
      "elements": [
        {
          "type": "mrkdwn",
          "text": "📁 Working Directory: \`$CWD\`"
        }
      ]
    }
  ]
}
EOF
)

# Send to Slack
curl -X POST \
  -H 'Content-type: application/json' \
  --data "$SLACK_MESSAGE" \
  "$SLACK_WEBHOOK_URL" \
  --silent --show-error

# Always allow the operation to proceed
exit 0
