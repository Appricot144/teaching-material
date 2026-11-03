# URL と Servlet class をどう対応付けるのか

> 疑問: Tomcat は、どの URL でどの Servlet class を呼ぶのかをどう知るのか。
>
> 答え: `@WebServlet` アノテーションか `web.xml` に書いた対応を、起動時に読み取ります。新しく書くなら、Servlet class のそばで対応がわかる `@WebServlet` を基本にするとよいです。

## 方法1: `@WebServlet`

```java
@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    // ...
}
```

複数の URL を対応させることもできます。

```java
@WebServlet({"/hello", "/hi"})
```

## 方法2: `web.xml`

`WEB-INF/web.xml` に、名前を介して Servlet class と URL を対応させます。Servlet class のコードを変えずに対応を変更でき、対応を1か所で一覧できます。

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

## URL パターン

複数のパターンが一致したときは、次の表の上から順に優先されます。

| 種類 | 例 | 一致する URL |
|---|---|---|
| 完全一致 | `/hello` | `/hello` のみ |
| パス一致 | `/users/*` | `/users`、`/users/1`、`/users/1/edit` など |
| 拡張子一致 | `*.do` | `/a.do`、`/b/c.do` など |
| デフォルト | `/` | 他のどれにも一致しなかった URL |

パス一致で残りの部分を知りたいときは `req.getPathInfo()` を使います。`/users/1` なら `/1` が返ります。

## 注意点

- パターンにコンテキストパスは含めない: `myapp.war` の場合、`@WebServlet("/hello")` の URL は `/myapp/hello` になります。
- HTTP メソッドは指定できない: GET と POST の違いは、`doGet()` と `doPost()` を書き分けて対応します。
- パス変数の記法はない: `/users/{id}` とは書けないので、`/users/*` で受けて `getPathInfo()` の値を解析します。
- 同じパターンを重複させない: 別々の Servlet class に同じパターンを指定すると、アプリの起動時にエラーになります。

---

前: [仕様、API、Servlet class、Tomcat はどう関係するのか](../02-servlet-and-tomcat/04-relationships.md) ｜ 次: [リクエストから Servlet class が呼ばれるまでに何が起こるのか](02-request-flow.md)
