---
title: "はじめに"
description: "Turboは、クライアントサイドのJavaScriptフレームワークを使用することなく、高速でモダンなウェブアプリケーションを作成するためのいくつかの技術を提供します。"
order: 1
---

# はじめに

Turboは 高速でモダンで、そして進歩的に改良されたWebアプリケーションを、JavaScriptをあまり使わずに作るためのいくつかの技術をまとめたものです。
Turboは流行のクライアントサイドフレームワークの代替手段を提供します。
流行のクライアントサイドフレームワークとは、全てのロジックをフロントエンドに置いて、あなたのアプリのサーバーサイドをJSON APIに毛が生えたようなものに制限してしまうものです。

Turbo を使えば、サーバーにHTMLを直接配布させることができます。それはつまり、すべてのロジック、例えばパーミッションをチェックしたり、ドメインモデルとやりとりしたり、その他アプリケーションのプログラミングに関わるあらゆることを、多かれ少なかれ、お好みのプログラミング言語に限定して書くことができるということです。
もう、JSONに分たれた両側（クライアントサイドとサーバーサイド）に、同じロジックを複製して書かなくて良いのです。全てのロジックはサーバ上で動き、ブラウザは、最終的なHTMLを扱うだけになります。

Wire上でHTMLを扱うことの利点については、<a href="https://hotwired.dev/">Hotwireサイト</a>で詳しく知ることができます。以下は、Turboがこれを可能にするテクニックについて書いていきます。

<details>
<summary>原文</summary>

Turbo bundles several techniques for creating fast, modern, progressively enhanced web applications without using much JavaScript. It offers a simpler alternative to the prevailing client-side frameworks which put all the logic in the front-end and confine the server side of your app to being little more than a JSON API.

With Turbo, you let the server deliver HTML directly, which means all the logic for checking permissions, interacting directly with your domain model, and everything else that goes into programming an application can happen more or less exclusively within your favorite programming language. You're no longer mirroring logic on both sides of a JSON divide. All the logic lives on the server, and the browser deals just with the final HTML.

You can read more about the benefits of this HTML-over-the-wire approach on the <a href="https://hotwired.dev/">Hotwire site</a>. What follows are the techniques that Turbo brings to make this possible.
</details>

## Turbo ドライブ: 永続的プロセス内でのページの変更

今までのシングルページ・アプリケーションを、古臭くいちいちページ遷移するやり方と比べたときの主な魅力は、動作のスピードです。SPAがそのスピードを可能にできるのは、アプリケーションのプロセスをいちいち破棄することなく、本当にページが遷移する際にのみ初期化するからです。

Turboドライブは、それと同じスピードを、SPAと同じ永続的プロセスモデルによって可能にしています。ただしそのために、その枠組みにのっとったアプリケーションを職人芸で組み上げる必要はありません。メンテナンスの必要なクライアントサイドのルーターも、慎重に管理しなければならないステート（状態）もありません。永続的プロセスはTurboによって管理されるため、プログラマは自分のサーバーサイドのコードだけを書けばいいのです。まるで、ゼロ年代初頭ーーいまのSPAモンスターの複雑性と関わりなく穏やかだったころに、時が戻ったように！

これは、同じドメインにリンクされた`<a href>`がクリックされるたびに、それを横から掠め取ることで実現されます。具体的には、対象範囲のリンクをクリックするたび、Turboドライブは、ブラウザがそのリンクに遷移するのを押しとどめ、ブラウザのURLを<a href="https://developer.mozilla.org/ja/docs/Web/API/History">History API</a>を使って更新し、<a href="https://developer.mozilla.org/ja/docs/Web/API/fetch">`fetch`</a>を使って新しいページをリクエストし、それからHTMLレスポンスを描画します。

フォームでも同じ扱いをします。フォームがサブミットされると、それはTurboドライブの`fetch`リクエストに変換され、TurboドライブはそのリクエストからのリダイレクトとHTMLレスポンスの描画を行います。

描画中、Turboドライブは`<body>`要素の内容を置き換え、`<head>`要素の内容をマージします。JavaScriptの<a href="https://developer.mozilla.org/ja/docs/Web/API/Window">Window</a>と<a href="https://developer.mozilla.org/ja/docs/Web/API/Document">document objects</a>、そしてその`<html>` 要素は、前の描画から次の描画へと移る際も保持されます。


*Turboドライブと直接やり取りして、ユーザーのアクションがどのように画面遷移につながるか、リクエストのライフサイクルへフックするかを制御することもできますが、ほとんどの場合、いくつかの規約を採用することで、置き換え時のスピードを速くすることができます。

<details>
<summary>原文</summary>

A key attraction with traditional single-page applications, when compared with the old-school, separate-pages approach, is the speed of navigation. SPAs get a lot of that speed from not constantly tearing down the application process, only to reinitialize it on the very next page.

Turbo Drive gives you that same speed by using the same persistent-process model, but without requiring you to craft your entire application around the paradigm. There's no client-side router to maintain, there's no state to carefully manage. The persistent process is managed by Turbo, and you write your server-side code as though you were living back in the early aughts – blissfully isolated from the complexities of today's SPA monstrosities!

This happens by intercepting all clicks on `<a href>` links to the same domain. When you click an eligible link, Turbo Drive prevents the browser from following it, changes the browser’s URL using the <a href="https://developer.mozilla.org/en-US/docs/Web/API/History">History API</a>, requests the new page using <a href="https://developer.mozilla.org/en-US/docs/Web/API/fetch">`fetch`</a>, and then renders the HTML response.

Same deal with forms. Their submissions are turned into `fetch` requests from which Turbo Drive will follow the redirect and render the HTML response.

During rendering, Turbo Drive replaces the contents of the `<body>` element and merges the contents of the `<head>` element. The JavaScript window and document objects, and the `<html>` element, persist from one rendering to the next.

While it's possible to interact directly with Turbo Drive to control how visits happen or hook into the lifecycle of the request, the majority of the time this is a drop-in replacement where the speed is free just by adopting a few conventions.
</details>

## Turboフレーム: 複雑なページをパーツに分ける

多くのWebアプリケーションは、いくつかの独立したセグメントを含んだページを提供します。例えば意見を交わせるディスカッションのためのページであれば、トップにナビゲーションバー、中央にメッセージのリスト、下に新しいメッセージの投稿フォーム、そして関連トピックの並んだサイドバーといった具合です。このディスカッション・ページを生成しようとするなら、普通は、一連のやり方で各セグメントを生成し、それを一つにまとめて、その結果を単一のHTMLレスポンスとしてブラウザに送ることになるでしょう。

Turboフレームを使うと、これらの独立したセグメントを、それぞれ別のフレームに配置することができます。そのフレームは、自身のナビゲーションの範囲が限定されており、遅延して読み込まれる場合があります。範囲の限定されたナビゲーションとはつまり、フレーム内でのすべてのやり取り、たとえばリンクのクリックやフォームの送信がフレームの内側で起こり、ページの他の部分は更新やリロードが起こらないということです。

独立したセグメントを、それ専用のナビゲーション・コンテキスト内にラップするためには、`<turbo-frame>`で囲みます。
例としては下記のようになります。

```html
<turbo-frame id="new_message">
  <form action="/messages" method="post">
    ...
  </form>
</turbo-frame>
```

上記のフォームを送信した際、Turbo は、リダイレクトされた HTML レスポンスから`<turbo-frame id="new_message">`要素に合致する部分を抽出し、既存の`new_message`フレーム要素の中身と、取得した要素の内容を入れ替えます。ページ内の他の部分は、そのまま残ります。

フレームは、ナビゲーションの範囲を限定するだけでなく、その内容の読み込みを遅延させることもあります。フレームの読み込みを遅延させるためには、自動的に読み込まれるURLを値にもった`src`属性を付与します。範囲の限定されたナビゲーションを使って、Turboは結果のレスポンスから合致するフレームを探索・抽出し、内容を置き換えます。

```html
<turbo-frame id="messages" src="/messages">
  <p>This message will be replaced by the response from /messages.</p>
</turbo-frame>
```

これは、古めかしいフレーム、ともすると`<iframe>`のように思えるかもしれません。しかしTurboフレームは、同一のDOMの一部であり、"実際の"フレームと関連した奇妙さや妥協は一切ありません。Turboフレームは共通のCSSでスタイル付けされ、共通のJavaScriptのコンテキストの一部であり、どのような追加のコンテンツセキュリティ制限の下にも置かれません。

それぞれのセグメントを独立したコンテキストに変えるだけでなく、Turboフレームは下記のことを可能にします。

1.**効果的なキャッシュ**。以前、例に出したディスカッション・ページでは、関連話題を集めたサイドバーは、新しい関連トピックが現れるたびに一旦キャッシュを破棄する必要があります。しかしその際、中央のメッセージリストはキャッシュの破棄は必要ではありません。全てのものが単一ページを構成する場合、独立したセグメントのうちどれかがキャッシュを破棄すると、すべてのキャッシュが破棄されます。フレームを使えば、各セグメントは独立してキャッシュするため、より少ない独立キーで、より長持ちするキャッシュを得ることができます。
1.**並行実行**。遅延読み込みされるそれぞれのフレームは、それぞれ独自のHTTPリクエスト/レスポンスで生成されます。つまり、それぞれ個別のプロセスで扱うことが可能です。プロセスを手で管理することなしに、並行実行が可能になるのです。表示を完了するまで400msかかる複雑な構成のページは、フレームによって分割できるかもしれません。そのフレームは、最初のリクエストにたったの50msしかかからず、それぞれ三つの遅延読み込みのフレームにも50msずつかかるとしましょう。そうすると、全てのページは100msで表示を完了することができます。なぜなら、それぞれ三つのフレームは、一つずつ順番に処理されるのではなく、同時に実行されるからです。
1.**モバイル対応**。モバイルアプリでは、たいてい、大きくて複雑な構成のページにすることはできません。各セグメントは、その目的のためだけの画面を必要とします。Turboフレームで構成されたアプリケーションでは、複巣の要素を組み合わせたページを、それぞれのセグメントに分割する準備ができています。これらのセグメントはネイティブアプリのSheetやスクリーンに、そのまま使うことができます（というのも、各セグメントは、それぞれ専用のURLを持っているからです）。

<details>
<summary>原文</summary>

Most web applications present pages that contain several independent segments. For a discussion page, you might have a navigation bar on the top, a list of messages in the center, a form at the bottom to add a new message, and a sidebar with related topics. Generating this discussion page normally means generating each segment in a serialized manner, piecing them all together, then delivering the result as a single HTML response to the browser.

With Turbo Frames, you can place those independent segments inside frame elements that can scope their navigation and be lazily loaded. Scoped navigation means all interaction within a frame, like clicking links or submitting forms, happens within that frame, keeping the rest of the page from changing or reloading.

To wrap an independent segment in its own navigation context, enclose it in a `<turbo-frame>` tag. For example:

```html
<turbo-frame id="new_message">
  <form action="/messages" method="post">
    ...
  </form>
</turbo-frame>
```

When you submit the form above, Turbo extracts the matching `<turbo-frame id="new_message">` element from the redirected HTML response and swaps its content into the existing `new_message` frame element. The rest of the page stays just as it was.

Frames can also defer loading their contents in addition to scoping navigation. To defer loading a frame, add a `src` attribute whose value is the URL to be automatically loaded. As with scoped navigation, Turbo finds and extracts the matching frame from the resulting response and swaps its content into place:

```html
<turbo-frame id="messages" src="/messages">
  <p>This message will be replaced by the response from /messages.</p>
</turbo-frame>
```

This may sound a lot like old-school frames, or even `<iframe>`s, but Turbo Frames are part of the same DOM, so there's none of the weirdness or compromises associated with "real" frames. Turbo Frames are styled by the same CSS, part of the same JavaScript context, and are not placed under any additional content security restrictions.

In addition to turning your segments into independent contexts, Turbo Frames affords you:

1. **Efficient caching.** In the discussion page example above, the related topics sidebar needs to expire whenever a new related topic appears, but the list of messages in the center does not. When everything is just one page, the whole cache expires as soon as any of the individual segments do. With frames, each segment is cached independently, so you get longer-lived caches with fewer dependent keys.
1. **Parallelized execution.** Each defer-loaded frame is generated by its own HTTP request/response, which means it can be handled by a separate process. This allows for parallelized execution without having to manually manage the process. A complicated composite page that takes 400ms to complete end-to-end can be broken up with frames where the initial request might only take 50ms, and each of three defer-loaded frames each take 50ms. Now the whole page is done in 100ms because the three frames each taking 50ms run concurrently rather than sequentially.
1. **Ready for mobile.** In mobile apps, you usually can't have big, complicated composite pages. Each segment needs a dedicated screen. With an application built using Turbo Frames, you've already done this work of turning the composite page into segments. These segments can then appear in native sheets and screens without alteration (since they all have independent URLs).
</details>

## Turboストリーム: Deliver live page changes

非同期なアクションに応答してページの一部を変化させることで、アプリケーションをとても生き生きしたものできます。Turboフレームはそのような更新を、一つのフレーム内でのHTTPプロトコルでの直接のやりとりに応じて行います。一方で、Turboストリームは、ページのどの部分であってもその更新に、WebSocketコネクションやSSE（Sever-sent events）、その他のトランスポートを使います。(<a href="http://itsnotatypo.com">imbox</a>を見てください。ここでは、新しいemailの着信が、自動的に反映されます）。

Turboストリームは、`<turbo-stream>` 要素を、8つの基本のアクション、`append`、 `prepend`、 `replace`、 `update`、 `remove`、 `before`、 `after`、`refresh`とともに導入します。これらのアクションは、あなたが操作したい要素の ID を指定する`target`属性と一緒に使われます。そのアクションと`target`属性によって、ページをリフレッシュするのに必要とされる全てのミューテーションをエンコードできます。いくつかのストリーム要素を一つのストリームメッセージにまとめることさえできます。簡単に、挿入や置き換えをしたい HTML を`<a href="https://developer.mozilla.org/ja/docs/Web/HTML/Element/template">template tag</a>`で囲います。あとはTurboがやってくれます。

```html
<turbo-stream action="append" target="messages">
  <template>
    <div id="message_1">My new message!</div>
  </template>
</turbo-stream>
```

このストリーム要素は、My new message! を含んだ`div`を取得し、ID`messages`のついたコンテナに追加します。
次のコードは、既存の要素を置き換えるだけです。

```html
<turbo-stream action="replace" target="message_1">
  <template>
    <div id="message_1">This changes the existing message!</div>
  </template>
</turbo-stream>
```

Turboストリームは、かつてのRailsの世界、初めは<a href="https://weblog.rubyonrails.org/2006/3/28/rails-1-1-rjs-active-record-respond_to-integration-tests-and-500-other-things/">RJS</a>と呼ばれ、次に<a href="https://signalvnoise.com/posts/3697-server-generated-javascript-responses">SJR</a>と呼ばれたものと概念的に連続しています。けれど、それをJavaScriptを書く必要がなく実現しています。
それらの利点は維持されています。

1. **サーバーサイドテンプレートの再利用**: リアルタイムなページの変更は、最初にページがロードされた時に使われたのと同じサーバサイドテンプレートを使って生成されています。
1. **Wire上のHTML**: 送っているものは全てHTMLなので、プロセスを更新するのにクライアントサイドのJavascriptは、必要ありません(もちろん、Turboの後ろでは動いてますが)。そう、HTMLのペイロードは、同等の内容のJSONよりも少し大きいかもしれません。gzip を使うことで、たいていは、その差異は無視できるものです。そして、JSONを取得して、HTMLに変換するのに必要な全てのクライアントサイドの労力を節約できます。
1. **より単純な制御フロー**: WebSocket、SSEやフォーム時の送信に対してのメッセージが来たときに、次に何が起こるかは明らかです。そこには、ルーティングやイベントの連鎖、そのほかの必要な回り道はありません。どのように変化するかを教えてくれるシングルタグに囲まれたHTMLが変更されるだけです。


今や、RJSとSJRと違って、Turboストリームの部品として、独自に定義したJavaScriptの関数を呼ぶことはできません。しかし、これは特色であって、バグではありません。独自に定義したJavaScript関数を呼ぶようなテクニックは、レスポンスにともなって、あまりに多くのJavaScriptが送られるようになる時、容易にこんがらかった混沌を生み出してしまいます。Turboは、DOMを更新することだけに、正面から取り組みます。そして、そのほかの振る舞いについては、 <a href="https://stimulus.hotwired.dev">Stimulus</a>のアクションを使ってライフサイクル・コールバックと結びつけることを期待しています。

<details>
<summary>原文</summary>

Making partial page changes in response to asynchronous actions is how we make the application feel alive. While Turbo Frames give us such updates in response to direct interactions within a single frame, Turbo Streams let us change any part of the page in response to updates sent over a WebSocket connection, SSE or other transport. (Think an <a href="http://itsnotatypo.com">imbox</a> that automatically updates when a new email arrives.)

Turbo Streams introduces a `<turbo-stream>` element with eight basic actions: `append`, `prepend`, `replace`, `update`, `remove`, `before`, `after`, and `refresh`. With these actions, along with the `target` attribute specifying the ID of the element you want to operate on, you can encode all the mutations needed to refresh the page. You can even combine several stream elements in a single stream message. Simply include the HTML you're interested in inserting or replacing in a <a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/template">template tag</a> and Turbo does the rest:

```html
<turbo-stream action="append" target="messages">
  <template>
    <div id="message_1">My new message!</div>
  </template>
</turbo-stream>
```

This stream element will take the `div` with the new message and append it to the container with the ID `messages`. It's just as simple to replace an existing element:

```html
<turbo-stream action="replace" target="message_1">
  <template>
    <div id="message_1">This changes the existing message!</div>
  </template>
</turbo-stream>
```

This is a conceptual continuation of what in the Rails world was first called <a href="https://weblog.rubyonrails.org/2006/3/28/rails-1-1-rjs-active-record-respond_to-integration-tests-and-500-other-things/">RJS</a> and then called <a href="https://signalvnoise.com/posts/3697-server-generated-javascript-responses">SJR</a>, but realized without any need for JavaScript. The benefits remain the same:

1. **Reuse the server-side templates**: Live page changes are generated using the same server-side templates that were used to create the first-load page.
1. **HTML over the wire**: Since all we're sending is HTML, you don't need any client-side JavaScript (beyond Turbo, of course) to process the update. Yes, the HTML payload might be a tad larger than a comparable JSON, but with gzip, the difference is usually negligible, and you save all the client-side effort it takes to fetch JSON and turn it into HTML.
1. **Simpler control flow**: It's really clear to follow what happens when messages arrive on the WebSocket, SSE or in response to form submissions. There's no routing, event bubbling, or other indirection required. It's just the HTML to be changed, wrapped in a single tag that tells us how.

Now, unlike RJS and SJR, it's not possible to call custom JavaScript functions as part of a Turbo Streams action. But this is a feature, not a bug. Those techniques can easily end up producing a tangled mess when way too much JavaScript is sent along with the response. Turbo focuses squarely on just updating the DOM, and then assumes you'll connect any additional behavior using <a href="https://stimulus.hotwired.dev">Stimulus</a> actions and lifecycle callbacks.
</details>

## Turboネイティブ: iOSとAndroid両用のハイブリッド・アプリケーション

Turboネイティブは、iOSとAndroid両用のハイブリッド・アプリケーションを構築するための理想です。サーバーサイドでレンダリングされた既存のHTMLを使って、ネイティブ・ラッパーにアプリの機能性の基礎的な範囲を確保することができます。そして、節約したすべての時間を、非常に忠実度の高いネイティブ・コントローラーから利益を得られるいくつかの画面をよりよくすることに使うことができるのです。

Basecampのようなアプリケーションは、何百もの画面を持っています。これらの画面の一つ一つを書き直すのは、骨折りばかりが膨大で、得られるものはほとんどありません。ネイティブならではの火力は、ハイ・ファイを必要とする高度なタッチ性能に取っておくほうがいいでしょう。Basecampのinbox内の”新着お知らせ"といった機能は、たとえば、使用感がしっくりくるスワイプコントロールの使い所です。しかしほとんどのページ、たとえば単独のメッセージを表示するようなページでは、完全なネイディブで作ったからといって、特に得られるものはありません。

ハイブリッドでアプリを作ると、開発プロセスをスピードアップするだけでなく、より自由に、遅くて厄介なアプリストアのリリースプロセスを経ることなくアプリを更新できるようになります。HTMLで完結するものはなんでも、Webアプリケーション内で変更し、すぐに全てのユーザーに届けられます。ビッグ・テックが変更を受け入れるのも、ユーザーがアプリを更新するのも待つことはありません。

TurboネイディブはiOSとAndoroidのために利用可能な推奨開発プラクティスを利用することを前提としています。Turboネイティブは、ネイティブのAPIを抽象化して遠ざけたフレームワークではありません。また、ネイティブコードを、プラットフォーム間で共用できるようにする試みでさえありません。共用部分は、HTMLです。このHTMLは、サーバーサイドでレンダリングされます。しかし、ネイティブの制御は推奨されるネイディブのAPIで書かれます。

より詳しいドキュメントは<a href="https://github.com/hotwired/turbo-ios">Turboネイティブ: iOS</a>と<a href="https://github.com/hotwired/turbo-android">Turboネイティブ: Android</a> のリポジトリを見てください。Turboの力でどんなかっこいいアプリが作られるかを感じるには、HEYのネイティブアプリ<a href="https://apps.apple.com/us/app/hey-email/id1506603805">iOS版</a> と <a href="https://play.google.com/store/apps/details?id=com.basecamp.hey&hl=en_US&gl=US">Android版</a>を見てください。

<details>
<summary>原文</summary>

Turbo Native is ideal for building hybrid apps for iOS and Android. You can use your existing server-rendered HTML to get baseline coverage of your app's functionality in a native wrapper. Then you can spend all the time you saved on making the few screens that really benefit from high-fidelity native controls even better.

An application like Basecamp has hundreds of screens. Rewriting every single one of those screens would be an enormous task with very little benefit. Better to reserve the native firepower for high-touch interactions that really demand the highest fidelity. Something like the "New For You" inbox in Basecamp, for example, where we use swipe controls that need to feel just right. But most pages, like the one showing a single message, wouldn't really be any better if they were completely native.

Going hybrid doesn't just speed up your development process, it also gives you more freedom to upgrade your app without going through the slow and onerous app store release processes. Anything that's done in HTML can be changed in your web application, and instantly be available to all users. No waiting for Big Tech to approve your changes, no waiting for users to upgrade.

Turbo Native assumes you're using the recommended development practices available for iOS and Android. This is not a framework that abstracts native APIs away or even tries to let your native code be shareable between platforms. The part that's shareable is the HTML that's rendered server-side. But the native controls are written in the recommended native APIs.

See the <a href="https://github.com/hotwired/turbo-ios">Turbo Native: iOS</a> and <a href="https://github.com/hotwired/turbo-android">Turbo Native: Android</a> repositories for more documentation. See the native apps for HEY on <a href="https://apps.apple.com/us/app/hey-email/id1506603805">iOS</a> and <a href="https://play.google.com/store/apps/details?id=com.basecamp.hey&hl=en_US&gl=US">Android</a> to get a feel for just how good you can make a hybrid app powered by Turbo.
</details>

## バックエンド・フレームワークとの統合

Turboを使うのに、バックエンド・フレームワークは必要ありません。全ての機能は、さらなる抽象化なしに、直接に使われるように設計されています。しかし、もしTurboと統合されたバックエンド・フレームワークを使う機会があるのなら、人生はより単純になるでしょう。[その中のRuby on Railsむけの統合のための実装例がこちらです。](https://github.com/hotwired/turbo-rails).

<details>
<summary>原文</summary>

You don't need any backend framework to use Turbo. All the features are built to be used directly, without further abstractions. But if you have the opportunity to use a backend framework that's integrated with Turbo, you'll find life a lot simpler. [We've created a reference implementation for such an integration for Ruby on Rails](https://github.com/hotwired/turbo-rails).
</details>
