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

- `<%@ taglib prefix="c" uri="jakarta.tags.core" %>`: `c:`という接頭辞の着いたタグをJSTL のタグとして認識するようにする
- `<c:forEach items="${fruits}">`: `fruits` の中身を、1つずつとりだす
- `var="fruit"`: 繰り返しのたびに、今の1つを `fruit` という名前で使えるようにする
- `<c:out value="${fruit}" />`: `fruit` の値を、エスケープして表示する

`<c:forEach>` は、Java の `for (String fruit : fruits)` と同じ働きをします。

`${fruit}` とだけ書くと、値はエスケープされません。`<c:out>` を使うと、[4章4節](../04-html-response/04-xss-and-escaping.md) で見た XSS を防ぐエスケープをしてから表示します。入力された値を表示するときは、必ず `<c:out>` を使います。

## `<c:forEach>` の中身は、繰り返すたびに出力される

`<c:forEach>` と `</c:forEach>` の間に書いた中身は、繰り返しのたびに1回ずつ出力され、`resp` に順に書き足されていきます。`<c:forEach>` のタグそのものは、出力されません。

`fruits` が `りんご`、`みかん`、`ぶどう` のときは、次のように動きます。

1. `fruit` に `りんご` を入れて、中身を出力する。`<li>りんご</li>` が書かれる
2. `fruit` に `みかん` を入れて、もう一度中身を出力する。`<li>みかん</li>` が書き足される
3. `fruit` に `ぶどう` を入れて、もう一度中身を出力する。`<li>ぶどう</li>` が書き足される

[2節](02-jsp-to-servlet-class.md) で見た書き換えのイメージでいうと、中身を書く `out.write` が、Java の `for` の中に入る形です。

```java
for (String fruit : fruits) {
    out.write("<li>");
    out.write(/* エスケープした fruit */);
    out.write("</li>");
}
```

内側に書いたものは、何であっても繰り返されます。たとえば `<ul>` まで内側に書くと、`<ul>` も3回出力され、項目が1つずつのリストが3つできてしまいます。

```html
<ul><li>りんご</li></ul>
<ul><li>みかん</li></ul>
<ul><li>ぶどう</li></ul>
```

例の後に書いた「空行や空白が少し残る」のも、この仕組みのためです。中身に含まれる改行や字下げの空白も、繰り返しのたびに出力されます。

## JSTL とは

例で使った `<c:forEach>` や `<c:out>` は、JSTL（Jakarta Standard Tag Library）というタグの集まりの一部です。JSP でよく使う処理を、HTML のタグと同じ形で書けるようにしたものです。

- `<c:forEach>`: 繰り返す
- `<c:if>`: 条件に合うときだけ表示する
- `<c:out>`: エスケープして表示する

JSP の中に Java の `for` や `if` を書く代わりに、これらのタグを使います。そうすると、JSP の中身を HTML の形のまま保てます。

JSTL は、JSP とは別の仕様として決まっていて、Tomcat には入っていません。そのため、自分のアプリに入れます。[2章2節](../02-servlet-and-tomcat/02-what-is-servlet.md) で Servlet API を入れたときと同じように、Maven の依存関係に追加します。

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

1つ目は JSTL の API（取り決めを Java の型にしたもの）、2つ目はその実装です。[2章4節](../02-servlet-and-tomcat/04-relationships.md) で見た、Servlet API と Tomcat の関係と同じです。

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

前: [Servlet class から JSP へどう処理と値を渡すのか](03-forward-and-attributes.md) ｜ 次: [6章 ユーザの入力とリダイレクト](../06-input-and-redirect/README.md)
