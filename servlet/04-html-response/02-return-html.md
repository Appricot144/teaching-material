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
        resp.setContentType("text/html; charset=UTF-8");

        resp.getWriter().println("""
            <!DOCTYPE html>
            <html lang="ja">
            <head><title>挨拶</title></head>
            <body>
              <h1>こんにちは</h1>
            </body>
            </html>
            """);
    }
}
```

`"""` で囲むと、何行にもわたる文字列をそのまま書けます。これは Java のテキストブロックという書き方です。

## `Content-Type` で表示が変わる

ブラウザは、`Content-Type` を見て、ボディをどう表示するかを決めます。

- `text/html`: HTML として表示する。`<h1>` は大きな見出しになる
- `text/plain`: ただの文字として表示する。`<h1>` という文字がそのまま見える

同じボディでも、`Content-Type` を変えると見え方が変わります。

## 大きなページを書くとき

ページが大きくなると、Java の文字列の中に HTML を書くのは読みにくくなります。そこで、ページによって次のように使い分けます。

- いつも同じページ: `.html` ファイルをアプリに入れておく。Tomcat がそのまま返す
- 中身が変わるページ: JSP を使う。HTML の中に、変わる部分だけを書き込める

JSP は [5章](../05-jsp/01-what-is-jsp.md) で説明します。

---

前: [リクエストとレスポンスをどう扱うのか](01-request-and-response.md) ｜ 次: [レスポンスはいつ送信されるのか](03-response-commit.md)
