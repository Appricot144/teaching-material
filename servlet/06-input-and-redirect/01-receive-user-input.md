# ユーザの入力をどう受け取るのか

> 疑問: ユーザの入力を Servlet class でどう受け取るのか。
>
> 答え: GET でも通常のフォームの POST でも、`req.getParameter()` で読みます。POST では本文の文字コードの指定が必要です。

## GET で受け取る

値は URL のクエリ文字列で届きます。

```text
GET /hello?name=taro HTTP/1.1
```

```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String name = req.getParameter("name");
    // ...
}
```

## POST で受け取る

通常のフォームでは、値はリクエストボディで届きます。

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

```java
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    req.setCharacterEncoding("UTF-8");   // パラメータを読む前に指定する
    String name = req.getParameter("name");
    // ...
}
```

`<input>` の `name` 属性が、`getParameter()` の引数に対応します。

## GET と POST の違い

| | GET | POST |
|---|---|---|
| 実装するメソッド | `doGet()` | `doPost()` |
| 値の場所 | URL のクエリ文字列 | 主にリクエストボディ |
| 文字コードの指定 | 通常は不要 | `req.setCharacterEncoding()` が必要 |
| 主な用途 | データの取得 | データの送信、更新 |
| レスポンスの書き込み方 | `resp` に書き込む | 同じ |

## 本文の形式による読み方の違い

| `Content-Type` | 主な用途 | 読み方 |
|---|---|---|
| `application/x-www-form-urlencoded` | 通常のフォーム | `req.getParameter()` |
| `multipart/form-data` | ファイルアップロード | `req.getPart()`（Servlet class に `@MultipartConfig` が必要） |
| `application/json` など | API | `req.getReader()` で本文を読む |

`getParameter()` は JSON を解析してくれません。読んだ文字列を自分で解析するか、JSON ライブラリを使います。

## 注意点

- 文字コードは最初に指定する: パラメータを読んだ後に `setCharacterEncoding()` を呼んでも反映されません。指定しないと、日本語が文字化けする原因になります。
- 本文は基本的に1回しか読めない: `getReader()` で読んだ後は読み直せません。`getParameter()` が本文を読んだ後に `getReader()` を呼んでも、中身は残っていません。
- 入力値は信頼しない: `null` の確認に加えて、HTML に表示するときは [エスケープ](../04-html-response/04-xss-and-escaping.md) します。

---

前: [JSP で HTML を返すにはどう書くのか](../05-jsp/04-return-html-with-jsp.md) ｜ 次: [リダイレクトとは何か](02-what-is-redirect.md)
