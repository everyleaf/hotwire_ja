---
permalink: /handbook/building.html
description: "Learn more about building an application with Turbo."
---

# Building Your Turbo Application
# Turbo アプリケーションの構築

Turbo is fast because it prevents the whole page from reloading when you follow a link or submit a form. Your application becomes a persistent, long-running process in the browser. This requires you to rethink the way you structure your JavaScript.
Turbo は、リンクを押す、あるいはフォームを送信する際に、全ページの読み込み直しを避けることで速さを実現しています。アプリケーションはブラウザの中で持続的な、息の長いプロセスとなります。これによって、JavaScript の構成も考え方を変えなければなりません。

In particular, you can no longer depend on a full page load to reset your environment every time you navigate. The JavaScript `window` and `document` objects retain their state across page changes, and any other objects you leave in memory will stay i
n memory.

実際に、ナビゲーションごとに環境をリセットするための、全ページの読み込み直しに頼ることはもうできません。
JavaScript の `window` と `document` オブジェクトはページの変更をまたいでその状態を保持します。そして、メモリ上に置いた他のオブジェクトもそのまま残るのです。

With awareness and a little extra care, you can design your application to gracefully handle this constraint without tightly coupling it to Turbo.
この事実に気づき、そしてそのためにほんの少しのケアをすれば、アプリケーションを Turbo に強固に結びつけることなく、この制約を洗練された形で扱えるようデザインできます。

## Working with Script Elements
## Script 要素と協働する

Your browser automatically loads and evaluates any `<script>` elements present on the initial page load.
最初のページロードの際に存在する `<script>` 要素を、ブラウザは自動的に読み込んで評価します。

When you navigate to a new page, Turbo Drive looks for any `<script>` elements in the new page’s `<head>` which aren’t present on the current page. Then it appends them to the current `<head>` where they’re loaded and evaluated by the browser. You can use this to load additional JavaScript files on-demand.
新しいページにアクセスするとき、 Turbo ドライブは新しいページの `<head>` 要素に、何か現在のページにはなかった `<script>` 要素がないかを探します。そして、あった場合、現在のページの `<head>` に追加し、ブラウザによる読み込みと評価が行われます。これによって、必要な時にのみ、JavaScript を読み込むことができるのです。

Turbo Drive evaluates `<script>` elements in a page’s `<body>` each time it renders the page. You can use inline body scripts to set up per-page JavaScript state or bootstrap client-side models. To install behavior, or to perform more complex operations when the page changes, avoid script elements and use the `turbo:load` event instead.
Turbo ドライブはページの `<body>` 内にある `<script>` 要素を、ページを描画するたびに評価します。ページごとの JavaScript の状態をセットしたり、クライアント側のモデルのブートストラップに、インラインのbody scriptを使うことができます。ページの変更時に、振る舞いをつけくわえたり、もっと複雑な操作を行いたい時は、 <script> 要素を避けて代わりに `turbo:load` イベントを使いましょう。

Annotate `<script>` elements with `data-turbo-eval="false"` if you do not want Turbo to evaluate them after rendering. Note that this annotation will not prevent your browser from evaluating scripts on the initial page load.
描画後に<script> 要素を Turbo に評価させたくない場合、`data-turbo-eval="false"` 要素をともなってアノテーションしましょう。このアノテーションは、ブラウザが最初のページロードの際の<script> 要素の評価は防がないので注意です。

### Loading Your Application’s JavaScript Bundle
### アプリケーションの JavaScript バンドルを読み込む

Always make sure to load your application’s JavaScript bundle using `<script>` elements in the `<head>` of your document. Otherwise, Turbo Drive will reload the bundle with every page change.
アプリケーションの JavaScript バンドルが必ず読み込まれるようにするために、`<script>` 要素をドキュメントの `<head>` 内に配置しましょう。そうしなければ、 Turbo ドライブはページの変更ごとにバンドルを再読み込みするでしょう。

```html
<head>
  ...
  <script src="/application-cbd3cd4.js" defer></script>
</head>
```

You should also consider configuring your asset packaging system to fingerprint each script so it has a new URL when its contents change. Then you can use the `data-turbo-track` attribute to force a full page reload when you deploy a new JavaScript bundle. See [Reloading When Assets Change](/handbook/drive#reloading-when-assets-change) for information.
使っているアセット・パッキングシステムの、内容が変わった際に新しいURLを付与するために各スクリプトにフィンガープリントを付与する設計についても考慮が必要です。その際は、`data-turbo-track` 属性を使って、新しい JavaScript のバンドルがデプロイされた際にはページがすべて再読み込みされるようにできます。詳しくは[Reloading When Assets Change](/handbook/drive#reloading-when-assets-change)を見てください。



## Understanding Caching
## キャッシュを理解する

Turbo Drive maintains a cache of recently visited pages. This cache serves two purposes: to display pages without accessing the network during restoration visits, and to improve perceived performance by showing temporary previews during application visits.
Turbo ドライブは、最近アクセスしたページのキャッシュを維持します。このキャッシュには、二つの目的があります。ページの再構成の間、ネットワークにアクセスすることなくページを表示することと、アプリケーションのアクセスの間、一時的なプレビューを表示することで体感でのパフォーマンスを上げることです。

When navigating by history (via [Restoration Visits](/handbook/drive#restoration-visits)), Turbo Drive will restore the page from cache without loading a fresh copy from the network, if possible.
履歴によるナビゲーション ([Restoration Visits](/handbook/drive#restoration-visits)経由)の場合、Turbo ドライブは可能であれば、ネットワークを介して新たなコピーを読み込むことなく、キャッシュからページを復元します。


Otherwise, during standard navigation (via [Application Visits](/handbook/drive#application-visits)), Turbo Drive will immediately restore the page from cache and display it as a preview while simultaneously loading a fresh copy from the network. This gives the illusion of instantaneous page loads for frequently accessed locations.

一方で、通常のナビゲーション（[Application Visits](/handbook/drive#application-visits)経由）の場合、Turbo ドライブは即時にキャッシュからページを復元し、並行してネットワークを介して最新のコピーを読み込む間、プレビューとして復元したページを表示します。これによって、頻繁にアクセスされるロケーションについては、瞬間的にページがロードされるような錯覚を与えることができます。

Turbo Drive saves a copy of the current page to its cache just before rendering a new page. Note that Turbo Drive copies the page using [`cloneNode(true)`](https://developer.mozilla.org/en-US/docs/Web/API/Node/cloneNode), which means any attached event listeners and associated data are discarded.

Turbo ドライブは現在のページを、新しいページを描画する直前にキャッシュにコピーします。Turbo ドライブはページを[`cloneNode(true)`](https://developer.mozilla.org/ja/docs/Web/API/Node/cloneNode)を使ってコピーすることに注意してください。つまり、アタッチされたイベントリスナーや、紐づけられたデータはすべて破棄されます。

### Preparing the Page to be Cached
### ページキャッシュへの備え

Listen for the `turbo:before-cache` event if you need to prepare the document before Turbo Drive caches it. You can use this event to reset forms, collapse expanded UI elements, or tear down any third-party widgets so the page is ready to be displayed again.

もし、Turbo Drive が document をキャッシュする前に準備する必要があるなら、`turbo:before-cache` イベントをリッスンするといいでしょう。このイベントにより、フォームをリセットしたり、展開したUIを戻したり、サードパーティのウィジェットを破棄したりして、ページがもう一度表示される準備をすることができます。

```js
document.addEventListener("turbo:before-cache", function() {
  // ...
})
```

Certain page elements are inherently _temporary_, like flash messages or alerts. If they’re cached with the document they’ll be redisplayed when it’s restored, which is rarely desirable. You can annotate such elements with `data-turbo-temporary` to have Turbo Drive automatically remove them from the page before it’s cached.
本質的に_一時的_ なページ要素というのもあります。たとえばフラッシュメッセージやアラートなどです。もしそれらが document とともにキャッシュされてしまうと、復元時に再表示されてしまいますが、大抵の場合それは望ましい挙動ではありません。そのような要素には、`data-turbo-temporary` をアノテートすることで、 Turbo ドライブは自動的に、キャッシュ時にそれらの要素を取り除きます。

```html
<body>
  <div class="flash" data-turbo-temporary>
    Your cart was updated!
  </div>
  ...
</body>
```

```html
<body>
  <div class="flash" data-turbo-temporary>
    カートが更新されました！
  </div>
  ...
</body>
```

### Detecting When a Preview is Visible
### Previewが表示しているかどうかの検出

Turbo Drive adds a `data-turbo-preview` attribute to the `<html>` element when it displays a preview from cache. You can check for the presence of this attribute to selectively enable or disable behavior when a preview is visible.

Turbo ドライブは、キャッシュからプレビューを表示する際に、`<html>` 要素に`data-turbo-preview` 属性を付与します。この属性の有無を調べることで、プレビュー表示時の振る舞いを選択的に有効にしたり無効にしたりできます。

```js
if (document.documentElement.hasAttribute("data-turbo-preview")) {
  // Turbo Drive is displaying a preview
}
```

```js
if (document.documentElement.hasAttribute("data-turbo-preview")) {
  // Turbo ドライブはプレビューを表示している
}
```

### Opting Out of Caching
### キャッシュのオプトアウト

You can control caching behavior on a per-page basis by including a `<meta name="turbo-cache-control">` element in your page’s `<head>` and declaring a caching directive.
キャッシュのページごとの振る舞いは、`<meta name="turbo-cache-control">`要素をページの`<head>`に含め、キャッシュのディレクティブを宣言することでコントロールできます。

Use the `no-preview` directive to specify that a cached version of the page should not be shown as a preview during an application visit. Pages marked no-preview will only be used for restoration visits.
ページのキャッシュ版を、アプリケーションのアクセス時のプレビューとして見せたくない場合は、`no-preview`ディレクティブを使います。`no-preview` とされたページのキャッシュは、再構成の場合にのみ利用されます。

To specify that a page should not be cached at all, use the `no-cache` directive. Pages marked no-cache will always be fetched over the network, including during restoation visits.
キャッシュを全く使わないように指定するには、`no-cache`ディレクティブを使います。no-cacheとされたページは、常にネットワークを通じて内容を取得します。ページの再構成時も同様です。

```html
<head>
  ...
  <meta name="turbo-cache-control" content="no-cache">
</head>
```

To completely disable caching in your application, ensure every page contains a no-cache directive.
アプリケーションのキャッシュを完全に無効にするためには、全てのページに`no-cache` ディレクティブが含まれるようにしてください。

### Opting Out of Caching from the client-side
### クライアントサイドのキャッシュのオプトアウト

The value of the `<meta name="turbo-cache-control">` element can also be controlled by a client-side API exposed via `Turbo.cache`.
`<meta name="turbo-cache-control">` 要素の値はまた、`Turbo.cache`を通じて参照できるクライアントサイドのAPIによってもコントロールできます。

```js
// Set cache control of current page to `no-cache`
Turbo.cache.exemptPageFromCache()

// Set cache control of current page to `no-preview`
Turbo.cache.exemptPageFromPreview()
```

```js
// 現在のページのキャッシュコントロールを`no-cache`に設定する
Turbo.cache.exemptPageFromCache()

// 現在のページのキャッシュコントロールを`no-preview`に設定する
Turbo.cache.exemptPageFromPreview()
```

Both functions will create a `<meta name="turbo-cache-control">` element in the `<head>` if the element is not already present.
どちらの関数も`<meta name="turbo-cache-control">`要素がまだなければ、`<head>`の中に`<meta name="turbo-cache-control">`を書き込むことができます。

A previously set cache control value can be reset via:
前に設定したキャッシュコントロールの値は、以下のようにリセットできます。

```js
Turbo.cache.resetCacheControl()
```

## Installing JavaScript Behavior
## JavaScriptのふるまいを取りこむ

You may be used to installing JavaScript behavior in response to the `window.onload`, `DOMContentLoaded`, or jQuery `ready` events. With Turbo, these events will fire only in response to the initial page load, not after any subsequent page changes. We compare two strategies for connecting JavaScript behavior to the DOM below.
`window.onload`や`DOMContentLoaded`、それにjQuery の`ready`イベントに応じて、JavaScriptのふるまいをレスポンスに注入するのはおなじみのやり方です。Turbo では、これらのイベントは一番最初のページロードに対するレスポンスでのみ発火します。後続のページの変更の際には何も起こりません。JavaScriptの振る舞いをDOM配下に連結するための2つの戦略を比べてみましょう。

### Observing Navigation Events
### ナビゲーションイベントを監視する

Turbo Drive triggers a series of events during navigation. The most significant of these is the `turbo:load` event, which fires once on the initial page load, and again after every Turbo Drive visit.
Turbo ドライブはナビゲーション中の一連のイベントを開始します。これらの中でもっとも重要なものは `turbo:load` イベントです。これは最初のページロードの際に発火し、Turbo ドライブのvisitごとにも発火します。

You can observe the `turbo:load` event in place of `DOMContentLoaded` to set up JavaScript behavior after every page change:

`DOMContentLoaded` の代わりに`turbo:load` イベントを監視することで、ページの変更ごとにJavaScriptの振る舞いをセットすることができます。


```js
document.addEventListener("turbo:load", function() {
  // ...
})
```

Keep in mind that your application will not always be in a pristine state when this event is fired, and you may need to clean up behavior installed for the previous page.
アプリケーションは、イベントが発火した際にいつでも初期状態なわけではなく、前のページのためにセットされた振る舞いを綺麗にする必要があるかもしれない、ということを心にとめておいてください。


Also note that Turbo Drive navigation may not be the only source of page updates in your application, so you may wish to move your initialization code into a separate function which you can call from `turbo:load` and anywhere else you may change the DOM.
また、Turboドライブのナビゲーションだけが アプリケーションでのページ更新の唯一の源というわけではないことも心にとめておいてください。そのため、初期化のコードを関数化して分離し、`turbo:load`からも、DOMを変更するかもしれない他のどこからでも呼べるようにしたくなるかもしれません。

When possible, avoid using the `turbo:load` event to add other event listeners directly to elements on the page body. Instead, consider using [event delegation](https://learn.jquery.com/events/event-delegation/) to register event listeners once on `document` or `window`.
他のイベントリスナーをページ・ボティに直接追加するのに`turbo:load`イベントを使うのは、できるだけ避けましょう。その代わり、 [event delegation](https://learn.jquery.com/events/event-delegation/) を利用してイベントリスナーを`document` あるいは `window` に追加することを考慮してください。

See the [Full List of Events](/reference/events) for more information.
より詳しい情報は、 [イベント全リスト](/reference/events) にあります。

### Attaching Behavior With Stimulus
### Stimulus を使ってふるまいを追加する

New DOM elements can appear on the page at any time by way of frame navigation, stream messages, or client-side rendering operations, and these elements often need to be initialized as if they came from a fresh page load.
あたらしいDOMは、フレームのナビゲーション、ストリーム・メッセージ、それにクライアント・サイドのレンダリング操作という方法によっていつでもページに現われる可能性があります。そしてこれらの新しい要素は、まるで新しいページロードが走ったかのように初期化される必要があることも、よくあります。

You can handle all of these updates, including updates from Turbo Drive page loads, in a single place with the conventions and lifecycle callbacks provided by Turbo's sister framework, [Stimulus](https://stimulus.hotwired.dev).
これらの、Turboドライブからのページロードを含めたすべての更新を、単一の箇所とのやりとりとライフサイクル・コールバックで管理することができます。 Turboの姉妹フレームワークである[Stimulus](https://stimulus.hotwired.dev)がそれを提供します。

Stimulus lets you annotate your HTML with controller, action, and target attributes:
Stimulusを使ってアプリのHTNMLにコントローラー、アクション、そしてターゲット属性をアノテーションすることができます。

```html
<div data-controller="hello">
  <input data-hello-target="name" type="text">
  <button data-action="click->hello#greet">Greet</button>
</div>
```


```html
<div data-controller="hello">
  <input data-hello-target="name" type="text">
  <button data-action="click->hello#greet">挨拶</button>
</div>
```
Implement a compatible controller and Stimulus connects it automatically:

対応したコントローラーを実装すれば、Stimulus は自動的に接続してくれます。

```js
// hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  greet() {
    console.log(`Hello, ${this.name}!`)
  }

  get name() {
    return this.targets.find("name").value
  }
}
```

```js
// hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  greet() {
    console.log(`こんにちは、 ${this.name}さん!`)
  }

  get name() {
    return this.targets.find("name").value
  }
}
```
Stimulus connects and disconnects these controllers and their associated event handlers whenever the document changes using the [MutationObserver](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver) API. As a result, it handles Turbo Drive page changes, Turbo Frames navigation, and Turbo Streams messages the same way it handles any other type of DOM update.

Stimulus はドキュメントが変更されたときにはいつでも、これらのコントーローラーへの接続と接続切断、さらにイベント・ハンドラの統合を行います。それには、 [MutationObserver](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver) API が利用されます。その結果、Turbo ドライブのページ変更、 Turbo フレームのナビゲーション、そして Turbo ストリームのメッセージを、他の方法でのDOM更新を扱うのと同じ方法で扱うことができるのです。

## Making Transformations Idempotent
## 変更をべき等にする

Often you’ll want to perform client-side transformations to HTML received from the server. For example, you might want to use the browser’s knowledge of the user’s current time zone to group a collection of elements by date.
サーバーから受け取ったHTMLに、クライアントサイドで変更を施したい場合というのはよくあります。
例えば、要素を日毎にグルーピングするのに、ブラウザが認識している、ユーザーの現在のタイムゾーンを使いたい、というような場合です。

Suppose you have annotated a set of elements with `data-timestamp` attributes indicating the elements’ creation times in UTC. You have a JavaScript function that queries the document for all such elements, converts the timestamps to local time, and inserts date headers before each element that occurs on a new day.
要素のセットに`data-timestamp`属性をアノテートするとしましょう。これらの要素の作成日時はUTCです。そして、こういった要素をドキュメントの中からすべて探しだし、タイムスタンプをローカルタイムに変更し、新しい日付に変わった要素の前に日付の見出しを挿入するJavaScriptの関数を用意します。

Consider what happens if you’ve configured this function to run on `turbo:load`. When you navigate to the page, your function inserts date headers. Navigate away, and Turbo Drive saves a copy of the transformed page to its cache. Now press the Back button—Turbo Drive restores the page, fires `turbo:load` again, and your function inserts a second set of date headers.
もし、この関数が`turbo:load`時に実行されるよう設定したら、何が起こるでしょう。このページにナビゲートしてきたら、関数が日付の見出しを挿入します。ページを去る際に、Turbo ドライブが変更された（日付の挿入された）ページのコピーをキャッシュします。さて、ユーザーがブラウザの戻るボタンを押し、Turbo ドライブがページを復元したとき、`turbo:load` がもう一度発火し、関数は二つ目の日付の見出したちを重ねて挿入することになります。

To avoid this problem, make your transformation function _idempotent_. An idempotent transformation is safe to apply multiple times without changing the result beyond its initial application.
この問題を避けるために、変更する関数を _べき等_ にしましょう。べき等な変更は、複数回それを適用しても、その最初の適用以上に結果を変えることはありません。

One technique for making a transformation idempotent is to keep track of whether you’ve already performed it by setting a `data` attribute on each processed element. When Turbo Drive restores your page from cache, these attributes will still be present. Detect these attributes in your transformation function to determine which elements have already been processed.

べき等な変更をつくるテクニックの一つは、すでに実行されたかどうかを、それぞれの処理された要素に`data` 属性をセットすることで追跡できるようにすることです。Turbo ドライブがキャッシュからページを復元する際、これらの属性は残っています。これらの属性を変更のための関数で走査し、どの要素がすでに処理済みなのかを決定するのです。

A more robust technique is simply to detect the transformation itself. In the date grouping example above, that means checking for the presence of a date divider before inserting a new one. This approach gracefully handles newly inserted elements that weren’t processed by the original transformation.
より堅牢なテクニックは、ただ変更自体を走査することです。前述の日付でのグルーピングの例でいえば、新しい日付を挿入する前に、その日付がすでにあるかどうかをチェックするのです。このやり方は元の変更で処理されていない新しい挿入要素だけを無駄なく取り扱うことができます。

## Persisting Elements Across Page Loads
## ページのロードにまたがって要素を永続化する


Turbo Drive allows you to mark certain elements as _permanent_. Permanent elements persist across page loads, so that any changes you make to those elements do not need to be reapplied after navigation.
Turob ドライブではある要素に _permanent_ とマーキングすることができます。永続化要素は、ページのロードにまたがって保持されるため、これらの要素に施した変更を、ナビゲーション後に再び施す必要はありません。

Consider a Turbo Drive application with a shopping cart. At the top of each page is an icon with the number of items currently in the cart. This counter is updated dynamically with JavaScript as items are added and removed.
ショッピングカートを実装するTurbo ドライブを考えてみましょう。各ページのトップには、現在カートに入っている商品の数がアイコンで表示されています。このカウンターは、商品が追加されたり削除されるたび、 JavaScript で動的に更新されます。

Now imagine a user who has navigated to several pages in this application. She adds an item to her cart, then presses the Back button in her browser. Upon navigation, Turbo Drive restores the previous page’s state from cache, and the cart item count erroneously changes from 1 to 0.
さて、ユーザーがアプリケーション内のいくつかのページを移動することを考えてみましょう。カートに商品を追加し、ブラウザの「戻る」ボタンを押します。ナビゲーション上で、Turbo ドライブは以前のページの状態をキャッシュから復元します。すると、カート内の商品数は、誤って1から0に変わるのです。

You can avoid this problem by marking the counter element as permanent. Designate permanent elements by giving them an HTML `id` and annotating them with `data-turbo-permanent`.
この問題は、カウンター要素をパーマネントなものとしてマーキングすることで避けられます。HTMLの`id` を付与し、`data-turbo-permanent`属性をアノテーションすることで、パーマネント指定をしましょう。

```html
<div id="cart-counter" data-turbo-permanent>1 item</div>
```

```html
<div id="cart-counter" data-turbo-permanent>1 アイテム</div>
```

Before each render, Turbo Drive matches all permanent elements by ID and transfers them from the original page to the new page, preserving their data and event listeners.

それぞれの描画の前に、Turbo ドライブはすべての永続要素をIDでマッチし、それを元ページから新ページに移し、そのデータとイベント・リスナーを保存します。
