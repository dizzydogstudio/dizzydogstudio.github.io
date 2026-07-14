#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# check-comparison-sync.sh
#
# The "How it compares" table is duplicated across every landing page (there's
# no build step / includes on this site). This checks the copies haven't drifted
# apart — a stale competitive claim on one page is worse than none at all.
#
# Usage: ./check-comparison-sync.sh        (exit 0 = in sync, 1 = drift)
# Run it after editing the comparison table on any page.
# ─────────────────────────────────────────────────────────────────────────────

set -uo pipefail
cd "$(dirname "$0")"

EN_PAGES=(index.html roommates.html couples.html travel.html)
ZH_PAGES=(Taiwan.html)
fail=0

# Pull just the <table class="cmp-table"> … </table> block out of a page.
extract_table() {
  sed -n '/<table class="cmp-table">/,/<\/table>/p' "$1"
}

# ── 1. The English tables must be byte-identical ─────────────────────────────
echo "== English comparison tables =="
ref="${EN_PAGES[0]}"
ref_hash=$(extract_table "$ref" | md5)

if [ -z "$(extract_table "$ref")" ]; then
  echo "  ✗ $ref — no cmp-table found"
  exit 1
fi

for page in "${EN_PAGES[@]}"; do
  hash=$(extract_table "$page" | md5)
  if [ -z "$(extract_table "$page")" ]; then
    echo "  ✗ $page — no cmp-table found"
    fail=1
  elif [ "$hash" = "$ref_hash" ]; then
    echo "  ✓ $page"
  else
    echo "  ✗ $page — DRIFTED from $ref"
    fail=1
  fi
done

# Show the actual diff so it's obvious what to fix.
if [ "$fail" -eq 1 ]; then
  for page in "${EN_PAGES[@]:1}"; do
    if [ "$(extract_table "$page" | md5)" != "$ref_hash" ]; then
      echo
      echo "--- diff: $ref vs $page ---"
      diff <(extract_table "$ref") <(extract_table "$page") | head -20
    fi
  done
fi

# ── 2. Translated pages: can't compare text, but row counts must match ───────
# Catches "added a row to the EN pages but forgot Taiwan.html".
echo
echo "== Translated pages (row count only) =="
ref_rows=$(extract_table "$ref" | grep -c "<tr><td class=\"cmp-feat\"")
for page in "${ZH_PAGES[@]}"; do
  [ -f "$page" ] || continue
  rows=$(extract_table "$page" | grep -c "<tr><td class=\"cmp-feat\"")
  if [ "$rows" -eq "$ref_rows" ]; then
    echo "  ✓ $page — $rows rows (matches EN)"
  else
    echo "  ✗ $page — $rows rows, but EN has $ref_rows"
    echo "    (a row was likely added/removed in EN without updating the translation)"
    fail=1
  fi
done

# ── 3. The "as of <date>" footnote should agree everywhere, incl. translations ─
echo
echo "== Comparison date footnote =="
dates=$(grep -ho "as of <strong[^>]*>[^<]*</strong>\|<strong[^>]*>20[0-9][0-9]年[^<]*</strong>" "${EN_PAGES[@]}" "${ZH_PAGES[@]}" 2>/dev/null \
        | sed -E 's/.*<strong[^>]*>([^<]*)<\/strong>.*/\1/' | sort -u)
count=$(echo "$dates" | grep -c . || true)
if [ "$count" -le 1 ]; then
  echo "  ✓ consistent: $(echo "$dates" | tr '\n' ' ')"
else
  echo "  ✗ multiple dates found across pages:"
  echo "$dates" | sed 's/^/      /'
  fail=1
fi

echo
if [ "$fail" -eq 0 ]; then
  echo "All comparison tables in sync ✓"
else
  echo "DRIFT DETECTED — update the pages above so every visitor sees the same claims."
fi
exit "$fail"
