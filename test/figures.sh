#!/usr/bin/env bash
# bin/figures を実行し、figures/ の HTML から PNG を作れることを確かめる。
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0

fail() {
  echo "NG: $1" >&2
  failures=$((failures + 1))
}

# bin/figures はスクリプトの場所からリポジトリのルートを決めるので、一時ディレクトリにルートを組み立てる
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/bin" "$fixture/alpha/01-chapter/figures" "$fixture/alpha/02-chapter"
cp "$root/bin/figures" "$fixture/bin/figures"
cp "$root/.puppeteerrc.cjs" "$fixture/.puppeteerrc.cjs"
ln -s "$root/node_modules" "$fixture/node_modules"

cat > "$fixture/alpha/01-chapter/figures/slot.html" <<'HTML'
<!DOCTYPE html>
<html lang="ja">
<body style="margin: 0">
  <div class="figure" style="width: 200px; height: 50px">図</div>
  <p>図の外の文字</p>
</body>
</html>
HTML
# figures/ の外の HTML は図ではない
printf '<!DOCTYPE html>\n<div class="figure">図ではない</div>\n' > "$fixture/alpha/02-chapter/other.html"

"$fixture/bin/figures" > /dev/null || fail "bin/figures が失敗した"

png="$fixture/alpha/01-chapter/figures/slot.png"
if [[ -f "$png" ]]; then
  # PNG であること
  [[ "$(head -c 8 "$png" | od -An -tx1 | tr -d ' \n')" == "89504e470d0a1a0a" ]] || fail "slot.png が PNG ではない"
  # .figure の要素だけを、2倍の解像度で撮る（200x50 なら 400x100）
  size="$(od -An -tu1 -j16 -N8 "$png" | tr -s ' ' | sed 's/^ //')"
  read -r w1 w2 w3 w4 h1 h2 h3 h4 <<< "$size"
  width=$(((w1 << 24) + (w2 << 16) + (w3 << 8) + w4))
  height=$(((h1 << 24) + (h2 << 16) + (h3 << 8) + h4))
  [[ "$width" == 400 && "$height" == 100 ]] || fail "slot.png の大きさが 400x100 ではない: ${width}x${height}"
else
  fail "slot.png が作られていない"
fi

[[ -e "$fixture/alpha/02-chapter/other.png" ]] && fail "figures/ の外の HTML から画像が作られた"

if ((failures > 0)); then
  echo "$failures 件の失敗" >&2
  exit 1
fi
echo "OK"
