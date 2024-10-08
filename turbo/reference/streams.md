---
order: 3
title: Turbo ストリーム
description: Turbo ストリームのリファレンス
---

# Turbo ストリーム

## 7つのアクション

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

## The seven actions

### Append

Appends the content within the template tag to the container designated by the target dom id.

If the template’s first element has an id that is already used by a direct child inside the container targeted by dom_id, it is replaced instead of appended.
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

If the template’s first element has an id that is already used by a direct child inside the container targeted by dom_id, it is replaced instead of prepended.
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

<details>
<summary>原文</summary>

### Replace 

Replaces the element designated by the target dom id.
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

<details>
<summary>原文</summary>

### Update

Updates the content within the template tag to the container designated by the target dom id.
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

