---
order: 2
title: "フレーム"
description: "Turboフレームのリファレンス"
commit: "17e5033"
---

# フレーム

## 基本フレーム

フレーム内にある、リンク先または送信したフォームのレスポンスにこのフレームとマッチするフレームタグが含まれていることを期待し、フレーム内の全ナビゲーションを制限しています。

```html
<turbo-frame id="messages">
  <a href="/messages/expanded">
    このフレームに、展開されたメッセージをすべて表示する。
  </a>

  <form action="/messages">
    このフレームに、フォームからの応答を表示する。
  </form>
</turbo-frame>
```

<details>
<summary>原文</summary>

# Frames

## Basic frame

Confines all navigation within the frame by expecting any followed link or form submission to return a response including a matching frame tag:

```html
<turbo-frame id="messages">
  <a href="/messages/expanded">
    Show all expanded messages in this frame.
  </a>

  <form action="/messages">
    Show response from this form within this frame.
  </form>
</turbo-frame>
```
</details>

## フレームの事前読み込み

基本的なフレームと同じように動作しますが、コンテンツはまずリモートの`src`から読み込まれます。

```html
<turbo-frame id="messages" src="/messages">
  コンテンツは、/messagesが読み込まれたときに置き換えられます。
</turbo-frame>
```

<details>
<summary>原文</summary>

## Eager-loaded frame

Works like the basic frame, but the content is loaded from a remote `src` first.

```html
<turbo-frame id="messages" src="/messages">
  Content will be replaced when /messages has been loaded.
</turbo-frame>
```
</details>

## フレームの遅延読み込み

フレームの事前読み込みに似ていますが、フレームが表示されるまでコンテンツは`src`から読み込まれません。

```html
<turbo-frame id="messages" src="/messages" loading="lazy">
  このフレームが表示され、/messagesが読み込まれると、コンテンツは置き換えられます。
</turbo-frame>
```

<details>
<summary>原文</summary>

## Lazy-loaded frame

Like an eager-loaded frame, but the content is not loaded from `src` until the frame is visible.

```html
<turbo-frame id="messages" src="/messages" loading="lazy">
  Content will be replaced when the frame becomes visible and /messages has been loaded.
</turbo-frame>
```
</details>

## デフォルトでページ全体を対象とするフレーム

```html
<turbo-frame id="messages" target="_top">
  <a href="/messages/1">
    このリンクは、このフレームではなく、ページ全体を置き換えます。
  </a>

  <a href="/messages/1" data-turbo-frame="_self">
    このリンクは、このフレームだけを置き換えます。
  </a>

  <form action="/messages">
    フォームの送信は、このフレームではなく、ページ全体を置き換えます。
  </form>
</turbo-frame>
```

<details>
<summary>原文</summary>

## Frame targeting the whole page by default

```html
<turbo-frame id="messages" target="_top">
  <a href="/messages/1">
    Following link will replace the whole page, not this frame.
  </a>

  <a href="/messages/1" data-turbo-frame="_self">
    Following link will replace just this frame.
  </a>

  <form action="/messages">
    Submitting form will replace the whole page, not this frame.
  </form>
</turbo-frame>
```

</details>

## ナビゲーションターゲットが上書きされたフレーム

```html
<turbo-frame id="messages">
  <a href="/messages/1">
    このリンクは、このフレームを置き換えます。
  </a>

  <a href="/messages/1" data-turbo-frame="_top">
    このリンクは、このフレームではなく、ページ全体を置き換えます。
  </a>

  <form action="/messages" data-turbo-frame="navigation">
    フォームの送信は、このフレームではなく、idが navigationのフレームを置き換えます。
  </form>
</turbo-frame>
```

<details>
<summary>原文</summary>

## Frame with overwritten navigation targets

```html
<turbo-frame id="messages">
  <a href="/messages/1">
    Following link will replace this frame.
  </a>

  <a href="/messages/1" data-turbo-frame="_top">
    Following link will replace the whole page, not this frame.
  </a>

  <form action="/messages" data-turbo-frame="navigation">
    Submitting form will replace the navigation frame.
  </form>
</turbo-frame>
```
</details>

## ページ遷移をナビゲーションしやすくするフレーム

```html
<turbo-frame id="messages" data-turbo-action="advance">
  <a href="/messages?page=2">
    ブラウザ履歴を次のページへ進めます
  </a>
  <a href="/messages?page=2" data-turbo-action="replace">
    ブラウザ履歴を次のページに置き換えます
  </a>
</turbo-frame>
```

<details>
<summary>原文</summary>

## Frame that promotes navigations to Visits

```html
<turbo-frame id="messages" data-turbo-action="advance">
  <a href="/messages?page=2">Advance history to next page</a>
  <a href="/messages?page=2" data-turbo-action="replace">Replace history with next page</a>
</turbo-frame>
```
</details>

## ページ更新時および明示的に.reload()で再読み込みされた際にモーフィング効果を伴って再読み込みされるフレーム

```html
<turbo-frame id="my-frame" refresh="morph" src="/my_frame">
</turbo-frame>
```

<details>
<summary>原文</summary>

## Frame that will get reloaded with morphing during page refreshes & when they are explicitly reloaded with .reload()

```html
<turbo-frame id="my-frame" refresh="morph" src="/my_frame">
</turbo-frame>
```
</details>

# 属性、プロパティ、関数

`<turbo-frame>`要素は、独自のHTML属性とJavaScriptプロパティを持つ[カスタム要素][]です。

[カスタム要素]: https://developer.mozilla.org/ja/docs/Web/API/Web_components/Using_custom_elements

<details>
<summary>原文</summary>

# Attributes, properties, and functions

The `<turbo-frame>` element is a [custom element][] with its own set of HTML
attributes and JavaScript properties.

[custom element]: https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements
</details>

## HTML属性

* `src`は、要素のナビゲーションをコントロールするURLまたはパスを受け付けます。
* `loading`は[列挙属性][]で、`"eager"`と`"lazy"`を指定できます。`"eager"`を指定した場合は、`src`属性の値へすぐに遷移します。`lazy`を指定した場合は、`src`属性の値への遷移は、要素がビューポートに表示されるまで遅れます。デフォルト値は`"eager"`です。
* `busy`は[真偽属性][]で、`<turbo-frame>`によるリクエストが開始されたときに`true`、終了したときに`false`になります。
* `disabled`は[真偽属性][]で、この属性があるとナビゲーションができなくなります。
* `target`には、子孫の`<a>`がクリックされたときに遷移する別の`<turbo-frame>`要素をIDで指定します。`target="_top"`の場合、ページ全体が遷移します。
* `complete`は[真偽属性][]で、`<turbo-frame>`要素がナビゲーションを終了したかどうかを示します。
* `recurse`は、別のネストされたフレームを含むコンテンツを`<turbo-frame>`が読み込めるようにします。`recurse` は、フレームの読み込まれたコンテンツ内に存在する別の `<turbo-frame>` 要素を ID で参照します。これは、ターボがターゲットフレームを直接含んでいないレスポンスからフレームコンテンツを抽出する必要がある場合に使用できます。ただし、そのレスポンスにはターゲットフレームを読み込める別のフレームが含まれている必要があります。

  例えば、`/frames.html`に以下が含まれているとします:

```html
<turbo-frame id="recursive" recurse="composer" src="recursive.html">
</turbo-frame>
```

また、`recursive.html`には以下が含まれています:
```html
<turbo-frame id="recursive">
  <turbo-frame id="composer">
    <a href="frames.html">リンク</a>
  </turbo-frame>
</turbo-frame>
```

`Link`が`frames.html`に戻るとき、Turbo は現在の`composer`フレームを更新するために、レスポンス内で ID`composer`のフレームを見つける必要があります。`frames.html`には直接そのようなフレームが存在しないため、Turbo は`recurse="composer"`を持つフレームを見つけ、それをアクティブ化してその`src`（`recursive.html`）を読み込み、その読み込まれたコンテンツから`composer`フレームを検索して抽出し、元のフレームを更新します。

* `autoscroll`は真偽属性で、読み込み後に`<turbo-frame>`要素（および、その子孫の`<turbo-frame>`要素）をスクロールして表示するかどうかをコントロールします。`data-autoscroll-block`属性に、[Element.scrollIntoView({ block: "..." })][Element.scrollIntoView]で有効な `"end"`、`"start"`、`"center"`、`"nearest"`のどれかを指定することで、垂直方向のスクロールをコントロールします。`data-autoscroll-block`属性がない場合、デフォルト値は `"end"`です。`data-autoscroll-behavior`属性に、[Element.scrollIntoView({ behavior: "..." })][Element.scrollIntoView]で有効な `"auto"`、`"smooth"`のどれかを指定することで、スクロールの振る舞いをコントロールします。`data-autoscroll-behavior`属性がない場合、デフォルト値は `"auto"`です。

[真偽属性]: https://momdo.github.io/html/common-microsyntaxes.html#boolean-attributes
[列挙属性]: https://momdo.github.io/html/common-microsyntaxes.html#keywords-and-enumerated-attributes
[Element.scrollIntoView]: https://developer.mozilla.org/ja/docs/Web/API/Element/scrollIntoView

<details>
<summary>原文</summary>

## HTML Attributes

* `src` accepts a URL or path value that controls navigation
  of the element

* `loading` has two valid [enumerated][] values: "eager" and "lazy". When
  `loading="eager"`, changes to the `src` attribute will immediately navigate
  the element. When `loading="lazy"`, changes to the `src` attribute will defer
  navigation until the element is visible in the viewport. The default value is `eager`.

* `busy` is a [boolean attribute][] toggled to be present when a
  `<turbo-frame>`-initiated request starts, and toggled false when the request
  ends

* `disabled` is a [boolean attribute][] that prevents any navigation when
  present

* `target` refers to another `<turbo-frame>` element by ID to be navigated when
  a descendant `<a>` is clicked. When `target="_top"`, navigate the window.

* `complete` is a boolean attribute whose presence or absence indicates whether
  or not the `<turbo-frame>` element has finished navigating.

* `recurse` allows the `<turbo-frame>` to load content that contains another nested
  frame. `recurse` refers to another `<turbo-frame>` element by ID, present in the
  frame's loaded contents. This can be used when Turbo needs to extract frame content
  from a response that doesn't contain the target frame directly, but contains another
  frame that can load the target frame.

  For example, imagine `/frames.html` contains:

```html
<turbo-frame id="recursive" recurse="composer" src="recursive.html">
</turbo-frame>
```

And `recursive.html` contains:
```html
<turbo-frame id="recursive">
  <turbo-frame id="composer">
    <a href="frames.html">Link</a>
  </turbo-frame>
</turbo-frame>
```

When `Link` navigates back to `frames.html`, Turbo needs to find the frame with ID `composer`
in the response to update the current `composer` frame. Since there's no such frame in
`frames.html` directly, Turbo finds the frame with `recurse="composer"`, activates it to load
its `src` (`recursive.html`), then searches for and extracts the `composer` frame from that
loaded content to update the original frame.

* `autoscroll` is a [boolean attribute][] that controls whether or not to scroll
  a `<turbo-frame>` element (and its descendant `<turbo-frame>` elements) into
  view after loading. Control the scroll's vertical alignment by setting the
  `data-autoscroll-block` attribute to a valid [Element.scrollIntoView({ block:
  "..." })][Element.scrollIntoView] value: one of `"end"`, `"start"`, `"center"`,
  or `"nearest"`. When `data-autoscroll-block` is absent, the default value is
  `"end"`. Control the scroll's behavior by setting the
  `data-autoscroll-behavior` attribute to a valid [Element.scrollIntoView({
    behavior:
  "..." })][Element.scrollIntoView] value: one of `"auto"`, or `"smooth"`.
  When `data-autoscroll-behavior` is absent, the default value is `"auto"`.


[boolean attribute]: https://www.w3.org/TR/html52/infrastructure.html#sec-boolean-attributes
[enumerated]: https://www.w3.org/TR/html52/infrastructure.html#keywords-and-enumerated-attributes
[Element.scrollIntoView]: https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollIntoView#parameters
</details>

## プロパティ

すべての`<turbo-frame>`要素は、`FrameElement`クラスのインスタンスを通してJavaScript環境でコントロールされます。

* `FrameElement.src`は、読み込むパス名またはURLをコントロールします。`src`プロパティを設定すると、要素はすぐに遷移します。`FrameElement.loaded`が`"lazy"`の場合、`src`プロパティの変更は、要素の遷移をビューポートに表示されるまで遅らせます。
* `FrameElement.disabled`は真偽値のプロパティで、要素を読み込むかどうかをコントロールします。
* `FrameElement.loading`は、フレームがコンテンツを読み込むスタイル（`"eager"`または`"lazy"`）をコントロールします。
* `FrameElement.loaded`で、`FrameElement`の遷移が完了した後に解決される[Promise][]インスタンスを参照できます。
* `FrameElement.complete`は読み取り専用の真偽値プロパティで、`FrameElement`の遷移が終了した時に`true`に設定され、そうでなければ`false`に設定されます。
* `FrameElement.autoscroll`は、一度読み込まれた要素をスクロールするかどうかをコントロールします。
* `FrameElement.isActive`は読み取り専用の真偽値プロパティで、フレームが読み込まれインタラクションできる状態になっているかどうかを示します。
* `FrameElement.isPreview`は読み取り専用の真偽値プロパティで、要素を含む`document`が[プレビュー][]である場合に`true`を返します。

[Promise]: https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Promise
[プレビュー]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/building/#preview%E3%81%8C%E8%A1%A8%E7%A4%BA%E3%81%97%E3%81%A6%E3%81%84%E3%82%8B%E3%81%8B%E3%81%A9%E3%81%86%E3%81%8B%E3%81%AE%E6%A4%9C%E5%87%BA

<details>
<summary>原文</summary>

## Properties

All `<turbo-frame>` elements can be controlled in JavaScript environments
through instances of the `FrameElement` class.

* `FrameElement.src` controls the pathname or URL to be loaded. Setting the `src` 
   property will immediately navigate the element. When `FrameElement.loaded` is 
   set to `"lazy"`, changes to the `src` property will defer navigation until the 
   element is visible in the viewport.

* `FrameElement.disabled` is a boolean property that controls whether or not the
  element will load

* `FrameElement.loading` controls the style (either `"eager"` or `"lazy"`) that
  the frame will loading its content.

* `FrameElement.loaded` references a [Promise][] instance that resolves once the
  `FrameElement`'s current navigation has completed.

* `FrameElement.complete` is a read-only boolean property set to `true` when the
  `FrameElement` has finished navigating and `false` otherwise.

* `FrameElement.autoscroll` controls whether or not to scroll the element into
  view once loaded

* `FrameElement.isActive` is a read-only boolean property that indicates whether
  or not the frame is loaded and ready to be interacted with

* `FrameElement.isPreview` is a read-only boolean property that returns `true`
  when the `document` that contains the element is a [preview][].

[Promise]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
[preview]: https://turbo.hotwired.dev/handbook/building#detecting-when-a-preview-is-visible
</details>

## 関数

* `FrameElement.reload()`は、フレーム要素をその`src`からリロードする関数です。

<details>
<summary>原文</summary>

## Functions

* `FrameElement.reload()` is a function that reloads the frame element from its `src`.
</details>
