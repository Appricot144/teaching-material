# JSP で HTML を返すにはどう書くのか

> 疑問: JSP で動的な HTML を作るにはどう書くのか。
>
> 答え: Servlet class で値を用意し、JSP では JSTL のタグで繰り返しや出力を書きます。

## 例: リストの表示

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

| 記述 | 意味 |
|---|---|
| `<%@ taglib ... %>` | JSTL のタグを `c:` という接頭辞で使えるようにする |
| `items="${fruits}"` | `setAttribute()` で渡したリストを繰り返しの対象にする |
| `var="fruit"` | 各要素を入れる変数の名前を決める |
| `<c:out>` | 値を HTML エスケープして出力する |

出力される HTML は次の通りです（実際には、タグがあった位置に空行や空白が少し残ります）。

```html
<ul>
  <li>りんご</li>
  <li>みかん</li>
  <li>ぶどう</li>
</ul>
```

## JSTL の追加

JSTL は Tomcat に同梱されていないので、依存関係に追加します。

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

`jakarta.servlet-api` と違って、WAR に含める必要があるので `provided` にはしません。

## JSTL を使わない場合

スクリプトレットで Java コードを直接書けば、Tomcat と Servlet API だけで動きます。

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

`<% %>` に Java の文を書き、`<%= %>` に出力する式を書きます。ただし、`<%= %>` もエスケープしないので、ユーザの入力を表示するときは自分でエスケープする必要があります。処理と表示も混ざりやすいので、新しく書くなら JSTL を使います。

---

前: [Servlet class から JSP へどう処理と値を渡すのか](03-forward-and-attributes.md) ｜ 次: [ユーザの入力をどう受け取るのか](../06-input-and-redirect/01-receive-user-input.md)
