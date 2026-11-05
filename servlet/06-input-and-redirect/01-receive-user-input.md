# ユーザの入力をどう受け取るのか

> 疑問: フォームに入力された値を、Servlet class でどうやって受け取るのか。
>
> 答え: `GET` でも `POST` でも、`req.getParameter()` で読みます。`POST` で日本語を受け取るときは、読む前に文字コードを指定します。

## フォームと `name` 属性

HTML のフォームは、入力された値をリクエストに入れて送ります。

```html
<form method="get" action="/myapp/hello">
  <input type="text" name="name">
  <button type="submit">送信</button>
</form>
```

`<input>` の `name` 属性が、値の名前になります。Servlet class では、この名前を `getParameter()` に渡して値を読みます。

```java
String name = req.getParameter("name");
```

## `GET` で送ると

`method="get"` のフォームに `taro` と入力して送ると、値は URL のクエリに入ります。

```text
GET /myapp/hello?name=taro HTTP/1.1
```

Servlet class では、`doGet` で受け取ります。

```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String name = req.getParameter("name");
    // ...
}
```

## `POST` で送ると

`method="post"` にすると、値は URL ではなく、リクエストのボディに入ります。

```html
<form method="post" action="/myapp/hello">
  <input type="text" name="name">
  <button type="submit">送信</button>
</form>
```

```text
POST /myapp/hello HTTP/1.1
Content-Type: application/x-www-form-urlencoded

name=taro
```

Servlet class では、`doPost` で受け取ります。読み方は `GET` と同じ `getParameter()` です。

```java
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    req.setCharacterEncoding("UTF-8");   // 値を読む前に書く
    String name = req.getParameter("name");
    // ...
}
```

## `POST` では文字コードを指定する

`POST` のボディに入った日本語を正しく読むには、`req.setCharacterEncoding("UTF-8")` で文字コードを指定します。指定しないと、日本語が読めない文字に化けることがあります。

この指定は、`getParameter()` で値を読む前に書きます。読んだあとに指定しても効きません。

## `GET` と `POST` の使い分け

- `GET`: 値を使って、ページを見るだけのとき。検索など
- `POST`: 値を使って、何かを変えるとき。登録や追加など

`GET` の値は URL に入るので、アドレス欄や履歴に残ります。パスワードのように見られたくない値は、`POST` で送ります。

## ボディの種類と読み方

`POST` のボディには、フォーム以外の形のデータが入ることもあります。形によって、読み方が変わります。

- ふつうのフォーム: `req.getParameter()` で読む
- ファイルを送るフォーム: `req.getPart()` で読む。Servlet class に `@MultipartConfig` を付ける
- JSON などのデータ: `req.getReader()` でボディの文字をそのまま読み、自分で読み取る

この教材では、ふつうのフォームだけを使います。

## 気をつけること

- `getParameter()` は、値がないと `null` を返す。使う前に確かめる
- 入力された値を HTML に表示するときは、[エスケープ](../04-html-response/04-xss-and-escaping.md) する
- ボディは、基本的に1回しか読めない。`getReader()` で読んだあとに `getParameter()` を呼んでも、値は取れない

---

前: [JSP で HTML を返すにはどう書くのか](../05-jsp/04-return-html-with-jsp.md) ｜ 次: [リダイレクトとは何か](02-what-is-redirect.md)
