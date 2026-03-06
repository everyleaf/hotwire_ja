---
order: 3
title: Turbo ストリーム
description: Turbo ストリームのリファレンス
commit: "4f4c385"
---

# Turbo ストリーム

## 8つのアクション

### Append 追加する
target の dom_id によって指定されたコンテナに template タグ内のコンテンツを追加します。

```html
<turbo-stream action="append" target="dom_id">
  <template>
    dom_id で指定されたコンテナに追加するコンテンツ
  </template>
</turbo-stream>
```

もし template の最初の要素が dom_id で指定されたコンテナの直下の子要素に既に使用されている id を持っていた場合、追加するのではなく置き換えられます。

<details>
<summary>原文</summary>

## The eight actions

### Append

Appends the content within the template tag to the container designated by the target dom id.

```html
<turbo-stream action="append" target="dom_id">
  <template>
    Content to append to container designated with the dom_id.
  </template>
</turbo-stream>
```

If the template's first element has an id that is already used by a direct child inside the container targeted by dom_id, it is replaced instead of appended.
</details>

### Prepend 先頭に追加

target の dom_id によって指定されたコンテナに template タグ内のコンテンツを先頭に追加します。

```html
<turbo-stream action="prepend" target="dom_id">
  <template>
    dom_id で指定されたコンテナの先頭に追加するコンテンツ
  </template>
</turbo-stream>
```

もし template の最初の要素が dom_id で指定されたコンテナの直下の子要素に既に使用されている id を持っていた場合、先頭に追加するのではなく置き換えられます。

<details>
<summary>原文</summary>

### Prepend

Prepends the content within the template tag to the container designated by the target dom id.

```html
<turbo-stream action="prepend" target="dom_id">
  <template>
    Content to prepend to container designated with the dom_id.
  </template>
</turbo-stream>
```

If the template's first element has an id that is already used by a direct child inside the container targeted by dom_id, it is replaced instead of prepended.
</details>

### Replace 置き換える

target の dom_id で指定された要素を置き換えます。

```html
<turbo-stream action="replace" target="dom_id">
  <template>
    dom_id で指定された要素を置き換えるためのコンテンツ
  </template>
</turbo-stream>
```

`turbo-stream`要素に`[method="morph"]`属性を追加することで、ターゲットとなる dom_id で指定された要素をmorph経由で置き換えられます。

```html
<turbo-stream action="replace" method="morph" target="dom_id">
  <template>
    要素を置き換えるコンテンツ
  </template>
</turbo-stream>
```

<details>
<summary>原文</summary>

### Replace 

Replaces the element designated by the target dom id.

```html
<turbo-stream action="replace" target="dom_id">
  <template>
    Content to replace the element designated with the dom_id.
  </template>
</turbo-stream>
```

The `[method="morph"]` attribute can be added to the `turbo-stream` element to replace the element designated by the target dom id via morph.

```html
<turbo-stream action="replace" method="morph" target="dom_id">
  <template>
    Content to replace the element.
  </template>
</turbo-stream>
```
</details>

### Update 更新する

target の dom_id で指定されたコンテナを template タグ内のコンテンツで更新します。

```html
<turbo-stream action="update" target="dom_id">
  <template>
    dom_id で指定されたコンテナを更新するためのコンテンツ
  </template>
</turbo-stream>
```

`turbo-stream`要素に`[method="morph"]`属性を追加することで、ターゲットとなる dom_id で指定された要素の子要素のみを変形させられます。

```html
<turbo-stream action="update" method="morph" target="dom_id">
  <template>
    要素を置き換えるコンテンツ
  </template>
</turbo-stream>
```

<details>
<summary>原文</summary>

### Update

Updates the content within the template tag to the container designated by the target dom id.

```html
<turbo-stream action="update" target="dom_id">
  <template>
    Content to update to container designated with the dom_id.
  </template>
</turbo-stream>
```

The `[method="morph"]` attribute can be added to the `turbo-stream` element to morph only the children of the element designated by the target dom id.

```html
<turbo-stream action="update" method="morph" target="dom_id">
  <template>
    Content to replace the element.
  </template>
</turbo-stream>
```
</details>

### Remove 取り除く

target の dom_id で指定された要素を取り除く。

```html
<turbo-stream action="remove" target="dom_id">
</turbo-stream>
```

<details>
<summary>原文</summary>

### Remove

Removes the element designated by the target dom id.

```html
<turbo-stream action="remove" target="dom_id">
</turbo-stream>
```
</details>

### Before 要素の前に挿入

target の dom_id で指定された要素の前に、 template タグ内のコンテンツを挿入します。

```html
<turbo-stream action="before" target="dom_id">
  <template>
    dom_id で指定された要素の前に配置するためのコンテンツ
  </template>
</turbo-stream>
```

<details>
<summary>原文</summary>

### Before

Inserts the content within the template tag before the element designated by the target dom id.

```html
<turbo-stream action="before" target="dom_id">
  <template>
    Content to place before the element designated with the dom_id.
  </template>
</turbo-stream>
```
</details>

### After 要素の前に挿入

target の dom_id で指定された要素の後に template タグ内のコンテンツを挿入します。

```html
<turbo-stream action="after" target="dom_id">
  <template>
    dom_id で指定された要素のあとに配置するコンテンツ
  </template>
</turbo-stream>
```

<details>
<summary>原文</summary>

### After

Inserts the content within the template tag after the element designated by the target dom id.

```html
<turbo-stream action="after" target="dom_id">
  <template>
    Content to place after the element designated with the dom_id.
  </template>
</turbo-stream>
```
</details>

### Refresh リフレッシュ

新しいコンテンツをレンダリングするために [ページリフレッシュ](/turbo/handbook/page_refreshes/) を始めます。

```html
<!-- `[request-id]` が無い場合 -->
<turbo-stream action="refresh"></turbo-stream>

<!-- `[request-id]` で連続実行を防止 -->
<turbo-stream action="refresh" request-id="abcd-1234"></turbo-stream>

<!-- `[method]` および `[scroll]` によるリフレッシュ動作 -->
<turbo-stream action="refresh" method="morph" scroll="preserve"></turbo-stream>
```

<details>
<summary>原文</summary>

### Refresh

Initiates a [Page Refresh](https://turbo.hotwired.dev/handbook/page_refreshes) to render new content.

```html
<!-- without `[request-id]` -->
<turbo-stream action="refresh"></turbo-stream>

<!-- debounced with `[request-id]` -->
<turbo-stream action="refresh" request-id="abcd-1234"></turbo-stream>

<!-- refresh behavior with `[method]` and `[scroll]` -->
<turbo-stream action="refresh" method="morph" scroll="preserve"></turbo-stream>
```

</details>

## 複数の要素に対してアクションを行う

単一のアクションで複数の要素を対象にする場合は、 `target` 属性の代わりにCSSセレクターを用いて `targets` 属性を使います。

```html
<turbo-stream action="remove" targets=".elementsWithClass">
</turbo-stream>

<turbo-stream action="after" targets=".elementsWithClass">
  <template>
    CSS クエリで指定された要素のあとに配置するコンテンツ
  </template>
</turbo-stream>
```

<details>
<summary>原文</summary>

## Targeting Multiple Elements

To target multiple elements with a single action, use the targets attribute with a CSS query selector instead of the target attribute.

```html
<turbo-stream action="remove" targets=".elementsWithClass">
</turbo-stream>

<turbo-stream action="after" targets=".elementsWithClass">
  <template>
    Content to place after the elements designated with the css query.
  </template>
</turbo-stream>
```
</details>

## Stream要素を処理する

Turbo は stream アクションを受け取り処理するためにあらゆる形式のストリームとつながることが出来ます。Stream ソースはそのイベントの `data` 属性に stream アクション HTML を含む [MessageEvent](https://developer.mozilla.org/ja/docs/Web/API/MessageEvent) を送信する必要があります。それから `Turbo.session.connectStreamSource(source)` によって接続され、 `Turbo.session.connectStreamSource(source)` によって切断されます。もし `MessageEvents` を生成するものとは異なるソースから stream アクションを処理する必要がある場合には、 `Turbo.renderStreamMessage(streamActionHTML)` と使うことでそれを行うことが出来ます。

これらをまとめる良い方法は、 turbo-rails が [TurboCableStreamSourceElement](https://github.com/hotwired/turbo-rails/blob/main/app/javascript/turbo/cable_stream_source_element.js) で行っているようにカスタム要素を使用することです。

<details>
<summary>原文</summary>

## Processing Stream Elements

Turbo can connect to any form of stream to receive and process stream actions. A stream source must dispatch MessageEvent messages that contain the stream action HTML in the data attribute of that event. It’s then connected by Turbo.session.connectStreamSource(source) and disconnected via Turbo.session.disconnectStreamSource(source). If you need to process stream actions from different source than something producing MessageEvents, you can use Turbo.renderStreamMessage(streamActionHTML) to do so.

A good way to wrap all this together is by using a custom element, like turbo-rails does with TurboCableStreamSourceElement.
</details>

## HTML内のストリーム要素

Turbo ストリームは [カスタムHTML要素](https://developer.mozilla.org/ja/docs/Web/API/Web_components/Using_custom_elements)として実装されています。
この要素は、要素がページの DOM に接続されたときにブラウザが呼び出す `connectedCallback` 関数の一部として解釈されます。

つまり、DOM にレンダリングされたストリーム要素はすべて解釈されるということです。 解釈された後、Turbo は要素を DOM から削除します。具体的には、ページやフレームのコンテンツ HTML 内でストリームアクションをレンダリングすると、それらが実行されるということです。これを利用して、メインコンテンツの読み込みとは別に追加の副作用を実行できます。

<details>
<summary>原文</summary>

## Stream Elements inside HTML

Turbo streams are implemented as [a custom HTML element](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements).
The element is interpreted as part of the `connectedCallback` function that the browser calls when the element is connected to the page dom.

This means that any stream elements that are rendered into the dom will be interpreted. After being interpreted, Turbo will remove the element from the dom. More specifically, it means that rendering stream actions inside the page or frame content HTML will cause them to be executed. This can be used to execute additional sideffects beside the main content loading.

</details>
