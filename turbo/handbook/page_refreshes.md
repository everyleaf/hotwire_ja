---
title: "モーフィングによるスムーズなページリフレッシュ"
description: "Turbo はモーフィングとスクロール位置の保存によってスムースなページの更新を可能にします"
order: 3
commit: "b8487ee"
---

# モーフィングによるスムーズなページリフレッシュ

 [Turbo Drive](/turbo/handbook/drive/)は全ページを読み込み直さないことによってナビゲーションを速くしています。しかし、 Turbo がページへの忠実度をさらに上げるやり方があります：現在のページをもう一度ロードすることです（ページリフレッシュ）

 ページリフレッシュのよくある使われ方は、フォームを送信してリダイレクトで返ってくる場合です。この場合、ページの `<body>` を置き換えるより、変更された内容のみを反映できれば、体感はぐっと良くなります。 Turbo はこの改善を、モーフィングとスクロール位置の保存によって行うことができます。

  <details>
  <summary>原文</summary>

  [Turbo Drive](https://turbo.hotwired.dev/handbook/drive) makes navigation faster by avoiding full-page reloads. But there is a scenario where Turbo can raise the fidelity bar further: loading the current page again (page refresh).

  A typical scenario for page refreshes is submitting a form and getting redirected back. In such scenarios, sensations significantly improve if only the changed contents get updated instead of replacing the `<body>` of the page. Turbo can do this on your behalf with morphing and scroll preservation.
  </details>

  ${toc}

  ## モーフィング

 Turboがページのリフレッシュをどのように扱うかは、ページのhead内の `<meta name="turbo-refresh-method">` で設定できます。

  ```html
  <head>
    ...
    <meta name="turbo-refresh-method" content="morph">
  </head>
  ```

  取りうる値は `morph` か `replace`（デフォルト）です。`morph` を指定すると、ページのリフレッシュが起こった際、`<body>` を置き換えるかわりに、Turboは変更のあったDOMを更新し、その他の部分はそのままにします。このアプローチによって、画面の状態が保持されるため、体感は向上します。

  内部的には、 Turboはすばらしい [idiomorph library](https://github.com/bigskysoftware/idiomorph) を使っています。

  <details>
  <summary>原文</summary>

  You can configure how Turbo handles page refresh with a `<meta name="turbo-refresh-method">` in the page's head.

  ```html
  <head>
    ...
    <meta name="turbo-refresh-method" content="morph">
  </head>
  ```

  The possible values are `morph` or `replace` (the default). When it is `morph,` when a page refresh happens, instead of replacing the page's `<body>,` Turbo will only update the DOM elements that have changed, keeping the rest untouched. This approach delivers better sensations because it keeps the screen state.

  Under the hood, Turbo uses the fantastic [idiomorph library](https://github.com/bigskysoftware/idiomorph).

  </details>

## スクロール位置の保持

Turboがどのようにスクロールを扱うかは、ページのhead内の  `<meta name="turbo-refresh-scroll">` で設定できます。

```html
<head>
  ...
  <meta name="turbo-refresh-scroll" content="preserve">
</head>
```

取りうる値は `preserve` か `reset`（デフォルト）です。`preserve` を指定すると、ページのリフレッシュが起こった際、Turbo はページの縦横のスクロール位置を保持します。

  <details>
  <summary>原文</summary>

You can configure how Turbo handles scrolling with a `<meta name="turbo-refresh-scroll">` in the page's head.

```html
<head>
  ...
  <meta name="turbo-refresh-scroll" content="preserve">
</head>
```

The possible values are `preserve` or `reset` (the default). When it is `preserve`, when a page refresh happens, Turbo will keep the page's vertical and horizontal scroll.
  </details>

## モーフィングからのセクションの排除指定

 時には、モーフィングを指定しながらも、特定の要素だけは無視したいこともあるでしょう。例えば、ページがリフレッシュされた際に、ポップオーバーだけは保持しなければならない場合などです。対象の要素に、`data-turbo-permanent` のフラグをつけることで、Turboはその要素をモーフィングの対象から外します。

```html
<div data-turbo-permanent>...</div>
```
  <details>
  <summary>原文</summary>

Sometimes, you want to ignore certain elements while morphing. For example, you might have a popover that you want to keep open when the page refreshes. You can flag such elements with `data-turbo-permanent`, and Turbo won't attempt to morph them.

```html
<div data-turbo-permanent>...</div>
```
  </details>


## Turbo フレーム
 ページリフレッシュ時、画面の中でモーフィングを使ってリロードする範囲を、 [turbo フレーム](/turbo/handbook/frames/) を使って定義できます。定義のためには、そのフレームに `refresh="morph"` でフラグを立てておく必要があります。

```html
<turbo-frame id="my-frame" refresh="morph">
  ...
</turbo-frame>
```

 この仕組みによって、はじめのページ読み込みでは到達できない内容（ページネーションなど）を読み込むことができます。ページのリフレッシュが起こった際、 Turbo はフレーム内の内容を取り除きません。代わりに、Turboフレームをリロードし、モーフィングで描画します。

  <details>
  <summary>原文</summary>

You can use [turbo frames](https://turbo.hotwired.dev/handbook/frames) to define regions in your screen that will get reloaded using morphing when a page refresh happens. To do so, you must flag those frames with `refresh="morph"`.

```html
<turbo-frame id="my-frame" refresh="morph">
  ...
</turbo-frame>
```

With this mechanism, you can load additional content that didn't arrive in the initial page load (e.g., pagination). When a page refresh happens, Turbo won't remove the frame contents; instead, it will reload the turbo frame and render its contents with morphing.

  </details>

## ページリフレッシュのブロードキャスト
  `refresh` と呼ばれる新しい[turbo ストリームのアクション](/turbo/handbook/streams/)があります。このアクションは、ページリフレッシュを起こします。

```html
<turbo-stream action="refresh"></turbo-stream>
```

 サーバーサイドフレームワークはこれらのストリームに、シンプルですが強力なブロードキャストのモデルでテコ入れすることができます。つまり、サーバーが単一の汎用的なシグナルをブロードキャストすると、ページはモーフィングによってスムーズにその内容に更新される、ということです。


 Railsでは、 [`turbo-rails`](https://github.com/hotwired/turbo-rails) gem によって次のように行うこととができます。

```ruby
# モデル
class Calendar < ApplicationRecord
  broadcasts_refreshes
end

# ビュー
turbo_stream_from @calendar
```
  <details>
  <summary>原文</summary>

There is a new [turbo stream action](https://turbo.hotwired.dev/handbook/streams) called `refresh` that will trigger a page refresh:

```html
<turbo-stream action="refresh"></turbo-stream>
```

Server-side frameworks can leverage these streams to offer a simple but powerful broadcasting model: the server broadcasts a single general signal, and pages smoothly refresh with morphing.

You can see how the  [`turbo-rails`](https://github.com/hotwired/turbo-rails) gem does it for Rails:

```ruby
class Calendar < ApplicationRecord
  broadcasts_refreshes
end

# View
turbo_stream_from @calendar
```
  </details>
