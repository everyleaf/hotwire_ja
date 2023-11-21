---
title: Streams
description: Turbo ストリームのリファレンス
---

# Streams

## 7つのアクション

### Append 追加する
target の dom_id によって指定されたコンテナに template タグ内のコンテンツを追加します。

```html
<turbo-stream action="append" target="dom_id">
  <template>
    dom_idで指定されたコンテナに追加するコンテンツ
  </template>
</turbo-stream>
```

もしtemplateの最初の要素がdom_idで指定されたコンテナの直下の子要素に既に使用されているidを持っていた場合、追加するのではなく置き換えられます。

### Prepend 先頭に追加
targetのdom_idによって指定されたコンテナにtemplateタグ内のコンテンツを先頭に追加します。

```html
<turbo-stream action="prepend" target="dom_id">
  <template>
    dom_idで指定されたコンテナの先頭に追加するコンテンツ
  </template>
</turbo-stream>
```

もしtemplateの最初の要素がdom_idで指定されたコンテナの直下の子要素に既に使用されているidを持っていた場合、先頭に追加するのではなく置き換えられます。

### Replace 置き換える
targetのdom_idで指定された要素を置き換えます。

```html
<turbo-stream action="replace" target="dom_id">
  <template>
    dom_idで指定された要素を置き換えるためのコンテンツ
  </template>
</turbo-stream>
```

### Update 更新する
target の dom_id で指定されたコンテナを template タグ内のコンテンツで更新します。

```html
<turbo-stream action="update" target="dom_id">
  <template>
    dom_idで指定されたコンテナを更新するためのコンテンツ
  </template>
</turbo-stream>
```

### Remove 取り除く
targetのdom_idで指定された要素を取り除く。

```html
<turbo-stream action="remove" target="dom_id">
</turbo-stream>
```

### Before 要素の前に挿入
targetのdom_idで指定された要素の前に、templateタグ内のコンテンツを挿入します。

```html
<turbo-stream action="before" target="dom_id">
  <template>
    dom_idで指定された要素の前に配置するためのコンテンツ
  </template>
</turbo-stream>
```

### After 要素の前に挿入
targetのdom_idで指定された要素の後にtemplateタグ内のコンテンツを挿入します。

```html
<turbo-stream action="after" target="dom_id">
  <template>
    dom_idで指定された要素のあとに配置するコンテンツ
  </template>
</turbo-stream>
```

## 複数の要素に対してアクションを行う
単一のアクションで複数の要素を対象にする場合は、 `target`属性の代わりにCSSセレクターを用いて`targets`属性を使います。

```html
<turbo-stream action="remove" targets=".elementsWithClass">
</turbo-stream>

<turbo-stream action="after" targets=".elementsWithClass">
  <template>
    CSSクエリで指定された要素のあとに配置するコンテンツ
  </template>
</turbo-stream>
```

## Stream要素を処理する
Turboはstreamアクションを受け取り処理するためにあらゆる形式のストリームとつながることが出来ます。Streamソースはそのイベントの`data`属性にstreamアクションHTMLを含む[MessageEvent](https://developer.mozilla.org/ja/docs/Web/API/MessageEvent)を送信する必要があります。それから `Turbo.session.connectStreamSource(source)`によって接続され、`Turbo.session.connectStreamSource(source)`によって切断されます。もし`MessageEvents`を生成するものとは異なるソースからstreamアクションを処理する必要がある場合には、`Turbo.renderStreamMessage(streamActionHTML)`と使うことでそれを行うことが出来ます。

これらをまとめる良い方法は、turbo-railsが[TurboCableStreamSourceElement](https://github.com/hotwired/turbo-rails/blob/main/app/javascript/turbo/cable_stream_source_element.js)で行っているようにカスタム要素を使用することです。
