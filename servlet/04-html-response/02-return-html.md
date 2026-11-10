# HTML をレスポンスとして返すにはどうするのか

> 疑問: 文字ではなく、HTML のページを返すにはどうすればよいのか。
>
> 答え: `Content-Type` を `text/html` にして、HTML を文字列としてボディに書きます。特別な書き方はいりません。

## HTML も文字

自分で書いた HTML ファイルは、中身を見るとただの文字です。Web サーバが HTML を返すときも、その文字をボディに入れて送るだけです。

## 例

```java
@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");

        resp.setContentType("text/html; charset=UTF-8");
        resp.getWriter().println("""
            <!DOCTYPE html>
            <html lang="ja">
            <head><title>挨拶</title></head>
            <body>
              <h1>こんにちは、%s</h1>
            </body>
            </html>
            """.formatted(name));
    }
}
```

`"""` で囲むと、何行にもわたる文字列をそのまま書けます。これは Java のテキストブロックという書き方です。

`.formatted(name)` は、文字列の中の `%s` の場所に、`name` の値を入れます。`/hello?name=taro` を開くと、見出しは「こんにちは、taro」になります。

## `Content-Type` で表示が変わる

`Content-Type` は、[1章4節](../01-web-basics/04-what-is-http.md) で見た、HTTP のレスポンスのヘッダーの1つです。ボディが何のデータかを表すもので、HTTP の決まりです。Tomcat や Servlet が決めたものではありません。`setContentType` は、このヘッダーを書くためのメソッドです。

ブラウザは、`Content-Type` を見て、ボディをどう表示するかを決めます。

- `text/html`: HTML として表示する。`<h1>` は大きな見出しになる
- `text/plain`: ただの文字として表示する。`<h1>` という文字がそのまま見える

同じボディでも、`Content-Type` を変えると見え方が変わります。

`Content-Type` を変えれば、HTML 以外のものも返せます。

- `application/json`: プログラムが読むためのデータ（JSON）。ブラウザの JavaScript やスマートフォンのアプリが受け取って使う
- `text/csv`: カンマで区切った表のデータ。表計算ソフトで開ける
- `image/png`: 画像。Servlet class で作ったグラフを、画像として返せる
- `application/pdf`: PDF。ブラウザが PDF として表示する

画像や PDF のように、文字ではないデータを書くときは、`getWriter()` ではなく `getOutputStream()` を使います。

## 大きなページを書くとき

ページが大きくなると、Java の文字列の中に HTML を書くのは読みにくくなります。そこで、ページによって次のように使い分けます。

- [静的ページ](../01-web-basics/01-what-is-web-server.md): `.html` ファイルをアプリに入れておく。Tomcat がそのまま返す
- 動的ページ: HTML のひな形を用意しておき、変わる部分だけをリクエストのたびに埋める。この教材では、そのために JSP を使う

JSP は [5章](../05-jsp/README.md) で説明します。

ここまでは、サーバが HTML を作って返す作り方です。ほかに、サーバは `application/json` でデータだけを返し、ブラウザの JavaScript がそのデータから HTML を組み立てる作り方もあります。今の Web アプリでは、こちらが主流になっています。

---

前: [リクエストとレスポンスをどう扱うのか](01-request-and-response.md) ｜ 次: [レスポンスはいつ送信されるのか](03-response-commit.md)
