# teaching-materials

教えるときに使う教材をためておくリポジトリです。教材はトピックごとのディレクトリにまとめていて、各トピックの `README.md` が目次です。

## 教材の一覧

| トピック | 内容 | 状態 |
|---|---|---|
| [Servlet と Tomcat の入門](servlet/README.md) | Web の基礎から、Tomcat 上で動く Servlet class と JSP の書き方まで | 公開中 |
| Spring | `servlet/` の続きとして Spring を扱う | 準備中 |

## Servlet と Tomcat の入門

Web の基礎から、Tomcat 上で動く Servlet class と JSP の書き方までを順に説明する教材です。1ファイルで1つの疑問に答えるので、気になるファイルだけを読むこともできます。

| 章 | 扱うこと |
|---|---|
| [1章 Web の基礎](servlet/01-web-basics/README.md) | Web サーバとは何か、URL と HTTP でブラウザと Web サーバがどうやり取りするのか |
| [2章 Servlet と Tomcat](servlet/02-servlet-and-tomcat/README.md) | 自分で書く Servlet class と、それを動かす Tomcat の受け持ち |
| [3章 Servlet class の呼び出し](servlet/03-servlet-invocation/README.md) | URL と Servlet class の対応付けから、`doGet` が呼ばれるまでの流れ |
| [4章 HTML を返す](servlet/04-html-response/README.md) | リクエストを読んで HTML を返す方法と、入力値を HTML に入れるときの危険 |
| [5章 JSP](servlet/05-jsp/README.md) | JSP で HTML を返す方法と、Servlet class から JSP へ値を渡す方法 |
| [6章 入力を受け取り、結果を返す](servlet/06-input-and-redirect/README.md) | フォームの入力の受け取り方、リダイレクト、POST の二重送信の防ぎ方 |

前提とする環境（Tomcat 11、Java 17 以上など）と用語は、[目次](servlet/README.md)にまとめています。
