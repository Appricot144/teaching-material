# Tomcat とは何か

> 疑問: Servlet class には `main` メソッドがない。では、どうやって動かすのか。
>
> 答え: Tomcat というプログラムを起動し、その上に Servlet class を載せます。Tomcat がリクエストを受け取り、Servlet class を呼び出します。

## Tomcat が受け持つこと

Tomcat は、Web サーバのうち、どのアプリでも同じ部分を受け持つプログラムです。

- リクエストを待ち、HTTP の決まりに沿って読み取る
- パスを見て、どの Servlet class を呼ぶかを選ぶ
- Servlet class のオブジェクトを作り、メソッドを呼ぶ
- たくさんのリクエストに、同時に返事をする
- Servlet class が書いたレスポンスを、ブラウザに送る

このように Servlet class を載せて動かすプログラムを、サーブレットコンテナと呼びます。

## ライブラリとの違い

Java では、他の人が作ったコードをライブラリとして使うことがあります。ライブラリは、自分のプログラムの中から呼び出します。

Tomcat はその逆で、Tomcat が自分の Servlet class を呼び出します。

```mermaid
flowchart LR
    subgraph L["ライブラリ"]
        A1["自分のコード"] -- 呼び出す --> B1["ライブラリ"]
    end
    subgraph T["Tomcat"]
        A2["Tomcat"] -- 呼び出す --> B2["自分のコード"]
    end
```

そのため、Tomcat はライブラリのように自分のプロジェクトに入れるだけでは動きません。Tomcat を別に用意して起動し、その上に自分のアプリを載せます。

## アプリを載せる

自分のアプリは、WAR ファイルという1つのファイルにまとめます。WAR ファイルの中には、Servlet class などが入っています。

この WAR ファイルを、Tomcat の `webapps/` フォルダに置きます。

```text
Tomcat
└─ webapps/
   └─ myapp.war    ← 自分の Servlet class が入っている
```

## WAR ファイルの名前と URL

WAR ファイルの名前は、URL のパスの最初の部分になります。

`myapp.war` の中に `/hello` を受け持つ Servlet class があるとき、URL は次のようになります。

```text
http://localhost:8080/myapp/hello
                     └─┬──┘└─┬─┘
              WAR ファイルの名前  Servlet class が受け持つパス
```

この `/myapp` の部分を、コンテキストパスと呼びます。1つの Tomcat に複数のアプリを載せても、コンテキストパスで区別できます。

URL の `localhost` は「自分のコンピュータ」を表すホスト名です。自分のコンピュータで Tomcat を動かすときに使います。`8080` は、Tomcat がはじめから使うポートです。

## Tomcat の仲間

サーブレットコンテナは Tomcat だけではありません。Jetty などもあります。どれも同じ Servlet 仕様に沿っているので、Servlet class は基本的にどれの上でも動きます。

---

前: [Servlet とは何か](02-what-is-servlet.md) ｜ 次: [仕様、API、Servlet class、Tomcat はどう関係するのか](04-relationships.md)
