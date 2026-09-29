---
name: pr-review
description: Review a pull request file by file. Summarizes each file's purpose, explains what the PR changed in it, and flags only major issues. Use when the user asks to review a PR, review the current branch's changes, or explain what a PR does.
---

Review a PR per file. Major issues only.

## Get the changes

- PR number/URL given: `gh pr diff <n>` and `gh pr view <n> --json title,body,files`.
- Nothing given: `gh pr diff` (PR for current branch). No PR exists: diff against the default branch with `git diff $(git merge-base HEAD origin/HEAD)...HEAD`.
- Read full file contents only when the diff lacks context to judge.

## Per file

Each file review is self-contained:

**`path/to/file`**
- **Purpose:** 1-3 sentences on what the file is for.
- **Changes:** what this PR changed here and what it achieves.
- **Issues:** major problems only, each with a short fix if obvious.

Major issues:
- Logic errors
- Unreadable code
- Code convention violations
- Unused variables/functions
- Other significant problems

No major issues: replace Issues with `Nothing outstanding here, code is fine as it is.`

## Rules

- Review per file, not globally across the PR.
- Ignore optional improvements (missing type checks, extra try/catch, style preferences).
- Keep minor or clean files short.
