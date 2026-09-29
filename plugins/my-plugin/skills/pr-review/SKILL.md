---
name: pr-review
description: Review a pull request. Gives a plain-language summary of what the PR does and how, reviews each file for major issues, and ends with a verdict on the overall approach. Use when the user asks to review a PR, review the current branch's changes, or explain what a PR does.
---

Review a PR: overview first, then per file, then overall verdict. Major issues only.

## Get the changes

- PR number/URL given: `gh pr diff <n>` and `gh pr view <n> --json title,body,files`.
- Nothing given: `gh pr diff` (PR for current branch). No PR exists: diff against the default branch with `git diff $(git merge-base HEAD origin/HEAD)...HEAD`.
- Read full file contents only when the diff lacks context to judge.

## Find repo conventions

Before reviewing, look for what the repo defines and apply it when judging convention violations:
- Claude skills about coding conventions/style (`.claude/skills/`, plugin skills) - invoke a matching one.
- Convention files: `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`, `docs/conventions*`, `STYLE*`.

None found: fall back to general good practice and the surrounding code's style.

## Output

### 1. Summary
2-4 sentences, simple words, no jargon:
- **What:** the goal of the PR.
- **How:** the approach it takes to get there.

### 2. Per file
Each file review is self-contained:

**`path/to/file`**
- **Purpose:** 1-3 sentences on what the file is for.
- **Changes:** what this PR changed here and what it achieves.
- **Issues:** major problems only, each with a short fix if obvious.

Major issues:
- Logic errors
- Unreadable code
- Violations of the repo's conventions
- Unused variables/functions
- Other significant problems

No major issues: replace Issues with `Nothing outstanding here, code is fine as it is.`

### 3. Overall verdict
Step back from individual files. State whether there are major concerns with the PR's structure or idea: wrong approach, wrong layer, needless complexity, missing pieces, risky design, scope creep. Name each concern and why it matters. No concerns: say so in one line.

## Rules

- Review per file, not globally, in section 2.
- Ignore optional improvements (missing type checks, extra try/catch, style preferences).
- Keep minor or clean files short.
