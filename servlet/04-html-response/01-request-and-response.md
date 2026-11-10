# リクエストとレスポンスをどう扱うのか

> 疑問: `doGet` の引数の `req` と `resp` は、何に使うのか。
>
> 答え: `req` は届いたリクエストで、ここから値を読みます。`resp` はこれから返すレスポンスで、ここに中身を書き込みます。

## 入力は `req`、出力は `resp`

いつものプログラムは、キーボードから入力を読み、画面に出力します。

Servlet class では、読む先と書く先が変わります。

- 入力: `req`（`HttpServletRequest`）から読む
- 出力: `resp`（`HttpServletResponse`）に書く

[3章2節](../03-servlet-invocation/02-request-flow.md) で見たとおり、どちらも Tomcat がリクエストのたびに作って、`doGet` に渡します。

## 例: 名前を受け取って挨拶する

`/hello?name=taro` を開くと「こんにちは、taro」と返す Servlet class です。

```java
@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");

        resp.setContentType("text/plain; charset=UTF-8");
        resp.getWriter().println("こんにちは、" + name);
    }
}
```

`doGet` の戻り値の型は `void` です。`doGet` は何も返しません。

では、レスポンスはどう返すのでしょうか。`resp` に中身を書き込みます。書き込んだ中身は、Tomcat がレスポンスとしてブラウザへ送ります。何を書き込めるかは、このあと説明します。

## `req` から読めるもの

`/hello?name=taro` を開くと、ブラウザは次のリクエストを送ります。リクエストの部品は、`req` のメソッドで読めます。

```text
GET /hello?name=taro HTTP/1.1   ← getMethod() で "GET"、getParameter("name") で "taro"
Host: localhost:8080
User-Agent: Mozilla/5.0         ← getHeader("User-Agent") で "Mozilla/5.0"
```

`getParameter` は、その名前の値がリクエストにないとき `null` を返します。`/hello` だけを開くと、`name` は `null` になります。

## `resp` に書けるもの

例の `HelloServlet` は、次のレスポンスを返します。レスポンスの部品ごとに、書くためのメソッドがあります。

```text
HTTP/1.1 200 OK                           ← setStatus(200)
Content-Type: text/plain; charset=UTF-8   ← setContentType("text/plain; charset=UTF-8")

こんにちは、taro                          ← getWriter().println("こんにちは、" + name)
```

例のコードでは `setStatus` を書いていないので、ステータスコードは `200` になります。`Content-Type` 以外のヘッダーは、`resp.setHeader("名前", "値")` で書けます。

## 書く順番

ステータスコードとヘッダーは、ボディより先に書きます。

[1章4節](../01-web-basics/04-what-is-http.md) で見たとおり、HTTP のレスポンスでは、ステータス行とヘッダーが、ボディより前に並んでいました。ボディを送り始めたあとでは、前の部分を書き直せません。特に `setContentType` の文字コードは、`getWriter()` より前に書かないと効きません。`getWriter()` を呼んだ時点で、ボディの文字をどの文字コードで送るかが決まるからです。

送るタイミングは [3節](03-response-commit.md) で詳しく説明します。

> コラム: System.out.println はブラウザに届かない
>
> `resp.getWriter()` が返すのは、`PrintWriter` という Java 標準のクラスのオブジェクトです。`System.out` と同じく、文字を出力するためのクラスなので、`println` や `print` のような見慣れたメソッドが使えます。
>
> 同じ `println` でも、書き込む先は、どのオブジェクトのメソッドを呼ぶかで変わります。
>
> - `resp.getWriter().println("a")`: レスポンスのボディに書く。ブラウザに届く
> - `System.out.println("a")`: Tomcat を動かしている画面やログに書く。標準出力に届く
>
> `System.out.println` で書いた内容は、Tomcat の `logs/catalina.out` などで見られます。動きを確かめるための記録に使えます。

---

前: [4章 HTML を返す](README.md) ｜ 次: [HTML をレスポンスとして返すにはどうするのか](02-return-html.md)
