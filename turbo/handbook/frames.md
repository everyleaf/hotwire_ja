---
title: "Turboフレームを分解する"
description: "Turbo Framesはページを独立したコンテキストに分解し、それらを遅延ロードできるようにし、インタラクションの範囲を制限します。"
order: 4
commit: "0b2c287"
---

# Turboフレームを分解する

Turbo フレームは、事前に定義されたページの一部分をリクエストに応じて更新できるようにします。フレームの中にあるすべてのリンクやフォームは捕捉され、フレームのコンテンツはレスポンスを受け取ると自動的に更新されます。
個々のフレームは、サーバーが完全なドキュメントを提供するか、リクエストされたフレームの更新版が入った断片を提供するかどうかに関わらず、レスポンスを切り取って、既存のコンテンツを置き換えます。

フレームはページの一部を `<turbo-frame>` 要素で囲うことで作られます。各要素は必ず一意のIDを持っており、リクエストに応じてサーバーから新しいページが来た際に、置き換えるべきコンテンツを一致させるのに使用します。ひとつのページに多数のフレームを持たせることができ、それぞれのフレームは独自のコンテキストを確立しています。

```html
<body>
  <div id="navigation">Links targeting the entire page</div>
  <div id="navigation">リンクのターゲットをページ全体にする</div>

  <turbo-frame id="message_1">
    <h1>メッセージタイトル</h1>
    <p>メッセージ内容</p>
    <a href="/messages/1/edit">このメッセージを編集</a>
  </turbo-frame>

  <turbo-frame id="comments">
    <div id="comment_1">1つ目のコメント</div>
    <div id="comment_2">2つ目のコメント</div>

    <form action="/messages/comments">...</form>
  </turbo-frame>
</body>
```

このページには2つのフレームがあります。ひとつめのフレームには、メッセージの表示とそれを編集するリンクがあります。そしてふたつめのフレームにはコメントリストと、コメントを追加するフォームがあります。それぞれがナビゲーション用の独自のコンテキストを作成し、リンクとフォーム送信の両方を捕捉します。

メッセージ編集のリンクをクリックすると、`/messages/1/edit` から提供されたレスポンスの Turbo フレーム部分 `<turbo-frame id="message_1">` が抽出され、クリックされた元のフレームのコンテンツが置き換えられます。
レスポンスコンテンツは次のようなものです。

```html
<body>
  <h1>メッセージの編集</h1>

  <turbo-frame id="message_1">
    <form action="/messages/1">
      <input name="message[name]" type="text" value="My message title">
      <textarea name="message[content]">メッセージ内容</textarea>
      <input type="submit">
    </form>
  </turbo-frame>
</body>
```

`<h1>` が `<turbo-frame>` の中にないことに注目してください。これは編集フォームとメッセージ表示を置き換えるときに `<h1>` はそのまま残されるということです。フレームの更新には、一致した `<turbo-frame>` の中のコンテンツだけが使用されます。

つまりこのページは2つの用途に使えます。フレームの内側で即時に編集を行うという用途、もしくはページ全体が編集処理専用である、フレームの外側で編集を行うという用途です。

フレームは、ある特定の目的のためにあります。つまり、コンテンツとナビゲーションをドキュメント内で区分けし、互いに影響させないようにするのです。その区分けの影響は子孫コンテンツの`<a>`要素や`<form>`要素にまで及ぶため、むやみに導入すべきではありません。
また Turbo フレームは [Turbo ストリーム](/turbo/handbook/streams/)のサポートを提供していません。アプリケーションが`<turbo-stream>`要素のために`<turbo-frame>`要素を使用している場合は、その`<turbo-frame>`要素を他の[ビルトインのHTML要素](https://developer.mozilla.org/ja/docs/Web/HTML/Element)に変更してください。

<details>
<summary>原文</summary>

# Decompose with Turbo Frames

Turbo Frames allow predefined parts of a page to be updated on request. Any links and forms inside a frame are captured, and the frame contents automatically updated after receiving a response. Regardless of whether the server provides a full document, or just a fragment containing an updated version of the requested frame, only that particular frame will be extracted from the response to replace the existing content.

Frames are created by wrapping a segment of the page in a `<turbo-frame>` element. Each element must have a unique ID, which is used to match the content being replaced when requesting new pages from the server. A single page can have multiple frames, each establishing their own context:

```html
<body>
  <div id="navigation">Links targeting the entire page</div>

  <turbo-frame id="message_1">
    <h1>My message title</h1>
    <p>My message content</p>
    <a href="/messages/1/edit">Edit this message</a>
  </turbo-frame>

  <turbo-frame id="comments">
    <div id="comment_1">One comment</div>
    <div id="comment_2">Two comments</div>

    <form action="/messages/comments">...</form>
  </turbo-frame>
</body>
```

This page has two frames: One to display the message itself, with a link to edit it. One to list all the comments, with a form to add another. Each create their own context for navigation, capturing both links and submitting forms.

When the link to edit the message is clicked, the response provided by `/messages/1/edit` has its `<turbo-frame id="message_1">` segment extracted, and the content replaces the frame from where the click originated. The edit response might look like this:

```html
<body>
  <h1>Editing message</h1>

  <turbo-frame id="message_1">
    <form action="/messages/1">
      <input name="message[name]" type="text" value="My message title">
      <textarea name="message[content]">My message content</textarea>
      <input type="submit">
    </form>
  </turbo-frame>
</body>
```

Notice how the `<h1>` isn't inside the `<turbo-frame>`. This means it will remain unchanged when the form replaces the display of the message upon editing. Only content inside a matching `<turbo-frame>` is used when the frame is updated.

Thus your page can easily play dual purposes: Make edits in place within a frame or edits outside of a frame where the entire page is dedicated to the action.

Frames serve a specific purpose: to compartmentalize the content and navigation for a fragment of the document. Their presence has ramification on any `<a>` elements or `<form>` elements contained by their child content, and shouldn't be introduced unnecessarily. Turbo Frames do not contribute support to the usage of [Turbo Stream](/handbook/streams). If your application utilizes `<turbo-frame>` elements for the sake of a `<turbo-stream>` element, change the `<turbo-frame>` into another [built-in element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element).

</details>

## フレームの事前読み込み

ページが読み込まれた時点でフレームの中身を配置しておく必要はありません。`turbo-frame` タグに `src` 属性があれば、ページにタグが出現した時点で `src` が参照している URL が自動的に読み込まれます。

```html
<body>
  <h1>受信トレイ</h1>

  <div id="emails">
    ...
  </div>

  <turbo-frame id="set_aside_tray" src="/emails/set_aside">
  </turbo-frame>

  <turbo-frame id="reply_later_tray" src="/emails/reply_later">
  </turbo-frame>
</body>
```

このページは、読み込まれるとすぐに `<a href="http://itsnotatypo.com">imbox</a>` に入っているすべてのメールの一覧を表示しますが、その後、取り置きメールや返信待ちのメールのためにあるページ下部の小さなトレイへ向けて2つの後続リクエストを発行します。それらのトレイは `src` が参照している URL に基づいて作られる個別の HTTP リクエストから生み出されます。

また、上記の例ではページ読み込み時点のトレイのフレームに中身はありませんが、先読みして初期コンテンツをいれておくこともできます。`src` からコンテンツを取得したタイミングでフレームの内容は上書きされます。

```html
<turbo-frame id="set_aside_tray" src="/emails/set_aside">
  <img src="/icons/spinner.gif">
</turbo-frame>
```

imbox ページを読み込むとき、取り置きメールのトレイは `/emails/set_aside` を読み込みます。またレスポンスには読み込み側に対応するフレーム要素を必ず含みます。元の例では `<turbo-frame id="set_aside_tray">` にあたります。

```html
<body>
  <h1>取り置きトレイ</h1>

  <p>このトレイのメールは取り置き設定したものです</p>

  <turbo-frame id="set_aside_tray">
    <div id="emails">
      <div id="email_1">
        <a href="/emails/1">重要なメール</a>
      </div>
    </div>
  </turbo-frame>
</body>
```

このページの直接の目的は見出しと説明文の表示ですが、imbox ページにあるトレイフレームの中で `div` タグと個々のメールを読み出すだけの最小化されたフォームも動作しています。メッセージを編集するフォームの例と同様です。

`/emails/set_aside` にある `<turbo-frame>` タグは `src` 属性を含んでいないことに注目してください。 `src` 属性は、フレームが読み込まれたときにコンテンツを表示するのではなく、遅延読み込みしてほしい場合にのみ追加します。

ナビゲーション中、フレームは新しいコンテンツを取得するときに、`<turbo-frame>` 要素の中に `[aria-busy="true"]` をセットします。ナビゲーションが完了したとき、フレームは `[aria-busy]` 属性を削除します。フレームが `<form>` の送信を通じて `<turbo-frame>` をナビゲーションしているとき、Turbo はフレームと協力してフォームの `[aria-busy="true"]` 属性を切り替えます。

[aria-busy]: https://www.w3.org/TR/wai-aria/#aria-busy

<details>
<summary>原文</summary>

## Eager-Loading Frames

Frames don't have to be populated when the page that contains them is loaded. If a `src` attribute is present on the `turbo-frame` tag, the referenced URL will automatically be loaded as soon as the tag appears on the page:

```html
<body>
  <h1>Imbox</h1>

  <div id="emails">
    ...
  </div>

  <turbo-frame id="set_aside_tray" src="/emails/set_aside">
  </turbo-frame>

  <turbo-frame id="reply_later_tray" src="/emails/reply_later">
  </turbo-frame>
</body>
```

This page lists all the emails available in your <a href="http://itsnotatypo.com">imbox</a> immediately upon loading the page, but then makes two subsequent requests to present small trays at the bottom of the page for emails that have been set aside or are waiting for a later reply. These trays are created out of separate HTTP requests made to the URLs referenced in the `src`.

In the example above, the trays start empty, but it's also possible to populate the eager-loading frames with initial content, which is then overwritten when the content is fetched from the `src`:

```html
<turbo-frame id="set_aside_tray" src="/emails/set_aside">
  <img src="/icons/spinner.gif">
</turbo-frame>
```

Upon loading the imbox page, the set-aside tray is loaded from `/emails/set_aside`, and the response must contain a corresponding `<turbo-frame id="set_aside_tray">` element as in the original example:

```html
<body>
  <h1>Set Aside Emails</h1>

  <p>These are emails you've set aside</p>

  <turbo-frame id="set_aside_tray">
    <div id="emails">
      <div id="email_1">
        <a href="/emails/1">My important email</a>
      </div>
    </div>
  </turbo-frame>
</body>
```

This page now works in both its minimized form, where only the `div` with the individual emails are loaded into the tray frame on the imbox page, but also as a direct destination where a header and a description is provided. Just like in the example with the edit message form.

Note that the `<turbo-frame>` on `/emails/set_aside` does not contain a `src` attribute. That attribute is only added to the frame that needs to lazily load the content, not to the rendered frame that provides the content.

During navigation, a Frame will set `[aria-busy="true"]` on the `<turbo-frame>` element when fetching the new contents. When the navigation completes, the Frame will remove the `[aria-busy]` attribute. When navigating the `<turbo-frame>` through a `<form>` submission, Turbo will toggle the Form's `[aria-busy="true"]` attribute in tandem with the Frame's.

After navigation finishes, a Frame will set the `[complete]` attribute on the
`<turbo-frame>` element.

[aria-busy]: https://www.w3.org/TR/wai-aria/#aria-busy
</details>

## フレームの遅延読み込み

ページが最初に読み込まれたときに見えていないフレームは、`loading="lazy"` をマークしておくことで、フレームが見えるようになるまで読み込みを遅延させることができます。`loading="lazy"` は `img` タグの `lazy=true` 属性のように動作します。`loading="lazy"` はフレームが `summary`/`detail` ペアやモーダル、または最初は非表示でその後表示されるものの中にあるときに、読み込みを遅延させる最適な方法です。

<details>
<summary>原文</summary>

## Lazy-Loading Frames

Frames that aren't visible when the page is first loaded can be marked with `loading="lazy"` such that they don't start loading until they become visible. This works exactly like the `lazy=true` attribute on `img`. It's a great way to delay loading of frames that sit inside `summary`/`detail` pairs or modals or anything else that starts out hidden and is then revealed.
</details>

## フレームの読み込みにおけるキャッシュの利点

ページセグメントをフレームに置き換えるとページの実装がシンプルになりますが、同じくらい重要なこととしてキャッシュダイナミクスの改善があります。多数のセグメントを持つ複雑なページは、効率的にキャッシュすることが難しくなります。特に、不特定のユーザー向けのコンテンツと、特定の個人ユーザー向けのコンテンツが混在している場合です。セグメントの数が多くなると、キャッシュの検索に必要な依存キーが増え、キャッシュの更新頻度が上がっていきます。

フレームは、所要時間や閲覧者が異なるページセグメントを分離するのに適しています。ページの大部分がすべてのユーザーに共有しやすいときは、ページ内にあるユーザー毎の要素をフレームに置きかえることは理にかなっています。 またその逆に、ほとんどが個別化されたページでひとつの共有セグメントをフレームに置き換えて共有キャッシュから提供することも理にかなっています。

フレームの読み込みのオーバーヘッドは一般的にとても小さいですが、それでも読み込むフレーム数には十分に注意したほうがよく、特にフレームがページに読み込みジッターを発生させないようにしましょう。しかしながら、ページ読み込み直後に見えていないフレームは基本的に自由です。モーダルの後ろや、折りたたまれたコンテンツに隠れているからです。

<details>
<summary>原文</summary>

## Cache Benefits to Loading Frames

Turning page segments into frames can help make the page simpler to implement, but an equally important reason for doing this is to improve cache dynamics. Complex pages with many segments are hard to cache efficiently, especially if they mix content shared by many with content specialized for an individual user. The more segments, the more dependent keys required for the cache look-up, the more frequently the cache will churn.

Frames are ideal for separating segments that change on different timescales and for different audiences. Sometimes it makes sense to turn the per-user element of a page into a frame, if the bulk of the rest of the page is then easily shared across all users. Other times, it makes sense to do the opposite, where a heavily personalized page turns the one shared segment into a frame to serve it from a shared cache.

While the overhead of fetching loading frames is generally very low, you should still be judicious in just how many you load, especially if these frames would create load-in jitter on the page. Frames are, however, essentially free if the content isn't immediately visible upon loading the page. Either because they're hidden behind modals or below the fold.
</details>

## ナビゲーションの対象をフレームの内部にするか、外部にするか

デフォルトでは、フレーム内のナビゲーションはそのフレームを対象としています。それはリンクの追跡とフォームの送信の両方に当てはまります。ですが、ナビゲーションはその対象を `_top` に設定することで、フレームに囲まれたコンテンツではなく、ページ全体を操作することができます。またはその対象をターゲットをフレームの ID に設定することで、他の名前つきフレームを操作することもできます。

例の中で、取り置きメールのトレイの中のリンクは個別のメールを指しています。それらのリンクに `set_aside_tray` という ID と一致するフレームタグを探させるのではなく、個々のメールへ直接ナビゲートさせたいとします。取り置きメールトレイのフレームに `target` 属性を付与することで実現できます。

```html
<body>
  <h1>受信トレイ</h1>
  ...
  <turbo-frame id="set_aside_tray" src="/emails/set_aside" target="_top">
  </turbo-frame>
</body>

<body>
  <h1>取り置きトレイ</h1>
  ...
  <turbo-frame id="set_aside_tray" target="_top">
    ...
  </turbo-frame>
</body>
```

多くのリンクはフレームの内容の中を操作し、その他の箇所を操作させないことが多いでしょう。それはフォームにも当てはまります。フレームではない要素を操作するために、その要素に `data-turbo-frame` 属性を付与することができます。

```html
<body>
  <turbo-frame id="message_1">
    ...
    <a href="/messages/1/edit">
      このメッセージを編集 (message_1 のフレーム内を置き換える)
    </a>

    <a href="/messages/1/permission" data-turbo-frame="_top">
      権限の変更 (ページ全体を置き換える)
    </a>
  </turbo-frame>

  <form action="/messages/1/delete" data-turbo-frame="message_1">
    <a href="/messages/1/warning" data-turbo-frame="_self">
      message_1 のフレーム内で警告を出す
    </a>

    <input type="submit" value="Delete this message">
    (特定のフレームに確認メッセージを表示する)
  </form>
</body>
```

<details>
<summary>原文</summary>

## Targeting Navigation Into or Out of a Frame

By default, navigation within a frame will target just that frame. This is true for both following links and submitting forms. But navigation can drive the entire page instead of the enclosing frame by setting the target to `_top`. Or it can drive another named frame by setting the target to the ID of that frame.

In the example with the set-aside tray, the links within the tray point to individual emails. You don't want those links to look for frame tags that match the `set_aside_tray` ID. You want to navigate directly to that email. This is done by marking the tray frames with the `target` attribute:

```html
<body>
  <h1>Imbox</h1>
  ...
  <turbo-frame id="set_aside_tray" src="/emails/set_aside" target="_top">
  </turbo-frame>
</body>

<body>
  <h1>Set Aside Emails</h1>
  ...
  <turbo-frame id="set_aside_tray" target="_top">
    ...
  </turbo-frame>
</body>
```

Sometimes you want most links to operate within the frame context, but not others. This is also true of forms. You can add the `data-turbo-frame` attribute on non-frame elements to control this:

```html
<body>
  <turbo-frame id="message_1">
    ...
    <a href="/messages/1/edit">
      Edit this message (within the current frame)
    </a>

    <a href="/messages/1/permission" data-turbo-frame="_top">
      Change permissions (replace the whole page)
    </a>
  </turbo-frame>

  <form action="/messages/1/delete" data-turbo-frame="message_1">
    <a href="/messages/1/warning" data-turbo-frame="_self">
      Load warning within current frame
    </a>

    <input type="submit" value="Delete this message">
    (with a confirmation shown in a specific frame)
  </form>
</body>
```
</details>

## フレームのナビゲーションをページアクセスに昇格させる

フレームをナビゲートすることで、フレーム以外のドキュメントの状態を維持したままページコンテンツの一部だけを変更することができます（例：現在の画面スクロール位置や要素のフォーカスなど）。しかし、時にはフレームの変更をブラウザの履歴に反映させたい場合もあります。

フレームのナビゲーションをページアクセスに昇格させるには、描画する要素に `[data-turbo-action]` 属性をもたせます。この属性はすべてのアクセスの値についてサポートしており、また以下の要素に対して宣言できます。

* `<turbo-frame>` 要素
* `<turbo-frame>` をナビゲートするすべての `<a>` 要素
* `<turbo-frame>` をナビゲートするすべての `<form>` 要素
* `<turbo-frame>` をナビゲートする `<form>` の中にある、すべての `<input type="submit">` および `<button>` 要素

例えば、ページ分割された記事のリストを表示し、ナビゲーションを "advance" アクションに変換するフレームについて考えてみましょう。

```html
<turbo-frame id="articles" data-turbo-action="advance">
  <a href="/articles?page=2" rel="next">次のページ</a>
</turbo-frame>
```

`<a rel="next">` 要素をクリックすると `<turbo-frame>` の `[src]` 属性とブラウザのURLパスの _両方_ に `/articles?page=2` がセットされます。

**注記:** ブラウザを更新してページが再描画される場合、URLパスや検索パラメータから得られる状態とともに _2_ ページ目の記事を描画するのは _アプリケーション_ の責任です。

[history]: https://developer.mozilla.org/en-US/docs/Web/API/History
[Visit]: /handbook/drive#page-navigation-basics
[advance]: /handbook/drive#application-visits

<details>
<summary>原文</summary>

## Promoting a Frame Navigation to a Page Visit

Navigating Frames provides applications with an opportunity to change part of
the page's contents while preserving the rest of the document's state (for
example, its current scroll position or focused element). There are times when
we want changes to a Frame to also affect the browser's [history][].

To promote a Frame navigation to a Visit, render the element with the
`[data-turbo-action]` attribute. The attribute supports all [Visit][] values,
and can be declared on:

* the `<turbo-frame>` element
* any `<a>` elements that navigate the `<turbo-frame>`
* any `<form>` elements that navigate the `<turbo-frame>`
* any `<input type="submit">` or `<button>` elements contained within `<form>`
  elements that navigate the `<turbo-frame>`

For example, consider a Frame that renders a paginated list of articles and
transforms navigations into ["advance" Actions][advance]:

```html
<turbo-frame id="articles" data-turbo-action="advance">
  <a href="/articles?page=2" rel="next">Next page</a>
</turbo-frame>
```

Clicking the `<a rel="next">` element will set _both_ the `<turbo-frame>`
element's `[src]` attribute _and_ the browser's path to `/articles?page=2`.

**Note:** when rendering the page after refreshing the browser, it is _the
application's_ responsibility to render the _second_ page of articles along with
any other state derived from the URL path and search parameters.

[history]: https://developer.mozilla.org/en-US/docs/Web/API/History
[Visit]: https://turbo.hotwired.dev/handbook/drive#page-navigation-basics
[advance]: https://turbo.hotwired.dev/handbook/drive#application-visits
</details>

## フレームからの脱却

`<turbo-frame>` を起点としたリクエストはそのフレームのコンテンツを取得することを期待されることがほとんどです（ `target` 属性や `data-turbo-frame` 属性の使い方によっては、ページ内の別のコンテンツが期待されます）。
つまり、レスポンスには常に `<turbo-frame>` 要素が含まれていなければなりません。Turbo が期待する `<turbo-frame>` 要素が　レスポンスにない場合、それはエラーとみなされます。フレーム内に状況を伝えるメッセージが描画され、例外もスローされます。

実際には `<turbo-frame>` リクエストに対するレスポンスを、フルページナビゲーションの代わりとなる、効果的にフレームから"脱却"した、新しいページとして扱いたい場面もあるでしょう。セッションが有効期限切れなどで失われ、アプリケーションのログインページへリダイレクトする場合はその典型的な例です。この場合、Turbo はセッション切れエラーとして扱うよりもログインページを表示させた方が良いでしょう。

その最も簡単な方法は、[`turbo-visit-control`][meta] meta タグを head 要素内に含めることです。この meta タグによって、ログインページはページ全体の再読み込みが必要であるという指定になります。

```html
<head>
  <meta name="turbo-visit-control" content="reload">
  ...
</head>
```

Turbo Rails を使っているなら、`turbo_page_requires_reload` ヘルパーを使えば同じことができます。

`turbo-visit-control` `reload` を指定したページは、フレーム内を起点としたリクエストに対しても常にフルページナビゲーションとなります。

レスポンスにフレームが見つからないときの処理を他の方法にしなくてはならないときは、[`turbo:frame-missing`][events] イベントを補足することで対応できます。
それは例えば、レスポンスの変換や、他のロケーションへアクセスする処理などです。

[meta]: https://turbo.hotwired.dev/reference/attributes#meta-tags
[events]: https://turbo.hotwired.dev/reference/events

<details>
<summary>原文</summary>

## "Breaking out" from a Frame

In most cases, requests that originate from a `<turbo-frame>` are expected to fetch content for that frame (or for
another part of the page, depending on the use of the `target` or `data-turbo-frame` attributes). This means the
response should always contain the expected `<turbo-frame>` element. If a response is missing the `<turbo-frame>`
element that Turbo expects, it's considered an error; when it happens Turbo will write an informational message into the
frame, and throw an exception.

In certain, specific cases, you might want the response to a `<turbo-frame>` request to be treated as a new, full-page
navigation instead, effectively "breaking out" of the frame. The classic example of this is when a lost or expired
session causes an application to redirect to a login page. In this case, it's better for Turbo to display that login
page rather than treat it as an error.

The simplest way to achieve this is to specify that the login page requires a full-page reload, by including the
[`turbo-visit-control`][meta] meta tag:

```html
<head>
  <meta name="turbo-visit-control" content="reload">
  ...
</head>
```

If you're using Turbo Rails, you can use the `turbo_page_requires_reload` helper to accomplish the same thing.

Pages that specify `turbo-visit-control` `reload` will always result in a full-page navigation, even if the request
originated from inside a frame.

If your application needs to handle missing frames in some other way, you can intercept the
[`turbo:frame-missing`][events] event to, for example, transform the response or perform a visit to another location.

[meta]: https://turbo.hotwired.dev/reference/attributes#meta-tags
[events]: https://turbo.hotwired.dev/reference/events
</details>

## アンチフォージェリのサポート (CSRF)

Turbo は、DOMをチェックして `name` 属性の値に `csrf-param` か `csrf-token` が入っている `<meta>` タグが存在する場合 [CSRF](https://en.wikipedia.org/wiki/Cross-site_request_forgery) 保護を提供しています。

```html
<meta name="csrf-token" content="[your-token]">
```

フォームを送信したとき、トークンは自動的にリクエストヘッダーへ `X-CSRF-TOKEN` として付与されます。リクエストが `data-turbo="false"` とともに作られると、ヘッダーへのトークン付与をスキップします。

<details>
<summary>原文</summary>

## Anti-Forgery Support (CSRF)

Turbo provides [CSRF](https://en.wikipedia.org/wiki/Cross-site_request_forgery) protection by checking the DOM for the existence of a `<meta>` tag with a `name` value of either `csrf-param` or `csrf-token`. For example:

```html
<meta name="csrf-token" content="[your-token]">
```

Upon form submissions, the token will be automatically added to the request's headers as `X-CSRF-TOKEN`. Requests made with `data-turbo="false"` will skip adding the token to headers.
</details>

# カスタムレンダリング

Turbo の `<turbo-frame>` におけるデフォルトの描画処理は、リクエストしている `<turbo-frame>` 要素のコンテンツを、レスポンス内の一致した `<turbo-frame>` 要素のコンテンツで置き換えるというものです。実際には、 `<turbo-frame>` 要素のコンテンツは [`<turbo-stream action="update">`](/reference/streams#update) 要素によって操作されているかのように描画されます。
基本的なレンダラーは、レスポンスの中にある`<turbo-frame>`タグ内のコンテンツを抽出し、リクエストした`<turbo-frame>`の持つコンテンツを、その抽出したコンテンツに置き換えます。[Turbo Drive が管理する `[src]`, `[busy]`, `[complete]` 属性](https://turbo.hotwired.dev/reference/frames#html-attributes)を除いて、`<turbo-frame>` 要素は、Turbo frame 要素のライフサイクル(リクエスト-レスポンス)の段階を通じて変更されることはありません。
アプリケーションは、`turbo:before-frame-render` イベントリスナーの付与と `event.detail.render` プロパティの上書きを行うことで `<turbo-frame>` の描画処理をカスタマイズできます。
例えば、 [morphdom](https://github.com/patrick-steele-idem/morphdom) によってリクエストした `<turbo-frame>` 要素の中にレスポンスの `<turbo-frame>` 要素をいれてしまうこともできます。

```javascript
import morphdom from "morphdom"

addEventListener("turbo:before-frame-render", (event) => {
  event.detail.render = (currentElement, newElement) => {
    morphdom(currentElement, newElement, { childrenOnly: true })
  }
})
```

`turbo:before-frame-render` イベントはドキュメントを上層へ伝播します。 `<turbo-frame>` 要素に直接イベントリスナーをアタッチしてその要素の描画を上書きしたり、
`document` にイベントリスナーをアタッチしてすべての `<turbo-frame>` 要素の描画を上書きする、ということもできます。

<details>
<summary>原文</summary>

# Custom Rendering

Turbo's default `<turbo-frame>` rendering process replaces the contents of the requesting `<turbo-frame>` element with the contents of a matching `<turbo-frame>` element in the response. In practice, a `<turbo-frame>` element's contents are rendered as if they operated on by [`<turbo-stream action="update">`](https://turbo.hotwired.dev/reference/streams#update) element. The underlying renderer extracts the contents of the `<turbo-frame>` in the response and uses them to replace the requesting `<turbo-frame>` element's contents. The `<turbo-frame>` element itself remains unchanged, save for the [`[src]`, `[busy]`, and `[complete]` attributes that Turbo Drive manages](https://turbo.hotwired.dev/reference/frames#html-attributes) throughout the stages of the element's request-response lifecycle.
Applications can customize the `<turbo-frame>` rendering process by adding a `turbo:before-frame-render` event listener and overriding the `event.detail.render` property.

For example, you could merge the response `<turbo-frame>` element into the requesting `<turbo-frame>` element with [morphdom](https://github.com/patrick-steele-idem/morphdom):

```javascript
import morphdom from "morphdom"

addEventListener("turbo:before-frame-render", (event) => {
  event.detail.render = (currentElement, newElement) => {
    morphdom(currentElement, newElement, { childrenOnly: true })
  }
})
```

Since `turbo:before-frame-render` events bubble up the document, you can override one `<turbo-frame>` element's rendering by attaching the event listener directly to the element, or override all `<turbo-frame>` elements' rendering by attaching the listener to the `document`.

</details>

## 描画の一時停止

アプリケーションは描画を一時停止させ、再開する前に追加の準備をすることができます。
`turbo:before-frame-render` イベントを待ち受けることでフレームの描画が開始されたことに気づけます。そして `event.preventDefault()` を使って描画を一時停止させます。
準備が整ったら `event.detail.resume()` を使って描画を再開させます。

以下は、描画を停止させて exit アニメーションを加えたいときのユースケースです。

```javascript
document.addEventListener("turbo:before-frame-render", async (event) => {
  event.preventDefault()

  await animateOut()

  event.detail.resume()
})
```

<details>
<summary>原文</summary>

## Pausing Rendering

Applications can pause rendering and make additional preparations before continuing.
Listen for the `turbo:before-frame-render` event to be notified when rendering is about to start, and pause it using `event.preventDefault()`. Once the preparation is done continue rendering by calling `event.detail.resume()`.
An example use case is adding exit animation:

```javascript
document.addEventListener("turbo:before-frame-render", async (event) => {
  event.preventDefault()

  await animateOut()

  event.detail.resume()
})
```
</details>
