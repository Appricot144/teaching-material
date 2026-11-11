# 処理した結果をどう返すのか

> 疑問: 果物を追加したあと、ユーザに何を返せばよいのか。
>
> 答え: 追加したあとの一覧を返します。値を `HttpServletRequest` に入れて JSP に表示を任せる。

[2節](02-process-input.md) で、果物をリストに追加するところまで作りました。このページでは、次の2つのときに返すページを作ります。

- 一覧を見るとき（`GET /myapp/fruits`）
- 果物を追加したとき（`POST /myapp/fruits`）

どちらも、果物の一覧とリストに要素を追加するためのフォームが並んだページを返します。

## 一覧を見るとき

`doGet` では、リストを `req` に入れて、JSP に表示を任せます。[5章3節](../05-jsp/03-forward-and-attributes.md) で見た `forward()` です。

```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    req.setAttribute("fruits", fruits);
    req.getRequestDispatcher("/WEB-INF/fruits.jsp").forward(req, resp);
}
```

`WEB-INF/fruits.jsp` は、[5章4節](../05-jsp/04-return-html-with-jsp.md) の一覧に、[1節](01-receive-user-input.md) の追加のフォームを加えたものです。

```jsp
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<body>
  <form method="post" action="/myapp/fruits">
    <input type="text" name="fruit">
    <button type="submit">追加</button>
  </form>

  <ul>
    <c:forEach var="fruit" items="${fruits}">
      <li><c:out value="${fruit}" /></li>
    </c:forEach>
  </ul>
</body>
</html>
```

## 追加したとき

追加したあとも、同じ一覧のページを返せば、ユーザは追加された果物を確かめられます。素直に書くと、`doPost` の最後で、`doGet` と同じように JSP に表示を任せます。

2節で作った部分と合わせると、`FruitServlet` の全体は次のようになります。

```java
@WebServlet("/fruits")
public class FruitServlet extends HttpServlet {
    // 全部のリクエストで共有するので、同時に使っても壊れないリストを使う
    private final List<String> fruits = new CopyOnWriteArrayList<>();

    // 一覧を見るとき
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("fruits", fruits);
        req.getRequestDispatcher("/WEB-INF/fruits.jsp").forward(req, resp);
    }

    // 果物を追加したとき
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String fruit = req.getParameter("fruit");
        if (fruit != null && !fruit.isBlank()) {
            fruits.add(fruit.strip());
        }

        req.setAttribute("fruits", fruits);
        req.getRequestDispatcher("/WEB-INF/fruits.jsp").forward(req, resp);
    }
}
```

名前が入っていないときは、`if` の中を通らないので、何も追加せずに一覧を返します。2節で決めたとおりです。

これで、入力を受け取り、処理して、結果を返す1往復ができました。

## 再読み込みすると、もう一度追加される

この書き方には、1つ問題があります。

果物を追加したあと、一覧を新しくしようとして、ブラウザで再読み込みをしたとします。今のページは、`POST` の返事として返ってきたページです。そのため、ブラウザは同じ `POST` をもう一度送ります。すると、同じ果物がもう一度追加されてしまいます。

ブラウザで「フォームを再送信しますか」という確認が出たのを、見たことがあるかもしれません。これは、この `POST` の送り直しについての確認です。

次のページでは、これを防ぐための道具としてリダイレクトを見ます。そのあと、[5節](05-prg-pattern.md) で、リダイレクトを使ってこの問題を防ぐ方法を説明します。

---

前: [受け取った値をどう処理するのか](02-process-input.md) ｜ 次: [リダイレクトとは何か](04-what-is-redirect.md)
