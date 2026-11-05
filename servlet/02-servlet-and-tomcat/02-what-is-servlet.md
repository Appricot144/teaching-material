# Servlet とは何か

> 疑問: 自分で書く「ページを作る部分」は、どんなコードになるのか。
>
> 答え: Servlet という決まりに沿った Java のクラスです。リクエストを受け取り、レスポンスを書くメソッドだけを書きます。

## Servlet class の例

次のクラスは、`/hello` を開いたブラウザに「こんにちは」と返します。

```java
@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/plain; charset=UTF-8");
        resp.getWriter().println("こんにちは");
    }
}
```

コードの各部分は、次のことを表します。

- `@WebServlet("/hello")`: このクラスが、パス `/hello` のリクエストを受け持つ
- `extends HttpServlet`: Servlet の決まりに沿ったクラスにする
- `doGet`: `GET` のリクエストが来たときに呼ばれるメソッド
- `req`: 届いたリクエスト
- `resp`: これから返すレスポンス。ここに中身を書き込む

前のファイルの `RawServer` と比べてください。リクエストを待つ処理も、HTTP の文字を組み立てる処理もありません。それらは Tomcat が受け持つからです。

## 「Servlet」という言葉が指すもの

「Servlet」という言葉は、場面によって次の3つのどれかを指します。

- Servlet 仕様: Tomcat と自分のクラスの間の取り決めを、文章で書いたもの
- Servlet API: その取り決めを、Java のクラスやインタフェースとして用意したもの。`HttpServlet` や `HttpServletRequest` など
- Servlet class: Servlet API を使って、自分で書くクラス。上の `HelloServlet` など

この教材では、3つを区別するために、上の呼び名を使い分けます。

## 呼び出すのは Tomcat

いつものプログラムでは、自分の `main` メソッドから、他のクラスのメソッドを呼び出します。

Servlet class には `main` メソッドがありません。`doGet` を呼び出すのは Tomcat です。自分は、呼ばれたときに何をするかだけを書きます。

```mermaid
flowchart LR
    subgraph L["いつものプログラム"]
        A1["自分の main"] -- 呼び出す --> B1["他のクラス"]
    end
    subgraph F["Servlet"]
        A2["Tomcat"] -- 呼び出す --> B2["自分の Servlet class"]
    end
```

## Servlet API をプロジェクトに入れる

Servlet class をコンパイルするには、`HttpServlet` などの Servlet API が必要です。Maven を使う場合は、次のように依存関係に追加します。

```xml
<dependency>
    <groupId>jakarta.servlet</groupId>
    <artifactId>jakarta.servlet-api</artifactId>
    <version>6.1.0</version>
    <scope>provided</scope>
</dependency>
```

`provided` は「コンパイルのときだけ使う」という指定です。動かすときには、Tomcat が持っている Servlet API が使われるので、自分のアプリに入れる必要はありません。

## 古い資料を読むときの注意

古い資料では、Servlet API のパッケージ名が `javax.servlet` になっています。Tomcat 10 から `jakarta.servlet` に変わりました。

この教材は Tomcat 11 を使うので、`jakarta.servlet` を使います。古い資料のコードを動かすときは、パッケージ名を書き換える必要があります。

---

前: [Java で Web サーバを作るにはどうするのか](01-java-web-server.md) ｜ 次: [Tomcat とは何か](03-what-is-tomcat.md)
