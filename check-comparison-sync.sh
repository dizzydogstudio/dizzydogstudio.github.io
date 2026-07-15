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
ZH_PAGES=(Taiwan.html Taiwan-roommates.html Taiwan-couples.html Taiwan-travel.html)
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

# ── 2. Translated pages ──────────────────────────────────────────────────────
# Two checks: the zh tables must be identical to each other (same transplanted
# block), and their row count must match EN — which catches "added a row to the
# EN pages but forgot the translations".
echo
echo "== Translated pages =="
ref_rows=$(extract_table "$ref" | grep -c "<tr><td class=\"cmp-feat\"")
zh_ref="${ZH_PAGES[0]}"
zh_ref_hash=$(extract_table "$zh_ref" | md5)

for page in "${ZH_PAGES[@]}"; do
  if [ ! -f "$page" ]; then
    echo "  ✗ $page — missing"
    fail=1
    continue
  fi
  rows=$(extract_table "$page" | grep -c "<tr><td class=\"cmp-feat\"")
  hash=$(extract_table "$page" | md5)
  if [ "$rows" -ne "$ref_rows" ]; then
    echo "  ✗ $page — $rows rows, but EN has $ref_rows"
    echo "    (a row was likely added/removed in EN without updating the translation)"
    fail=1
  elif [ "$hash" != "$zh_ref_hash" ]; then
    echo "  ✗ $page — $rows rows, but DRIFTED from $zh_ref"
    fail=1
  else
    echo "  ✓ $page — $rows rows (matches EN, identical to $zh_ref)"
  fi
done

# ── 3. The "as of <date>" footnote should agree everywhere, incl. translations ─
# EN reads "July 5, 2026" and zh reads "2026 年 7 月 5 日", so the two can never
# match as raw strings — normalise both to YYYY-MM-DD before comparing. (The old
# regex here required "2026年" with no spaces, so it silently matched nothing and
# the translations were never actually checked.)
echo
echo "== Comparison date footnote =="
if python3 - "${EN_PAGES[@]}" "${ZH_PAGES[@]}" <<'PY'
import re, sys

MONTHS = {m: i for i, m in enumerate(
    ["January","February","March","April","May","June","July",
     "August","September","October","November","December"], start=1)}

def norm(page):
    s = open(page, encoding="utf-8").read()
    for raw in re.findall(r'<strong[^>]*>([^<]*)</strong>', s):
        t = raw.strip()
        m = re.fullmatch(r'([A-Z][a-z]+)\s+(\d{1,2}),\s*(\d{4})', t)
        if m and m.group(1) in MONTHS:
            return "%s-%02d-%02d" % (m.group(3), MONTHS[m.group(1)], int(m.group(2))), t
        m = re.fullmatch(r'(\d{4})\s*年\s*(\d{1,2})\s*月\s*(\d{1,2})\s*日', t)
        if m:
            return "%s-%02d-%02d" % (m.group(1), int(m.group(2)), int(m.group(3))), t
    return None, None

found, missing = {}, []
for page in sys.argv[1:]:
    iso, raw = norm(page)
    if iso is None:
        missing.append(page)
    else:
        found.setdefault(iso, []).append("%s (%s)" % (page, raw))

for page in missing:
    print("  ✗ %s — no comparison date footnote found" % page)
if len(found) == 1:
    print("  ✓ consistent: %s — across %d pages"
          % (list(found)[0], sum(len(v) for v in found.values())))
else:
    print("  ✗ pages disagree on the comparison date:")
    for iso, pages in sorted(found.items()):
        print("      %s" % iso)
        for p in pages:
            print("        %s" % p)
sys.exit(0 if len(found) == 1 and not missing else 1)
PY
then :; else fail=1; fi

echo
if [ "$fail" -eq 0 ]; then
  echo "All comparison tables in sync ✓"
else
  echo "DRIFT DETECTED — update the pages above so every visitor sees the same claims."
fi
exit "$fail"
