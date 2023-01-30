---
permalink: /handbook/frames.html
description: "Turbo Frames decompose pages into independent contexts, which can be lazy-loaded and scope interaction."
---

[DHHの許諾](https://github.com/hotwired/turbo-site/issues/96)のもと、[公式のTurboHandbook](https://turbo.hotwired.dev/handbook/introduction)を[オリジナル](https://github.com/hotwired/turbo-site/commit/59943d962b37a02c1dcb68ebaa1057f713a45975)として、翻訳をしています。
このサイトの全ての文責は、[株式会社万葉](https://everyleaf.com/)にあります。

# Decompose with Turbo Frames
# Turboフレームを分解する

Turbo Frames allow predefined parts of a page to be updated on request. Any links and forms inside a frame are captured, and the frame contents automatically updated after receiving a response. Regardless of whether the server provides a full document, or just a fragment containing an updated version of the requested frame, only that particular frame will be extracted from the response to replace the existing content.
Turbo フレームは、事前に定義されたページの一部分をリクエストに応じて更新できるようにします。フレームの中にあるすべてのリンクやフォームは捕捉され、フレームのコンテンツはレスポンスを受け取ると自動的に更新されます。
個々のフレームは、サーバーが完全なドキュメントを提供するか、リクエストされたフレームの更新版が入った断片を提供するかどうかに関わらず、レスポンスを切り取って、既存のコンテンツを置き換えます。

Frames are created by wrapping a segment of the page in a `<turbo-frame>` element. Each element must have a unique ID, which is used to match the content being replaced when requesting new pages from the server. A single page can have multiple frames, each establishing their own context:
フレームはページの一部を `<turbo-frame>` 要素で囲うことで作られます。各要素には一意のIDが必要です。このIDは、サーバーへリクエストした新しいページと置き換えるコンテンツを一致させるのに使用します。ひとつのページに多数のフレームを持たせることができ、それぞれのフレームは独自のコンテキストを確立しています。

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
このページには2つのフレームがあります。ひとつめのフレームには、メッセージの表示とそれを編集するリンクがあります。ふたつめのフレームにはコメントリストと、コメントを追加するフォームがありです。それぞれがナビゲーション用の独自のコンテキストを作成し、リンクとフォーム送信の両方を捕捉します。

When the link to edit the message is clicked, the response provided by `/messages/1/edit` has its `<turbo-frame id="message_1">` segment extracted, and the content replaces the frame from where the click originated. The edit response might look like this:
メッセージ編集のリンクをクリックすると、`/messages/1/edit` から提供されたレスポンスの Turbo フレーム部分 `<turbo-frame id="message_1">` が抽出され、クリックされた元のフレームのコンテンツが置き換えられます。
レスポンスコンテンツは次のようなものです。

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

Notice how the `<h1>` isn't inside the `<turbo-frame>`. This means it'll be ignored when the form replaces the display of the message upon editing. Only content inside a matching `<turbo-frame>` is used when the frame is updated.
`<h1>` が `<turbo-frame>` の中にないことに注目してください。これは編集フォームとメッセージ表示を置き換えるときに `<h1>` は無視されるということです。フレームの更新には、一致した `<turbo-frame>` の中のコンテンツだけが使用されます。

Thus your page can easily play dual purposes: Make edits in place within a frame or edits outside of a frame where the entire page is dedicated to the action.
つまりこのページでは、かんたんに2つの目的を果たせます。それはフレームの内側で即時に編集を行うか、もしくはページ全体が編集処理専用である、フレームの外側で編集を行うかということです。

## Eager-Loading Frames
## フレームの事前読み込み

Frames don't have to be populated when the page that contains them is loaded. If a `src` attribute is present on the `turbo-frame` tag, the referenced URL will automatically be loaded as soon as the tag appears on the page:
ページが読み込まれた時点でフレームの中身を配置しておく必要はありません。`turbo-frame` タグに `src` 属性があれば、ページにタグが出現した時点で `src` が参照している URL が自動的に読み込まれます。

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
このページは、読み込まれるとすぐに `<a href="http://itsnotatypo.com">imbox</a>` に入っているすべてのメールの一覧を表示しますが、その後、取り置きメールや返信待ちのメールのためにあるページ下部の小さなトレイへ向けて2つの後続リクエストを発行します。それらのトレイは `src` が参照している URL から作られた個別の HTTP リクエストから生み出されます。

In the example above, the trays start empty, but it's also possible to populate the eager-loading frames with initial content, which is then overwritten when the content is fetched from the `src`:
また、上記の例ではページ読み込み時点のトレイのフレームに中身はありませんが、先読みして初期コンテンツをいれておくこともできます。`src` からコンテンツを取得したタイミングでフレームの内容は上書きされます。

```html
<turbo-frame id="set_aside_tray" src="/emails/set_aside">
  <img src="/icons/spinner.gif">
</turbo-frame>
```

Upon loading the imbox page, the set-aside tray is loaded from `/emails/set_aside`, and the response must contain a corresponding `<turbo-frame id="set_aside_tray">` element as in the original example:
imbox ページを読み込むとき、取り置きメールのトレイは `/emails/set_aside` を読み込みます。またレスポンスには読み込み側に対応するフレーム要素を必ず含みます。例文では `<turbo-frame id="set_aside_tray">` にあたります。

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
このページの直接の目的は見出しと説明文の表示ですが、imbox ページにあるトレイフレームの中で `div` タグと個々のメールを読み出すだけの最小化されたフォームも動作しています。メッセージを編集するフォームの例と同様です。

Note that the `<turbo-frame>` on `/emails/set_aside` does not contain a `src` attribute. That attribute is only added to the frame that needs to lazily load the content, not to the rendered frame that provides the content.
`/emails/set_aside` にある `<turbo-frame>` タグは `src` 属性を含んでいないことに注目してください。 `src` 属性はフレームが読み込まれたときにコンテンツを表示するのではなく、遅延読み込みしてほしい場合にのみ追加します。

During navigation, a Frame will set `[aria-busy="true"]` on the `<turbo-frame>` element when fetching the new contents. When the navigation completes, the Frame will remove the `[aria-busy]` attribute. When navigating the `<turbo-frame>` through a `<form>` submission, Turbo will toggle the `[aria-busy="true"]` attribute in tandem with the Frame's.
ナビゲーション中、フレームは新しいコンテンツを取得するときに、`<turbo-frame>` 要素の中に `[aria-busy="true"]` をセットします。ナビゲーションが完了したとき、フレームは `[aria-busy]` 属性を削除します。フレームが `<form>` の送信を通じて `<turbo-frame>` をナビゲーションしているとき、Turbo はフレームと協力して `[aria-busy="true"]` 属性を切り替えます。

[aria-busy]: https://www.w3.org/TR/wai-aria/#aria-busy

## Lazy-Loading Frames
## フレームの遅延読み込み

Frames that aren't visible when the page is first loaded can be marked with `loading="lazy"` such that they don't start loading until they become visible. This works exactly like the `lazy=true` attribute on `img`. It's a great way to delay loading of frames that sit inside `summary`/`detail` pairs or modals or anything else that starts out hidden and is then revealed.

ページが最初に読み込まれたときに見えていないフレームは、フレームが見えるまでは読み込みを開始しないように `loading="lazy"` でマークできます。`loading="lazy"` は `img`タグの `lazy=true` 属性のように動作します。`loading="lazy"` は `summary`/`detail` ペアやモーダル、または最初は非表示でその後表示されるものの中にあるフレームに対し、読み込みを遅延させる最適な方法です。

## Cache Benefits to Loading Frames
## ローディングフレームにおけるキャッシュの利点

Turning page segments into frames can help make the page simpler to implement, but an equally important reason for doing this is to improve cache dynamics. Complex pages with many segments are hard to cache efficiently, especially if they mix content shared by many with content specialized for an individual user. The more segments, the more dependent keys required for the cache look-up, the more frequently the cache will churn.

ページの区分をフレームに変えるとページの実装が簡単になりますが、キャッシュダイナミクスの改善は同じくらい重要なことです。多数の区分を持つ複雑なページは、効率的にキャッシュすることが難しくなります。特に、多くの人と共有する内容と、個々のユーザーに特化した内容が混在している場合です。区分の数が多くなると、キャッシュの検索に必要な依存キーが増え、キャッシュの更新頻度が上がっていきます。

Frames are ideal for separating segments that change on different timescales and for different audiences. Sometimes it makes sense to turn the per-user element of a page into a frame, if the bulk of the rest of the page is then easily shared across all users. Other times, it makes sense to do the opposite, where a heavily personalized page turns the one shared segment into a frame to serve it from a shared cache.

フレームは、異なる所要時間で変化する区分や、異なる閲覧者に向けた区分を分離するのに適しています。 ページの大部分がすべてのユーザーに共有しやすいときなどは、ページ内にあるユーザー毎の要素をフレームに置きかえることは理にかなっています。 またその逆に、ほとんどが個別化されたページでひとつの共有要素をフレームに置き換えて共有キャッシュから提供することも理にかなっています。

While the overhead of fetching loading frames is generally very low, you should still be judicious in just how many you load, especially if these frames would create load-in jitter on the page. Frames are, however, essentially free if the content isn't immediately visible upon loading the page. Either because they're hidden behind modals or below the fold.

ローディングフレームを取得するオーバーヘッドは一般的にとても小さいですが、それでも読み込むフレーム数には十分に注意したほうがよく、特にフレームがページに読み込みジッターを発生させないようにしましょう。しかしながらフレームは、ページ読み込み時にすぐに表示されないときは基本的に自由です。モーダルの後ろや、折りたたまれたコンテンツに隠れているからです。

## Targeting Navigation Into or Out of a Frame
## ナビゲーションの対象をフレーム内かフレームの外か決める

By default, navigation within a frame will target just that frame. This is true for both following links and submitting forms. But navigation can drive the entire page instead of the enclosing frame by setting the target to `_top`. Or it can drive another named frame by setting the target to the ID of that frame.

デフォルトでは、フレーム内のナビゲーションはそのフレームを対象としています。それはリンクの追跡とフォームの送信の両方に当てはまります。
ですが、ナビゲーションはその対象を `_top` に設定することで、フレームに囲まれたコンテンツではなく、ページ全体を操作することができます。
またはその対象をターゲットをフレームの ID に設定することで、他の名前つきフレームを操作することもできます。

In the example with the set-aside tray, the links within the tray point to individual emails. You don't want those links to look for frame tags that match the `set_aside_tray` ID. You want to navigate directly to that email. This is done by marking the tray frames with the `target` attribute:

例文の中で、取り置きメールのトレイの中のリンクは個別のメールを指しています。
それらのリンクに `set_aside_tray` という ID と一致するフレームタグを探させるのではなく、個々のメールへ直接ナビゲートさせるほうがよいです。取り置きメールトレイのフレームに `target` 属性を付与することで実現できます。

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

多くのリンクはフレームの内容の中を操作し、その他の箇所を操作させないことが多いでしょう。
それはフォームにも当てはまります。
フレームではない要素を操作するために、その要素に `data-turbo-frame` 属性を付与することができます。

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

## Promoting a Frame Navigation to a Page Visit
## フレームのナビゲーションをページアクセスに昇格させる

Navigating Frames provides applications with an opportunity to change part of
the page's contents while preserving the rest of the document's state (for
example, its current scroll position or focused element). There are times when
we want changes to a Frame to also affect the browser's [history][].

フレームをナビゲートすることで、フレーム以外のドキュメントの状態を維持したままページ内容の一部だけを変更することができます。
（例：現在の画面スクロール位置や要素のフォーカスなど）
しかし、時にはフレームの変更をブラウザの履歴に反映させたい場合もあります。

To promote a Frame navigation to a Visit, render the element with the
`[data-turbo-action]` attribute. The attribute supports all [Visit][] values,
and can be declared on:

フレームのナビゲーションをページアクセスに昇格させるには、描画する要素に `[data-turbo-action]` 属性をもたせます。
この属性はすべてのアクセスの値についてサポートしており、また以下の要素に対して宣言できます。

* the `<turbo-frame>` element
* any `<a>` elements that navigate the `<turbo-frame>`
* any `<form>` elements that navigate the `<turbo-frame>`
* any `<input type="submit">` or `<button>` elements contained within `<form>`
  elements that navigate the `<turbo-frame>`

* `<turbo-frame>` 要素
* `<turbo-frame>` をナビゲートするすべての `<a>` 要素
* `<turbo-frame>` をナビゲートするすべての `<form>` 要素
* `<turbo-frame>` をナビゲートする `<form>` の中にある、すべての `<input type="submit">` および `<button>` 要素

For example, consider a Frame that renders a paginated list of articles and
transforms navigations into ["advance" Actions][advance]:

例えば、ページ分割された記事のリストを表示し、ナビゲーションを "advance" アクションに変換するフレームについて考えてみましょう。

```html
<turbo-frame data-turbo-action="advance">
  <a href="/articles?page=2" rel="next">Next page</a>
</turbo-frame>
```

Clicking the `<a rel="next">` element will set _both_ the `<turbo-frame>` 
element's `[src]` attribute _and_ the browser's path to `/articles?page=2`.

`<a rel="next">` 要素をクリックすると `<turbo-frame>` の `[src]` 属性とブラウザのURLパスの _両方_ に `/articles?page=2` がセットされます。

**Note:** when rendering the page after refreshing the browser, it is _the
application's_ responsibility to render the _second_ page of articles along with
any other state derived from the URL path and search parameters.

**注記:**
ブラウザを更新してページが再描画される場合、URLパスや検索パラメータから得られる状態とともに _2_ ページ目の記事を描画するのは _アプリケーション_ の責任です。

[history]: https://developer.mozilla.org/en-US/docs/Web/API/History
[Visit]: /handbook/drive#page-navigation-basics
[advance]: /handbook/drive#application-visits

## Anti-Forgery Support (CSRF)
## アンチフォージェリのサポート (CSRF)

Turbo provides [CSRF](https://en.wikipedia.org/wiki/Cross-site_request_forgery) protection by checking the DOM for the existence of a `<meta>` tag with a `name` value of either `csrf-param` or `csrf-token`. For example:

Turbo は、DOMをチェックして `name` 属性の値に `csrf-param` か `csrf-token` が入っている `<meta>` タグが存在する場合 [CSRF](https://en.wikipedia.org/wiki/Cross-site_request_forgery) 保護を提供しています。

```html
<meta name="csrf-token" content="[your-token]">
```

Upon form submissions, the token will be automatically added to the request's headers as `X-CSRF-TOKEN`. Requests made with `data-turbo="false"` will skip adding the token to headers.

フォームを送信したとき、トークンは自動的にリクエストヘッダーへ `X-CSRF-TOKEN` として付与されます。リクエストが `data-turbo="false"` とともに作られると、ヘッダーへのトークン付与をスキップします。
