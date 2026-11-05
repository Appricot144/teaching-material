# JSP で HTML を返すにはどう書くのか

> 疑問: リストの中身を全部表示したいとき、JSP で繰り返しをどう書くのか。
>
> 答え: JSTL というタグを使います。`<c:forEach>` で繰り返し、`<c:out>` でエスケープして表示します。

## 例: 果物のリストを表示する

Servlet class で果物のリストを用意し、JSP で `<ul>` のリストにします。

Servlet class:

```java
@WebServlet("/fruits")
public class FruitServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("fruits", List.of("りんご", "みかん", "ぶどう"));
        req.getRequestDispatcher("/WEB-INF/fruits.jsp").forward(req, resp);
    }
}
```

`WEB-INF/fruits.jsp`:

```jsp
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<body>
  <ul>
    <c:forEach var="fruit" items="${fruits}">
      <li><c:out value="${fruit}" /></li>
    </c:forEach>
  </ul>
</body>
</html>
```

返す HTML は、次のようになります。

```html
<ul>
  <li>りんご</li>
  <li>みかん</li>
  <li>ぶどう</li>
</ul>
```

本当は、タグがあった場所に空行や空白が少し残ります。

## JSP の各部分

- `<%@ taglib prefix="c" uri="jakarta.tags.core" %>`: JSTL のタグを、`c:` を付けて使えるようにする
- `<c:forEach items="${fruits}">`: `fruits` の中身を、1つずつ繰り返す
- `var="fruit"`: 繰り返しのたびに、今の1つを `fruit` という名前で使えるようにする
- `<c:out value="${fruit}" />`: `fruit` の値を、エスケープして表示する

`<c:forEach>` は、Java の `for (String fruit : fruits)` と同じ働きをします。

## `<c:out>` で表示する

`${fruit}` とだけ書くと、値はエスケープされません。`<c:out>` を使うと、[XSS](../04-html-response/04-xss-and-escaping.md) を防ぐエスケープをしてから表示します。

入力された値を表示するときは、必ず `<c:out>` を使います。

## JSTL をプロジェクトに入れる

JSTL は Tomcat に入っていません。そのため、自分のアプリに入れます。Maven では、次のように依存関係に追加します。

```xml
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
    <version>3.0.0</version>
</dependency>
<dependency>
    <groupId>org.glassfish.web</groupId>
    <artifactId>jakarta.servlet.jsp.jstl</artifactId>
    <version>3.0.1</version>
</dependency>
```

`jakarta.servlet-api` とは違い、`provided` は付けません。Tomcat が持っていないので、自分のアプリに入れて一緒に載せる必要があるからです。

## 補足: Java のコードを直接書く方法

JSP には、`<% %>` の中に Java のコードを直接書く方法もあります。この書き方をスクリプトレットと呼びます。

```jsp
<%@ page contentType="text/html; charset=UTF-8" import="java.util.List" %>
<!DOCTYPE html>
<html lang="ja">
<body>
  <ul>
    <% for (String fruit : (List<String>) request.getAttribute("fruits")) { %>
      <li><%= fruit %></li>
    <% } %>
  </ul>
</body>
</html>
```

`<% %>` に Java の文を書き、`<%= %>` に表示する値を書きます。

この方法は、新しく書くときには使いません。理由は次の2つです。

- `<%= %>` はエスケープしないので、XSS を防ぐには自分でエスケープする必要がある
- HTML と Java のコードが混ざって、読みにくくなる

古いアプリを読むときに出てくるので、形だけ知っておけば十分です。

---

## 参考文献

この章では、わかりやすさを優先して説明を単純にしています。正確な仕組みや、さらに詳しい内容は次の資料で学べます。

JSP と関連する仕様:

- [Jakarta Pages 4.0（JSP の仕様）](https://jakarta.ee/specifications/pages/4.0/)
- [Jakarta Expression Language 6.0（`${name}` の書き方の仕様）](https://jakarta.ee/specifications/expression-language/6.0/)
- [Jakarta Standard Tag Library 3.0（JSTL の仕様）](https://jakarta.ee/specifications/tags/3.0/)

Servlet 仕様の該当する章:

- [Jakarta Servlet 6.1 仕様: Dispatching Requests（`forward()` のしくみ）](https://jakarta.ee/specifications/servlet/6.1/jakarta-servlet-spec-6.1.html#dispatching-requests)

Tomcat のドキュメント:

- [Jasper 2 JSP Engine How To（Tomcat が JSP を Servlet class にするしくみ）](https://tomcat.apache.org/tomcat-11.0-doc/jasper-howto.html)

---

前: [Servlet class から JSP へどう処理と値を渡すのか](03-forward-and-attributes.md) ｜ 次: [ユーザの入力をどう受け取るのか](../06-input-and-redirect/01-receive-user-input.md)
