#!/bin/bash
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

claude plugin marketplace add cedricziel/claude-plugins >/dev/null 2>&1
claude plugin install oss@cedricziel >/dev/null 2>&1
exit 0
