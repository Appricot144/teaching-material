---
name: spring
description: spring 教材を書く・直すときの、想定する読者、執筆時の環境、説明の方針と紹介する資料
paths:
  - "spring/**/*.md"
---

# spring 教材のルール

`spring/` の教材を書く・直すときに従うルール。全ドキュメントで共通のルールは、リポジトリのルートの `.claude/rules/writing.md` に従う。

## 想定する読者

`servlet/` の教材を読み終えた人を読者とする。読み終える前の読者像は、`servlet/.claude/rules/servlet.md` の「想定する読者」を引き継ぐ。

読者ができること:

- `servlet/` の教材で説明した内容（Web の基礎、Servlet class、Tomcat、JSP など）を前提知識として使える

`servlet/` の教材で説明していないことは、読者が知らないこととして扱う。

## 執筆時の環境

環境は前提として求めず、`spring/README.md` に「執筆時の環境」として付記する。

| 要素 | バージョン |
|---|---|
| Spring Boot | 4.x |
| Spring Framework | 7.x |
| Java | 17 以上 |

## Spring Framework と Spring Boot の使い分け

- DI などの概念は、Spring Framework だけで説明する
- アプリを作るところから、Spring Boot を使う

## コード例と設定例

- ビルドツールは Maven を使う
- servlet 教材と同じく、コード例では `import` 文を省略する

## servlet 教材とのつなぎ方

Servlet で書いた方法と比べながら説明する（「Servlet ではこう書いた → Spring ではこう書く」）。

## 参考文献として紹介する資料

公式ドキュメントとして、次のようなものを紹介する。

- Spring Framework のリファレンス
- Spring Boot のリファレンス
