---
permalink: /reference/frames.html
order: 02
description: "A reference of everything you can do with Turbo Frames."
---

# Frames
フレーム

## Basic frame
基本フレーム

Confines all navigation within the frame by expecting any followed link or form submission to return a response including a matching frame tag:

フレーム内でのナビゲーションを制限し、フォローされたリンクやフォームの送信が、マッチングするフレームタグを含むレスポンスを返すことを期待する。

```html
<turbo-frame id="messages">
  <a href="/messages/expanded">
    Show all expanded messages in this frame.
    このフレームに展開されたメッセージをすべて表示する。
  </a>

  <form action="/messages">
    Show response from this form within this frame.
    このフレーム内にこのフォームからの応答を表示する。
  </form>
</turbo-frame>
```

## Eager-loaded frame
イージーロードフレーム

Works like the basic frame, but the content is loaded from a remote `src` first.

基本的なフレームと同じように動作しますが、コンテンツはまずリモートのsrcから読み込まれます。

```html
<turbo-frame id="messages" src="/messages">
  Content will be replaced when /messages has been loaded.
  コンテンツは、/messagesがロードされたときに置き換えられます。
</turbo-frame>
```

## Lazy-loaded frame
レイジー・ロード・フレーム

Like an eager-loaded frame, but the content is not loaded from `src` until the frame is visible.

eager-loadedフレームと似ていますが、フレームが表示されるまで、コンテンツはsrcから読み込まれません。

```html
<turbo-frame id="messages" src="/messages" loading="lazy">
  Content will be replaced when the frame becomes visible and /messages has been loaded.
  フレームが表示され、/messagesが読み込まれると、コンテンツは置き換えられます。
</turbo-frame>
```

## Frame targeting the whole page by default
デフォルトでページ全体を対象とするフレーム

```html
<turbo-frame id="messages" target="_top">
  <a href="/messages/1">
    Following link will replace the whole page, not this frame.
    以下のリンクは、このフレームではなく、ページ全体を置き換えます。
  </a>

  <a href="/messages/1" data-turbo-frame="_self">
    Following link will replace just this frame.
    以下のリンクは、このフレームだけを交換するものです。
  </a>

  <form action="/messages">
    Submitting form will replace the whole page, not this frame.
    フォームを送信すると、このフレームではなく、ページ全体が置き換えられます。
  </form>
</turbo-frame>
```

## Frame with overwritten navigation targets
ナビゲーションターゲットが上書きされたフレーム

```html
<turbo-frame id="messages">
  <a href="/messages/1">
    Following link will replace this frame.
    以下のリンクは、このフレームを置き換えるものです。
  </a>

  <a href="/messages/1" data-turbo-frame="_top">
    Following link will replace the whole page, not this frame.
    以下のリンクは、このフレームではなく、ページ全体を置き換えます。
  </a>

  <form action="/messages" data-turbo-frame="navigation">
    Submitting form will replace the navigation frame.
    フォームを送信すると、ナビゲーションフレームが置き換えられます。
  </form>
</turbo-frame>
```

## Frame that promotes navigations to Visits
ビジターへのナビゲーションを促進するフレーム

```html
<turbo-frame id="messages" data-turbo-action="advance">
  <a href="/messages?page=2">Advance history to next page</a>
  <a href="/messages?page=2">次のページへ履歴を進める</a>
  <a href="/messages?page=2" data-turbo-action="replace">Replace history with next page</a>
  <a href="/messages?page=2" data-turbo-action="replace">履歴を次のページに置き換える</a>
</turbo-frame>
```

# Attributes, properties, and functions
属性、プロパティ、関数

The `<turbo-frame>` element is a [custom element][] with its own set of HTML
attributes and JavaScript properties.
<turbo-frame>要素は、独自のHTML属性とJavaScriptプロパティを持つカスタム要素です。

[custom element]: https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements

## HTML Attributes
HTML属性

* `src` accepts a URL or path value that controls navigation
  of the element
* srcは、要素のナビゲーションを制御するURLまたはパスの値を受け入れます。
* `loading` has two valid [enumerated][] values: "eager" and "lazy". When
  `loading="eager"`, changes to the `src` attribute will immediately navigate
  the element. When `loading="lazy"`, changes to the `src` attribute will defer
  navigation until the element is visible in the viewport. The default value is `eager`.
* loadingには2つの有効な列挙値がある：「eager "と "lazy "です。loading="eager "の場合、src属性への変更は即座に要素をナビゲートします。loading="lazy "の場合、src属性への変更は、要素がビューポートに表示されるまでナビゲーションを延期します。デフォルト値はeagerです。
* `busy` is a [boolean attribute][] toggled to be present when a
  `<turbo-frame>`-initiated request starts, and toggled false when the request
  ends
* busy属性は、<turbo-frame>によって開始されたリクエストが開始されたときにオン、終了したときにオフに切り替わります。
* `disabled` is a [boolean attribute][] that prevents any navigation when
  present
* disabledはブーリアン属性で、この属性があるとナビゲーションができなくなります。
* `target` refers to another `<turbo-frame>` element by ID to be navigated when
  a descendant `<a>` is clicked. When `target="_top"`, navigate the window.
* targetは、子孫の<a>がクリックされたときに移動する別の<turbo-frame>要素をIDで指定します。target="_top "の場合、ウィンドウを移動する。
* `complete` is a boolean attribute whose presence or absence indicates whether
  or not the `<turbo-frame>` element has finished navigating.
* completeは、<turbo-frame>要素がナビゲーションを終了したかどうかを示す真偽値属性です。
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
* autoscrollは、読み込み後に<turbo-frame>要素（およびその子孫の<turbo-frame>要素）をスクロールして表示するかどうかを制御するブール値属性です。data-autoscroll-block属性に、有効なElement.scrollIntoView({ block: "..." })の値："end"、"start"、"center"、"nearest "のいずれかを設定することで、スクロールの垂直方向の配置を制御します。data-autoscroll-blockがない場合、デフォルト値は "end "です。data-autoscroll-behavior属性を有効なElement.scrollIntoView({ behavior: "..." })の値に設定することで、スクロールの振る舞いを制御します。data-autoscroll-behaviorがない場合、デフォルト値は "auto "です。

[boolean attribute]: https://www.w3.org/TR/html52/infrastructure.html#sec-boolean-attributes
[enumerated]: https://www.w3.org/TR/html52/infrastructure.html#keywords-and-enumerated-attributes
[Element.scrollIntoView]: https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollIntoView#parameters

## Properties
プロパティ

All `<turbo-frame>` elements can be controlled in JavaScript environments
through instances of the `FrameElement` class.
すべての <turbo-frame> 要素は、FrameElement クラスのインスタンスを通して JavaScript 環境で制御することができます。

* `FrameElement.src` controls the pathname or URL to be loaded. Setting the `src` 
   property will immediately navigate the element. When `FrameElement.loaded` is 
   set to `"lazy"`, changes to the `src` property will defer navigation until the 
   element is visible in the viewport.
* FrameElement.srcは、読み込むパス名またはURLを制御します。srcプロパティを設定すると、要素は即座にナビゲートされます。FrameElement.loadedが "lazy "に設定されている場合、srcプロパティを変更すると、要素がビューポートに表示されるまでナビゲーションが延期されます。
* `FrameElement.disabled` is a boolean property that controls whether or not the
  element will load
* FrameElement.disabledは、要素をロードするかどうかを制御するブール値のプロパティです。
* `FrameElement.loading` controls the style (either `"eager"` or `"lazy"`) that
  the frame will loading its content.
* FrameElement.loadingは、フレームがコンテンツをロードするスタイル（"eager "または "lazy"）を制御します。
* `FrameElement.loaded` references a [Promise][] instance that resolves once the
  `FrameElement`'s current navigation has completed.
* FrameElement.loadedは、FrameElementの現在のナビゲーションが完了すると解決されるPromiseインスタンスを参照します。
* `FrameElement.complete` is a read-only boolean property set to `true` when the
  `FrameElement` has finished navigating and `false` otherwise.
* FrameElement.completeは、読み取り専用のブール値プロパティで、FrameElementがナビゲーションを終了した時にtrueに設定され、そうでなければfalseに設定されます。
* `FrameElement.autoscroll` controls whether or not to scroll the element into
  view once loaded
* FrameElement.autoscrollは、一度読み込まれた要素をスクロールして表示するかどうかを制御します。
* `FrameElement.isActive` is a read-only boolean property that indicates whether
  or not the frame is loaded and ready to be interacted with
* FrameElement.isActiveは読み取り専用のブール値プロパティで、フレームが読み込まれ、インタラクションできる状態になっているかどうかを示します。
* `FrameElement.isPreview` is a read-only boolean property that returns `true`
  when the `document` that contains the element is a [preview][].
* FrameElement.isPreviewは読み取り専用のブール型プロパティで、要素を含むドキュメントがプレビューである場合に真を返します。

## Functions

* `FrameElement.reload()` is a function that reloads the frame element from its `src`.
* FrameElement.reload()は、フレーム要素をそのsrcからリロードする関数です。
