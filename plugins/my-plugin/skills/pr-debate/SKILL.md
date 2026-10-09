---
name: pr-debate
description: Review your own PR with a fresh reviewer, then debate its findings. Spawns an Opus subagent with no session history to review the PR, challenges its findings with the context this session has, and reports what actually needs to change and what was dropped. Use when the user asks for a fresh/second-opinion review of their PR or branch, a "debate review", or invokes /pr-debate.
---

Fresh reviewer finds what the coding session missed. This session has the context to filter its noise. Debate until agreement, then report to the user. No code changes during this skill.

## 1. Scope the change

- PR number/URL given: `gh pr view <n> --json title,body,baseRefOid,headRefOid`.
- Nothing given: `gh pr view` for the current branch. No PR: `BASE_SHA=$(git merge-base HEAD origin/HEAD)`, `HEAD_SHA=$(git rev-parse HEAD)`, description from commit messages.

## 2. Dispatch the reviewer

Invoke `superpowers:requesting-code-review` and fill its `code-reviewer.md` template:
- DESCRIPTION: PR title + body.
- PLAN_OR_REQUIREMENTS: the spec/plan file if one exists for this work, else the PR body.
- BASE_SHA / HEAD_SHA from step 1.

Append to the prompt: "Judge convention violations against the repo's CLAUDE.md, AGENTS.md, `.claude/rules/`, and any nested CLAUDE.md in directories the diff touches."

Dispatch with `subagent_type: general-purpose`, `model: opus`. Give it no session history and no justification for why the code is the way it is: the reviewer must judge the work cold. Keep the returned agent ID.

## 3. Triage

For each finding, verify the claim against the code, then mark it:
- **accept**: real issue.
- **reject**: with a concrete reason (code ref, test, design decision, requirement, out of scope).
- **question**: need the reviewer to clarify.

Rejecting valid feedback to defend your own work defeats the point. When unsure, accept.

## 4. Debate

Load `SendMessage` via ToolSearch (`select:SendMessage`) if it is deferred. Send the reviewer (by agent ID) every rejected and questioned finding with your reasoning. Ask it to answer each one with:
- **concede**: your reason holds, drop it.
- **defend**: new argument or evidence it still matters.
- **revise**: narrower or different version of the finding.

Re-triage the replies. Repeat with only the still-disputed findings until none remain, max 6 rounds.

## 5. Report to the user

### Should change
Agreed findings, ranked by severity: `file:line`, problem, one-line fix.

### Still disputed
Only if the 6-round cap was hit. Per finding: reviewer's last argument, your last argument, one line each. User decides.

### Dropped
Per finding, one line: what it was and why it was dropped (false positive, resolved by context, nitpick, out of scope).

End with rounds used. Ask before applying any fix.
