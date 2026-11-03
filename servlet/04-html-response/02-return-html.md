# HTML をレスポンスとして返すにはどうするのか

> 疑問: Servlet class から HTML を返すには、特別な書き方が必要か。
>
> 答え: 必要ありません。`Content-Type` を `text/html` にして、HTML を文字列としてレスポンスボディに書き込みます。

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

`"""` で囲む書き方は Java のテキストブロックで、複数行の文字列をそのまま書けます。

ブラウザは `Content-Type` を見て、本文を HTML として表示します。`text/plain` なら、タグも含めてそのまま文字として表示します。

## 大きな HTML を書く場合

Servlet class の中に HTML を文字列で書くと、ページが大きくなるほど読みにくくなります。そのため、ページの内容に応じて次のように使い分けます。

| ページの内容 | 使うもの |
|---|---|
| 毎回同じ（静的） | `.html` ファイル。アプリに含めれば Tomcat がそのまま返す |
| 表示だけで済む動的な内容 | JSP に直接アクセス |
| 表示の前に処理が必要 | Servlet class から JSP へ `forward()` |

JSP については [第5章](../05-jsp/01-what-is-jsp.md) で説明します。

---

前: [リクエストとレスポンスをどう扱うのか](01-request-and-response.md) ｜ 次: [レスポンスはいつ送信されるのか](03-response-commit.md)
