# teaching-materials

Markdown で書いた教材を、ブラウザで読む HTML に変換するリポジトリです。

## ディレクトリ構成

```text
├─ servlet/           教材（トピックごとのディレクトリ。README.md が目次）
├─ bin/build          ビルドスクリプト
├─ bin/figures        HTML で書いた図を PNG にするスクリプト
├─ build/
│  ├─ links.lua       .md へのリンクを .html に置き換え、図に srcset を付ける pandoc フィルター
│  ├─ mermaid.json    Mermaid の描画設定
│  └─ style.css       HTML のスタイル
├─ test/build.sh      ビルド結果のテスト
├─ test/figures.sh    bin/figures のテスト
├─ .puppeteerrc.cjs   mmdc と bin/figures が使う Chromium の設定
└─ dist/              ビルドの出力先
```

## 書き方

- 教材は、リポジトリ直下のトピックのディレクトリに置きます。直下の Markdown はビルドされません。
- 下書きは `DRAFT` で始まる名前（`DRAFT-what-is-di.md` など）にします。下書きはビルドされません。
- 図は Mermaid のコードブロックで書きます。流れや関係のように、箱と矢印で表せる図に向いています。
- 位置や形を自分で決めたい図は、HTML で書いて PNG にします。詳しくは「HTML で書く図」を見てください。
- 他の教材へのリンクは、`.md` ファイルへの相対パスで書きます。

## HTML で書く図

Mermaid では描きにくい図（文字列の一部に穴を開けて見せる図など）は、HTML と CSS で書き、PNG に変換して Markdown に取り込みます。

1. 図を使う Markdown と同じディレクトリに `figures/` を作り、図の HTML を置く（例: `servlet/05-jsp/figures/template-slot.html`）
2. HTML の中で、画像にしたい要素に `class="figure"` を付ける
3. `bin/figures`（または `npm run figures`）を実行する。`figures/*.html` ごとに、同じ名前の PNG ができる
4. Markdown から画像として読み込む（例: `![テンプレートの穴に値がはまる様子](figures/template-slot.png)`）
5. HTML と PNG の両方をコミットする

PNG は、`class="figure"` の要素だけを2倍の解像度で撮ったものです。ビルドでは、`figures/` の PNG に `srcset="… 2x"` を付けるので、ブラウザでは図の HTML で決めた大きさで表示されます。図の大きさを変えたいときは、図の HTML を直して作り直します。HTML を直したら、`bin/figures` で PNG を作り直してからコミットします。PNG もコミットするのは、GitHub で Markdown を見たときにも図が出るようにするためです。

作り直し忘れは、`bin/figures --check` で見つけられます。PNG には元の HTML のハッシュ値が書き込んであり、今の HTML と合わない PNG と、元の HTML がない PNG を「古い PNG」として表示します。`npm test`（`test/figures.sh`）もこの確認を行い、端末から実行したときは、古い PNG を削除するかを y/n で聞きます。

## 必要なもの

- pandoc
- Chromium（`/usr/bin/chromium`。場所が違う場合は `.puppeteerrc.cjs` を変更する）

## ビルドのしかた

```bash
bin/build                  # すべてのトピックをビルドする
bin/build servlet          # servlet/ だけをビルドする
bin/build servlet spring   # 複数のトピックを指定する
```

`npm run build -- servlet` のように、npm からも指定できます。

## ビルドの仕様

教材の Markdown ごとに、次の処理を行います。

1. Mermaid のコードブロックを SVG に変換する
2. pandoc で HTML に変換し、`.md` へのリンクを `.html` に置き換える

トピックの中の画像（`.png`、`.svg`、`.jpg`、`.gif`）は、同じ相対パスで `dist/` にコピーします。`figures/*.html` は図の元なので、コピーしません。

`README.md` は `index.html` として出力します。

ビルドのたびに出力を作り直します。トピックを指定しないときは `dist/` 全体を、指定したときは `dist/` の下のそのトピックのディレクトリだけを作り直します。

`dist/` の下のトピックのディレクトリは、それだけで読めるように完結させます。

```text
dist/
└─ servlet/
   ├─ index.html
   ├─ assets/style.css          トピックごとに同梱する CSS
   └─ 05-jsp/
      ├─ 01-what-is-jsp.html
      └─ 01-what-is-jsp-1.svg   HTML と同じディレクトリに置く
```
