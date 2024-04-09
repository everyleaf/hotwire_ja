---
order: 02
description: "Turboフレームのリファレンス"
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

Confines all navigation within the frame by expecting any followed link or form submission to return a response including a matching frame tag:
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

Works like the basic frame, but the content is loaded from a remote `src` first.
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

Like an eager-loaded frame, but the content is not loaded from `src` until the frame is visible.
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

# 属性、プロパティ、関数

`<turbo-frame>`要素は、独自のHTML属性とJavaScriptプロパティを持つ[カスタム要素][]です。

[カスタム要素]: https://developer.mozilla.org/ja/docs/Web/API/Web_components/Using_custom_elements

<details>
<summary>原文</summary>

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
* `autoscroll`は真偽属性で、読み込み後に`<turbo-frame>`要素（および、その子孫の`<turbo-frame>`要素）をスクロールして表示するかどうかをコントロールします。`data-autoscroll-block`属性に、[Element.scrollIntoView({ block: "..." })][Element.scrollIntoView]で有効な `"end"`、`"start"`、`"center"`、`"nearest"`のどれかを指定することで、垂直方向のスクロールをコントロールします。`data-autoscroll-block`属性がない場合、デフォルト値は `"end"`です。`data-autoscroll-behavior`属性に、[Element.scrollIntoView({ behavior: "..." })][Element.scrollIntoView]で有効な `"auto"`、`"smooth"`のどれかを指定することで、スクロールの振る舞いをコントロールします。`data-autoscroll-behavior`属性がない場合、デフォルト値は `"auto"`です。

[真偽属性]: https://momdo.github.io/html/common-microsyntaxes.html#boolean-attributes
[列挙属性]: https://momdo.github.io/html/common-microsyntaxes.html#keywords-and-enumerated-attributes
[Element.scrollIntoView]: https://developer.mozilla.org/ja/docs/Web/API/Element/scrollIntoView

<details>
<summary>原文</summary>

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

* `autoscroll` is a [boolean attribute][] that controls whether or not to scroll
  a `<turbo-frame>` element (and its descendant `<turbo-frame>` elements) into
  view when after loading. Control the scroll's vertical alignment by setting the
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

* `FrameElement.reload()`は、フレーム要素をその`src`からリロードします。

<details>
<summary>原文</summary>

* `FrameElement.reload()` is a function that reloads the frame element from its `src`.
</details>
