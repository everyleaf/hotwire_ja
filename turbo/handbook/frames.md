---
order: 04
title: "Turboフレームを分解する"
description: "Turbo Framesはページを独立したコンテキストに分解し、それらを遅延ロードできるようにし、インタラクションの範囲を制限します。"
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

フレームは、ドキュメント内で区分けしたコンテンツやナビゲーション同士を互いに影響させないように動作します。その区分けの影響は子孫コンテンツの`<a>`要素や`<form>`要素にまで及ぶため、むやみに導入すべきではありません。
また Turbo フレームは [Turbo ストリーム](/turbo/handbook/streams/)のサポートを提供していません。アプリケーションが`<turbo-stream>`要素のために`<turbo-frame>`要素を使用している場合は、その`<turbo-frame>`要素を他の[ビルトインのHTML要素](https://developer.mozilla.org/ja/docs/Web/HTML/Element)に変更してください。

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

## フレームの遅延読み込み

ページが最初に読み込まれたときに見えていないフレームは、`loading="lazy"` をマークしておくことで、フレームが見えるようになるまで読み込みを遅延させることができます。`loading="lazy"` は `img` タグの `lazy=true` 属性のように動作します。`loading="lazy"` はフレームが `summary`/`detail` ペアやモーダル、または最初は非表示でその後表示されるものの中にあるときに、読み込みを遅延させる最適な方法です。

## フレームの読み込みにおけるキャッシュの利点

ページセグメントをフレームに置き換えるとページの実装がシンプルになりますが、同じくらい重要なこととしてキャッシュダイナミクスの改善があります。多数のセグメントを持つ複雑なページは、効率的にキャッシュすることが難しくなります。特に、不特定のユーザー向けのコンテンツと、特定の個人ユーザー向けのコンテンツが混在している場合です。セグメントの数が多くなると、キャッシュの検索に必要な依存キーが増え、キャッシュの更新頻度が上がっていきます。

フレームは、所要時間や閲覧者が異なるページセグメントを分離するのに適しています。ページの大部分がすべてのユーザーに共有しやすいときは、ページ内にあるユーザー毎の要素をフレームに置きかえることは理にかなっています。 またその逆に、ほとんどが個別化されたページでひとつの共有セグメントをフレームに置き換えて共有キャッシュから提供することも理にかなっています。

フレームの読み込みのオーバーヘッドは一般的にとても小さいですが、それでも読み込むフレーム数には十分に注意したほうがよく、特にフレームがページに読み込みジッターを発生させないようにしましょう。しかしながら、ページ読み込み直後に見えていないフレームは基本的に自由です。モーダルの後ろや、折りたたまれたコンテンツに隠れているからです。

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

## アンチフォージェリのサポート (CSRF)

Turbo は、DOMをチェックして `name` 属性の値に `csrf-param` か `csrf-token` が入っている `<meta>` タグが存在する場合 [CSRF](https://en.wikipedia.org/wiki/Cross-site_request_forgery) 保護を提供しています。

```html
<meta name="csrf-token" content="[your-token]">
```

フォームを送信したとき、トークンは自動的にリクエストヘッダーへ `X-CSRF-TOKEN` として付与されます。リクエストが `data-turbo="false"` とともに作られると、ヘッダーへのトークン付与をスキップします。
