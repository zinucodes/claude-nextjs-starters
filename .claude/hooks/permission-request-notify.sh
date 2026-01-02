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
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "Unknown"')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // {}')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "Unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // "Unknown"')

# Extract specific details based on tool type
if [ "$TOOL_NAME" = "Bash" ]; then
    COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // "N/A"')
    DESCRIPTION=$(echo "$INPUT" | jq -r '.tool_input.description // "No description"')
    DETAILS="Command: \`$COMMAND\`\nDescription: $DESCRIPTION"
elif [ "$TOOL_NAME" = "Edit" ] || [ "$TOOL_NAME" = "Write" ]; then
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // "N/A"')
    DETAILS="File: \`$FILE_PATH\`"
else
    DETAILS=$(echo "$TOOL_INPUT" | jq -c '.')
fi

# Create Slack message with rich formatting
SLACK_MESSAGE=$(cat <<EOF
{
  "blocks": [
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "🔐 Claude Code - 권한 요청",
        "emoji": true
      }
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*Tool:*\n$TOOL_NAME"
        },
        {
          "type": "mrkdwn",
          "text": "*Session:*\n\`${SESSION_ID:0:8}\`"
        }
      ]
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Details:*\n$DETAILS"
      }
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
