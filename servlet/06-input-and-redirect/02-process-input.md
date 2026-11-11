# 受け取った値をどう処理するのか

> 疑問: フォームから受け取った値は、そのまま使ってよいのか。
>
> 答え: そのままでは使えないことがあります。値が入っているかを確かめ、使える形に整えてから処理します。

[1節](01-receive-user-input.md) で受け取った果物の名前を、果物のリストに追加します。このページでは、`doPost` の中で、受け取った値を処理するところまでを作ります。

## 受け取る値は、文字列か `null`

`getParameter()` が返すのは、いつも文字列か `null` です。

- フォームに `りんご` と入力して送ると、`"りんご"`
- 何も入力せずに送ると、空の文字 `""`
- フォームを通さずにリクエストが送られて、`fruit` という名前の値がないと、`null`

ユーザは、思った通りに入力してくれるとは限りません。空のまま送信ボタンを押すこともあります。そのため、受け取った値は、使う前に確かめます。

## 値を確かめる

果物の名前が入っていないときは、何も追加せずに、そのまま一覧を返すことにします。ユーザに「名前を入力してください」と知らせる方法もありますが、この章では扱いません。

名前が入っているかは、次の条件で確かめます。

```java
String fruit = req.getParameter("fruit");
if (fruit != null && !fruit.isBlank()) {
    // 名前が入っているときだけ、ここで追加する
}
```

`isBlank()` は、空の文字や、空白だけの文字のときに `true` を返します。ただし、`null` に対して呼ぶと例外になります。そのため、先に `null` でないかを確かめます。`&&` は、左が `false` なら右を調べないので、`null` のときに `isBlank()` は呼ばれません。

## 使える形に整える

入力された値の前後に、空白が付いていることがあります。`strip()` で取り除いてから使います。

```java
fruits.add(fruit.strip());   // " りんご " なら "りんご" を追加する
```

## リストに追加する

果物のリストは、`FruitServlet` のフィールドに持たせます。全員が同じリストに追加し、同じリストを見るためです。

フィールドは、[3章4節](../03-servlet-invocation/04-instance-and-threads.md) で見たとおり、全部のスレッドで共有されます。そのため、同時に使っても壊れないように作られた `CopyOnWriteArrayList` を使います。

```java
@WebServlet("/fruits")
public class FruitServlet extends HttpServlet {
    // 全部のリクエストで共有するので、同時に使っても壊れないリストを使う
    private final List<String> fruits = new CopyOnWriteArrayList<>();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");

        String fruit = req.getParameter("fruit");
        if (fruit != null && !fruit.isBlank()) {
            fruits.add(fruit.strip());
        }

        // 結果の返し方は、次のページで考える
    }
}
```

処理は `doPost` に書き、表示は書きません。[5章1節](../05-jsp/01-what-is-jsp.md) で見たとおり、Servlet class は処理を受け持ち、表示は JSP に任せます。

これで、受け取った値でリストを変えるところまでできました。次のページでは、追加したあとに、ユーザに何を返すかを考えます。

> コラム: データをどこに置くか
>
> この例では、果物のリストを `FruitServlet` のフィールドに置いています。そのため、次の限界があります。
>
> - 全員が同じ1つのリストを使う
> - Tomcat を止めると、リストは消える
>
> 本物のアプリでは、データベースなどに保存します。データベースに保存すれば、Tomcat を止めてもデータは残り、ユーザごとにデータを分けることもできます。

---

前: [ユーザの入力をどう受け取るのか](01-receive-user-input.md) ｜ 次: [処理した結果をどう返すのか](03-return-result.md)
