# Servlet と Tomcat の入門

Web の基礎から、Tomcat 上で動く Servlet class と JSP の書き方までを順に説明する教材です。1ファイルで1つの疑問に答えるので、気になるファイルだけを読むこともできます。

## 前提とする環境

| 要素 | 前提 |
|---|---|
| Tomcat | 11 |
| Servlet API | `jakarta.servlet-api` 6.1 |
| Java | 17 以上 |

Spring などのフレームワークは使いません。コード例では `import` 文を省略しています。

## 用語

| 用語 | 指すもの |
|---|---|
| Servlet 仕様 | Tomcat などのコンテナとアプリの間の取り決め |
| Servlet API | Servlet 仕様を Java の型として定義したもの |
| Servlet class | Servlet API に沿って自分で書く、アプリ処理のクラス |
| Tomcat | Servlet 仕様を実装し、Servlet class を動かす実行環境 |

## 目次

### 1. Web の基礎

1. [Web サーバとは何か](01-web-basics/01-what-is-web-server.md)
2. [入力を受けて出力するプログラムとどう違うのか](01-web-basics/02-web-server-vs-program.md)
3. [URL とは何か](01-web-basics/03-what-is-url.md)
4. [HTTP とは何か](01-web-basics/04-what-is-http.md)

補遺:

- [ハイパーテキストとは何か](01-web-basics/appendix-a-hypertext.md)
- [URI とは何か](01-web-basics/appendix-b-uri.md)

### 2. Servlet と Tomcat

1. [Java で Web サーバを作るにはどうするのか](02-servlet-and-tomcat/01-java-web-server.md)
2. [Servlet とは何か](02-servlet-and-tomcat/02-what-is-servlet.md)
3. [Tomcat とは何か](02-servlet-and-tomcat/03-what-is-tomcat.md)
4. [仕様、API、Servlet class、Tomcat はどう関係するのか](02-servlet-and-tomcat/04-relationships.md)

### 3. Servlet class の呼び出し

1. [URL と Servlet class をどう対応付けるのか](03-servlet-invocation/01-url-mapping.md)
2. [リクエストから Servlet class が呼ばれるまでに何が起こるのか](03-servlet-invocation/02-request-flow.md)
3. [`doGet()` や `doPost()` は誰が振り分けるのか](03-servlet-invocation/03-service-dispatch.md)
4. [Servlet class は同時アクセスをどう処理するのか](03-servlet-invocation/04-instance-and-threads.md)

### 4. HTML を返す

1. [リクエストとレスポンスをどう扱うのか](04-html-response/01-request-and-response.md)
2. [HTML をレスポンスとして返すにはどうするのか](04-html-response/02-return-html.md)
3. [レスポンスはいつ送信されるのか](04-html-response/03-response-commit.md)
4. [入力値を HTML に埋め込むとなぜ危険なのか](04-html-response/04-xss-and-escaping.md)

### 5. JSP

1. [JSP とは何か](05-jsp/01-what-is-jsp.md)
2. [JSP はどうやって Servlet class になるのか](05-jsp/02-jsp-to-servlet-class.md)
3. [Servlet class から JSP へどう処理と値を渡すのか](05-jsp/03-forward-and-attributes.md)
4. [JSP で HTML を返すにはどう書くのか](05-jsp/04-return-html-with-jsp.md)

### 6. ユーザの入力とリダイレクト

1. [ユーザの入力をどう受け取るのか](06-input-and-redirect/01-receive-user-input.md)
2. [リダイレクトとは何か](06-input-and-redirect/02-what-is-redirect.md)
3. [POST の二重送信をどう防ぐのか](06-input-and-redirect/03-prg-pattern.md)
