---
permalink: /handbook/streams.html
description: "Turbo Streams deliver page changes over WebSocket, SSE or in response to form submissions using just HTML and a set of CRUD-like actions."
---

[DHHの許諾](https://github.com/hotwired/turbo-site/issues/96)のもと、[公式のTurboHandbook](https://turbo.hotwired.dev/handbook/introduction)を[オリジナル](https://github.com/hotwired/turbo-site/commit/59943d962b37a02c1dcb68ebaa1057f713a45975)として、翻訳をしています。
このサイトの全ての文責は、[株式会社万葉](https://everyleaf.com/)にあります。

# Come Alive with Turbo Streams
# Turboストリームを利用してみよう

Turbo Streams deliver page changes as fragments of HTML wrapped in self-executing `<turbo-stream>` elements. Each stream element specifies an action together with a target ID to declare what should happen to the HTML inside it. These elements are delivered by the server over a WebSocket, SSE or other transport to bring the application alive with updates made by other users or processes. A new email arriving in your <a href="http://itsnotatypo.com">imbox</a> is a great example.

Turboストリームは、ページの変更をTurboで実行可能な`<turbo-stream>`要素で囲んだHTMLの一部として配信します。
それぞれのストリーム要素は、ターゲットIDと一緒にアクションを明記することで、ストリーム要素の中でHTMLに対してどのような変更が起こるべきかを宣言できます。これらの要素は、WebSocketやSSEや他の通信を介してサーバーから配信されます。そうすることで、他のユーザーやプロセスによる更新をアプリケーションに即座に反映できます。<a href="http://itsnotatypo.com">imbox</a>に一通の新着メールが届いた時が、良い例の一つです。

## Stream Messages and Actions
## メッセージとアクションの配信

A Turbo Streams message is a fragment of HTML consisting of `<turbo-stream>` elements. The stream message below demonstrates the seven possible stream actions:

一つのTurboストリームメッセージは、`<turbo-stream>`要素から構成されるHTMLの一部です。そのストリームメッセージは、下記の7つの実行可能なストリームアクションを示します。

```html
<turbo-stream action="append" target="messages">
  <template>
    <div id="message_1">
      This div will be appended to the element with the DOM ID "messages".
      この div は、DOM IDが"messages"である要素内の最後に追加されます。
    </div>
  </template>
</turbo-stream>

<turbo-stream action="prepend" target="messages">
  <template>
    <div id="message_1">
      This div will be prepended to the element with the DOM ID "messages".
      この div は、DOM IDが"messages"である要素内の最初に追加されます。
    </div>
  </template>
</turbo-stream>

<turbo-stream action="replace" target="message_1">
  <template>
    <div id="message_1">
      This div will replace the existing element with the DOM ID "message_1".
      この div は、DOM IDが"message_1"である既存要素と取り変わります。
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
    <!-- このテンプレートの内容は、DOM IDが"unread_count"である要素の内容を
    innerHTML を空に設定したうえで、テンプレート内の内容と取り変わります。
    "unread_count"な要素に結び付けられているどのハンドラーも保持されます。
    この挙動は、上記の"replace"アクションと対照的です。
    なぜなら、"replace"アクションでは、ハンドラーを再構築する必要があるためです。
    -->
    1
  </template>
</turbo-stream>

<turbo-stream action="remove" target="message_1">
  <!-- The element with DOM ID "message_1" will be removed.
  The contents of this stream element are ignored. -->
  <!-- DOM IDが"message_1の要素は取り除かれます。
  このストリーム要素の内容は無視されます。-->
</turbo-stream>

<turbo-stream action="before" target="current_step">
  <template>
    <!-- The contents of this template will be added before the
    the element with ID "current_step". -->
    <!-- このテンプレートの内容は、DOM IDが"current_step"である要素の直前に追加されます。-->
    <li>New item</li>
  </template>
</turbo-stream>

<turbo-stream action="after" target="current_step">
  <template>
    <!-- The contents of this template will be added after the
    the element with ID "current_step". -->
    <!-- このテンプレートの内容は、DOM IDが"current_step"である要素の直後に追加されます。-->
    <li>New item</li>
  </template>
</turbo-stream>
```

Note that every `<turbo-stream>` element must wrap its included HTML inside a `<template>` element.
全ての`<turbo-stream>`要素は、その中に含まれるHTMLを一つの`<template>`要素で包まなければならないことを注意してください。

You can render any number of stream elements in a single stream message from a WebSocket, SSE or in response to a form submission.
WebSocket、SSEやフォーム送信の応答としての1つのストリームメッセージの中で、任意の数のストリーム要素もレンダリングできます。

## Actions With Multiple Targets
## 複数のターゲットを利用したアクション

Actions can be applied against multiple targets using the `targets` attribute with a CSS query selector, instead of the regular `target` attribute that uses a dom ID reference. Examples:
アクションは、DOM IDの参照を利用した普通の`target`属性を利用する代わりに、CSS のクエリセレクターの `targets` 属性を利用することで、複数のターゲットに対して適用されます。
例は、下記になります。

```html
<turbo-stream action="remove" targets=".old_records">
  <!-- The element with the class "old_records" will be removed.
  The contents of this stream element are ignored. -->
  <!-- class "old_records" を持つ要素は、取り除かれます。
  このストリーム要素の内容は、無視されます。 -->
</turbo-stream>

<turbo-stream action="after" targets="input.invalid_field">
  <template>
    <!-- The contents of this template will be added after the
    all elements that match "inputs.invalid_field". -->
    <!-- このテンプレートの内容は、"inputs.invalid_field"に合致する全ての要素の後に
    追加されます。　-->
    <span>Incorrect</span>
  </template>
</turbo-stream>
```

## Streaming From HTTP Responses
## HTTPレスポンスからのストリーミング

Turbo knows to automatically attach `<turbo-stream>` elements when they arrive in response to `<form>` submissions that declare a [MIME type][] of `text/vnd.turbo-stream.html`. When submitting a `<form>` element whose [method][] attribute is set to `POST`, `PUT`, `PATCH`, or `DELETE`, Turbo injects `text/vnd.turbo-stream.html` into the set of response formats in the request's [Accept][] header. When responding to requests containing that value in its [Accept][] header, servers can tailor their responses to deal with Turbo Streams, HTTP redirects, or other types of clients that don't support streams (such as native applications).
Turboは、[MIME type][]が`text/vnd.turbo-stream.html`である`<form>`送信に対する応答に自動的に`<turbo-stream>` 要素を付与します。
[method][]属性に`POST`,`PUT`,`PATCH`や`DELETE`が設定されている`<form>`要素の送信時に、
Turboは、[Accept][]リクエストヘッダー内のレスポンスフォーマットのセットに`text/vnd.turbo-stream.html`を差し込みます。
[Accept][]リクエストヘッダー内にそのフォーマットを含むリクエストに応答するとき、
サーバーは、Turboストリーム、HTTPリダイレクトやストリームをサポートしない他のクライアントタイプ（ネイティブアプリケーションのような）に対応するために、レスポンスを調整できます。

In a Rails controller, this would look like:
Railsのコントローラー内では、このようになります。

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

[MIME type]: https://developer.mozilla.org/ja/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
[method]: https://developer.mozilla.org/ja/docs/Web/HTML/Element/form#attr-method
[Accept]: https://developer.mozilla.org/ja/docs/Web/HTTP/Headers/Accept

## Reusing Server-Side Templates
## サーバーサイドテンプレートの再利用

The key to Turbo Streams is the ability to reuse your existing server-side templates to perform live, partial page changes. The HTML template used to render each message in a list of such on the first page load is the same template that'll be used to add one new message to the list dynamically later. This is at the essence of the HTML-over-the-wire approach: You don't need to serialize the new message as JSON, receive it in JavaScript, render a client-side template. It's just the standard server-side templates reused.

Turboストリームの秘訣は、ライブ的な部分的なページの変更を実現するのに既存のサーバーサイドテンプレートを再利用できることです。
最初にページがロードされた時にリスト表示されるメッセージそれぞれを描画するために使われるHTMLテンプレートは、後でリストに新しく1つのメッセージを動的に追加する際に使われるテンプレートと同じです。
これが、HTMLオーバーザワイヤーアプローチの本質です。JSON 形式で新しいメッセージをシリアライズし、JavaScript でそれを受け取り、1つのクライアントサイドのテンプレートとして描画する必要はないのです。ただ、標準的なサーバーサイドのテンプレートとして再利用するだけです。

Another example from how this would look in Rails:
Railsでどのように動くか他の例を見てみましょう。

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
新しくメッセージを作成するためのフィームが、`MessagesController#create`アクションに送信する時、`MessagesController#index`内でメッセージ一覧を描画する際に利用したのと全く同じ
部分テンプレートが、Turboストリームアクションを描画するのに利用されます。下記のようなレスポンスとして伝わります。

```html
Content-Type: text/vnd.turbo-stream.html; charset=utf-8

<turbo-stream action="append" target="messages">
  <template>
    <div id="message_1">
      The content of the message.
      メッセージの内容
    </div>
  </template>
</turbo-stream>
```

This `messages/message` template partial can then also be used to re-render the message following an edit/update operation. Or to supply new messages created by other users over a WebSocket or a SSE connection. Being able to reuse the same templates across the whole spectrum of use is incredibly powerful, and key to reducing the amount of work it takes to create these modern, fast applications.
そして、この`messages/message`部分テンプレートは、他にも続く編集や更新操作でメッセージを再描画するためにも利用されます。さらに、WebSocketやSSEコネクション上で他のユーザーに
新しく作成されたメッセージを伝えるのにも利用されます。全ての領域で同じテンプレートを再利用できるのは、非常に強力です。さらにモダンで速いアプリケーションを作るためにかかる時間の削減する
秘訣にもなります。

## Progressively Enhance When Necessary
## 必要になった時に、段階的に利用していく

It's good practice to start your interaction design without Turbo Streams. Make the entire application work as it would if Turbo Streams were not available, then layer them on as a level-up. This means you won't come to rely on the updates for flows that need to work in native applications or elsewhere without them.
Turboストリームを利用しないで、相互作用的なデザインを始めるのもおすすめします。たとえ、Turboストリームを利用しなくても、かつてのようにアプリケーション全体を動作させられます。
そして、レベルアップとしてTurboストリームの層を追加していけます。つまり、Turboストリームを利用しないで、ネイティブアプリケーションなどを動作させる必要がある場合でも、アップデートをする必要はありません。

The same is especially true for WebSocket updates. On poor connections, or if there are server issues, your WebSocket may well get disconnected. If the application is designed to work without it, it'll be more resilient.
特に同様のことが、WebSocketの更新にも言えます。コネクションが弱く、サーバー側に問題があるならば、WebSocketは、利用しない方が良いでしょう。
もし、アプリケーションがWebSocketが無くても動くようにデザインされているならば、より弾力性を持つでしょう。

## But What About Running JavaScript?
## JavaScript の実行に関してはどうでしょう？

Turbo Streams consciously restricts you to seven actions: append, prepend, (insert) before, (insert) after, replace, update, and remove. If you want to trigger additional behavior when these actions are carried out, you should attach behavior using <a href="https://stimulus.hotwired.dev">Stimulus</a> controllers. This restriction allows Turbo Streams to focus on the essential task of delivering HTML over the wire, leaving additional logic to live in dedicated JavaScript files.
Turboストリームは、意図的に7つのアクションを利用するように制限します。それは、append, prepend, (insert) before, (insert) after, replace, update と remove です。
もしアクションが実行されたときに、追加の挙動をトリガーしたいならば、[Stimulus](https://stimulus.hotwired.dev)コントローラーを利用することで、その挙動を実現すべきです。
この制限は、Turboストリームがワイヤー上でのHTML配信という必要不可欠なタスクに専念することができ、追加のロジックはJavaScript専用のファイル内に留めます。

Embracing these constraints will keep you from turning individual responses in a jumble of behaviors that cannot be reused and which make the app hard to follow. The key benefit from Turbo Streams is the ability to reuse templates for initial rendering of a page through all subsequent updates.
これらの制約を守ることで、再利用できないず、アプリを複雑にするような理解し難い複雑な挙動に個々に応答するような状態を防げるでしょう。
Turboストリームの重要な利点は、続けて起こる全ての更新を通して、最初にページをレンダーするために利用したテンプレートを再利用できる点にあります。

## Integration with Server-Side Frameworks

Of all the techniques that are included with Turbo, it's with Turbo Streams you'll see the biggest advantage from close integration with your backend framework. As part of the official Hotwire suite, we've created a reference implementation for what such an integration can look like in the <a href="https://github.com/hotwired/turbo-rails">turbo-rails gem</a>. This gem relies on the built-in support for both WebSockets and asynchronous rendering present in Rails through the Action Cable and Active Job frameworks, respectively.

Using the <a href="https://github.com/hotwired/turbo-rails/blob/main/app/models/concerns/turbo/broadcastable.rb">Broadcastable</a> concern mixed into Active Record, you can trigger WebSocket updates directly from your domain model. And using the <a href="https://github.com/hotwired/turbo-rails/blob/main/app/models/turbo/streams/tag_builder.rb">Turbo::Streams::TagBuilder</a>, you can render `<turbo-stream>` elements in inline controller responses or dedicated templates, invoking the five actions with associated rendering through a simple DSL.

Turbo itself is completely backend-agnostic, though. So we encourage other frameworks in other ecosystems to look at the reference implementation provided for Rails to create their own tight integration.

Alternatively, a straightforward way to integrate any backend application with Turbo Streams is to rely on [the Mercure protocol](https://mercure.rocks). Mercure defines a convenient way for server applications to broadcast page changes to every connected clients through [Server-Sent Events (SSE)](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events). [Learn how to use Mercure with Turbo Streams](https://mercure.rocks/docs/ecosystem/hotwire).
