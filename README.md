# teaching-materials

学習用の教材を Markdown で書き、HTML に変換してブラウザで読むためのリポジトリです。

## ディレクトリ構成

```text
teaching-materials/
├─ servlet/           Servlet と Tomcat の教材（README.md が目次）
├─ bin/build          ビルドスクリプト
├─ build/             ビルドで使う設定とスタイル
│  ├─ links.lua       .md へのリンクを .html へのリンクに置き換える pandoc フィルター
│  ├─ mermaid.json    Mermaid の描画設定
│  └─ style.css       HTML のスタイル
├─ test/build.sh      ビルド結果のテスト
├─ .puppeteerrc.cjs   mmdc が使う Chromium の設定
└─ dist/              ビルドの出力先（git では管理しない）
```

教材はトピックごとにディレクトリを分けます。新しいトピックを追加するときは、リポジトリ直下にディレクトリを作り、その中に Markdown を置きます。リポジトリ直下に置いた Markdown は、ビルドの対象になりません。

## 文章の書き方

- 文章は Markdown で書きます。
- 図は Mermaid のコードブロックで書きます。
- 他の教材へのリンクは `.md` ファイルへの相対パスで書きます。

Markdown のままでも、glowm を使えばターミナルで図を含めて確認できます。ただし、glowm の図は tmux の中では表示されません。

## ビルド

### 必要なもの

| ツール | 用途 | 入れ方 |
|---|---|---|
| Node.js と npm | mmdc の実行 | 導入済みのものを使う |
| pandoc | Markdown から HTML への変換 | `sudo apt install pandoc` |
| Chromium | mmdc による Mermaid の描画 | `sudo apt install chromium` |

mmdc は、Chromium を `/usr/bin/chromium` から起動します。場所が異なる場合は、`.puppeteerrc.cjs` の `executablePath` を変更してください。

### 手順

最初に一度だけ、mmdc をインストールします。

```sh
npm install
```

その後、次のコマンドでビルドします。

```sh
npm run build
```

ビルド結果が次の仕様を満たしているかは、次のコマンドで確かめられます。ビルドも合わせて実行します。

```sh
npm test
```

### ビルドの処理

`bin/build` は、教材の Markdown ごとに次の処理を行います。

1. mmdc で Mermaid のコードブロックを SVG に変換し、画像への参照に置き換える
2. pandoc で HTML に変換する
3. `.md` へのリンクを `.html` へのリンクに置き換える

各ディレクトリの `README.md` は `index.html` として出力します。また、ビルドのたびに `dist/` を作り直します。

### 出力の仕様

`dist/` の下のトピックごとのディレクトリは、それだけで完結したドキュメントパッケージにします。ディレクトリをコピーしたり、zip にして渡したりしても、そのまま読めます。

```text
dist/
└─ servlet/
   ├─ index.html                README.md から作る入口
   ├─ assets/style.css          トピックごとに同梱する CSS
   └─ 05-jsp/
      ├─ 01-what-is-jsp.html    ../assets/style.css を読み込む
      └─ 01-what-is-jsp-1.svg   HTML と同じディレクトリに置く図
```

- `dist/` の直下には、トピックのディレクトリだけを置きます。
- CSS は、各トピックの `assets/` に同梱します。
- HTML は、同じトピックの CSS を相対パスで読み込みます。
- 図の SVG は、それを使う HTML と同じディレクトリに置きます。

## 読み方

ビルド後、`dist/` の HTML をブラウザで開きます。各トピックの入口は `dist/<トピック>/index.html` です。

- Servlet と Tomcat: `dist/servlet/index.html`
