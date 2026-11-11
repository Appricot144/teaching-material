#!/usr/bin/env bash
# bin/figures を実行し、figures/ の HTML から PNG を作れることと、古い PNG を見つけられることを確かめる。
# 実際の教材に古い PNG があれば報告する。端末から実行したときは、削除するかを y/n で聞く。
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

# --- ファイルを指定して PNG を作る ---

# 指定した図だけを作り、ほかの図には触れない
cat > "$fixture/alpha/01-chapter/figures/two.html" <<'HTML'
<!DOCTYPE html>
<div class="figure" style="width: 100px; height: 40px">二つ目</div>
HTML
touch -d '2000-01-01 00:00:00' "$png"
"$fixture/bin/figures" "$fixture/alpha/01-chapter/figures/two.html" > /dev/null || fail "ファイルを指定した bin/figures が失敗した"
[[ -f "$fixture/alpha/01-chapter/figures/two.png" ]] || fail "指定した two.html の PNG が作られていない"
[[ "$(stat -c %Y "$png")" == "$(date -d '2000-01-01 00:00:00' +%s)" ]] || fail "指定していない slot.png が作り直された"

# 作業ディレクトリからの相対パスでも指定できる
rm "$fixture/alpha/01-chapter/figures/two.png"
(cd "$fixture/alpha/01-chapter" && "$fixture/bin/figures" figures/two.html > /dev/null) || fail "相対パスを指定した bin/figures が失敗した"
[[ -f "$fixture/alpha/01-chapter/figures/two.png" ]] || fail "相対パスで指定した two.html の PNG が作られていない"

# figures/ の HTML でないもの、存在しないものを指定すると、何も作らずに失敗する
for bad in "$fixture/alpha/02-chapter/other.html" "$fixture/alpha/01-chapter/figures/nope.html" "$png"; do
  "$fixture/bin/figures" "$bad" > /dev/null 2>&1 && fail "図ではない $bad を指定しても成功した"
done
[[ -e "$fixture/alpha/02-chapter/other.png" ]] && fail "figures/ の外の HTML から画像が作られた（指定したとき）"
rm "$fixture/alpha/01-chapter/figures/two.html" "$fixture/alpha/01-chapter/figures/two.png"

# --- 古い PNG を見つける（bin/figures --check） ---

# 作ったばかりの PNG は古くない
"$fixture/bin/figures" --check > /dev/null || fail "--check: 作ったばかりの PNG が古いと判定された"

# HTML を直したのに PNG を作り直していなければ、古い PNG として報告する
printf '<!-- 直した -->\n' >> "$fixture/alpha/01-chapter/figures/slot.html"
out="$("$fixture/bin/figures" --check)" && fail "--check: HTML を直したのに成功した"
grep -qx 'alpha/01-chapter/figures/slot.png' <<< "$out" || fail "--check: 直した HTML の PNG が報告されていない: $out"

# 元の HTML がない PNG も、古い PNG として報告する
cp "$png" "$fixture/alpha/01-chapter/figures/orphan.png"
out="$("$fixture/bin/figures" --check)" || true
grep -qx 'alpha/01-chapter/figures/orphan.png' <<< "$out" || fail "--check: 元の HTML がない PNG が報告されていない: $out"

# 作り直すと、元の HTML がある PNG は古くなくなる
rm "$fixture/alpha/01-chapter/figures/orphan.png"
"$fixture/bin/figures" > /dev/null
"$fixture/bin/figures" --check > /dev/null || fail "--check: 作り直したのに古いと判定された"

# --- 実際の教材に、古い PNG がないかを確かめる ---

if ! stale="$("$root/bin/figures" --check)"; then
  while IFS= read -r rel; do
    [[ -z "$rel" ]] && continue
    # 端末から実行したときだけ、削除するかを聞く。端末でなければ、止まらずに報告だけする
    if [[ -t 0 && -t 1 ]]; then
      read -r -p "古い PNG があります: $rel 削除しますか? [y/n] " answer < /dev/tty
      if [[ "$answer" == y ]]; then
        rm "$root/$rel"
        echo "削除しました: $rel"
      fi
    fi
    fail "古い PNG: $rel（bin/figures で作り直すか、元の HTML がなければ削除してください）"
  done <<< "$stale"
fi

if ((failures > 0)); then
  echo "$failures 件の失敗" >&2
  exit 1
fi
echo "OK"
