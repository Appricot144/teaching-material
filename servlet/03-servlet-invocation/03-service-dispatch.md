# `doGet()` や `doPost()` は誰が振り分けるのか

> 疑問: `doGet` という名前のメソッドを書いただけで、なぜ `GET` のときに呼ばれるのか。
>
> 答え: `HttpServlet` から受け継いだ `service()` が、HTTP メソッドを見て `doGet` か `doPost` を呼び分けているからです。

## Tomcat が呼ぶのは `service()` だけ

Tomcat は、どの Servlet class に対しても、同じ `service()` というメソッドを呼びます。`doGet` を直接呼ぶわけではありません。

[2章4節](../02-servlet-and-tomcat/04-relationships.md) では、Tomcat が `doGet` を呼ぶイメージで説明しました。実際は、`service()` を通して `doGet` が呼ばれます。

自分で書いた `HelloServlet` を、もう一度見てみます。中身は省いています。

```java
@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 自分で書いた処理
    }
}
```

`service()` は、どこにも書いていません。`HelloServlet` は `extends HttpServlet` と書いたので、`HttpServlet` が持つ `service()` を受け継いでいます。

## `service()` がすること

`HttpServlet` の `service()` は、リクエストの HTTP メソッドを見て、呼ぶメソッドを選びます。

- `GET` なら `doGet()` を呼ぶ
- `POST` なら `doPost()` を呼ぶ

中身は、イメージとしては次のようになっています。

```java
// HttpServlet の service()（イメージ）
protected void service(HttpServletRequest req, HttpServletResponse resp) {
    String method = req.getMethod();
    if (method.equals("GET")) {
        doGet(req, resp);
    } else if (method.equals("POST")) {
        doPost(req, resp);
    }
}
```

HTTP メソッドを `if` で確かめて、対応するメソッドを呼んでいるだけです。

## 自分の `doGet` が呼ばれる理由

`service()` の中の `doGet(req, resp)` は、`HttpServlet` のコードです。それなのに、なぜ自分で書いた `doGet` が動くのでしょうか。

理由は、`HelloServlet` が `doGet` を上書き（オーバーライド）しているからです。上の `HelloServlet` の `@Override` は、上書きしていることを表す印です。2章4節で見たとおり、上書きしたメソッドを呼ぶと、オブジェクトが持っている上書きした側のメソッドが動きます。`service()` から呼ぶ `doGet` も同じです。`HelloServlet` のオブジェクトでは、自分で書いた `doGet` が動きます。

このしくみのおかげで、自分は `doGet` や `doPost` に、それぞれのときの処理を書くだけで済みます。

## 上書きしていないメソッドが呼ばれたとき

`doPost` だけを書いた Servlet class に、`GET` のリクエストが来たとします。

`doGet` は上書きしていないので、`HttpServlet` がもともと持っている `doGet` が呼ばれます。このメソッドは、`405 Method Not Allowed`（その HTTP メソッドには対応していない）を返します。

メソッドの名前を書き間違えたときも同じです。`doget` のように書くと、`doGet` の上書きにはならず、別の新しいメソッドになります。`GET` のリクエストが来ても `HttpServlet` の `doGet` が呼ばれ、`405` が返ります。

`HelloServlet` の `doGet` に `@Override` を付けているのは、この書き間違いを防ぐためです。`@Override` を付けたメソッドが何も上書きしていないと、コンパイルエラーになります。

## この振り分けは決まりの一部

`service()` が HTTP メソッドで振り分けることは、Servlet 仕様で決まっています。そのため、Tomcat 以外のサーブレットコンテナでも、`doGet` は同じように呼ばれます。

一方、Tomcat が HTTP をどう読み取るかなど、Tomcat の中の作りは仕様で決まっていません。仕様で決まっているのは、Tomcat と Servlet class がつながる部分だけです。

---

前: [リクエストから Servlet class が呼ばれるまでに何が起こるのか](02-request-flow.md) ｜ 次: [Servlet class は同時アクセスをどう処理するのか](04-instance-and-threads.md)
