# URL と Servlet class をどう対応付けるのか

> 疑問: `/hello` のリクエストが来たとき、Tomcat はどの Servlet class を呼べばよいかを、どうやって知るのか。
>
> 答え: Servlet class に付けた `@WebServlet("/hello")` を読んで知ります。`web.xml` というファイルに書く方法もあります。

## 方法1: `@WebServlet` を付ける

Servlet class の上に `@WebServlet` を付け、受け持つパスを書きます。

```java
@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    // ...
}
```

Tomcat は、アプリを読み込むときに `@WebServlet` を探し、「`/hello` なら `HelloServlet`」という対応表を作ります。

1つの Servlet class に、複数のパスを受け持たせることもできます。

```java
@WebServlet({"/hello", "/hi"})
```

この方法では、クラスを見ればどのパスを受け持つかがすぐにわかります。新しく書くときは、この方法を使うとよいでしょう。

## 方法2: `web.xml` に書く

WAR ファイルの中の `WEB-INF/` フォルダに置く `web.xml` というファイルに、対応を書く方法もあります。

```xml
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee" version="6.1">
    <servlet>
        <servlet-name>hello</servlet-name>
        <servlet-class>com.example.HelloServlet</servlet-class>
    </servlet>

    <servlet-mapping>
        <servlet-name>hello</servlet-name>
        <url-pattern>/hello</url-pattern>
    </servlet-mapping>
</web-app>
```

`<servlet>` で Servlet class に `hello` という名前を付け、`<servlet-mapping>` でその名前とパスを結び付けます。

この方法では、すべての対応を1つのファイルで見渡せます。`@WebServlet` が使えるようになる前は、この方法しかなかったため、古いアプリでよく使われています。

## パスの書き方

受け持つパスには、`/hello` のようにぴったりのパスだけでなく、決まった形のパスをまとめて書くこともできます。

| 書き方 | 例 | 受け持つパス |
|---|---|---|
| ぴったり | `/hello` | `/hello` だけ |
| 前の部分が同じ | `/users/*` | `/users`、`/users/1`、`/users/1/edit` など |
| 拡張子が同じ | `*.do` | `/a.do`、`/b/c.do` など |
| どれにも当てはまらない | `/` | 他のどの書き方にも当てはまらないパス |

1つのパスが複数の書き方に当てはまるときは、表の上にある書き方が選ばれます。

`/users/*` で受けたとき、`*` の部分は `req.getPathInfo()` で取り出せます。`/users/1` なら `/1` が返ります。

## 気をつけること

- パスに、[コンテキストパス](../02-servlet-and-tomcat/03-what-is-tomcat.md) は書かない。`myapp.war` の `@WebServlet("/hello")` は、URL では `/myapp/hello` になる
- パスの対応付けでは、`GET` か `POST` かを区別しない。区別は `doGet` と `doPost` を書き分けて行う（[3節](03-service-dispatch.md) で説明する）
- 同じパスを、2つの Servlet class に受け持たせない。アプリを読み込むときにエラーになる

---

前: [3章 Servlet class の呼び出し](README.md) ｜ 次: [リクエストから Servlet class が呼ばれるまでに何が起こるのか](02-request-flow.md)
