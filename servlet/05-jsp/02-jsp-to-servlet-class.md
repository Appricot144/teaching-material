# JSP はどうやって Servlet class になるのか

> 疑問: JSP は HTML に近いファイルなのに、なぜ Tomcat で動くのか。
>
> 答え: Tomcat が JSP を Servlet class の Java コードに書き換え、コンパイルして動かすからです。

## JSP から Servlet class を作る

Tomcat は、JSP がはじめて使われたとき（ブラウザから直接リクエストされたとき、または Servlet class から表示を任されたとき）に、次の3つのことをします。

1. JSP を、Java のコードに書き換える
2. そのコードをコンパイルして、クラスを作る
3. できたクラスを呼び出す

この3つを行うのは、[1節](01-what-is-jsp.md) のコラムで見た `JspServlet` です。

JSP を書き直したときは、Tomcat がもう一度書き換えてコンパイルします。

## 書き換えたコードのイメージ

次の JSP があるとします。

```jsp
<h1>こんにちは、${name}</h1>
```

Tomcat は、これをおおよそ次のようなコードに書き換えます。本物のコードはもっと複雑ですが、考え方は同じです。

```java
out.write("<h1>こんにちは、");
out.write(/* name の値 */);
out.write("</h1>");
```

`out.write` は、`resp.getWriter().println` と同じように、リクエストボディに書き込むメソッドです。

つまり JSP は、[4章2節](../04-html-response/02-return-html.md) で自分で書いていた「HTML をリクエストボディに書き込む処理」を、Tomcat が代わりに作ってくれるしくみです。

## Servlet class と同じところ

JSP から作られたクラスも Servlet class なので、次の点は自分で書く Servlet class と同じです。

- Tomcat がオブジェクトを作り、リクエストのたびに呼び出す
- 1つのオブジェクトを、たくさんのスレッドが同時に使う（[3章4節](../03-servlet-invocation/04-instance-and-threads.md)）

## 自分で書く Servlet class と違うところ

- クラスを書くのはTomcat
- パスとの対応は `@WebServlet` で書かない。`*.jsp` のパスは `JspServlet` が受け持ち、JSP から作ったクラスを呼ぶ

Tomcat が作った Java のコードは、Tomcat の `work/` フォルダの中（たとえば `work/Catalina/localhost/myapp/org/apache/jsp/hello_jsp.java`）で見られます。

---

前: [JSP とは何か](01-what-is-jsp.md) ｜ 次: [Servlet class から JSP へどう処理と値を渡すのか](03-forward-and-attributes.md)
