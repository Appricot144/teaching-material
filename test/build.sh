#!/usr/bin/env bash
# bin/build を実行し、dist/ の各トピックが単体で完結していることを確かめる。
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dist="$root/dist"
failures=0

fail() {
  echo "NG: $1" >&2
  failures=$((failures + 1))
}

"$root/bin/build" > /dev/null

# dist/ の直下には、トピックのディレクトリだけがある
while IFS= read -r entry; do
  [[ -d "$entry" ]] || fail "dist/ の直下にファイルがある: ${entry#"$dist"/}"
done < <(find "$dist" -mindepth 1 -maxdepth 1)
[[ -e "$dist/assets" ]] && fail "dist/assets/ が残っている"

while IFS= read -r topic; do
  name="$(basename "$topic")"

  # トピックごとに CSS を同梱する
  [[ -f "$topic/assets/style.css" ]] || fail "$name/assets/style.css がない"

  # 各 HTML が読み込む CSS は、同じトピックの中にある
  while IFS= read -r html; do
    rel="${html#"$dist"/}"
    href="$(grep -o '<link rel="stylesheet" href="[^"]*"' "$html" | sed 's/.*href="//; s/"$//')"
    if [[ -z "$href" ]]; then
      fail "$rel が CSS を読み込んでいない"
      continue
    fi
    target="$(realpath -m "$(dirname "$html")/$href")"
    [[ "$target" == "$topic/"* ]] || fail "$rel の CSS がトピックの外を指している: $href"
    [[ -f "$target" ]] || fail "$rel の CSS が見つからない: $href"
  done < <(find "$topic" -name '*.html')
done < <(find "$dist" -mindepth 1 -maxdepth 1 -type d)

if ((failures > 0)); then
  echo "$failures 件の失敗" >&2
  exit 1
fi
echo "OK"
