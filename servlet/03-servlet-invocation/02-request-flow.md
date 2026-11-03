# リクエストから Servlet class が呼ばれるまでに何が起こるのか

> 疑問: Tomcat はどのような流れで Servlet class を呼び出すのか。
>
> 答え: 起動時に URL と Servlet class の対応表を作り、リクエストのたびにそれを使って呼び出します。

## ライフサイクル全体

```mermaid
flowchart TB
    A["Tomcat の起動<br/>アプリを読み込み、対応表を作る"]
    B["最初のリクエスト<br/>インスタンスを生成し、init() を呼ぶ"]
    C["リクエストごと<br/>service() を呼ぶ"]
    D["アプリの停止<br/>destroy() を呼ぶ"]
    A --> B --> C
    C --> C
    C --> D
```

`load-on-startup` を設定すると、最初のリクエストを待たず、アプリの起動時に生成と初期化を行えます。

## リクエストごとの処理

`GET /myapp/hello?name=taro` の例です。

```mermaid
flowchart TB
    S1["1. 接続を受け付ける"]
    S2["2. スレッドプールからスレッドを割り当てる"]
    S3["3. HTTP を解析し、request と response を作る"]
    S4["4. 呼び出す Servlet class を決める"]
    S5["5. フィルターを順に通す"]
    S6["6. service() を呼ぶ"]
    S7["7. HTTP メソッドに応じて doGet() などに振り分ける"]
    S8["8. アプリ処理を実行し、response に書き込む"]
    S9["9. レスポンスを送信する"]
    S1 --> S2 --> S3 --> S4 --> S5 --> S6 --> S7 --> S8 --> S9
```

## 呼び出し先の決定

URL を2段階で照合します。

```text
/myapp/hello
  │     └─ Servlet class を選ぶ: /hello → HelloServlet
  └─ アプリを選ぶ: /myapp → myapp.war
```

対応する Servlet class がなければ、Tomcat が 404 を返します。この場合、自分のコードは呼ばれません。

## フィルター

フィルターは、Servlet class の前後に認証やログなどの共通処理を挟む仕組みです。フィルターが処理を止めると、Servlet class は呼ばれません。

## Servlet class から見た流れ

Servlet class は自分で接続を待ったりスレッドを作ったりしません。生成から呼び出し、破棄まで Tomcat が管理するので、呼ばれたときの処理だけを書きます。

---

前: [URL と Servlet class をどう対応付けるのか](01-url-mapping.md) ｜ 次: [`doGet()` や `doPost()` は誰が振り分けるのか](03-service-dispatch.md)
