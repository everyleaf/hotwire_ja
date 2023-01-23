---
permalink: /handbook/drive.html
description: "Turbo Drive accelerates links and form submissions by negating the need for full page reloads."
---

[DHHの許諾](https://github.com/hotwired/turbo-site/issues/96)のもと、[公式のTurboHandbook](https://turbo.hotwired.dev/handbook/introduction)を[オリジナル](https://github.com/hotwired/turbo-site/commit/59943d962b37a02c1dcb68ebaa1057f713a45975)として、翻訳をしています。
このサイトの全ての文責は、[株式会社万葉](https://everyleaf.com/)にあります。

# Navigate with Turbo Drive
# Turbo ドライブを使ったナビゲート

Turbo Drive is the part of Turbo that enhances page-level navigation. It watches for link clicks and form submissions, performs them in the background, and updates the page without doing a full reload. It's the evolution of a library previously known as [Turbolinks](https://github.com/turbolinks/turbolinks).

Turbo ドライブは、ページ単位のナビゲーションを強化する、Turbo の一部機能です。
リンクのクリックとフォームの送信を監視し、それらをバックグラウンドで実行し、全リロードを行わずにページを更新します。以前 [Turbolinks](https://github.com/turbolinks/turbolinks) という名前で知られていたライブラリの進化版です。

${toc}

## Page Navigation Basics
## ページ・ナビゲーションの基本

Turbo Drive models page navigation as a *visit* to a *location* (URL) with an *action*.
Turob ドライブは、ページ・ナビゲーションを、ある*アクション*をともなった、ある*ロケーション* (URL)へのアクセスという形で表現します。

Visits represent the entire navigation lifecycle from click to render. That includes changing browser history, issuing the network request, restoring a copy of the page from cache, rendering the final response, and updating the scroll position.
アクセスは、ページの描画のために、クリックから始まるすべてのナビゲーション・ライフサイクルを要求します。そのサイクルには、ブラウザ履歴の更新や、ネットワーク・リクエストの発行、キャッシュからのページのコピーの再構築、最終的なレスポンスの描画、スクロール位置の更新も含まれます。

There are two types of visit: an _application visit_, which has an action of _advance_ or _replace_, and a _restoration visit_, which has an action of _restore_.
アクセスには二つの種類があります。_アプリケーション・アクセス_、_advance_ あるいは _replace_ のアクションを伴うものと、_リストア・アクセス_、_restore_ のアクションを伴うものです。

## Application Visit
## アプリケーション・アクセス

Application visits are initiated by clicking a Turbo Drive-enabled link, or programmatically by calling [`Turbo.visit(location)`](/reference/drive#turbodrivevisit).

アプリケーション・アクセスは、Turbo ドライブが使えるリンクのクリック、あるいはプログラムによる[`Turbo.visit(location)`](/reference/drive#turbodrivevisit) の呼び出しです。

An application visit always issues a network request. When the response arrives, Turbo Drive renders its HTML and completes the visit.
アプリケーション・アクセスは常にネットワーク・リクエストを発行します。レスポンスが戻ってくると、Turbo ドライブはその HTML を描画し、アクセスを完了します。

If possible, Turbo Drive will render a preview of the page from cache immediately after the visit starts. This improves the perceived speed of frequent navigation between the same pages.
可能であれば、Turbo ドライブはアクセスがはじまった直後に、キャッシュからプレビューを描画します。これによって、同じページ間の頻繁なナビゲーションの体感スピードは改善します。


If the visit’s location includes an anchor, Turbo Drive will attempt to scroll to the anchored element. Otherwise, it will scroll to the top of the page.
もしアクセス先のロケーションがアンカーを含んでいる場合、Turbo ドライブはアンカー先の要素へスクロールします。含まれていなければ、そのページのトップへとスクロールします。

Application visits result in a change to the browser’s history; the visit’s _action_ determines how.
アプリケーション・アクセスはブラウザ履歴に残ります。アクセスに伴う _アクション_ によって、どのように残るかは異なります。

![Advance visit action](https://s3.amazonaws.com/turbolinks-docs/images/advance.svg)
![advance アクセス・アクション](https://s3.amazonaws.com/turbolinks-docs/images/advance.svg)

The default visit action is _advance_. During an advance visit, Turbo Drives pushes a new entry onto the browser’s history stack using [`history.pushState`](https://developer.mozilla.org/en-US/docs/Web/API/History/pushState).
デフォルトのアクセスのアクションは _advance_ です。advance アクセスの間、Turbo ドライブは[`history.pushState`](https://developer.mozilla.org/ja/docs/Web/API/History/pushState)を用いてブラウザ履歴に項目を積みます。

Applications using the Turbo Drive [iOS adapter](https://github.com/hotwired/turbo-ios) typically handle advance visits by pushing a new view controller onto the navigation stack. Similarly, applications using the [Android adapter](https://github.com/hotwired/turbo-android) typically push a new activity onto the back stack.
 Turbo ドライブ [iOS adapter](https://github.com/hotwired/turbo-ios)を用いるアプリケーションは、普通はナビゲーション・スタックに新しい view コントローラーを積むことで Advance アクセスを扱います。同様に、[Android adapter](https://github.com/hotwired/turbo-android)  を用いたアプリケーションは、新しいアクティビティをバックスタックに積みます。

![Replace visit action](https://s3.amazonaws.com/turbolinks-docs/images/replace.svg)
![replace アクセス・アクション](https://s3.amazonaws.com/turbolinks-docs/images/replace.svg)

You may wish to visit a location without pushing a new history entry onto the stack. The _replace_ visit action uses [`history.replaceState`](https://developer.mozilla.org/en-US/docs/Web/API/History/replaceState) to discard the topmost history entry and replace it with the new location.

ブラウザ履歴に新しい履歴項目を積まずにロケーションにアクセスをしたいことがあるかもしれません。[`history.replaceState`](https://developer.mozilla.org/ja/docs/Web/API/History/replaceState) を用いた _replace_ アクセス・アクションは一番上の履歴項目を破棄し、新しいロケーションにそれを取り替えます。

To specify that following a link should trigger a replace visit, annotate the link with `data-turbo-action="replace"`:
次のリンクが replace アクセスを発火させるよう指定するために、該当リンクに `data-turbo-action="replace"` をアノテーションします。

```html
<a href="/edit" data-turbo-action="replace">Edit</a>
```

```html
<a href="/edit" data-turbo-action="replace">編集</a>
```

To programmatically visit a location with the replace action, pass the `action: "replace"` option to `Turbo.visit`:
プログラム的に replace アクションとともにロケーションにアクセスするには、`Turbo.visit`に`action: "replace"` オプションを渡します。

```js
Turbo.visit("/edit", { action: "replace" })
```

```js
Turbo.visit("/edit", { action: "replace" })
```

Applications using the Turbo Drive [iOS adapter](https://github.com/hotwired/turbo-ios) typically handle replace visits by dismissing the topmost view controller and pushing a new view controller onto the navigation stack without animation.
 Turbo ドライブ [iOS adapter](https://github.com/hotwired/turbo-ios)を用いるアプリケーションは一般に、最上位の view コントローラーを閉じ、新しい view コントローラーをナビゲーション・スタック上にアニメーションなしでpushすることで更新を扱います。

## Restoration Visits
## リストア・アクセス

Turbo Drive automatically initiates a restoration visit when you navigate with the browser’s Back or Forward buttons. Applications using the [iOS](https://github.com/hotwired/turbo-ios) or [Android](https://github.com/hotwired/turbo-android) adapters initiate a restoration visit when moving backward in the navigation stack.

 Turbo ドライブは、ブラウザバックやブラウザで前に進むボタンでの移動があった場合に、自動的にリストア・アクセスを開始します。[iOS](https://github.com/hotwired/turbo-ios) あるいは [Android](https://github.com/hotwired/turbo-android) アダプタを使うアプリケーションは、ナビゲーション・スタック内で後ろに戻る動きがあった場合に、リストア・アクセスを開始します。

![Restore visit action](https://s3.amazonaws.com/turbolinks-docs/images/restore.svg)

If possible, Turbo Drive will render a copy of the page from cache without making a request. Otherwise, it will retrieve a fresh copy of the page over the network. See [Understanding Caching](/handbook/building#understanding-caching) for more details.
可能であれば、Turbo ドライブは、リクエストを発生させることなくキャッシュからページの複製を描画します。それが不可能な場合、ネットワークごしに、ページの新しい複製を作ろうとします。詳しくは、[Understanding Caching](/handbook/building#understanding-caching) を見てください。

Turbo Drive saves the scroll position of each page before navigating away and automatically returns to this saved position on restoration visits.
 Turbo ドライブは各ページのスクロール位置を、ナビゲーション移動が起こる前に保存し、リストア・アクセスにおいて保存された位置まで自動的に戻ります。

Restoration visits have an action of _restore_ and Turbo Drive reserves them for internal use. You should not attempt to annotate links or invoke `Turbo.visit` with an action of `restore`.
リストア・アクセスは _restore_ アクションを伴い、Turbo ドライブはそれを内部的な利用のために取っておいてあります。わざわざリンクにアノテーションをしたり、`Turbo.visit` を `restore` アクションと共に発動したりするべきではありません。

## Canceling Visits Before They Start
## アクセスを開始前にキャンセルする

Application visits can be canceled before they start, regardless of whether they were initiated by a link click or a call to [`Turbo.visit`](/reference/drive#turbovisit).
アプリケーション・アクセスは開始前にキャンセルできます。それが、リンクのクリックによって始まったものでも、[`Turbo.visit`](/reference/drive#turbovisit) によって始まったものでも。

Listen for the `turbo:before-visit` event to be notified when a visit is about to start, and use `event.detail.url` (or `$event.originalEvent.detail.url`, when using jQuery) to check the visit’s location. Then cancel the visit by calling `event.preventDefault()`.
アクセスが始まろうとする瞬間に気づくために、`turbo:before-visit` を待ち受け、`event.detail.url` ( jQuery を使っている場合は `$event.originalEvent.detail.url` )を使いましょう。そして、`event.preventDefault()` でキャンセルするのです。

Restoration visits cannot be canceled and do not fire `turbo:before-visit`. Turbo Drive issues restoration visits in response to history navigation that has *already taken place*, typically via the browser’s Back or Forward buttons.
リストア・アクセスは、`turbo:before-visit` を発火しないのでキャンセルすることができません。 Turbo ドライブは、リストア・アクセスを、*すでに存在する*アクセス履歴への応答の場合に発行します。よくあるのは、ブラウザバックやブラウザで前に進む場合です。

## Pausing Rendering
## 描画の一時停止

Application can pause rendering and make additional preparation before it will be executed.
アプリケーションは描画を一時停止して、実行前に追加で下準備をすることができます。

Listen for the `turbo:before-render` event to be notified when rendering is about to start, and pause it using `event.preventDefault()`. Once the preparation is done continue rendering by calling `event.detail.resume()`.
`turbo:before-render` イベントを待ち受けることで、描画が始まろうとする瞬間に気づくことができます。そこで、`event.preventDefault()` で描画を停止させましょう。下準備が終わったら、`event.detail.resume()` を呼ぶことで描画を再開します。

An example use case is adding exit animation for visits:
アクセスにexitのアニメーションを追加する例です。

```javascript
document.addEventListener('turbo:before-render', async (event) => {
  event.preventDefault()

  await animateOut()

  event.detail.resume()
})
```

## Pausing Requests
## リクエストの一時停止

Application can pause request and make additional preparation before it will be executed.
アプリケーションはリクエストを一時停止して、実行前に追加で下準備をすることができます。

Listen for the `turbo:before-fetch-request` event to be notified when a request is about to start, and pause it using `event.preventDefault()`. Once the preparation is done continue request by calling `event.detail.resume()`.
`turbo:before-fetch-request` イベントを待ち受けることで、リクエストが始まろうとする瞬間に気づくことができます。そこで、`event.preventDefault()` でリクエストを停止させましょう。下準備が終わったら、`event.detail.resume()` を呼ぶことでリクエストを再開します。

An example use case is setting `Authorization` header for the request:
リクエストに `Authorization` ヘッダを設定する例です。

```javascript
document.addEventListener('turbo:before-fetch-request', async (event) => {
  event.preventDefault()

  const token = await getSessionToken(window.app)
  event.detail.fetchOptions.headers['Authorization'] = `Bearer ${token}`

  event.detail.resume()
})
```

## Performing Visits With a Different Method
## 異なるメソッドでアクセスを行う

By default, link clicks send a `GET` request to your server. But you can change this with `data-turbo-method`:
デフォルトでは、リンクのクリックはサーバへ `GET` リクエストを送ります。しかし、これを `data-turbo-method` で変更することができます。

```html
<a href="/articles/54" data-turbo-method="delete">Delete the article</a>
```

The link will get converted into a hidden form next to the `a` element in the DOM. This means that the link can't appear inside another form, as you can't have nested forms.
リンクは隠されたformに変換され、DOM内の `a` 要素の次の位置に配置されます。これは、リンクは別のフォームの中には配置できないということです。フォームをネストすることはできないからです。

You should also consider that for accessibility reasons, it's better to use actual forms and buttons for anything that's not a GET.
アクセシビリティの観点からも、 GET 以外のリクエストには実際のフォームとボタンを使うのが望ましいでしょう。


## Disabling Turbo Drive on Specific Links or Forms
## 特定のリンク/フォームでの Turbo ドライブの無効化

Turbo Drive can be disabled on a per-element basis by annotating the element or any of its ancestors with `data-turbo="false"`.
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

To reenable when an ancestor has opted out, use `data-turbo="true"`:
親要素で Turbo ドライブが無効化されている際に、再度 Turbo ドライブを有効化するには、`data-turbo="true"` を使います。


```html
<div data-turbo="false">
  <a href="/" data-turbo="true">Enabled</a>
</div>
```

Links or forms with Turbo Drive disabled will be handled normally by the browser.
 Turbo ドライブが無効化されたリンク/フォームは、ブラウザから通常通りに扱われます。

If you want Drive to be opt-in rather than opt-out, then you can set `Turbo.session.drive = false`; then, `data-turbo="true"` is used to enable Drive on a per-element basis. If you're importing Turbo in a JavaScript pack, you can do this globally:
ドライブを都度無効化するのではなく、必要なときにだけ有効化するには、 `Turbo.session.drive = false` を設定することができます。
その上で、`data-turbo="true"` を使って要素ごとにドライブを有効化します。
JavaScript パック内で Turbo をインポートしている場合、このようにして設定をグローバルにできます。


```js
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
```

## Displaying Progress
## 進行状況を表示する

During Turbo Drive navigation, the browser will not display its native progress indicator. Turbo Drive installs a CSS-based progress bar to provide feedback while issuing a request.
 Turbo ドライブのナビゲーション中、ブラウザはその進行状況インジケータを表示しません。 Turbo ドライブは、リクエスト発行中のフィードバックを示すため、CSS ベースのプログレスバーを導入しています。

The progress bar is enabled by default. It appears automatically for any page that takes longer than 500ms to load. (You can change this delay with the [`Turbo.setProgressBarDelay`](/reference/drive#turbodrivesetprogressbardelay) method.)
このプログレスバーはデフォルトで利用可能です。読み込みに500ms以上を要するページ全てに自動的に表示されます（この表示設定は [`Turbo.setProgressBarDelay`](/reference/drive#turbodrivesetprogressbardelay) で変更できます）。

The progress bar is a `<div>` element with the class name `turbo-progress-bar`. Its default styles appear first in the document and can be overridden by rules that come later.
このプログレスバーは `turbo-progress-bar` クラス名を持つ `<div>` 要素です。デフォルトのスタイルはドキュメントの先頭で指定されるため、後で設定されるルールによって上書き可能です。

For example, the following CSS will result in a thick green progress bar:
例えば、次のCSSを当てると太い緑のプログレスバーが表示されます。

```css
.turbo-progress-bar {
  height: 5px;
  background-color: green;
}
```

To disable the progress bar entirely, set its `visibility` style to `hidden`:
プログレスバーを完全に無効化するには、その要素の `visibility` スタイルを `hidden` に設定します。

```css
.turbo-progress-bar {
  visibility: hidden;
}
```

In tandem with the progress bar, Turbo Drive will also toggle the [`[aria-busy]` attribute][aria-busy] on the page's `<html>` element during page navigations started from Visits or Form Submissions. Turbo Drive will set `[aria-busy="true"]` when the navigation begins, and will remove the `[aria-busy]` attribute when the navigation completes.
プログレスバーと歩調を合わせるために、Turbo ドライブは、アクセスあるいはフォームの送信から始まるページのナビゲーションの間、そのページの `<html>` 要素の[ `[aria-busy]`  属性][aria-busy]を切り替えます。 Turbo ドライブはナビゲーション開始時に `[aria-busy="true"]` をセットし、ナビゲーション完了時に `[aria-busy]` 属性を取り除きます。

[aria-busy]: https://www.w3.org/TR/wai-aria/#aria-busy

## Reloading When Assets Change
## アセット変更時のリロード

Turbo Drive can track the URLs of asset elements in `<head>` from one page to the next and automatically issue a full reload if they change. This ensures that users always have the latest versions of your application’s scripts and styles.

 Turbo ドライブは、あるページから別のページへの遷移時に `<head>` 内のアセット要素のURLを追跡し、URLが変更されていればフル・リロードを発行します。これによってユーザーは、最新のアプリケーションのスクリプトやスタイルを入手できます。

Annotate asset elements with `data-turbo-track="reload"` and include a version identifier in your asset URLs. The identifier could be a number, a last-modified timestamp, or better, a digest of the asset’s contents, as in the following example.

アセット要素を `data-turbo-track="reload"` をつけてアノテーションし、アセットのURLにバージョン識別番号をつけます。識別子は番号でも、最終更新日時でもよいですし、アセットの内容のダイジェストならもっといいでしょう。次の例のようにします。

```html
<head>
  ...
  <link rel="stylesheet" href="/application-258e88d.css" data-turbo-track="reload">
  <script src="/application-cbd3cd4.js" data-turbo-track="reload"></script>
</head>
```

## Ensuring Specific Pages Trigger a Full Reload
## 特定のトリガーで確実にフル・リロードを行う

You can ensure visits to a certain page will always trigger a full reload by including a `<meta name="turbo-visit-control">` element in the page’s `<head>`.

`<meta name="turbo-visit-control">` 要素をあるページの `<head>` に含めることで、そのページにアクセスしたとき確実にフル・リロードするようにできます。

```html
<head>
  ...
  <meta name="turbo-visit-control" content="reload">
</head>
```

This setting may be useful as a workaround for third-party JavaScript libraries that don’t interact well with Turbo Drive page changes.

この設定は、Trubo ドライブのページ変更とうまく協調できないサードパーティ JavaScript ライブラリの回避方法として有用です。

## Setting a Root Location
## ルートロケーションの設定

By default, Turbo Drive only loads URLs with the same origin—i.e. the same protocol, domain name, and port—as the current document. A visit to any other URL falls back to a full page load.

デフォルトでは、Turbo ドライブは同じオリジンでのURLのみをロード対象とします。つまり、同じプロトコル、ドメイン名、ポートが現在のドキュメントと同一のURLのみということです。他のすべてのURLはフォールバックされて、ページのフル・リロードが走ります。

In some cases, you may want to further scope Turbo Drive to a path on the same origin. For example, if your Turbo Drive application lives at `/app`, and the non-Turbo Drive help site lives at `/help`, links from the app to the help site shouldn’t use Turbo Drive.
場合によっては、同一オリジン上のパスで、Turbo ドライブの範囲を限定したいこともあるでしょう。 Turbo ドライブのあるアプリケーションが `/app` の path にあり、Turbo ドライブでないヘルプページが `/help` にある場合、アプリからヘルプページへのリンクには Turbo ドライブを使うべきではありません。

Include a `<meta name="turbo-root">` element in your pages’ `<head>` to scope Turbo Drive to a particular root location. Turbo Drive will only load same-origin URLs that are prefixed with this path.

ページの `<head>` 内に `<meta name="turbo-root">` 要素を加えることで、Turbo ドライブの範囲を特定のルートロケーションに定めることができます。 Turbo ドライブは、このパスがプリフィックスでついた、同一URLのみをロードの対象とします。
```html
<head>
  ...
  <meta name="turbo-root" content="/app">
</head>
```

## Form Submissions
## フォームの送信

Turbo Drive handles form submissions in a manner similar to link clicks. The key difference is that form submissions can issue stateful requests using the HTTP POST method, while link clicks only ever issue stateless HTTP GET requests.
 Turbo ドライブは、リンクのクリックと似たやり方でフォームの送信を扱います。主な違いは、フォームの送信は HTTP の POST メソッドを使って状態をもつリクエストを発行できますが、リンクのクリックは HTTP の状態を持たない GET リクエストしか発行できません。

Throughout a submission, Turbo Drive will dispatch a series of [events][] that
target the `<form>` element and [bubble up][] through the document:
フォームの送信を通じて、Turbo ドライブは `<form>` 要素を対象とした一連の [events][] をディスパッチし、documentへと [バブリング][] していきます。

1. `turbo:submit-start`
2. `turbo:before-fetch-request`
3. `turbo:before-fetch-response`
4. `turbo:submit-end`

During a submission, Turbo Drive will set the "submitter" element's [disabled][] attribute when the submission begins, then remove the attribute after the submission ends. When submitting a `<form>` element, browser's will treat the `<input type="submit">` or `<button>` element that initiated the submission as the [submitter][]. To submit a `<form>` element programmatically, invoke the [HTMLFormElement.requestSubmit()][] method and pass an `<input type="submit">` or `<button>` element as an optional parameter.

フォームを送信する間、まず送信開始時に Turbo ドライブは "submitter" 要素の [disabled][] 属性をセットし、送信終了時に [disabled][] 属性を取り除きます。`<form>` 要素の送信時、ブラウザは送信の口火を切る `<input type="submit">` か `<button>` 要素を [submitter][] として扱います。 `<form>` 要素をプログラム的に送信するためには、 [HTMLFormElement.requestSubmit()][] メソッドを呼び出して `<input type="submit">` か `<button>` 要素をオプショナルなパラメーターとして渡します。

If there are other changes you'd like to make during a `<form>` submission (for
example, disabling _all_ [fields within a submitted `<form>`][elements]), you
can declare your own event listeners:

もし `<form>` 送信中に行いたい他の変更があるなら（例えば、_すべての_ [送信される `<form>` 内のフィールド][要素]を disable にしたいなど）、独自にイベント・リスナーを宣言することができます。

```js
addEventListener("turbo:submit-start", ({ target }) => {
  for (const field of target.elements) {
    field.disabled = true
  }
})
```

[events]: /reference/events
[bubble up]: https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Building_blocks/Events#event_bubbling_and_capture
[elements]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLFormElement/elements
[disabled]: https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/disabled
[submitter]: https://developer.mozilla.org/en-US/docs/Web/API/SubmitEvent/submitter
[HTMLFormElement.requestSubmit()]: https://developer.mozilla.org/ja/docs/Web/API/HTMLFormElement/requestSubmit


[events]: /reference/events
[バブリング]: https://developer.mozilla.org/ja/docs/Learn/JavaScript/Building_blocks/Events#%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88%E3%81%AE%E3%83%90%E3%83%96%E3%83%AA%E3%83%B3%E3%82%B0%E3%81%A8%E3%82%AD%E3%83%A3%E3%83%97%E3%83%81%E3%83%A3%E3%83%AA%E3%83%B3%E3%82%B0
[要素]: https://developer.mozilla.org/ja/docs/Web/API/HTMLFormElement/elements
[disabled]: https://developer.mozilla.org/ja/docs/Web/HTML/Attributes/disabled
[submitter]: https://developer.mozilla.org/ja/docs/Web/API/SubmitEvent/submitter
[HTMLFormElement.requestSubmit()]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLFormElement/requestSubmit


## Redirecting After a Form Submission
## フォーム送信後のリダイレクト

After a stateful request from a form submission, Turbo Drive expects the server to return an [HTTP 303 redirect response](https://en.wikipedia.org/wiki/HTTP_303), which it will then follow and use to navigate and update the page without reloading.
フォームの送信によるステートフルなリクエストの後、Turbo ドライブはサーバーに [HTTP 303 リダイレクト・レスポンス](https://en.wikipedia.org/wiki/HTTP_303) を期待します。このレスポンスに続いて、ドライブは、レスポンスを利用してページのリロードなしのナビゲートと更新を行います。

The exception to this rule is when the response is rendered with either a 4xx or 5xx status code. This allows form validation errors to be rendered by having the server respond with `422 Unprocessable Entity` and a broken server to display a "Something Went Wrong" screen on a `500 Internal Server Error`.

このルールの例外は、レスポンスが 4xx あるいは 5xx のステータスコードで描画された場合です。この場合、 `422 Unprocessable Entity` の応答がサーバーから帰ってきた時はフォームバリデーションエラーが描画され、 `500 Internal Server Error` の時は "Something Went Wrong" の壊れたサーバー状態が描画されます。


The reason Turbo doesn't allow regular rendering on 200's from POST requests is that browsers have built-in behavior for dealing with reloads on POST visits where they present a "Are you sure you want to submit this form again?" dialogue that Turbo can't replicate. Instead, Turbo will stay on the current URL upon a form submission that tries to render, rather than change it to the form action, since a reload would then issue a GET against that action URL, which may not even exist.

Turbo が POST リクエストに通常の200ステータスの応答を許さないのは、POST リクエストは、ブラウザが POST アクセスにリロードが走った際に、"フォームを再送信しますか?"のダイアログを出す振る舞いを、組み込みで持っているからです。Turbo はこれを再現できません。代わりに Turobo は、フォームのアクションを変えることはせず、描画しようとするフォーム送信の現在のURLに止まります。なぜなら、リロードは存在しないアクションURLへも GET リクエストを発行してしまうからです。

If the form submission is a GET request, you may render the directly rendered response by giving the form a `data-turbo-frame` target. If you'd like the URL to update as part of the rendering also pass a `data-turbo-action` attribute.
フォーム送信が GET リクエストの場合は、フォームに `data-turbo-frame` ターゲットを与えられることで直接レスポンスを描画します。描画の一部としてURLを更新したい場合は、 `data-turbo-action` 属性を渡します。

## Streaming After a Form Submission
## フォーム送信後のストリーミング

Servers may also respond to form submissions with a [Turbo Streams](streams) message by sending the header `Content-Type: text/vnd.turbo-stream.html` followed by one or more `<turbo-stream>` elements in the response body. This lets you update multiple parts of the page without navigating.
サーバーはフォームの送信に対して、レスポンス・ボディ内の一つ以上の `<turbo-stream>` 要素を伴う `Content-Type: text/vnd.turbo-stream.html` [Turboストリーム](streams)メッセージで応答することもあります。この応答によって、ナビゲーションなしに、ページの複数箇所を更新することができます。
<br><br>
