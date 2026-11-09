#!/usr/bin/env bash
# bin/build を実行し、トピックの指定と下書きの除外が効くこと、dist/ の各トピックが単体で完結していることを確かめる。
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dist="$root/dist"
failures=0

fail() {
  echo "NG: $1" >&2
  failures=$((failures + 1))
}

# --- 仮の教材でビルドの指定方法を確かめる ---

# bin/build はスクリプトの場所からリポジトリのルートを決めるので、一時ディレクトリにルートを組み立てる
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/bin" "$fixture/build"
cp "$root/bin/build" "$fixture/bin/build"
cp -r "$root/build/." "$fixture/build/"
ln -s "$root/node_modules" "$fixture/node_modules"

# 仮のトピック: alpha と beta は教材、gamma は下書きだけ
write_md() {
  mkdir -p "$(dirname "$fixture/$1")"
  printf '# %s\n\n本文\n' "$1" > "$fixture/$1"
}
write_md alpha/README.md
write_md alpha/01-chapter/01-page.md
write_md alpha/01-chapter/README.md
printf '# page\n\n[表紙](README.md)\n' > "$fixture/alpha/01-chapter/02-page.md"
write_md alpha/DRAFT-top.md
write_md alpha/01-chapter/DRAFT-page.md
write_md alpha/.claude/rules/rule.md
write_md beta/README.md
write_md gamma/DRAFT-only.md

fbuild="$fixture/bin/build"
fdist="$fixture/dist"

# 引数なしでは、すべてのトピックをビルドする
"$fbuild" > /dev/null || fail "引数なしのビルドが失敗した"
[[ -f "$fdist/alpha/index.html" ]] || fail "引数なし: alpha/index.html がない"
[[ -f "$fdist/alpha/01-chapter/01-page.html" ]] || fail "引数なし: alpha/01-chapter/01-page.html がない"
[[ -f "$fdist/beta/index.html" ]] || fail "引数なし: beta/index.html がない"

# 章のディレクトリの README.md は、章の表紙として index.html にする
[[ -f "$fdist/alpha/01-chapter/index.html" ]] || fail "引数なし: 章の表紙 alpha/01-chapter/index.html がない"
[[ -e "$fdist/alpha/01-chapter/README.html" ]] && fail "章の表紙が README.html として出力されている"
grep -q 'href="index.html"' "$fdist/alpha/01-chapter/02-page.html" || fail "章の表紙へのリンクが index.html になっていない"

# DRAFT*.md は下書きなので、HTML にしない
while IFS= read -r entry; do
  fail "下書きが出力されている: ${entry#"$fdist"/}"
done < <(find "$fdist" -name 'DRAFT*')
[[ -e "$fdist/gamma" ]] && fail "下書きしかないトピックが出力されている"

# トピックを指定すると、そのトピックだけを作り直し、他のトピックの出力は残す
touch "$fdist/alpha/keep" "$fdist/beta/stale"
"$fbuild" beta > /dev/null || fail "トピックを指定したビルドが失敗した"
[[ -f "$fdist/alpha/keep" ]] || fail "指定していないトピックの出力が消えた"
[[ -e "$fdist/beta/stale" ]] && fail "指定したトピックの古い出力が残っている"
[[ -f "$fdist/beta/index.html" ]] || fail "指定したトピック: beta/index.html がない"
[[ -f "$fdist/beta/assets/style.css" ]] || fail "指定したトピック: beta/assets/style.css がない"

# 複数のトピックを指定でき、末尾の / は無視する
"$fbuild" alpha/ beta > /dev/null || fail "複数のトピックを指定したビルドが失敗した"
[[ -e "$fdist/alpha/keep" ]] && fail "複数指定: alpha の古い出力が残っている"

# 存在しないトピックや下書きしかないトピックを指定すると、何も消さずに失敗する
touch "$fdist/alpha/keep"
for topic in nope gamma build; do
  "$fbuild" alpha "$topic" > /dev/null 2>&1 && fail "教材ではない $topic を指定してもビルドが成功した"
done
[[ -f "$fdist/alpha/keep" ]] || fail "指定に誤りがあるのに出力が消えた"

# 引数なしでは、dist/ 全体を作り直す
"$fbuild" > /dev/null || fail "引数なしの再ビルドが失敗した"
[[ -e "$fdist/alpha/keep" ]] && fail "引数なし: 古い出力が残っている"

# --- 実際の教材をビルドし、各トピックが単体で完結していることを確かめる ---

"$root/bin/build" > /dev/null

# dist/ の直下には、トピックのディレクトリだけがある
while IFS= read -r entry; do
  [[ -d "$entry" ]] || fail "dist/ の直下にファイルがある: ${entry#"$dist"/}"
done < <(find "$dist" -mindepth 1 -maxdepth 1)
[[ -e "$dist/assets" ]] && fail "dist/assets/ が残っている"

# .claude/ の中のルールは教材ではないので、HTML にしない
while IFS= read -r entry; do
  fail ".claude/ が出力されている: ${entry#"$dist"/}"
done < <(find "$dist" -name .claude)

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
