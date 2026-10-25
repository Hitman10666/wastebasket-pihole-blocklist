#!/usr/bin/env bash
# Adds one domain to blocklist.txt or allowlist.txt.
# Usage: add-domain.sh <domain> <blocklist|allowlist> <wildcard|exact> [note]
# Prints a one-line result; exits 0 when the file changed, 3 when nothing needed changing.
set -euo pipefail

raw="$1"; list="$2"; match="$3"; note="${4:-}"

# Normalize: lowercase, trim, strip scheme/path/port and any list syntax the user pasted.
d=$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
d=${d#*://}
d=${d%%/*}
d=${d%%:*}
d=${d#@@}
d=${d#||}
d=${d%^}
d=${d#\*.}
d=${d#.}
d=${d%.}

if ! [[ "$d" =~ ^([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9-]{2,63}$ ]]; then
  echo "ERROR: '$raw' is not a valid domain name."
  exit 1
fi

case "$list" in
  blocklist) file=blocklist.txt; other=allowlist.txt
             [[ "$match" == wildcard ]] && line="||$d^" || line="$d" ;;
  allowlist) file=allowlist.txt; other=blocklist.txt
             [[ "$match" == wildcard ]] && line="@@||$d^" || line="$d" ;;
  *) echo "ERROR: unknown list '$list'."; exit 1 ;;
esac

if grep -qxF -- "$line" "$file"; then
  echo "SKIPPED: $line is already in $file."
  exit 3
fi

# Same domain in the other form (exact vs wildcard) is allowed, but worth knowing.
for form in "$d" "||$d^" "@@||$d^"; do
  [[ "$form" != "$line" ]] && grep -qxF -- "$form" "$file" && echo "NOTE: $file also has $form."
done
for form in "$d" "||$d^" "@@||$d^"; do
  grep -qxF -- "$form" "$other" && echo "WARNING: $other has $form (allowlist entries win over blocklist entries)."
done

header='! ---- Added via GitHub form ----'
grep -qxF -- "$header" "$file" || printf '\n%s\n' "$header" >> "$file"
# Make sure the file ends with a newline before appending.
[[ -n "$(tail -c1 "$file")" ]] && echo >> "$file"
[[ -n "$note" ]] && printf '! %s (%s)\n' "$note" "$(date -u +%Y-%m-%d)" >> "$file"
printf '%s\n' "$line" >> "$file"

echo "ADDED: $line to $file."
