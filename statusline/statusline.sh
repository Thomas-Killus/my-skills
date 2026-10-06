#!/bin/bash
# Status line: model | context bar % | git branch | folder | 5h/7d usage | session name
# Also re-emits the caveman plugin's badge so that indicator keeps working.

input=$(cat)
IFS=$'\t' read -r model ctx dir five week session < <(printf '%s' "$input" | jq -r '[
  (.model.display_name // "?"),
  (.context_window.used_percentage // 0 | floor),
  (.workspace.current_dir // .cwd // "."),
  (.rate_limits.five_hour.used_percentage // "-" | if . == "-" then . else floor end),
  (.rate_limits.seven_day.used_percentage // "-" | if . == "-" then . else floor end),
  (.session_name // "")
] | @tsv')

if [ "$ctx" -ge 90 ]; then c=31; elif [ "$ctx" -ge 70 ]; then c=33; else c=32; fi
filled=$((ctx / 10)); [ "$filled" -gt 10 ] && filled=10
f=$(printf '%*s' "$filled" ''); e=$(printf '%*s' $((10 - filled)) '')
bar="${f// /█}${e// /░}"

printf '\033[36m%s\033[00m | \033[%sm%s %s%%\033[00m' "$model" "$c" "$bar" "$ctx"

branch=$(git --no-optional-locks -C "$dir" branch --show-current 2>/dev/null)
[ -n "$branch" ] && printf ' | \033[35m%s\033[00m' "$branch"

printf ' | \033[01;34m%s\033[00m' "$(basename "$dir")"

[ "$five" != "-" ] && printf ' | 5h: %s%%' "$five"
[ "$week" != "-" ] && printf ' | 7d: %s%%' "$week"
[ -n "$session" ] && printf ' | \033[32m%s\033[00m' "$session"

if [ -x "$HOME/.claude/hooks/caveman-statusline.sh" ]; then
  badge=$(printf '%s' "$input" | bash "$HOME/.claude/hooks/caveman-statusline.sh")
  [ -n "$badge" ] && printf ' %s' "$badge"
fi

printf '\n'
