---
title: "Turbo ドライブを使ったナビゲート"
description: "Turbo ドライブは、ページ全体の再読み込みの必要を無くすことで、リンクとフォームの送信を高速化します。"
order: 2
commit: "3b06afb"
---

# Turbo ドライブを使ったナビゲート

Turbo ドライブは、ページ単位のナビゲーションを強化する、Turbo の一部機能です。
リンクのクリックとフォームの送信を監視し、それらをバックグラウンドで実行し、全リロードを行わずにページを更新します。以前 [Turbolinks](https://github.com/turbolinks/turbolinks) という名前で知られていたライブラリの進化版です。

${toc}

## ページ・ナビゲーションの基本

Turbo ドライブは、ページ・ナビゲーションを、ある*アクション*をともなった、ある*ロケーション* (URL)へのアクセスという形で表現します。

アクセスは、ページの描画のために、クリックから始まるすべてのナビゲーション・ライフサイクルを要求します。そのサイクルには、ブラウザ履歴の更新や、ネットワーク・リクエストの発行、キャッシュからのページのコピーの再構築、最終的なレスポンスの描画、スクロール位置の更新も含まれます。

描画中、Turbo ドライブはリクエストしているドキュメントの`<body>`の内容をレスポンスのドキュメントの`<body>`で置き換えます。`<head>`の内容もマージし、必要に応じて`<html>`要素の`lang`属性を更新します。`<head>`要素を置き換える代わりにマージするポイントは、`<title>`または`<meta>`タグが変わった時にそれらは期待どおり更新され、アセットのリンクが変わらない時にそのリンクに対して再び処理しないところです。

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

## 描画のカスタム

ドキュメント全体に対して `turbo:before-render` イベントリスナーを追加し、 `event.detail.render` プロパティをオーバーライドすることで、アプリケーションの描画プロセスをカスタマイズできます。

例えば、[morphdom]で、リクエストを投げたドキュメントの `<body>` 要素を、レスポンスのドキュメントにある `<body>` 要素にマージできます。

```javascript
import morphdom from "morphdom"

addEventListener("turbo:before-render", (event) => {
  event.detail.render = (currentElement, newElement) => {
    morphdom(currentElement, newElement)
  }
})
```

[morphdom]: https://github.com/patrick-steele-idem/morphdom

<details>
<summary>原文</summary>

Applications can customize the rendering process by adding a document-wide `turbo:before-render` event listener and overriding the `event.detail.render` property.

For example, you could merge the response document's `<body>` element into the requesting document's `<body>` element with [morphdom](https://github.com/patrick-steele-idem/morphdom):

```javascript
import morphdom from "morphdom"

addEventListener("turbo:before-render", (event) => {
  event.detail.render = (currentElement, newElement) => {
    morphdom(currentElement, newElement)
  }
})
```

</details>

## 描画の一時停止

アプリケーションは描画を一時停止して、続行する前に追加で下準備をすることができます。

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

## アクセス前に確認ダイアログを表示する

リンクに `data-turbo-confirm` 属性を付けると、アクセス前に確認ダイアログが表示できます。

```html
<a href="/articles" data-turbo-confirm="このページから離れますか？">Back to articles</a>
<a href="/articles/54" data-turbo-method="delete" data-turbo-confirm="本当に記事を削除しますか？">Delete the article</a>
```

確認時に呼ぶメソッドは `Turbo.setConfirmMethod` を使って、変更できます。確認時に呼ぶメソッドのデフォルトは、ブラウザに組み込まれてる `confirm` です。

<details>
<summary>原文</summary>

Decorate links with `data-turbo-confirm`, and confirmation will be required for a visit to proceed.

```html
<a href="/articles" data-turbo-confirm="Do you want to leave this page?">Back to articles</a>
<a href="/articles/54" data-turbo-method="delete" data-turbo-confirm="Are you sure you want to delete the article?">Delete the article</a>
```

Use `Turbo.setConfirmMethod` to change the method that gets called for confirmation. The default is the browser's built in `confirm`.

</details>

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

## ビュートランジション

[ビュートランジション API]を[サポートしているブラウザ]では、Turboはページ間を移動するときにビュートランジションをトリガーします。

Turbo は、現在と次のページの両方に以下の `<meta>` 要素があるときに、ビュートランジションをトリガーします。

```html
<meta name="view-transition" content="same-origin" />
```

Turbo は `<html>` 要素に `data-turbo-visit-direction` 属性を追加することで、トランジションの方向を指定できます。その属性の値として以下のものを使えます。

- `forward`: ページを全て変える方向
- `back`: ページを前のページに戻す方向
- `none`: ページの一部を置き換える方向

この属性を使えば、トランジション中で実行されるアニメーションをカスタマイズできます。

```css
html[data-turbo-visit-direction="forward"]::view-transition-old(sidebar):only-child {
  animation: slide-to-right 0.5s ease-out;
}
```

[サポートしているブラウザ]: https://caniuse.com/?search=View%20Transition%20API
[ビュートランジション API]: https://developer.mozilla.org/ja/docs/Web/API/View_Transitions_API

<details>
<summary>原文</summary>

In [browsers that support](https://caniuse.com/?search=View%20Transition%20API) the [View Transition API](https://developer.mozilla.org/en-US/docs/Web/API/View_Transitions_API) Turbo can trigger view transitions when navigating between pages.

Turbo triggers a view transition when both the current and the next page have this meta tag:

```
<meta name="view-transition" content="same-origin" />
```

Turbo also adds a `data-turbo-visit-direction` attribute to the `<html>` element to indicate the direction of the transition. The attribute can have one of the following values:

- `forward` in advance visits.
- `back` in restoration visits.
- `none` in replace visits.

You can use this attribute to customize the animations that are performed during a transition:

```css
html[data-turbo-visit-direction="forward"]::view-transition-old(sidebar):only-child {
  animation: slide-to-right 0.5s ease-out;
}
```

</details>

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

## ホバーでリンク先のプリフェッチ

Turbo は、ユーザーがリンクをクリックする前に発生した`mouseenter` イベントでリンク先を自動で読み込みます。これにより、リンク・ナビゲーションの待ち時間が短縮されます。通常、クリック・ナビゲーション単位で500から800ミリ秒の速度が向上します。

リンク先のプリフェッチは、Turbo v8からデフォルトで有効になっています。ただ、以下のメタタグをページに追加すれば、無効化できます。

```html
<meta name="turbo-prefetch" content="false">
```

ユーザーが少しの間だけリンクをホバーしただけでリンク先をプリフェッチしないように、Turbo はリンク先をプリフェッチする前に100ミリ秒待ちます。

HTML要素、あるいは、その祖先に `data-turbo-prefetch="false"`をつけることで、プリフェッチ機能を要素ごとに無効化できます。

```html
<html>
  <head>
    <meta name="turbo-prefetch" content="true">
  </head>
  <body>
    <a href="/articles">Articles</a> <!-- このリンク先はプリフェッチされます -->
    <a href="/about" data-turbo-prefetch="false">About</a> <!-- このリンク先はプリフェッチされません -->
    <div data-turbo-prefetch="false"`>
      <!-- このdiv内のリンクはプリフェッチされません -->
    </div>
  </body>
</html>
```

`turbo:before-prefetch` イベントをインターセプトして `event.preventDefault()` を呼ぶことで、プログラムでプリフェッチ機能を無効化できます。

```javascript
document.addEventListener("turbo:before-prefetch", (event) => {
  if (isSavingData() || hasSlowInternet()) {
    event.preventDefault()
  }
})

function isSavingData() {
  return navigator.connection?.saveData
}

function hasSlowInternet() {
  return navigator.connection?.effectiveType === "slow-2g" ||
         navigator.connection?.effectiveType === "2g"
}
```


<details>
<summary>原文</summary>

Turbo can also speed up perceived link navigation latency by automatically loading links on `mouseenter` events, and before the user clicks the link. This usually leads to a speed bump of 500-800ms per click navigation.

Prefetching links is enabled by default since Turbo v8, but you can disable it by adding this meta tag to your page:

```html
<meta name="turbo-prefetch" content="false">
```

To avoid prefetching links that the user is briefly hovering, Turbo waits 100ms after the user hovers over the link before prefetching it. But you may want to disable the prefetching behavior on certain links leading to pages with expensive rendering.

You can disable the behavior on a per-element basis by annotating the element or any of its ancestors with `data-turbo-prefetch="false"`.

```html
<html>
  <head>
    <meta name="turbo-prefetch" content="true">
  </head>
  <body>
    <a href="/articles">Articles</a> <!-- This link is prefetched -->
    <a href="/about" data-turbo-prefetch="false">About</a> <!-- Not prefetched -->
    <div data-turbo-prefetch="false"`>
      <!-- Links inside this div will not be prefetched -->
    </div>
  </body>
</html>
```

You can also disable the behaviour programatically by intercepting the `turbo:before-prefetch` event and calling `event.preventDefault()`.

```javascript
document.addEventListener("turbo:before-prefetch", (event) => {
  if (isSavingData() || hasSlowInternet()) {
    event.preventDefault()
  }
})

function isSavingData() {
  return navigator.connection?.saveData
}

function hasSlowInternet() {
  return navigator.connection?.effectiveType === "slow-2g" ||
         navigator.connection?.effectiveType === "2g"
}
```
</details>

## リンク先をキャッシュにプリロード

[data-turbo-preload] 属性を使えば、リンク先をTurbo ドライブのキャッシュにプリロードできます。

これにより、ページに初めてアクセスする前でもページのプレビューが提供され、ページアクセスが高速に感じられます。これはアプリケーション上で最も重要なページのプリロードに使えます。過剰な使用は、不要なコンテントを読み込むことになるので、避けてください。

すべての `<a>` 要素がプリロードされるわけではありません。以下のような `[data-turbo-preload]` 属性を持つリンクはプリロードされません。

* 他のドメインにアクセスするリンク
* ある `<turbo-frame>` 要素に対して適用される `[data-turbo-frame]` 属性を持つリンク
* 先祖要素の `<turbo-frame>` に対して適用されるリンク
* `[data-turbo="false"]` 属性を持つリンク
* `[data-turbo-stream]` 属性を持つリンク
* `[data-turbo-method]` 属性を持つリンク
* 先祖要素が `[data-turbo="false"]` 属性を持つリンク
* 先祖要素が `[data-turbo-prefetch="false"]` 属性を持つリンク

<br><br>

プリロードされた `<a>` 要素は [turbo:before-fetch-request] と [turbo:before-fetch-response] イベントをディスパッチすることに注意してください。`turbo:before-fetch-request` イベントがプリロードにより発生したのかそれとも他のメカニズムにより発生したのかの区別は、リクエストの `X-Sec-Purpose` ヘッダーに `"prefetch"`がセットされているかどうかで確認できます（`X-Sec-Purpose` ヘッダーの値は `event.detail.fetchOptions.headers["X-Sec-Purpose"]` プロパティから取得できます）。

```js
addEventListener("turbo:before-fetch-request", (event) => {
  if (event.detail.fetchOptions.headers["X-Sec-Purpose"] === "prefetch") {
    // 追加のプリロード設定を行う
  } else {
    // 何かを行う
  }
})
```


[data-turbo-preload]: /hotwire_ja/turbo/reference/attributes#data-attributes
[turbo:before-fetch-request]: /hotwire_ja/turbo/reference/events#turbo%3Abefore-fetch-request
[turbo:before-fetch-response]: /hotwire_ja/turbo/reference/events#turbo%3Abefore-fetch-response

<details>
<summary>原文</summary>

Preload links into Turbo Drive's cache using the [data-turbo-preload][] boolean attribute.

This will make page transitions feel lightning fast by providing a preview of a page even before the first visit. Use it to preload the most important pages in your application. Avoid over usage, as it will lead to loading content that is not needed.

Not every `<a>` element can be preloaded. The `[data-turbo-preload]` attribute
won't have any effect on links that:

* navigate to another domain
* have a `[data-turbo-frame]` attribute that drives a `<turbo-frame>` element
* drive an ancestor `<turbo-frame>` element
* have the `[data-turbo="false"]` attribute
* have the `[data-turbo-stream]` attribute
* have a `[data-turbo-method]` attribute
* have an ancestor with the `[data-turbo="false"]` attribute
* have an ancestor with the `[data-turbo-prefetch="false"]` attribute

It also dovetails nicely with pages that leverage [Eager-Loading Frames](/reference/frames#eager-loaded-frame) or [Lazy-Loading Frames](/reference/frames#lazy-loaded-frame). As you can preload the structure of the page and show the user a meaningful loading state while the interesting content loads.
<br><br>

Note that preloaded `<a>` elements will dispatch [turbo:before-fetch-request](/reference/events) and [turbo:before-fetch-response](/reference/events) events. To distinguish a preloading `turbo:before-fetch-request` initiated event from an event initiated by another mechanism, check whether the request's `X-Sec-Purpose` header (read from the `event.detail.fetchOptions.headers["X-Sec-Purpose"]` property) is set to `"prefetch"`:

```js
addEventListener("turbo:before-fetch-request", (event) => {
  if (event.detail.fetchOptions.headers["X-Sec-Purpose"] === "prefetch") {
    // do additional preloading setup…
  } else {
    // do something else…
  }
})
```
</details>
