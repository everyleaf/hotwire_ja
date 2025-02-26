---
title: "Turbo ドライブを使ったナビゲート"
description: "Turbo ドライブは、ページ全体の再読み込みの必要を無くすことで、リンクとフォームの送信を高速化します。"
order: 2
commit: "8849e6b"
---

# Turbo ドライブを使ったナビゲート

Turbo ドライブは、ページ単位のナビゲーションを強化する、Turbo の一部機能です。
リンクのクリックとフォームの送信を監視し、それらをバックグラウンドで実行し、全リロードを行わずにページを更新します。以前 [Turbolinks](https://github.com/turbolinks/turbolinks) という名前で知られていたライブラリの進化版です。

${toc}

## ページ・ナビゲーションの基本

Turbo ドライブは、ページ・ナビゲーションを、ある*アクション*をともなった、ある*ロケーション* (URL)へのアクセスという形で表現します。

アクセスは、ページの描画のために、クリックから始まるすべてのナビゲーション・ライフサイクルを要求します。そのサイクルには、ブラウザ履歴の更新や、ネットワーク・リクエストの発行、キャッシュからのページのコピーの再構築、最終的なレスポンスの描画、スクロール位置の更新も含まれます。

アクセスには二つの種類があります。_アプリケーション・アクセス_、_advance_ あるいは _replace_ のアクションを伴うものと、_リストア・アクセス_、_restore_ のアクションを伴うものです。

## アプリケーション・アクセス

アプリケーション・アクセスは、Turbo ドライブが使えるリンクのクリック、あるいはプログラムによる[`Turbo.visit(location)`](https://turbo.hotwired.dev/reference/drive#turbodrivevisit) の呼び出しです。
アプリケーション・アクセスは常にネットワーク・リクエストを発行します。レスポンスが戻ってくると、Turbo ドライブはその HTML を描画し、アクセスを完了します。

可能であれば、Turbo ドライブはアクセスがはじまった直後に、キャッシュからプレビューを描画します。これによって、同じページ間の頻繁なナビゲーションの体感スピードは改善します。


もしアクセス先のロケーションがアンカーを含んでいる場合、Turbo ドライブはアンカー先の要素へスクロールします。含まれていなければ、そのページのトップへとスクロールします。

アプリケーション・アクセスはブラウザ履歴に残ります。アクセスに伴う _アクション_ によって、どのように残るかは異なります。

![advance アクセス・アクション](https://s3.amazonaws.com/turbolinks-docs/images/advance.svg)

デフォルトのアクセスのアクションは _advance_ です。advance アクセスの間、Turbo ドライブは[`history.pushState`](https://developer.mozilla.org/ja/docs/Web/API/History/pushState)を用いてブラウザ履歴に項目を積みます。

 Turbo ドライブ [iOS adapter](https://github.com/hotwired/turbo-ios)を用いるアプリケーションは、普通はナビゲーション・スタックに新しい view コントローラーを積むことで Advance アクセスを扱います。同様に、[Android adapter](https://github.com/hotwired/turbo-android)  を用いたアプリケーションは、新しいアクティビティをバックスタックに積みます。

![replace アクセス・アクション](https://s3.amazonaws.com/turbolinks-docs/images/replace.svg)


ブラウザ履歴に新しい履歴項目を積まずにロケーションにアクセスをしたいことがあるかもしれません。[`history.replaceState`](https://developer.mozilla.org/ja/docs/Web/API/History/replaceState) を用いた _replace_ アクセス・アクションは一番上の履歴項目を破棄し、新しいロケーションにそれを取り替えます。

次のリンクが replace アクセスを発火させるよう指定するために、該当リンクに `data-turbo-action="replace"` をアノテーションします。


```html
<a href="/edit" data-turbo-action="replace">編集</a>
```

プログラム的に replace アクションとともにロケーションにアクセスするには、`Turbo.visit`に`action: "replace"` オプションを渡します。

```js
Turbo.visit("/edit", { action: "replace" })
```

 Turbo ドライブ [iOS adapter](https://github.com/hotwired/turbo-ios)を用いるアプリケーションは一般に、最上位の view コントローラーを閉じ、新しい view コントローラーをナビゲーション・スタック上にアニメーションなしでpushすることで更新を扱います。

## リストア・アクセス


 Turbo ドライブは、ブラウザバックやブラウザで前に進むボタンでの移動があった場合に、自動的にリストア・アクセスを開始します。[iOS](https://github.com/hotwired/turbo-ios) あるいは [Android](https://github.com/hotwired/turbo-android) アダプタを使うアプリケーションは、ナビゲーション・スタック内で後ろに戻る動きがあった場合に、リストア・アクセスを開始します。

![Restore visit action](https://s3.amazonaws.com/turbolinks-docs/images/restore.svg)

可能であれば、Turbo ドライブは、リクエストを発生させることなくキャッシュからページの複製を描画します。それが不可能な場合、ネットワークごしに、ページの新しい複製を作ろうとします。詳しくは、[キャッシュを理解する](/turbo/handbook/building#キャッシュを理解する) を見てください。

 Turbo ドライブは各ページのスクロール位置を、ナビゲーション移動が起こる前に保存し、リストア・アクセスにおいて保存された位置まで自動的に戻ります。

リストア・アクセスは _restore_ アクションを伴い、Turbo ドライブはそれを内部的な利用のために取っておいてあります。わざわざリンクにアノテーションをしたり、`Turbo.visit` を `restore` アクションと共に発動したりするべきではありません。

## アクセスを開始前にキャンセルする

Application visits can be canceled before they start, regardless of whether they were initiated by a link click or a call to [`Turbo.visit`](https://turbo.hotwired.dev/reference/drive#turbovisit).
アプリケーション・アクセスは開始前にキャンセルできます。それが、リンクのクリックによって始まったものでも、[`Turbo.visit`](https://turbo.hotwired.dev/reference/drive#turbovisit) によって始まったものでも。

アクセスが始まろうとする瞬間に気づくために、`turbo:before-visit` を待ち受け、`event.detail.url` ( jQuery を使っている場合は `$event.originalEvent.detail.url` )を使いましょう。そして、`event.preventDefault()` でキャンセルするのです。

リストア・アクセスは、`turbo:before-visit` を発火しないのでキャンセルすることができません。 Turbo ドライブは、リストア・アクセスを、*すでに存在する*アクセス履歴への応答の場合に発行します。よくあるのは、ブラウザバックやブラウザで前に進む場合です。

## 描画の一時停止

アプリケーションは描画を一時停止して、実行前に追加で下準備をすることができます。

`turbo:before-render` イベントを待ち受けることで、描画が始まろうとする瞬間に気づくことができます。そこで、`event.preventDefault()` で描画を停止させましょう。下準備が終わったら、`event.detail.resume()` を呼ぶことで描画を再開します。

アクセスにexitのアニメーションを追加する例です。

```javascript
document.addEventListener('turbo:before-render', async (event) => {
  event.preventDefault()

  await animateOut()

  event.detail.resume()
})
```

## リクエストの一時停止

アプリケーションはリクエストを一時停止して、実行前に追加で下準備をすることができます。

`turbo:before-fetch-request` イベントを待ち受けることで、リクエストが始まろうとする瞬間に気づくことができます。そこで、`event.preventDefault()` でリクエストを停止させましょう。下準備が終わったら、`event.detail.resume()` を呼ぶことでリクエストを再開します。

リクエストに `Authorization` ヘッダを設定する例です。

```javascript
document.addEventListener('turbo:before-fetch-request', async (event) => {
  event.preventDefault()

  const token = await getSessionToken(window.app)
  event.detail.fetchOptions.headers['Authorization'] = `Bearer ${token}`

  event.detail.resume()
})
```

## 異なるメソッドでアクセスを行う

デフォルトでは、リンクのクリックはサーバへ `GET` リクエストを送ります。しかし、これを `data-turbo-method` で変更することができます。

```html
<a href="/articles/54" data-turbo-method="delete">Delete the article</a>
```

リンクは隠されたformに変換され、DOM内の `a` 要素の次の位置に配置されます。これは、リンクは別のフォームの中には配置できないということです。フォームをネストすることはできないからです。

アクセシビリティの観点からも、 GET 以外のリクエストには実際のフォームとボタンを使うのが望ましいでしょう。

## 特定のリンク/フォームでの Turbo ドライブの無効化

 Turbo ドライブは、対象となる要素かその親要素で `data-turbo="false"` を宣言することで、要素単位で無効化することができます。

```html
<a href="/" data-turbo="false">Disabled</a>

<form action="/messages" method="post" data-turbo="false">
  ...
</form>

<div data-turbo="false">
  <a href="/">Disabled</a>
  <form action="/messages" method="post">
    ...
  </form>
</div>
```

親要素で Turbo ドライブが無効化されている際に、再度 Turbo ドライブを有効化するには、`data-turbo="true"` を使います。


```html
<div data-turbo="false">
  <a href="/" data-turbo="true">Enabled</a>
</div>
```

 Turbo ドライブが無効化されたリンク/フォームは、ブラウザから通常通りに扱われます。

ドライブを都度無効化するのではなく、必要なときにだけ有効化するには、 `Turbo.session.drive = false` を設定することができます。
その上で、`data-turbo="true"` を使って要素ごとにドライブを有効化します。
JavaScript パック内で Turbo をインポートしている場合、このようにして設定をグローバルにできます。


```js
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
```

## 進行状況を表示する

 Turbo ドライブのナビゲーション中、ブラウザはその進行状況インジケータを表示しません。 Turbo ドライブは、リクエスト発行中のフィードバックを示すため、CSS ベースのプログレスバーを導入しています。

このプログレスバーはデフォルトで利用可能です。読み込みに500ms以上を要するページ全てに自動的に表示されます（この表示設定は [`Turbo.setProgressBarDelay`](https://turbo.hotwired.dev/reference/drive#turbodrivesetprogressbardelay) で変更できます）。

このプログレスバーは `turbo-progress-bar` クラス名を持つ `<div>` 要素です。デフォルトのスタイルはドキュメントの先頭で指定されるため、後で設定されるルールによって上書き可能です。

例えば、次のCSSを当てると太い緑のプログレスバーが表示されます。

```css
.turbo-progress-bar {
  height: 5px;
  background-color: green;
}
```

プログレスバーを完全に無効化するには、その要素の `visibility` スタイルを `hidden` に設定します。

```css
.turbo-progress-bar {
  visibility: hidden;
}
```

プログレスバーと歩調を合わせるために、Turbo ドライブは、アクセスあるいはフォームの送信から始まるページのナビゲーションの間、そのページの `<html>` 要素の[ `[aria-busy]`  属性][aria-busy]を切り替えます。 Turbo ドライブはナビゲーション開始時に `[aria-busy="true"]` をセットし、ナビゲーション完了時に `[aria-busy]` 属性を取り除きます。

[aria-busy]: https://www.w3.org/TR/wai-aria/#aria-busy

## アセット変更時のリロード


 Turbo ドライブは、あるページから別のページへの遷移時に `<head>` 内のアセット要素のURLを追跡し、URLが変更されていればフル・リロードを発行します。これによってユーザーは、最新のアプリケーションのスクリプトやスタイルを入手できます。


アセット要素を `data-turbo-track="reload"` をつけてアノテーションし、アセットのURLにバージョン識別番号をつけます。識別子は番号でも、最終更新日時でもよいですし、アセットの内容のダイジェストならもっといいでしょう。次の例のようにします。

```html
<head>
  ...
  <link rel="stylesheet" href="/application-258e88d.css" data-turbo-track="reload">
  <script src="/application-cbd3cd4.js" data-turbo-track="reload"></script>
</head>
```

## 特定のトリガーで確実にフル・リロードを行う


`<meta name="turbo-visit-control">` 要素をあるページの `<head>` に含めることで、そのページにアクセスしたとき確実にフル・リロードするようにできます。

```html
<head>
  ...
  <meta name="turbo-visit-control" content="reload">
</head>
```


この設定は、Trubo ドライブのページ変更とうまく協調できないサードパーティ JavaScript ライブラリの回避方法として有用です。

## ルートロケーションの設定


デフォルトでは、Turbo ドライブは同じオリジンでのURLのみをロード対象とします。つまり、同じプロトコル、ドメイン名、ポートが現在のドキュメントと同一のURLのみということです。他のすべてのURLはフォールバックされて、ページのフル・リロードが走ります。

場合によっては、同一オリジン上のパスで、Turbo ドライブの範囲を限定したいこともあるでしょう。 Turbo ドライブのあるアプリケーションが `/app` の path にあり、Turbo ドライブでないヘルプページが `/help` にある場合、アプリからヘルプページへのリンクには Turbo ドライブを使うべきではありません。


ページの `<head>` 内に `<meta name="turbo-root">` 要素を加えることで、Turbo ドライブの範囲を特定のルートロケーションに定めることができます。 Turbo ドライブは、このパスがプリフィックスでついた、同一URLのみをロードの対象とします。

```html
<head>
  ...
  <meta name="turbo-root" content="/app">
</head>
```

## フォームの送信

 Turbo ドライブは、リンクのクリックと似たやり方でフォームの送信を扱います。主な違いは、フォームの送信は HTTP の POST メソッドを使って状態をもつリクエストを発行できますが、リンクのクリックは HTTP の状態を持たない GET リクエストしか発行できません。

フォームの送信を通じて、Turbo ドライブは `<form>` 要素を対象とした一連の [events][] をディスパッチし、documentへと [バブリング][] していきます。

1. `turbo:submit-start`
2. `turbo:before-fetch-request`
3. `turbo:before-fetch-response`
4. `turbo:submit-end`

フォームを送信する間、まず送信開始時に Turbo ドライブは "submitter" 要素の [disabled][] 属性をセットし、送信終了時に [disabled][] 属性を取り除きます。`<form>` 要素の送信時、ブラウザは送信の口火を切る `<input type="submit">` か `<button>` 要素を [submitter][] として扱います。 `<form>` 要素をプログラム的に送信するためには、 [HTMLFormElement.requestSubmit()][] メソッドを呼び出して `<input type="submit">` か `<button>` 要素をオプショナルなパラメーターとして渡します。

もし `<form>` 送信中に行いたい他の変更があるなら（例えば、_すべての_ [送信される `<form>` 内のフィールド][要素]を disable にしたいなど）、独自にイベント・リスナーを宣言することができます。

```js
addEventListener("turbo:submit-start", ({ target }) => {
  for (const field of target.elements) {
    field.disabled = true
  }
})
```

[events]: https://turbo.hotwired.dev/reference/events
[バブリング]: https://developer.mozilla.org/ja/docs/Learn/JavaScript/Building_blocks/Events#%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88%E3%81%AE%E3%83%90%E3%83%96%E3%83%AA%E3%83%B3%E3%82%B0%E3%81%A8%E3%82%AD%E3%83%A3%E3%83%97%E3%83%81%E3%83%A3%E3%83%AA%E3%83%B3%E3%82%B0
[要素]: https://developer.mozilla.org/ja/docs/Web/API/HTMLFormElement/elements
[disabled]: https://developer.mozilla.org/ja/docs/Web/HTML/Attributes/disabled
[submitter]: https://developer.mozilla.org/ja/docs/Web/API/SubmitEvent/submitter
[HTMLFormElement.requestSubmit()]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLFormElement/requestSubmit


## フォーム送信後のリダイレクト

フォームの送信によるステートフルなリクエストの後、Turbo ドライブはサーバーに [HTTP 303 リダイレクト・レスポンス](https://en.wikipedia.org/wiki/HTTP_303) を期待します。このレスポンスに続いて、ドライブは、レスポンスを利用してページのリロードなしのナビゲートと更新を行います。

このルールの例外は、レスポンスが 4xx あるいは 5xx のステータスコードで描画された場合です。この場合、 `422 Unprocessable Entity` の応答がサーバーから帰ってきた時はフォームバリデーションエラーが描画され、 `500 Internal Server Error` の時は "Something Went Wrong" の壊れたサーバー状態が描画されます。


Turbo が POST リクエストに通常の200ステータスの応答を許さないのは、POST リクエストは、ブラウザが POST アクセスにリロードが走った際に、"フォームを再送信しますか?"のダイアログを出す振る舞いを、組み込みで持っているからです。Turbo はこれを再現できません。代わりに Turobo は、フォームのアクションを変えることはせず、描画しようとするフォーム送信の現在のURLに止まります。なぜなら、リロードは存在しないアクションURLへも GET リクエストを発行してしまうからです。

フォーム送信が GET リクエストの場合は、フォームに `data-turbo-frame` ターゲットを与えられることで直接レスポンスを描画します。描画の一部としてURLを更新したい場合は、 `data-turbo-action` 属性を渡します。

## フォーム送信後のストリーミング

サーバーはフォームの送信に対して、レスポンス・ボディ内の一つ以上の `<turbo-stream>` 要素を伴う `Content-Type: text/vnd.turbo-stream.html` [Turboストリーム](/turbo/handbook/streams)メッセージで応答することもあります。この応答によって、ナビゲーションなしに、ページの複数箇所を更新することができます。
<br><br>
