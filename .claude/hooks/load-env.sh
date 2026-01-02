#!/bin/bash

# SessionStart hook to load environment variables for Claude Code
# This script is executed when a Claude Code session starts

# Source environment variables from .claude/env if it exists
ENV_FILE="$(dirname "$0")/env"
if [ -f "$ENV_FILE" ]; then
  source "$ENV_FILE"

  # Also append to CLAUDE_ENV_FILE if set
  if [ -n "$CLAUDE_ENV_FILE" ]; then
    cat "$ENV_FILE" >> "$CLAUDE_ENV_FILE"
  fi
fi

exit 0
