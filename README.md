# teaching-materials

Markdown で書いた教材を、ブラウザで読む HTML に変換するリポジトリです。

## ディレクトリ構成

```text
├─ servlet/           教材（トピックごとのディレクトリ。README.md が目次）
├─ bin/build          ビルドスクリプト
├─ build/
│  ├─ links.lua       .md へのリンクを .html に置き換える pandoc フィルター
│  ├─ mermaid.json    Mermaid の描画設定
│  └─ style.css       HTML のスタイル
├─ test/build.sh      ビルド結果のテスト
├─ .puppeteerrc.cjs   mmdc が使う Chromium の設定
└─ dist/              ビルドの出力先
```

## 書き方

- 教材は、リポジトリ直下のトピックのディレクトリに置きます。直下の Markdown はビルドされません。
- 図は Mermaid のコードブロックで書きます。
- 他の教材へのリンクは、`.md` ファイルへの相対パスで書きます。

## 必要なもの

- pandoc
- Chromium（`/usr/bin/chromium`。場所が違う場合は `.puppeteerrc.cjs` を変更する）

## ビルドの仕様

教材の Markdown ごとに、次の処理を行います。

1. Mermaid のコードブロックを SVG に変換する
2. pandoc で HTML に変換し、`.md` へのリンクを `.html` に置き換える

`README.md` は `index.html` として出力します。`dist/` はビルドのたびに作り直します。

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
