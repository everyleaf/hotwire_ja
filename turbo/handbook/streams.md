---
permalink: /handbook/streams.html
description: "Turbo Streams deliver page changes over WebSocket, SSE or in response to form submissions using just HTML and a set of CRUD-like actions."
---

[DHH の許諾](https://github.com/hotwired/turbo-site/issues/96)のもと、[公式の TurboHandbook](https://turbo.hotwired.dev/handbook/introduction)を[オリジナル](https://github.com/hotwired/turbo-site/commit/59943d962b37a02c1dcb68ebaa1057f713a45975)として、翻訳をしています。
このサイトの全ての文責は、[株式会社万葉](https://everyleaf.com/)にあります。

# Turbo ストリームを利用してみよう

Turbo ストリームは、ページの変更を Turbo で実行可能な`<turbo-stream>`要素で囲んだ HTML の一部として配信します。
それぞれのストリーム要素は、ターゲット ID と一緒にアクションを明記することで、ストリーム要素の中で HTML に対してどのような変更が起こるべきかを宣言できます。これらの要素は、WebSocket や SSE や他の通信を介してサーバーから配信されます。そうすることで、他のユーザーやプロセスによる更新をアプリケーションに即座に反映できます。<a href="http://itsnotatypo.com">imbox</a>に一通の新着メールが届いた時が、良い例です。

## メッセージとアクションの配信

一つの Turbo ストリームメッセージは、`<turbo-stream>`要素から構成される HTML の一部です。そのストリームメッセージは、下記の 7 つの実行可能なストリームアクションを示します。

```html
<turbo-stream action="append" target="messages">
  <template>
    <div id="message_1">
      この div は、DOM ID が"messages"である要素内の最後に追加されます。
    </div>
  </template>
</turbo-stream>

<turbo-stream action="prepend" target="messages">
  <template>
    <div id="message_1">
      この div は、DOM ID が"messages"である要素内の最初に追加されます。
    </div>
  </template>
</turbo-stream>

<turbo-stream action="replace" target="message_1">
  <template>
    <div id="message_1">
      この div は、DOM ID が"message_1"である既存要素と置き換えられます。
    </div>
  </template>
</turbo-stream>

<turbo-stream action="update" target="unread_count">
  <template>
    <!-- このテンプレートの内容は、DOM ID が"unread_count"である要素の内容を
    innerHTML を空に設定したうえで、テンプレート内の内容と置き換えます。
    "unread_count"な要素に結び付けられているどのハンドラーも保持されます。
    この挙動は、上記の"replace"アクションと対照的です。
    なぜなら、"replace"アクションでは、ハンドラーを再構築する必要があるためです。
    -->
    1
  </template>
</turbo-stream>

<turbo-stream action="remove" target="message_1">
  <!-- DOM ID が"message_1"の要素は取り除かれます。
  このストリーム要素の内容は無視されます。-->
</turbo-stream>

<turbo-stream action="before" target="current_step">
  <template>
    <!-- このテンプレートの内容は、DOM ID が"current_step"である要素の直前に追加されます。-->
    <li>新しいアイテム</li>
  </template>
</turbo-stream>

<turbo-stream action="after" target="current_step">
  <template>
    <!-- このテンプレートの内容は、DOM ID が"current_step"である要素の直後に追加されます。-->
    <li>新しいアイテム</li>
  </template>
</turbo-stream>
```

全ての`<turbo-stream>`要素は、その中に含まれる HTML を一つの`<template>`要素で包まなければならないことに注意してください。
WebSocket、SSE やフォーム送信の応答としての 1 つのストリームメッセージの中で、任意の数のストリーム要素をレンダリングできます。

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
    <!-- このテンプレートの内容は、"inputs.invalid_field"に合致する全ての要素の後に
    追加されます。　-->
    <span>間違っています</span>
  </template>
</turbo-stream>
```

## HTTP レスポンスからのストリーミング

Turbo は、[MIME type](https://developer.mozilla.org/ja/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types)を `text/vnd.turbo-stream.html` と宣言した `<form>` 送信に対する応答に自動的に `<turbo-stream>` 要素を付与します。
[method](https://developer.mozilla.org/ja/docs/Web/HTML/Element/form#attr-method)属性に `POST`, `PUT`, `PATCH` や `DELETE` が設定されている `<form>` 要素の送信時に、
Turbo は、[Accept](https://developer.mozilla.org/ja/docs/Web/HTTP/Headers/Accept)リクエストヘッダー内のレスポンスフォーマットのセットに `text/vnd.turbo-stream.html` を差し込みます。
[Accept](https://developer.mozilla.org/ja/docs/Web/HTTP/Headers/Accept)リクエストヘッダー内にそのフォーマットを含むリクエストに応答するとき、
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

新しくメッセージを作成するためのフォームが、`MessagesController#create`アクションに送信する時、`MessagesController#index`内でメッセージ一覧を描画する際に利用したのと全く同じ
部分テンプレートが、Turbo ストリームアクションを描画するのに利用されます。下記のようなレスポンスとして伝わります。

```html
Content-Type: text/vnd.turbo-stream.html; charset=utf-8

<turbo-stream action="append" target="messages">
  <template>
    <div id="message_1">メッセージの内容</div>
  </template>
</turbo-stream>
```

そして、この`messages/message`部分テンプレートは他にも、続く編集や更新操作でメッセージを再描画するためにも利用されます。さらに、WebSocket や SSE コネクション上で他のユーザーに
新しく作成されたメッセージを伝えるのにも利用されます。全ての領域で同じテンプレートを再利用できるのは、非常に強力です。さらにモダンで速いアプリケーションを作るためにかかる時間を削減する
秘訣にもなります。

## 必要になった時に、段階的に利用していく

Turbo ストリームを利用せずに、相互作用的なデザインを始めるのもおすすめします。たとえ Turbo ストリームが使えなくとも、アプリケーション全体が動作するように作りましょう。それから、レベルアップとして、Turbo ストリームの層を追加していくのです。
そうすれば、Turbo ストリームを利用しないで、ネイティブアプリケーションなどを動作させる必要がある場合でも、アップデートをする必要はありません。

同様のことが特に、WebSocket の更新にも言えます。コネクションが貧弱な場合や、サーバーに問題がある場合、WebSocket は接続が切れてしまいます。
もし、アプリケーションが WebSocket が無くても動くようにデザインされているならば、より弾力性を持つでしょう。

## JavaScript の実行に関してはどうでしょう？

Turbo ストリームは、意図的に 7 つのアクションを利用するように制限します。それは、append, prepend, (insert) before, (insert) after, replace, update と remove です。
もし上記のアクションが実行されたときに、追加の挙動をトリガーしたいならば、[Stimulus](https://stimulus.hotwired.dev)コントローラーを利用することで、その挙動を実現すべきです。
この制限によって、Turbo ストリームがワイヤー上での HTML 配信という必要不可欠なタスクに専念することができ、追加のロジックは JavaScript 専用のファイル内に留められます。

これらの制約を守ることで、再利用できず、アプリを複雑にするような理解し難い複雑な挙動に個々に応答するような状態を防げるでしょう。
Turbo ストリームの重要な利点は、続けて起こる全ての更新を通して、最初にページをレンダーするために利用したテンプレートを再利用できる点にあります。

## サーバーサイドフレームワークとの連携

Turbo に付随した全ての技術の中で、バックエンドフレームワークとの密な連携に関して最も大きな優位性があります。
公式の Hotwire スイートな部分として、[turbo-rails gem](https://github.com/hotwired/turbo-rails)内で、どのように統合できるかの参考実装を作成しています。
この gem は、Rails 内の WebScoket と非同期なレンダリングに対する組み込み済みのサポートを、それぞれ Action Cable や Active Job フレームワークを利用して実現しています。

Active Record にミックスインされた[Broadcastable](https://github.com/hotwired/turbo-rails/blob/main/app/models/concerns/turbo/broadcastable.rb)を利用することで、
Webscoket の更新を直接ドメインモデルからトリガーできます。さらに[Turbo::Streams::TagBuilder](https://github.com/hotwired/turbo-rails/blob/main/app/models/turbo/streams/tag_builder.rb)を利用することで、インラインなコントローラーのレスポンスまたは専用テンプレート内で`<turbo-stream>`要素をレンダリングできます。同時に、シンプルな DSL を通して、レンダリングに関する 5 つのアクションを実行できます。

しかしながら、Trubo 自体は、バックエンドに対して一切関知しません。他のエコシステム内の異なるフレームワークで密な統合を作成するためにも Rails に対する参考実装をみることを推奨します。

バックエンドアプリケーションと Trubo ストリームを統合する、もう一つの簡単な方法は、[Mercure protocol](https://mercure.rocks)を利用することです。
Mercure は、サーバーアプリケーションに対して便利な方法を定義します。それは、ページの変更を[Server-Sent Events (SSE)](https://developer.mozilla.org/ja/docs/Web/API/Server-sent_events)を通して、全ての接続されたクライアントに送信できる方法です。[Learn how to use Mercure with Turbo Streams](https://mercure.rocks/docs/ecosystem/hotwire)
