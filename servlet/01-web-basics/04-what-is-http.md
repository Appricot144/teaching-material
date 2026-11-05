# HTTP とは何か

> 疑問: ブラウザと Web サーバは、どんな書き方で頼みと返事をやり取りしているのか。
>
> 答え: HTTP という決まりに沿った書き方です。リクエストもレスポンスも、決まった順番で並べた文字です。

## 決まりが必要な理由

ブラウザにはたくさんの種類があり、Web サーバにもたくさんの種類があります。どの組み合わせでも話が通じるには、頼み方と返事の仕方を全員でそろえる必要があります。このそろえた決まりが HTTP です。

## リクエストの中身

`https://example.com/myapp/hello?name=taro` を開くと、ブラウザは次のような文字を Web サーバに送ります。

```http
GET /myapp/hello?name=taro HTTP/1.1
Host: example.com
User-Agent: Mozilla/5.0
```

リクエストは、上から次の順に並んでいます。

1. リクエスト行: 何をしてほしいか。ここでは「`/myapp/hello?name=taro` をください」
2. ヘッダー: 頼みに添える情報。ここでは頼む先のホストと、ブラウザの種類
3. 空行: ヘッダーの終わりの印
4. ボディ: Web サーバに渡したいデータ。ページをもらうだけのときは空

リクエスト行の最初の `GET` は、頼みの種類を表します。この種類を HTTP メソッドと呼びます。

## レスポンスの中身

Web サーバは、次のような文字を返します。

```http
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html>
<html>...</html>
```

レスポンスも、上から次の順に並んでいます。

1. ステータス行: 頼みがうまくいったかどうか。`200 OK` はうまくいったことを表す
2. ヘッダー: 返事に添える情報。`Content-Type` は、ボディが HTML であることを表す
3. 空行: ヘッダーの終わりの印
4. ボディ: 返す中身。ここでは HTML

ブラウザは `Content-Type` を見て、ボディを HTML として画面に表示します。

## よく使う HTTP メソッド

HTTP メソッドのうち、この教材で使うのは次の2つです。

- `GET`: ページをもらう。URL を開いたり、リンクをクリックしたりしたときに使う
- `POST`: Web サーバにデータを送る。フォームに入力して送信するときに使う

## ステータスコード

ステータス行の数字をステータスコードと呼びます。最初の1桁で、結果の大まかな種類がわかります。

| 最初の桁 | 意味 | 例 |
|---|---|---|
| 2 | うまくいった | `200 OK` |
| 3 | 別の URL を見てほしい | `302 Found` |
| 4 | 頼み方に問題がある | `404 Not Found`（ページがない） |
| 5 | Web サーバの中で問題が起きた | `500 Internal Server Error` |

## HTTP は前の頼みを覚えていない

HTTP では、1つのリクエストと1つのレスポンスで、やり取りが完結します。Web サーバは、同じブラウザから前にどんなリクエストが来たかを覚えていません。

そのため、ログインしたことを次のページでも覚えておくには、別の仕組みを組み合わせます。この仕組みは後の章で扱います。

---

## 参考文献

この章では、わかりやすさを優先して説明を単純にしています。正確な仕組みや、さらに詳しい内容は次の資料で学べます。

Web の仕組みを入門者向けに説明した資料:

- [Web サーバーとは何か？（MDN）](https://developer.mozilla.org/ja/docs/Learn_web_development/Howto/Web_mechanics/What_is_a_web_server)
- [URL とは何か？（MDN）](https://developer.mozilla.org/ja/docs/Learn_web_development/Howto/Web_mechanics/What_is_a_URL)
- [HTTP の概要（MDN）](https://developer.mozilla.org/ja/docs/Web/HTTP/Guides/Overview)
- [ハイパーテキスト（MDN 用語集）](https://developer.mozilla.org/ja/docs/Glossary/Hypertext)

HTTP と URI の正式な仕様:

- [RFC 9110: HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110)
- [RFC 3986: Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986)

書籍:

- 山本陽平『Web を支える技術』技術評論社、2010年。URL や HTTP が、なぜ今の形になっているかを説明している

---

前: [URL とは何か](03-what-is-url.md) ｜ 次: [ハイパーテキストとは何か](appendix-a-hypertext.md)
