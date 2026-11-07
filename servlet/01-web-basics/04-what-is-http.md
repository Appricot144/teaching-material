# HTTP とは何か

> 疑問: ブラウザと Web サーバは、どんな書き方で頼みと返事をやり取りしているのか。
>
> 答え: HTTP という決まりに沿った書き方です。リクエストもレスポンスも、決まった順番で並べた文字です。

## 決まりが必要な理由

ブラウザにはたくさんの種類があり、Web サーバにもたくさんの種類があります。どの組み合わせでも話が通じるには、頼み方と返事の仕方を全員でそろえる必要があります。このそろえた決まりが HTTP です。

## リクエストの中身

`http://example.com/myapp/hello?name=taro` を開くと、ブラウザは次のような文字を Web サーバに送ります。

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

3節で見たパスとクエリは、リクエスト行に入っています。ホストは `Host` ヘッダーに入っています。

リクエスト行の最初の `GET` は、頼みの種類を表します。この種類を HTTP メソッドと呼びます。
このリクエストではボディにデータがないため、ヘッダを区切る空行でリクエストが終わっています。

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
2. ヘッダー: 返事に添える情報。`Content-Type` は、ボディのデータが HTML であることを表す
3. 空行: ヘッダーの終わりの印
4. ボディ: 返す中身。ここでは HTML

ブラウザは `Content-Type` を見て、ボディ部分に格納されたデータを HTML として画面に表示します。

## よく使う HTTP メソッド

HTTP メソッドにはいくつかの種類があります。この教材で使うのは次の2つです。

- `GET`: ページをもらう。URL を開いたり、リンクをクリックしたりしたときに使う
- `POST`: Web サーバにデータを渡して、処理を頼む。フォームに入力して送信するときに使う

いちばんなじみがあるのは GET でしょう。リンクをクリックしてページを開くと、ブラウザは GET のリクエストを Web サーバに送ります。画面に表示されているのは、レスポンスとして返ってきた HTML です。

POST で渡したデータをどう使うかは、Web サーバが決めます。たとえばログインフォームでは、入力したユーザ ID とパスワードを POST で送り、Web サーバはそれが正しいかを確かめます。掲示板の書き込みフォームでは、Web サーバは書き込みを新しく保存します。

## ステータスコード

ブラウザでサイトを見たとき、「404 Not Found」と書かれたページが出たことはないだろうか。この `404` は、Web サーバがレスポンスのステータス行で返した数字です。

ステータス行の数字をステータスコードと呼びます。最初の1桁で、結果の大まかな種類がわかります。

| 最初の桁 | 意味 | 例 |
|---|---|---|
| 2 | うまくいった | `200 OK` |
| 3 | 別の URL を見てほしい | `302 Found` |
| 4 | 頼み方に問題がある | `404 Not Found`（ページがない） |
| 5 | Web サーバの中で問題が起きた | `500 Internal Server Error` |

Servlet を書きはじめると、URL を間違えたときの `404` や、プログラムでエラーが起きたときの `500` によく出会います。`302` は、6章のリダイレクトで使います。

## HTTP は前のリクエストを覚えていない

HTTP では、1つのリクエストと1つのレスポンスで、やり取りが完結します。Web サーバは、同じブラウザから前にどんなリクエストが来たかを覚えていません。

そのため、ログインしたことを次のページでも覚えておくには、別の仕組みを組み合わせます。この仕組みは、この教材では扱いません。

> コラム: GET と POST とほかのメソッド
>
> HTTP メソッドには、ほかに `PUT` や `DELETE` もあります。
>
> - `PUT`: 「この URL の場所に、このデータを置いてほしい」と頼む。すでに何かあれば置き換わる。同じ PUT を何度送っても、置かれているのは最後に送ったデータ1つだけ
> - `DELETE`: 「この URL の場所にあるものを消してほしい」と頼む
>
> POST は「このデータで何かしてほしい」と頼むだけなので、同じ POST を何度送ると、Web サーバはそのたびに処理をします。掲示板なら、同じ書き込みがいくつもできます。
>
> HTML のフォームから送れるのは GET と POST だけです。PUT や DELETE は、ブラウザ以外のプログラムが Web サーバとやり取りするときによく使います。

> コラム: "状態"を記録する仕組み
>
> HTTP は前のリクエストを覚えていません。それでも、ログインしたあとに別のページを開くと、ログインしたままになっています。これは、次の2つを組み合わせているからです。
>
> - Cookie: Web サーバがレスポンスに付けて、ブラウザに預ける小さな文字列。ブラウザは、それ以降のリクエストに毎回これを付けて送る
> - セッション: Web サーバが、ブラウザごとに覚えておきたいことをしまっておく場所。どのブラウザの分かを見分ける番号を、Cookie に入れて預ける
>
> ログインすると、Web サーバはセッションに「この人はログインした」と書き、その番号を Cookie でブラウザに預けます。次のリクエストで Cookie が届くと、Web サーバは番号からセッションを探し、ログインしたことを思い出せます。

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

前の頼みを覚えておく仕組み（Cookie とセッション）:

- [HTTP Cookie の使用（MDN）](https://developer.mozilla.org/ja/docs/Web/HTTP/Guides/Cookies)
- [セッション (コンピュータ)（Wikipedia）](https://ja.wikipedia.org/wiki/セッション_(コンピュータ))
- [Jakarta Servlet 6.1 仕様: Sessions](https://jakarta.ee/specifications/servlet/6.1/jakarta-servlet-spec-6.1.html#sessions)。Servlet でセッションを使う方法

書籍:

- 山本陽平『Web を支える技術』技術評論社、2010年。URL や HTTP が、なぜ今の形になっているかを説明している

---

前: [URL とは何か](03-what-is-url.md) ｜ 次: [ハイパーテキストとは何か](appendix-a-hypertext.md)
