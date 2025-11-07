---
order: 4
title: イベント
description: "Turbo イベントでできるすべてのことのレファレンス"
commit: "17e5033"
---

# イベント

Turbo は、次のソースから発火するさまざまな種類の[カスタムイベント][Custom Events]を提供します。

* [Document](#document)
* [Page Refreshes](#page-refreshes)
* [Forms](#forms)
* [Frames](#frames)
* [Streams](#streams)
* [HTTP Requests](#http-requests)

jQuery と一緒に利用する際は、イベント上のデータは `$event.originalEvent.detail`で取得できるようにする必要があります。

<details>
<summary>原文</summary>

# Events

Turbo emits a variety of [Custom Events][] types, dispatched from the following
sources:

* [Document](#document)
* [Page Refreshes](#page-refreshes)
* [Forms](#forms)
* [Frames](#frames)
* [Streams](#streams)
* [HTTP Requests](#http-requests)

When using jQuery, the data on the event must be accessed as `$event.originalEvent.detail`.

</details>

## Document

Turboドライブは、ナビゲーション・ライフサイクルを追跡しページの読み込みに返答できるイベントを発行します。
特記がない限り、Turbo は、[`document.documentElement`][] オブジェクト（つまり、<html>要素）でイベントを発生させます。

[`document.documentElement`]: https://developer.mozilla.org/ja/docs/Web/API/Document/documentElement

<details>
<summary>原文</summary>

## Document

Turbo Drive emits events that allow you to track the navigation life cycle and respond to page loading. Except where noted, the following events fire on the [document.documentElement][] object (i.e., the `<html>` element).

[document.documentElement]: https://developer.mozilla.org/en-US/docs/Web/API/Document/documentElement

</details>

### `turbo:click`

Turbo が有効になったリンクをクリックしたときに発火します。クリックされた要素が、[`event.target`][] になります。
リクエスト先は、`event.detail.url` で取得できます。このイベントをキャンセルすると、クリックはブラウザに普通のナビゲーションとしてそのまま渡されます。

| `event.detail` プロパティ  | 型                | 説明
|---------------------------|-------------------|------------
| `url`                     | `string`          | リクエストされたURI
| `originalEvent`           | [`MouseEvent`][]  | 元の [`click`] イベント

[`event.target`]: https://developer.mozilla.org/en-US/docs/Web/API/Event/target
[`MouseEvent`]: https://developer.mozilla.org/ja/docs/Web/API/MouseEvent
[`click`]: https://developer.mozilla.org/ja/docs/Web/API/Element/click_event

<details>
<summary>原文</summary>

### `turbo:click`

Fires when you click a Turbo-enabled link. The clicked element is the [event.target][]. Access the requested location with `event.detail.url`. Cancel this event to let the click fall through to the browser as normal navigation.

| `event.detail` property   | Type              | Description
|---------------------------|-------------------|------------
| `url`                     | `string`          | the requested location
| `originalEvent`           | [MouseEvent][]    | the original [`click` event]

[`click` event]: https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event
[event.target]: https://developer.mozilla.org/en-US/docs/Web/API/Event/target
[MouseEvent]: https://developer.mozilla.org/ja/docs/Web/API/MouseEvent

</details>

### `turbo:before-visit`

あるロケーションへアクセスする前に発火します（ブラウザの履歴からのアクセスする場合を除きます）。`event.detail.url` でリクエストされたロケーションを取得できます。このイベントをキャンセルすると、ナビゲーションが中止されます。

あるロケーションに移動する前に発火します（ただし、履歴操作によるナビゲーション時は除きます）。`event.detail.url` からリクエスト先のロケーションを取得できます。このイベントをキャンセルすると、ナビゲーションが行われなくなります。

| `event.detail` プロパティ  | 型                | 説明
|---------------------------|-------------------|------------
| `url`                     | `string`          | リクエストされたロケーション

<details>
<summary>原文</summary>

### `turbo:before-visit`

Fires before visiting a location, except when navigating by history. Access the requested location with `event.detail.url`. Cancel this event to prevent navigation.

| `event.detail` property   | Type              | Description
|---------------------------|-------------------|------------
| `url`                     | `string`          | the requested location

</details>

### `turbo:visit`

ページ遷移が開始された直後に発火します。`event.detail.url` でリクエストされたロケーションを、`event.detail.action` でページ遷移のアクションを取得できます。

| `event.detail` プロパティ  | 型                                    | 説明
|---------------------------|---------------------------------------|------------
| `url`                     | `string`                              | リクエストされたロケーション
| `action`                  | `"advance" \| "replace" \| "restore"` | ページ遷移の[アクション][]

[Action]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/drive#ページ・ナビゲーションの基本

<details>
<summary>原文</summary>

### `turbo:visit`

Fires immediately after a visit starts. Access the requested location with `event.detail.url` and action with `event.detail.action`.

| `event.detail` property   | Type                                  | Description
|---------------------------|---------------------------------------|------------
| `url`                     | `string`                              | the requested location
| `action`                  | `"advance" \| "replace" \| "restore"` | the visit's [Action][]

[Action]: /handbook/drive#page-navigation-basics

</details>

### `turbo:before-cache`

Turbo が現在のページをキャッシュに保存する前に発火します。

`turbo:before-cache` イベントには、`event.detail` プロパティは含まれません。

<details>
<summary>原文</summary>

### `turbo:before-cache`

Fires before Turbo saves the current page to cache.

Instances of `turbo:before-cache` events do not have an `event.detail` property.

</details>

### `turbo:before-render`

ページの描画前に発火します。新しい `<body>` 要素は `event.detail.newBody` から取得できます。描画は `event.detail.resume` を使って停止および再開ができます（詳細は [描画の一時停止][] を参照してください）。Turbo ドライブがレスポンスを描画する方法は、`event.detail.render` 関数を上書きしてカスタマイズできます（詳細は [描画処理をカスタマイズする][] を参照してください）。

| `event.detail` プロパティ  | 型                               | 説明
|---------------------------|---------------------------------|-----------------------------------------------------
| `renderMethod`            | `"replace" \| "morph"`          | 新しいコンテンツを描画するときに使われる方式
| `newBody`                 | [HTMLBodyElement][]             | 現在の `<body>` 要素を置き換える新しい `<body>` 要素
| `resume`                  | `(value?: any) => void`         | [描画の一時停止][] 時に呼び出す関数
| `render`                  | `(currentBody, newBody) => void`| [描画処理をカスタマイズする][] 用に既存の描画処理をカスタマイズする関数

[HTMLBodyElement]: https://developer.mozilla.org/ja/docs/Web/API/HTMLBodyElement
[描画の一時停止]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/drive#描画の一時停止
[描画処理をカスタマイズする]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/drive#描画処理をカスタマイズする

<details>
<summary>原文</summary>

### `turbo:before-render`

Fires before rendering the page. Access the new `<body>` element with `event.detail.newBody`. Rendering can be canceled and continued with `event.detail.resume` (see [Pausing Rendering](/handbook/drive#pausing-rendering)). Customize how Turbo Drive renders the response by overriding the `event.detail.render` function (see [Custom Rendering](/handbook/drive#custom-rendering)).

| `event.detail` property   | Type                              | Description
|---------------------------|-----------------------------------|------------
| `renderMethod`            | `"replace" \| "morph"`            | the strategy that will be used to render the new content
| `newBody`                 | [HTMLBodyElement][]               | the new `<body>` element that will replace the document's current `<body>` element
| `resume`                  | `(value?: any) => void`           | called when [Pausing Requests][]
| `render`                  | `(currentBody, newBody) => void`  | override to [Customize Rendering](/handbook/drive#custom-rendering)

[HTMLBodyElement]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLBodyElement
[preview]: /handbook/building#understanding-caching

TODO: The above link isn't used so I will make a PR fat toward the upstream.

</details>

### `turbo:render`

Turbo がページを描画した後に発火します。キャッシュされたロケーションへの遷移時に、このイベントは 2 回発火します。
1 回目はキャッシュ版の描画後、2 回目は最新のコンテンツを描画後に発火します。

| `event.detail` プロパティ  | 型                        | 説明
|---------------------------|---------------------------|------------
| `renderMethod`            | `"replace" \| "morph"`    | 新しいコンテンツを描画する際に使用された方式

<details>
<summary>原文</summary>

### `turbo:render`

Fires after Turbo renders the page. This event fires twice during an application visit to a cached location: once after rendering the cached version, and again after rendering the fresh version.

| `event.detail` property   | Type                      | Description
|---------------------------|---------------------------|------------
| `renderMethod`            | `"replace" \| "morph"`    | the strategy used to render the new content

</details>

### `turbo:load`

初回のページ読み込み後と、すべての Turbo ページ遷移後に 1 回ずつ発火します。

| `event.detail` プロパティ  | 型      　| 説明
|---------------------------|-----------|------------
| `url`                     | `string`  | リクエストされたロケーション
| `timing.visitStart`       | `number`  | ページ遷移の開始時刻（タイムスタンプ）
| `timing.requestStart`     | `number`  | 次のページへの HTTP リクエスト開始時刻（タイムスタンプ）
| `timing.requestEnd`       | `number`  | 次のページへの HTTP リクエスト終了時刻（タイムスタンプ）
| `timing.visitEnd`         | `number`  | ページ遷移の終了時刻（タイムスタンプ）

<details>
<summary>原文</summary>

### `turbo:load`

Fires once after the initial page load, and again after every Turbo visit.

| `event.detail` property   | Type      | Description
|---------------------------|-----------|------------
| `url`                     | `string`  | the requested location
| `timing.visitStart`       | `number`  | timestamp at the start of the Visit
| `timing.requestStart`     | `number`  | timestamp at the start of the HTTP request for the next page
| `timing.requestEnd`       | `number`  | timestamp at the end of the HTTP request for the next page
| `timing.visitEnd`         | `number`  | timestamp at the end of the Visit

</details>

## Page Refreshes

Turbo ドライブは、ページのコンテンツをモーフィングして更新している間にイベントを発火します。

<details>
<summary>原文</summary>

## Page Refreshes

Turbo Drive emits events while morphing the page's content.

</details>

### `turbo:morph`

Turbo がページをモーフィングして更新した後に発火します。

| `event.detail` プロパティ  | 型        | 説明
|---------------------------|-------------|------------
| `currentElement`          | [Element][] | モーフィング後も接続されたまま残る元の [Element][]（通常は `document.body`）
| `newElement`              | [Element][] | 新しい属性や子要素を持ち、モーフィング後には接続されていない [Element][]

[Element]: https://developer.mozilla.org/ja/docs/Web/API/Element

<details>
<summary>原文</summary>

### `turbo:morph`

Fires after Turbo morphs the page.

| `event.detail` property   | Type        | Description
|---------------------------|-------------|------------
| `currentElement`          | [Element][] | the original [Element][] that remains connected after the morph (most commonly `document.body`)
| `newElement`              | [Element][] | the [Element][] with the new attributes and children that is not connected after the morph

</details>

### `turbo:before-morph-element`

Turbo が要素をモーフィングする前に発火します。 [event.target][] は、ドキュメントに接続されたまま残る元の要素を参照します。`event.preventDefault()` を呼び出すことで、このイベントをキャンセルし、モーフィングをスキップして元の要素・属性・子要素を保持できます。

| `event.detail` プロパティ   | 型          | 説明
|---------------------------|---------------|------------
| `newElement`              | [Element][]   | 新しい属性や子要素を持ち、モーフィング後には接続されていない [Element][]

<details>
<summary>原文</summary>

### `turbo:before-morph-element`

Fires before Turbo morphs an element. The [event.target][] references the original element that will remain connected to the document. Cancel this event by calling `event.preventDefault()` to skip morphing and preserve the original element, its attributes, and its children.

| `event.detail` property   | Type          | Description
|---------------------------|---------------|------------
| `newElement`              | [Element][]   | the [Element][] with the new attributes and children that is not connected after the morph

</details>

### `turbo:before-morph-attribute`

Turbo が要素の属性をモーフィングする前に発火します。[event.target][] は、ドキュメントに接続されたまま残る元の要素を参照します。event.preventDefault() を呼び出すことで、このイベントをキャンセルし、モーフィングをスキップして元の属性を保持できます。

| `event.detail` プロパティ  | 型                      | 説明
|---------------------------|---------------------------|------------
| `attributeName`           | `string`                  | 変更される属性の名前
| `mutationType`            | `"update" \| "remove"`    | 属性がどのように変更されるか（更新または削除）

<details>
<summary>原文</summary>

### `turbo:before-morph-attribute`

Fires before Turbo morphs an element's attributes. The [event.target][] references the original element that will remain connected to the document. Cancel this event by calling `event.preventDefault()` to skip morphing and preserve the original attribute value.

| `event.detail` property   | Type                      | Description
|---------------------------|---------------------------|------------
| `attributeName`           | `string`                  | the name of the attribute to be mutated
| `mutationType`            | `"update" \| "remove"`    | how the attribute will be mutated

</details>

### `turbo:morph-element`

Turbo が要素をモーフィングした後に発火します。[event.target][] は、モーフィング後もドキュメントに接続されたまま残る要素を参照します。

| `event.detail` プロパティ  | 型          | 説明
|---------------------------|---------------|------------
| `newElement`              | [Element][]   | 新しい属性や子要素を持ち、モーフィング後には接続されていない [Element][]

<details>
<summary>原文</summary>

### `turbo:morph-element`

Fires after Turbo morphs an element. The [event.target][] references the morphed element that remains connected after the morph.

| `event.detail` property   | Type          | Description
|---------------------------|---------------|------------
| `newElement`              | [Element][]   | the [Element][] with the new attributes and children that is not connected after the morph

</details>

## Forms

Turbo ドライブは、フォームの送信、リダイレクト、および送信エラーの発生時にイベントを発火します。
以下のイベントは、フォーム送信中に `<form>` 要素上で発火します。

<details>
<summary>原文</summary>

## Forms

Turbo Drive emits events during submission, redirection, and submission failure. The following events fire on the `<form>` element during submission.

</details>

### `turbo:submit-start`

フォームの送信中に発火します。`event.detail.formSubmission` で [FormSubmission][] オブジェクトにアクセスできます。
バリデーションエラーなどで送信を中止したい場合は、`event.detail.formSubmission.stop()` を呼び出します。
jQuery を使用している場合は、`event.originalEvent.detail.formSubmission.stop()` を使用してください。

| `event.detail` プロパティ  | 型                                      | 説明
|---------------------------|-------------------------------------------|------------
| `formSubmission`          | [FormSubmission][]                        | `<form>` 要素の送信情報

[FormSubmission]: https://everyleaf.github.io/hotwire_ja/turbo/reference/drive/#formsubmission

<details>
<summary>原文</summary>

### `turbo:submit-start`

Fires during a form submission. Access the [FormSubmission][] object with `event.detail.formSubmission`. Abort form submission (e.g. after validation failure) with `event.detail.formSubmission.stop()`. Use `event.originalEvent.detail.formSubmission.stop()` if you're using jQuery.

| `event.detail` property   | Type                                      | Description
|---------------------------|-------------------------------------------|------------
| `formSubmission`          | [FormSubmission][]                        | the `<form>` element submission

</details>

### `turbo:submit-end`

フォーム送信によって開始されたネットワークリクエストが完了した後に発火します。
`event.detail.formSubmission` で [FormSubmission][] オブジェクトにアクセスでき、`event.detail` 内の各プロパティを参照できます。

| `event.detail` プロパティ  | 型                             | 説明
|---------------------------|----------------------------------|------------
| `formSubmission`          | [FormSubmission][]               | `<form>` 要素の送信情報
| `success`                 | `boolean`                        | リクエストが成功したかを示す `boolean`
| `fetchResponse`           | [FetchResponse][] \| `undefined` | レスポンスが受信された場合に存在します（`success: false` でも含まれる）。リクエストがレスポンスを受け取る前に失敗した場合は `undefined` になります。
| `error`                   | [Error][] \| `undefined`         | 実際のフェッチエラー（例：ネットワーク障害）が発生した場合にのみ設定します。それ以外の場合は、`undefined` です。

[Error]: https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Errors

<details>
<summary>原文</summary>

### `turbo:submit-end`

Fires after the form submission-initiated network request completes. Access the [FormSubmission][] object with `event.detail.formSubmission` along with the properties included within `event.detail`.

| `event.detail` property   | Type                             | Description
|---------------------------|----------------------------------|------------
| `formSubmission`          | [FormSubmission][]               | the `<form>` element submission
| `success`                 | `boolean`                        | a `boolean` representing the request's success
| `fetchResponse`           | [FetchResponse][] \| `undefined` | present when a response is received, even if `success: false`. `undefined` if the request errored before a response was received
| `error`                   | [Error][] \| `undefined`         | `undefined` unless an actual fetch error occurs (e.g., network issues)

[Error]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Errors
[FormSubmission]: /reference/drive#formsubmission

</details>

## Frames

Turbo フレームは、ナビゲーションのライフサイクル中にイベントを発火します。
以下のイベントは、`<turbo-frame>` 要素上で発火します。

<details>
<summary>原文</summary>

## Frames

Turbo Frames emit events during their navigation life cycle. The following events fire on the `<turbo-frame>` element.

</details>

### `turbo:before-frame-render`

`<turbo-frame>` 要素を描画する前に発火します。`event.detail.newFrame` で新しい `<turbo-frame>` 要素にアクセスできます。`event.detail.resume` を使うことで、描画を一時停止および再開できます（詳細は [描画の一時停止][] を参照）。
Turbo ドライブがレスポンスを描画する方法は、`event.detail.render` 関数を上書きしてカスタマイズできます（詳細は [描画処理をカスタマイズする][] を参照）。

| `event.detail` プロパティ  | 型                              | 説明
|---------------------------|-----------------------------------|------------
| `newFrame`                | `FrameElement`                    | 現在の `<turbo-frame>` 要素を置き換える新しい `<turbo-frame>` 要素
| `resume`                  | `(value?: any) => void`           | [描画の一時停止][] 時に呼び出す関数
| `render`                  | `(currentFrame, newFrame) => void`| [描画処理をカスタマイズする][] 用に既存の描画処理をカスタマイズする関数

<details>
<summary>原文</summary>

### `turbo:before-frame-render`

Fires before rendering the `<turbo-frame>` element. Access the new `<turbo-frame>` element with `event.detail.newFrame`. Rendering can be canceled and continued with `event.detail.resume` (see [Pausing Rendering](/handbook/frames#pausing-rendering)). Customize how Turbo Drive renders the response by overriding the `event.detail.render` function (see [Custom Rendering](/handbook/frames#custom-rendering)).

| `event.detail` property   | Type                              | Description
|---------------------------|-----------------------------------|------------
| `newFrame`                | `FrameElement`                    | the new `<turbo-frame>` element that will replace the current `<turbo-frame>` element
| `resume`                  | `(value?: any) => void`           | called when [Pausing Requests][]
| `render`                  | `(currentFrame, newFrame) => void`| override to [Customize Rendering](/handbook/drive#custom-rendering)

</details>

TODO: 翻訳

<details>
<summary>原文</summary>

### `turbo:frame-render`

Fires right after a `<turbo-frame>` element renders its view. The specific `<turbo-frame>` element is the [event.target][]. Access the [FetchResponse][] object with `event.detail.fetchResponse` property.

| `event.detail` property   | Type                              | Description
|---------------------------|-----------------------------------|------------
| `fetchResponse`           | [FetchResponse][]                 | the HTTP request's response

</details>

TODO: 翻訳

<details>
<summary>原文</summary>

### `turbo:frame-load`

Fires when a `<turbo-frame>` element is navigated and finishes loading (fires after `turbo:frame-render`). The specific `<turbo-frame>` element is the [event.target][].

Instances of `turbo:frame-load` events do not have an `event.detail` property.

</details>

TODO: 翻訳

<details>
<summary>原文</summary>

### `turbo:frame-missing`

Fires when the response to a `<turbo-frame>` element request does not contain a matching `<turbo-frame>` element. By default, Turbo writes an informational message into the frame and throws an exception. Cancel this event to override this handling. You can access the [Response][] instance with `event.detail.response`, and perform a visit by calling `event.detail.visit(location, visitOptions)` (see [Turbo.visit][] to learn more about `VisitOptions`).

| `event.detail` property   | Type                                                                  | Description
|---------------------------|-----------------------------------------------------------------------|------------
| `response`                | [Response][]                                                          | the HTTP response for the request initiated by a `<turbo-frame>` element
| `visit`                   | `async (location: string \| URL, visitOptions: VisitOptions) => void` | a convenience function to initiate a page-wide navigation

[Response]: https://developer.mozilla.org/en-US/docs/Web/API/Response
[Turbo.visit]: /reference/drive#turbo.visit

</details>

TODO: 翻訳

<details>
<summary>原文</summary>

## Streams

Turbo Streams emit events during their life cycle. The following events fire on the `<turbo-stream>` element.

</details>

TODO: 翻訳

<details>
<summary>原文</summary>

### `turbo:before-stream-render`

Fires before rendering a Turbo Stream page update. Access the new `<turbo-stream>` element with `event.detail.newStream`. Customize the element's behavior by overriding the `event.detail.render` function (see [Custom Actions][]).

| `event.detail` property   | Type                              | Description
|---------------------------|-----------------------------------|------------
| `newStream`               | `StreamElement`                   | the new `<turbo-stream>` element whose action will be executed
| `render`                  | `async (currentElement) => void`  | override to define [Custom Actions][]

[Custom Actions]: /handbook/streams#custom-actions

</details>

TODO: 翻訳

<details>
<summary>原文</summary>

## HTTP Requests

Turbo emits events when fetching content over HTTP. Depending on the what
initiated the request, the events could fire on:

* a `<turbo-frame>` during its navigation
* a `<form>` during its submission
* the `<html>` element during a page-wide Turbo Visit

</details>

TODO: 翻訳

<details>
<summary>原文</summary>

### `turbo:before-fetch-request`

Fires before Turbo issues a network request (to fetch a page, submit a form, preload a link, etc.). Access the requested location with `event.detail.url` and the fetch options object with `event.detail.fetchOptions`. This event fires on the respective element (`<turbo-frame>` or `<form>` element) which triggers it and can be accessed with [event.target][] property. Request can be canceled and continued with `event.detail.resume` (see [Pausing Requests][]).

| `event.detail` property   | Type                              | Description
|---------------------------|-----------------------------------|------------
| `fetchOptions`            | [RequestInit][]                   | the `options` used to construct the [Request][]
| `url`                     | [URL][]                           | the request's location
| `resume`                  | `(value?: any) => void` callback  | called when [Pausing Requests][]

[RequestInit]: https://developer.mozilla.org/en-US/docs/Web/API/Request/Request#options
[Request]: https://developer.mozilla.org/en-US/docs/Web/API/Request/Request
[URL]: https://developer.mozilla.org/en-US/docs/Web/API/URL
[Pausing Requests]: /handbook/drive#pausing-requests

</details>

TODO: 翻訳

<details>
<summary>原文</summary>

### `turbo:before-fetch-response`

Fires after the network request completes. Access the fetch options object with `event.detail`. This event fires on the respective element (`<turbo-frame>` or `<form>` element) which triggers it and can be accessed with [event.target][] property.

| `event.detail` property   | Type                      | Description
|---------------------------|---------------------------|------------
| `fetchResponse`           | [FetchResponse][]         | the HTTP request's response

[FetchResponse]: /reference/drive#fetchresponse

</details>

TODO: 翻訳

<details>
<summary>原文</summary>

### `turbo:before-prefetch`

Fires before Turbo prefetches a link. The link is the `event.target`. Cancel this event to prevent prefetching.

</details>

TODO: 翻訳

<details>
<summary>原文</summary>

### `turbo:fetch-request-error`

Fires when a form or frame fetch request fails due to network errors. This event fires on the respective element (`<turbo-frame>` or `<form>` element) which triggers it and can be accessed with [event.target][] property. This event can be canceled.

| `event.detail` property   | Type              | Description
|---------------------------|-------------------|------------
| `request`                 | [FetchRequest][]  | The HTTP request that failed
| `error`                   | [Error][]         | provides the cause of the failure

[Error]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Errors
[FetchRequest]: /reference/drive#fetchrequest

</details>
