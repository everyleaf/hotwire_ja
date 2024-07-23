---
title: "Turbo ストリームを利用してみよう"
description: "Turbo ストリームは、WebSocketやSSEを利用して、またはフォームの送信に応答して、HTMLと一連のCRUDのようなアクションを使用してページの変更を配信します。"
---

# Turbo ストリームを利用してみよう

Turbo ストリームは、ページの変更を `<turbo-stream>` 要素で囲んだ HTML の一部として配信します。
それぞれのストリーム要素は、ターゲット ID と一緒にアクションを明記することで、ストリーム要素の中で HTML に対してどのような変更が起こるべきかを宣言できます。これらの要素はブラウザへ、古典的なHTTPレスポンスで同期的に配信も可能ですし、非同期的にWebSocket や SSE や他の通信を介して配信もできます。。そうすることで、他のユーザーやプロセスによる更新をアプリケーションに即座に反映できます。

Turbo ストリームは、リストからの要素の削除といったユーザーのアクションを、ページ全体の再読み込みなしで局地的に正確に反映するのに使われます。また、リモートユーザーが新しい発言を送信した際にチャットの末尾にその発言を追加するといった、リアルタイム機能を実装するのにも使われます。

<details>
<summary>原文</summary>

# Come Alive with Turbo Streams

Turbo Streams deliver page changes as fragments of HTML wrapped in `<turbo-stream>` elements. Each stream element specifies an action together with a target ID to declare what should happen to the HTML inside it. These elements can be delivered to the browser synchronously as a classic HTTP response, or asynchronously over transports such as webSockets, SSE, etc, to bring the application alive with updates made by other users or processes.

They can be used to surgically update the DOM after a user action such as removing an element from a list without reloading the whole page, or to implement real-time capabilities such as appending a new message to a live conversation as it is sent by a remote user.
</details>

## メッセージとアクションの配信

一つの Turbo ストリームメッセージは、`<turbo-stream>` 要素から構成される HTML の一部です。そのストリームメッセージは、下記の8つの実行可能なストリームアクションを示します。

```html
<turbo-stream action="append" target="messages">
  <template>
    <div id="message_1">
      この div は、DOM ID が "messages" である要素内の最後に追加されます。
    </div>
  </template>
</turbo-stream>

<turbo-stream action="prepend" target="messages">
  <template>
    <div id="message_1">
      この div は、DOM ID が "messages" である要素内の最初に追加されます。
    </div>
  </template>
</turbo-stream>

<turbo-stream action="replace" target="message_1">
  <template>
    <div id="message_1">
      この div は、DOM ID が "message_1" である既存要素と置き換えられます。
    </div>
  </template>
</turbo-stream>

<turbo-stream action="update" target="unread_count">
  <template>
    <!-- このテンプレートの内容は、DOM ID が "unread_count" である要素の内容を
    innerHTML を空に設定したうえで、テンプレート内の内容と置き換えます。
    "unread_count" な要素に結び付けられているどのハンドラーも保持されます。
    この挙動は、上記の "replace" アクションと対照的です。
    なぜなら、"replace" アクションでは、ハンドラーを再構築する必要があるためです。
    -->
    1
  </template>
</turbo-stream>

<turbo-stream action="remove" target="message_1">
  <!-- DOM ID が "message_1" の要素は取り除かれます。
  このストリーム要素の内容は無視されます。-->
</turbo-stream>

<turbo-stream action="before" target="current_step">
  <template>
    <!-- このテンプレートの内容は、DOM ID が "current_step" である要素の直前に追加されます。-->
    <li>新しいアイテム</li>
  </template>
</turbo-stream>

<turbo-stream action="after" target="current_step">
  <template>
    <!-- このテンプレートの内容は、DOM ID が "current_step" である要素の直後に追加されます。-->
    <li>新しいアイテム</li>
  </template>
</turbo-stream>


<turbo-stream action="morph" target="current_step">
  <template>
    <!-- このテンプレートの内容はモーフィングを介して DOM ID が"current_step" である要素を置き換えます。 -->
    <li>新しいアイテム</li>
  </template>
</turbo-stream>

<turbo-stream action="morph" target="current_step" children-only>
  <template>
    <!-- このテンプレートの内容はモーフィングを介して DOM ID が"current_step" である要素の子要素を置き換えます。 -->
    <li>新しいアイテム</li>
  </template>
</turbo-stream>

<turbo-stream action="refresh" request-id="abcd-1234"></turbo-stream>
```

全ての `<turbo-stream>` 要素は、その中に含まれる HTML を一つの `<template>` 要素で包まなければならないことに注意してください。

Turboストリームは、ドキュメント内のどんな要素でも、[id](https://developer.mozilla.org/ja/docs/Web/HTML/Global_attributes/id)属性か[CSS セレクター](https://developer.mozilla.org/ja/docs/Web/CSS/CSS_Selectors) で解決できるものなら統合できます。対象の要素を[`<turbo-frame>`要素](/trubo/handbook/frames)に入れる必要はありません。もしアプリケーションで `<turbo-stream>` 要素のために`<turbo-frame>` 要素を使っているのなら、`<turbo-frame>` を他の [組み込み要素](https://developer.mozilla.org/ja/docs/Web/HTML/Element) に変更しましょう。

WebSocket、SSE やフォーム送信の応答としての 1 つのストリームメッセージの中で、任意の数のストリーム要素をレンダリングできます。

<details>
<summary>原文</summary>
A Turbo Streams message is a fragment of HTML consisting of `<turbo-stream>` elements. The stream message below demonstrates the eight possible stream actions:

```html
<turbo-stream action="append" target="messages">
  <template>
    <div id="message_1">
      This div will be appended to the element with the DOM ID "messages".
    </div>
  </template>
</turbo-stream>

<turbo-stream action="prepend" target="messages">
  <template>
    <div id="message_1">
      This div will be prepended to the element with the DOM ID "messages".
    </div>
  </template>
</turbo-stream>

<turbo-stream action="replace" target="message_1">
  <template>
    <div id="message_1">
      This div will replace the existing element with the DOM ID "message_1".
    </div>
  </template>
</turbo-stream>

<turbo-stream action="update" target="unread_count">
  <template>
    <!-- The contents of this template will replace the
    contents of the element with ID "unread_count" by
    setting innerHtml to "" and then switching in the
    template contents. Any handlers bound to the element
    "unread_count" would be retained. This is to be
    contrasted with the "replace" action above, where
    that action would necessitate the rebuilding of
    handlers. -->
    1
  </template>
</turbo-stream>

<turbo-stream action="remove" target="message_1">
  <!-- The element with DOM ID "message_1" will be removed.
  The contents of this stream element are ignored. -->
</turbo-stream>

<turbo-stream action="before" target="current_step">
  <template>
    <!-- The contents of this template will be added before the
    the element with ID "current_step". -->
    <li>New item</li>
  </template>
</turbo-stream>

<turbo-stream action="after" target="current_step">
  <template>
    <!-- The contents of this template will be added after the
    the element with ID "current_step". -->
    <li>New item</li>
  </template>
</turbo-stream>

<turbo-stream action="morph" target="current_step">
  <template>
    <!-- The contents of this template will replace the
    element with ID "current_step" via morph. -->
    <li>New item</li>
  </template>
</turbo-stream>

<turbo-stream action="morph" target="current_step" children-only>
  <template>
    <!-- The contents of this template will replace the
    children of the element with ID "current_step" via morph. -->
    <li>New item</li>
  </template>
</turbo-stream>

<turbo-stream action="refresh" request-id="abcd-1234"></turbo-stream>
```

Note that every `<turbo-stream>` element must wrap its included HTML inside a `<template>` element.

A Turbo Stream can integrate with any element in the document that can be
resolved by an [id](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/id) attribute or [CSS selector](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors) (with the exception of `<template>` element or `<iframe>` element content). It is not necessary to change targeted elements into [`<turbo-frame>` elements](/handbook/frames). If your application utilizes `<turbo-frame>` elements for the sake of a `<turbo-stream>` element, change the `<turbo-frame>` into another [built-in element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element).


You can render any number of stream elements in a single stream message from a WebSocket, SSE or in response to a form submission.

</details>

## 複数のターゲットを利用したアクション

アクションは、DOM ID の参照を利用した普通の `target` 属性の代わりに、CSS のクエリセレクターの `targets` 属性を利用することで、複数のターゲットに対して適用されます。
例は、下記になります。

```html
<turbo-stream action="remove" targets=".old_records">
  <!-- class "old_records" を持つ要素は、取り除かれます。
  このストリーム要素の内容は、無視されます。 -->
</turbo-stream>

<turbo-stream action="after" targets="input.invalid_field">
  <template>
    <!-- このテンプレートの内容は、"inputs.invalid_field" に合致する全ての要素の後に
    追加されます。　-->
    <span>間違っています</span>
  </template>
</turbo-stream>
```

<details>
<summary>原文</summary>

Actions can be applied against multiple targets using the `targets` attribute with a CSS query selector, instead of the regular `target` attribute that uses a dom ID reference. Examples:
```html
<turbo-stream action="remove" targets=".old_records">
  <!-- The element with the class "old_records" will be removed.
  The contents of this stream element are ignored. -->
</turbo-stream>
<turbo-stream action="after" targets="input.invalid_field">
  <template>
    <!-- The contents of this template will be added after the
    all elements that match "inputs.invalid_field". -->
    <span>Incorrect</span>
  </template>
</turbo-stream>
```


</details>
## HTTP レスポンスからのストリーミング

Turbo は、[MIME type](https://developer.mozilla.org/ja/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types) を `text/vnd.turbo-stream.html` と宣言した `<form>` 送信に対する応答に自動的に `<turbo-stream>` 要素を付与します。
[method](https://developer.mozilla.org/ja/docs/Web/HTML/Element/form#attr-method) 属性に `POST`, `PUT`, `PATCH` や `DELETE` が設定されている `<form>` 要素の送信時に、
Turbo は、[Accept](https://developer.mozilla.org/ja/docs/Web/HTTP/Headers/Accept) リクエストヘッダー内のレスポンスフォーマットのセットに `text/vnd.turbo-stream.html` を差し込みます。
[Accept](https://developer.mozilla.org/ja/docs/Web/HTTP/Headers/Accept) リクエストヘッダー内にそのフォーマットを含むリクエストに応答するとき、
サーバーは、Turbo ストリーム、HTTP リダイレクトやストリームをサポートしない他のクライアントタイプ（ネイティブアプリケーションのような）に対応するために、レスポンスを調整できます。

Rails のコントローラー内では、このようになります。

```ruby
def destroy
  @message = Message.find(params[:id])
  @message.destroy

  respond_to do |format|
    format.turbo_stream { render turbo_stream: turbo_stream.remove(@message) }
    format.html         { redirect_to messages_url }
  end
end
```

By default, Turbo doesn't add the `text/vnd.turbo-stream.html` MIME type when submitting links, or forms with a method type of `GET`. To use Turbo Streams responses with `GET` requests in an application you can instruct Turbo to include the MIME type by adding a `data-turbo-stream` attribute to a link or form.

デフォルトでは、Turbo は リンク、あるいは `GET` メソッドで送信されるフォームのサブミット時に `text/vnd.turbo-stream.html` にMIME タイプは付与しません。アプリケーション内でTruboストリームのレスポンスを `GET` メソッドのリクエストに使用したい時は、対象のリンクやフォームに `data-turbo-stream` 属性を追加します。この属性によって、Turbo は MIME タイプを含めるようになります。

<details>
<summary>原文</summary>
Turbo knows to automatically attach `<turbo-stream>` elements when they arrive in response to `<form>` submissions that declare a [MIME type][] of `text/vnd.turbo-stream.html`. When submitting a `<form>` element whose [method][] attribute is set to `POST`, `PUT`, `PATCH`, or `DELETE`, Turbo injects `text/vnd.turbo-stream.html` into the set of response formats in the request's [Accept][] header. When responding to requests containing that value in its [Accept][] header, servers can tailor their responses to deal with Turbo Streams, HTTP redirects, or other types of clients that don't support streams (such as native applications).
In a Rails controller, this would look like:

```ruby
def destroy
  @message = Message.find(params[:id])
  @message.destroy
  respond_to do |format|
    format.turbo_stream { render turbo_stream: turbo_stream.remove(@message) }
    format.html         { redirect_to messages_url }
  end
end
```

By default, Turbo doesn't add the `text/vnd.turbo-stream.html` MIME type when submitting links, or forms with a method type of `GET`. To use Turbo Streams responses with `GET` requests in an application you can instruct Turbo to include the MIME type by adding a `data-turbo-stream` attribute to a link or form.

[MIME type]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
[method]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form#attr-method
[Accept]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept

</details>
## サーバーサイドテンプレートの再利用

Turbo ストリームの秘訣は、ページの一部の動的な変更を実現するのに既存のサーバーサイドテンプレートを再利用できることです。
最初にページがロードされた時に、リストの各メッセージを描画するために利用する HTML テンプレートは、後でリストに新しく 1 つのメッセージを動的に追加する際に利用されるのと同じテンプレートです。
これが、HTML オーバーザワイヤーアプローチの本質です。JSON 形式で新しいメッセージをシリアライズし、JavaScript でそれを受け取り、1 つのクライアントサイドのテンプレートとして描画する必要はないのです。ただ、標準的なサーバーサイドのテンプレートとして再利用するだけです。

Rails でどのように動くか他の例を見てみましょう。

```erb
<!-- app/views/messages/_message.html.erb -->
<div id="<%= dom_id message %>">
  <%= message.content %>
</div>

<!-- app/views/messages/index.html.erb -->
<h1>全てのメッセージ</h1>
<%= render partial: "messages/message", collection: @messages %>
```

```ruby
# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def create
    message = Message.create!(params.require(:message).permit(:content))

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(:messages, partial: "messages/message",
          locals: { message: message })
      end

      format.html { redirect_to messages_url }
    end
  end
end
```

新しくメッセージを作成するためのフォームが、`MessagesController#create` アクションに送信する時、`MessagesController#index` 内でメッセージ一覧を描画する際に利用したのと全く同じ
部分テンプレートが、Turbo ストリームアクションを描画するのに利用されます。下記のようなレスポンスとして伝わります。

```html
Content-Type: text/vnd.turbo-stream.html; charset=utf-8

<turbo-stream action="append" target="messages">
  <template>
    <div id="message_1">メッセージの内容</div>
  </template>
</turbo-stream>
```

そして、この `messages/message` 部分テンプレートは他にも、続く編集や更新操作でメッセージを再描画するためにも利用されます。さらに、WebSocket や SSE コネクション上で他のユーザーに
新しく作成されたメッセージを伝えるのにも利用されます。全ての領域で同じテンプレートを再利用できるのは、非常に強力です。さらにモダンで速いアプリケーションを作るためにかかる時間を削減する
秘訣にもなります。

<details>
<summary>原文</summary>
The key to Turbo Streams is the ability to reuse your existing server-side templates to perform live, partial page changes. The HTML template used to render each message in a list of such on the first page load is the same template that'll be used to add one new message to the list dynamically later. This is at the essence of the HTML-over-the-wire approach: You don't need to serialize the new message as JSON, receive it in JavaScript, render a client-side template. It's just the standard server-side templates reused.
Another example from how this would look in Rails:
```erb
<!-- app/views/messages/_message.html.erb -->
<div id="<%= dom_id message %>">
  <%= message.content %>
</div>
<!-- app/views/messages/index.html.erb -->
<h1>All the messages</h1>
<%= render partial: "messages/message", collection: @messages %>
```
```ruby
# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end
  def create
    message = Message.create!(params.require(:message).permit(:content))
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(:messages, partial: "messages/message",
          locals: { message: message })
      end
      format.html { redirect_to messages_url }
    end
  end
end
```
When the form to create a new message submits to the `MessagesController#create` action, the very same partial template that was used to render the list of messages in `MessagesController#index` is used to render the turbo-stream action. This will come across as a response that looks like this:
```html
Content-Type: text/vnd.turbo-stream.html; charset=utf-8
<turbo-stream action="append" target="messages">
  <template>
    <div id="message_1">
      The content of the message.
    </div>
  </template>
</turbo-stream>
```
This `messages/message` template partial can then also be used to re-render the message following an edit/update operation. Or to supply new messages created by other users over a WebSocket or a SSE connection. Being able to reuse the same templates across the whole spectrum of use is incredibly powerful, and key to reducing the amount of work it takes to create these modern, fast applications.

</details>

## 必要になった時に、段階的に利用していく

Turbo ストリームを利用せずに、相互作用的なデザインを始めるのもおすすめします。たとえ Turbo ストリームが使えなくとも、アプリケーション全体が動作するように作りましょう。それから、レベルアップとして、Turbo ストリームの層を追加していくのです。
そうすれば、Turbo ストリームを利用しないで、ネイティブアプリケーションなどを動作させる必要がある場合でも、アップデートをする必要はありません。

同様のことが特に、WebSocket の更新にも言えます。コネクションが貧弱な場合や、サーバーに問題がある場合、WebSocket は接続が切れてしまいます。
もし、アプリケーションが WebSocket が無くても動くようにデザインされているならば、より弾力性を持つでしょう。

<details>
<summary>原文</summary>

It's good practice to start your interaction design without Turbo Streams. Make the entire application work as it would if Turbo Streams were not available, then layer them on as a level-up. This means you won't come to rely on the updates for flows that need to work in native applications or elsewhere without them.
The same is especially true for WebSocket updates. On poor connections, or if there are server issues, your WebSocket may well get disconnected. If the application is designed to work without it, it'll be more resilient.

</details>

## JavaScript の実行に関してはどうでしょう？

Turbo ストリームは、意図的に 8 つのアクションを利用するように制限します。それは、append, prepend, (insert) before, (insert) after, replace, update, remove そして refresh です。
もし上記のアクションが実行されたときに、追加の挙動をトリガーしたいならば、[Stimulus](https://stimulus.hotwired.dev) コントローラーを利用することで、その挙動を実現すべきです。
この制限によって、Turbo ストリームがワイヤー上での HTML 配信という必要不可欠なタスクに専念することができ、追加のロジックは JavaScript 専用のファイル内に留められます。

これらの制約を守ることで、再利用できず、アプリを複雑にするような理解し難い複雑な挙動に個々に応答するような状態を防げるでしょう。
Turbo ストリームの重要な利点は、続けて起こる全ての更新を通して、最初にページをレンダーするために利用したテンプレートを再利用できる点にあります。

<details>
<summary>原文</summary>

Turbo Streams consciously restricts you to eight actions: append, prepend, (insert) before, (insert) after, replace, update, remove, and refresh. If you want to trigger additional behavior when these actions are carried out, you should attach behavior using <a href="https://stimulus.hotwired.dev">Stimulus</a> controllers. This restriction allows Turbo Streams to focus on the essential task of delivering HTML over the wire, leaving additional logic to live in dedicated JavaScript files.

Embracing these constraints will keep you from turning individual responses into a jumble of behaviors that cannot be reused and which make the app hard to follow. The key benefit from Turbo Streams is the ability to reuse templates for initial rendering of a page through all subsequent updates.
</details>

## カスタム・アクション

デフォルトでは、Turbo ストリームは [`action` 属性に8つの値](/reference/streams#the-seven-actions)をサポートしています。もしアプリケーションが他の属性をサポートする必要が出てきたら、   `event.detail.render` 関数をオーバーライドしましょう。

例えば、8つのアクションに加えて `<turbo-stream>` 要素に`[action="alert"]` あるいは `[action="log"]` をサポートするよう拡張したい場合、`turbo:before-stream-render` リスナーにカスタムした振る舞いを宣言できます。


```javascript
addEventListener("turbo:before-stream-render", ((event) => {
  const fallbackToDefaultActions = event.detail.render

  event.detail.render = function (streamElement) {
    if (streamElement.action == "alert") {
      // ...
    } else if (streamElement.action == "log") {
      // ...
    } else {
      fallbackToDefaultActions(streamElement)
    }
  }
}))
```

`turbo:before-stream-render` イベントをリッスンする方法に加え、アプリケーションはアクションを`StreamActions` にプロパティとして直接宣言もできます。

In addition to listening for `turbo:before-stream-render` events, applications
can also declare actions as properties directly on `StreamActions`:

```javascript
import { StreamActions } from "@hotwired/turbo"

// <turbo-stream action="log" message="Hello, world"></turbo-stream>
//
StreamActions.log = function () {
  console.log(this.getAttribute("message"))
}
```
<details>
<summary>原文</summary>

By default, Turbo Streams support [eight values for its `action` attribute](/reference/streams#the-seven-actions). If your application needs to support other behaviors, you can override the `event.detail.render` function.

For example, if you'd like to expand upon the eight actions to support `<turbo-stream>` elements with `[action="alert"]` or `[action="log"]`, you could declare a `turbo:before-stream-render` listener to provide custom behavior:

```javascript
addEventListener("turbo:before-stream-render", ((event) => {
  const fallbackToDefaultActions = event.detail.render

  event.detail.render = function (streamElement) {
    if (streamElement.action == "alert") {
      // ...
    } else if (streamElement.action == "log") {
      // ...
    } else {
      fallbackToDefaultActions(streamElement)
    }
  }
}))
```

In addition to listening for `turbo:before-stream-render` events, applications
can also declare actions as properties directly on `StreamActions`:

```javascript
import { StreamActions } from "@hotwired/turbo"

// <turbo-stream action="log" message="Hello, world"></turbo-stream>
//
StreamActions.log = function () {
  console.log(this.getAttribute("message"))
}
```

</details>

## サーバーサイドフレームワークとの連携

Turbo に付随した全ての技術の中で、バックエンドフレームワークとの密な連携に関して最も大きな優位性があります。
公式の Hotwire スイートな部分として、[turbo-rails gem](https://github.com/hotwired/turbo-rails) 内で、どのように統合できるかの参考実装を作成しています。
この gem は、Rails 内の WebScoket と非同期なレンダリングに対する組み込み済みのサポートを、それぞれ Action Cable や Active Job フレームワークを利用して実現しています。

Active Record にミックスインされた [Broadcastable](https://github.com/hotwired/turbo-rails/blob/main/app/models/concerns/turbo/broadcastable.rb) を利用することで、
Webscoket の更新を直接ドメインモデルからトリガーできます。さらに [Turbo::Streams::TagBuilder](https://github.com/hotwired/turbo-rails/blob/main/app/models/turbo/streams/tag_builder.rb) を利用することで、インラインなコントローラーのレスポンスまたは専用テンプレート内で `<turbo-stream>` 要素をレンダリングできます。同時に、シンプルな DSL を通して、レンダリングに関する 5 つのアクションを実行できます。

しかしながら、Trubo 自体は、バックエンドに対して一切関知しません。他のエコシステム内の異なるフレームワークで密な統合を作成するためにも Rails に対する参考実装をみることを推奨します。

Turboの `<turbo-stream-source>` カスタム要素は要素の `[src]` 属性を通してストリームのソースへ接続します。srcの値を`ws://` あるいは `wss://` URL で宣言した場合、 裏でストリームするソースは [WebSocket][] インスタンスとなります。その他の形の宣言であれば、[EventSource][] を通しての接続になります。

要素がドキュメントと接続した際に、ストリームのソースも接続されます。要素の接続が切れたら、ストリームも接続が切られます。

ドキュメントの `<head>` はTurbo のナビゲーション間にわたって変わらないため、`<turbo-stream-source>` をドキュメントの `body` 要素にマウントするのが重要です。

Typical full page navigations driven by Turbo will result in the `<body>` contents
being discarded and replaced with the resulting document. It's the server's
responsibility to ensure that the element is present on any page that requires
streaming.
典型的には、Turbo による全ページのナビゲーションは `<body>` 内に宣言され、その中で結果のドキュメントに置き換えられます。サーバーの責務として、その要素はストリーミングを要求する全てのページに存在しなければならないからです。

バックエンドアプリケーションと Trubo ストリームを統合する、もう一つの簡単な方法は、[Mercure protocol](https://mercure.rocks) を利用することです。
Mercure は、サーバーアプリケーションに対して便利な方法を定義します。それは、ページの変更を [Server-Sent Events (SSE)](https://developer.mozilla.org/ja/docs/Web/API/Server-sent_events) を通して、全ての接続されたクライアントに送信できる方法です。[Learn how to use Mercure with Turbo Streams](https://mercure.rocks/docs/ecosystem/hotwire)

[WebSocket]: https://developer.mozilla.org/ja/docs/Web/API/WebSocket
[EventSource]: https://developer.mozilla.org/ja/docs/Web/API/EventSource

<details>
<summary>原文</summary>
Of all the techniques that are included with Turbo, it's with Turbo Streams you'll see the biggest advantage from close integration with your backend framework. As part of the official Hotwire suite, we've created a reference implementation for what such an integration can look like in the <a href="https://github.com/hotwired/turbo-rails">turbo-rails gem</a>. This gem relies on the built-in support for both WebSockets and asynchronous rendering present in Rails through the Action Cable and Active Job frameworks, respectively.
Using the <a href="https://github.com/hotwired/turbo-rails/blob/main/app/models/concerns/turbo/broadcastable.rb">Broadcastable</a> concern mixed into Active Record, you can trigger WebSocket updates directly from your domain model. And using the <a href="https://github.com/hotwired/turbo-rails/blob/main/app/models/turbo/streams/tag_builder.rb">Turbo::Streams::TagBuilder</a>, you can render `<turbo-stream>` elements in inline controller responses or dedicated templates, invoking the five actions with associated rendering through a simple DSL.

Turbo itself is completely backend-agnostic, though. So we encourage other frameworks in other ecosystems to look at the reference implementation provided for Rails to create their own tight integration.

Turbo's `<turbo-stream-source>` custom element connects to a stream source
through its `[src]` attribute. When declared with an `ws://` or `wss://` URL,
the underlying stream source will be a [WebSocket][] instance. Otherwise, the
connection is through an [EventSource][].

When the element is connected to the document, the stream source is
connected. When the element is disconnected, the stream is disconnected.

Since the document's `<head>` is persistent across Turbo navigations, it's
important to mount the `<turbo-stream-source>` as a descendant of the document's
`<body>` element.

Typical full page navigations driven by Turbo will result in the `<body>` contents
being discarded and replaced with the resulting document. It's the server's
responsibility to ensure that the element is present on any page that requires
streaming.

Alternatively, a straightforward way to integrate any backend application with Turbo Streams is to rely on [the Mercure protocol](https://mercure.rocks). Mercure defines a convenient way for server applications to broadcast page changes to every connected clients through [Server-Sent Events (SSE)](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events). [Learn how to use Mercure with Turbo Streams](https://mercure.rocks/docs/ecosystem/hotwire).

[WebSocket]: https://developer.mozilla.org/en-US/docs/Web/API/WebSocket
[EventSource]: https://developer.mozilla.org/en-US/docs/Web/API/EventSource
</details>
