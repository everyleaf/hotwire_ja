---
order: 1
title: Turbo ドライブ
description: "Turbo ドライブのリファレンス"
commit: "79760f0"
---

# Turbo ドライブ

## Turbo.visit

```js
Turbo.visit(location)
Turbo.visit(location, { action: action })
Turbo.visit(location, { frame: frame })
```

指定された _location_（URLまたはパスを含む文字列）に対して、指定された _action_（`"advance"` または `"replace"` のいずれかの文字列）で[アプリケーション・アクセス]を行います。

_location_ がクロスオリジンなURL、または指定されたルートの範囲外にある場合（[ルートロケーションの設定]を参照）、Turbo は、`window.location` を利用し画面全体の再読み込みを行います。

_action_ が指定されていない場合、Turbo ドライブは、`"advance"`が指定されたとみなします。

画面遷移が実行される前に、Turboドライブは `document` に対して `turbo:before-visit` イベントを発火します。アプリケーション側では、このイベントを検知し、`event.preventDefault()` を利用して画面遷移をキャンセルできます。（[アクセスを開始前にキャンセルする]を参照）。」

_frame_ が指定されている場合、指定された値と一致する `[id]` 属性を持つ `<turbo-frame>` 要素を、指定された _location_ へナビゲートします。`<turbo-frame>` 要素が見つからない場合は、画面全体での[アプリケーション・アクセス]を行います。

[アプリケーション・アクセス]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/drive/#アプリケーション・アクセス
[ルートロケーションの設定]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/drive/#ルートロケーションの設定
[アクセスを開始前にキャンセルする]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/drive/#アクセスを開始前にキャンセルする

<details>
<summary>原文</summary>

# Drive

## Turbo.visit

Performs an [Application Visit] to the given _location_ (a string containing a URL or path) with the specified _action_ (a string, either `"advance"` or `"replace"`).

If _location_ is a cross-origin URL, or falls outside of the specified root (see [Setting a Root Location]), Turbo performs a full page load by setting `window.location`.

If _action_ is unspecified, Turbo Drive assumes a value of `"advance"`.

Before performing the visit, Turbo Drive fires a `turbo:before-visit` event on `document`. Your application can listen for this event and cancel the visit with `event.preventDefault()` (see [Canceling Visits Before They Start]).

If _frame_ is specified, find a `<turbo-frame>` element with an `[id]` attribute that matches the provided value, and navigate it to the provided _location_. If the `<turbo-frame>` cannot be found, perform a page-level [Application Visit].

[Application Visit]: https://turbo.hotwired.dev/handbook/drive#application-visits
[Setting a Root Location]: https://turbo.hotwired.dev/handbook/drive#setting-a-root-location
[Canceling Visits Before They Start]: https://turbo.hotwired.dev/handbook/drive#canceling-visits-before-they-start

</details>

## Turbo.cache.clear

```js
Turbo.cache.clear()
```

Turbo ドライブによってキャッシュされたページ情報を全て削除します。サーバー上の状態が変更され、キャッシュされたページに影響を与える可能性がある場合は、この `Turbo.cache.clear()` を呼んでください。

**注記:** この機能は以前 `Turbo.clearCache()` として公開されていましたが、トップレベルで非推奨となり、代わりに新しい `Turbo.cache.clear()` の利用が推奨されています。

<details>
<summary>原文</summary>

## Turbo.cache.clear

Removes all entries from the Turbo Drive page cache. Call this when state has changed on the server that may affect cached pages.

**Note:** This function was previously exposed as `Turbo.clearCache()`. The top-level function was deprecated in favor of the new `Turbo.cache.clear()` function.

</details>

## Turbo.config.drive.progressBarDelay

```js
Turbo.config.drive.progressBarDelay = delayInMilliseconds
```

ナビゲーション中にプログレスバーが表示されるまでの遅延をミリ秒単位で設定できます。デフォルトでは、[プログレスバー]は500ミリ秒後に表示されます。

iOS または Android アダプターと併用した場合、このメソッドは動作しないので注意しましょう。

**注:** この関数は以前は `Turbo.setProgressBarDelay` 関数として公開されていました。トップレベルの関数は非推奨となり、代わりに新しい `Turbo.config.drive.progressBarDelay = delayInMilliseconds` 構文が推奨されるようになりました。

[プログレスバー]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/drive/#進行状況を表示する

<details>
<summary>原文</summary>

## Turbo.config.drive.progressBarDelay

```js
Turbo.config.drive.progressBarDelay = delayInMilliseconds
```

Sets the delay after which the [progress bar] will appear during navigation, in milliseconds. The progress bar appears after 500ms by default.

Note that this method has no effect when used with the iOS or Android adapters.

**Note:** This function was previously exposed as `Turbo.setProgressBarDelay` function. The top-level function was deprecated in favor of the new `Turbo.config.drive.progressBarDelay = delayInMilliseconds` syntax.

[progress bar]:https://turbo.hotwired.dev/handbook/drive#displaying-progress

</details>

## Turbo.config.forms.confirm

```js
Turbo.config.forms.confirm = confirmMethod
```

[`data-turbo-confirm`] を指定したリンクによって呼び出されるメソッドを設定できます。デフォルトは、ブラウザの組み込みの `confirm` が設定されています。ここで設定したメソッドは、画面遷移を行うかによって true または talse を返す `Promise` オブジェクトを返す必要があります。

**注:** この関数は以前は `Turbo.setConfirmMethod` 関数として公開されていました。トップレベルの関数は非推奨となり、代わりに新しい `Turbo.config.forms.confirm = confirmMethod` 構文が推奨されるようになりました。

[`data-turbo-confirm`]: https://turbo.hotwired.dev/handbook/drive#requiring-confirmation-for-a-visit

<details>
<summary>原文</summary>

## Turbo.config.forms.confirm

```js
Turbo.config.forms.confirm = confirmMethod
```

Sets the method that is called by links decorated with [`data-turbo-confirm`]. The default is the browser's built in `confirm`. The method should return a `Promise` object that resolves to true or false, depending on whether the visit should proceed.

+**Note:** This function was previously exposed as `Turbo.setConfirmMethod` function. The top-level function was deprecated in favor of the new `Turbo.config.forms.confirm = confirmMethod` syntax.

[`data-turbo-confirm`]: https://turbo.hotwired.dev/handbook/drive#requiring-confirmation-for-a-visit

</details>

## Turbo.session.drive

```js
Turbo.session.drive = false
```

デフォルトで Turbo ドライブをオフに設定できます。また、Turbo ドライブを部分的に利用したい場合は、`data-turbo="true"` を設定することで、リンクやフォームごとに Turbo ドライブをオプトインできます。

<details>
<summary>原文</summary>

## Turbo.session.drive

Turns Turbo Drive off by default. You must now opt-in to Turbo Drive on a per-link and per-form basis using `data-turbo="true"`.

</details>

## `FetchRequest`

Turbo は HTTP リクエストの実行中に、さまざまな[イベント](https://everyleaf.github.io/hotwire_ja/turbo/reference/events)を発火します。
これらのイベントでは、次のプロパティを持つ `FetchRequest` オブジェクトを参照します。

| Property          | Type                                                                              | Description
|-------------------|-----------------------------------------------------------------------------------|------------
| `body`            | [FormData][] \| [URLSearchParams][]                                               | `"get"` リクエストの場合は [URLSearchParams][] インスタンス、それ以外の場合は [FormData][]
| `enctype`         | `"application/x-www-form-urlencoded" \| "multipart/form-data" \| "text/plain"`    | [HTMLFormElement.enctype][] の値
| `fetchOptions`    | [RequestInit][]                                                                   | リクエストの設定オプション
| `headers`         | [Headers][] \| `{ [string]: [any] }`                                              | リクエストのHTTPヘッダー
| `method`          | `"get" \| "post" \| "put" \| "patch" \| "delete"`                                 | the HTTP verb
| `params`          | [URLSearchParams][]                                                               | `"get"` リクエストの [URLSearchParams][] インスタンス
| `target`          | [HTMLFormElement][] \| [HTMLAnchorElement][] \| `FrameElement` \| `null`          | リクエストを開始した要素
| `url`             | [URL][]                                                                           | リクエストの [URL][]

[HTMLAnchorElement]: https://developer.mozilla.org/ja/docs/Web/API/HTMLAnchorElement
[RequestInit]: https://developer.mozilla.org/ja/docs/Web/API/Request/Request#options
[Headers]: https://developer.mozilla.org/ja/docs/Web/API/Request/headers
[HTMLFormElement.enctype]: https://developer.mozilla.org/ja/docs/Web/API/HTMLFormElement/enctype

<details>
<summary>原文</summary>

## `FetchRequest`

Turbo dispatches a variety of [events while making HTTP requests](https://turbo.hotwired.dev/reference/events#http-requests) that reference `FetchRequest` objects with the following properties:

| Property          | Type                                                                              | Description
|-------------------|-----------------------------------------------------------------------------------|------------
| `body`            | [FormData][] \| [URLSearchParams][]                                               | a [URLSearchParams][] instance for `"get"` requests, [FormData][] otherwise
| `enctype`         | `"application/x-www-form-urlencoded" \| "multipart/form-data" \| "text/plain"`    | the [HTMLFormElement.enctype][] value
| `fetchOptions`    | [RequestInit][]                                                                   | the request's configuration options
| `headers`         | [Headers][] \| `{ [string]: [any] }`                                              | the request's HTTP headers
| `method`          | `"get" \| "post" \| "put" \| "patch" \| "delete"`                                 | the HTTP verb
| `params`          | [URLSearchParams][]                                                               | the [URLSearchParams][] instance for `"get"` requests
| `target`          | [HTMLFormElement][] \| [HTMLAnchorElement][] \| `FrameElement` \| `null`          | the element responsible for initiating the request
| `url`             | [URL][]                                                                           | the request's [URL][]

[HTMLAnchorElement]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLAnchorElement
[RequestInit]: https://developer.mozilla.org/en-US/docs/Web/API/Request/Request#options
[Headers]: https://developer.mozilla.org/en-US/docs/Web/API/Request/Request#headers
[HTMLFormElement.enctype]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLFormElement/enctype

</details>

## `FetchResponse`
Turbo は HTTP リクエストの実行中に、さまざまな[イベント](https://everyleaf.github.io/hotwire_ja/turbo/reference/events)を発火します。
これらのイベントでは、次のプロパティを持つ `FetchResponse` オブジェクトを参照します。

| Property          | Type               | Description
|-------------------|--------------------|------------
| `clientError`     | `boolean`          | ステータスが 400 から 499 の間であれば `true`、それ以外であれば `false`
| `contentType`     | `string` \| `null` | [Content-Type][] ヘッダーの値
| `failed`          | `boolean`          | レスポンスが成功していない場合は `true`、それ以外であれば `false`
| `isHTML`          | `boolean`          | コンテンツタイプが HTML であれば `true`、それ以外であれば `false`
| `location`        | [URL][]            | [Response.url][] の値
| `redirected`      | `boolean`          | [Response.redirected][] の値
| `responseHTML`    | `Promise<string>`  | HTMLの場合は `Response` を複製し、 [Response.text()][] を呼び出す
| `responseText`    | `Promise<string>`  | `Response`を複製し、 [Response.text()][] を呼び出す
| `response`        | [Response]         | `Response` インスタンス
| `serverError`     | `boolean`          | ステータスが 500 から 599 の間の場合は `true`、それ以外であれば `false`
| `statusCode`      | `number`           | [Response.status][] の値
| `succeeded`       | `boolean`          | [Response.ok][] の場合は `true`、それ以外であれば `false`

[Response]: https://developer.mozilla.org/ja/docs/Web/API/Response
[Response.url]: https://developer.mozilla.org/ja/docs/Web/API/Response/url
[Response.ok]: https://developer.mozilla.org/ja/docs/Web/API/Response/ok
[Response.redirected]: https://developer.mozilla.org/ja/docs/Web/API/Response/redirected
[Response.status]: https://developer.mozilla.org/ja/docs/Web/API/Response/status
[Response.text()]: https://developer.mozilla.org/ja/docs/Web/API/Response/text
[Content-Type]: https://developer.mozilla.org/ja/docs/Web/HTTP/Reference/Headers/Content-Type

<details>
<summary>原文</summary>

Turbo dispatches a variety of [events while making HTTP requests](https://turbo.hotwired.dev/reference/events#http-requests) that reference `FetchResponse` objects with the following properties:

| Property          | Type               | Description
|-------------------|--------------------|------------
| `clientError`     | `boolean`          | `true` if the status is between 400 and 499, `false` otherwise
| `contentType`     | `string` \| `null` | the value of the [Content-Type][] header
| `failed`          | `boolean`          | `true` if the response did not succeed, `false` otherwise
| `isHTML`          | `boolean`          | `true` if the content type is HTML, `false` otherwise
| `location`        | [URL][]            | the value of [Response.url][]
| `redirected`      | `boolean`          | the value of [Response.redirected][]
| `responseHTML`    | `Promise<string>`  | clones the `Response` if its HTML, then calls [Response.text()][]
| `responseText`    | `Promise<string>`  | clones the `Response`, then calls [Response.text()][]
| `response`        | [Response]         | the `Response` instance
| `serverError`     | `boolean`          | `true` if the status is between 500 and 599, `false` otherwise
| `statusCode`      | `number`           | the value of [Response.status][]
| `succeeded`       | `boolean`          | `true` if the [Response.ok][], `false` otherwise

[Response]: https://developer.mozilla.org/en-US/docs/Web/API/Response
[Response.url]: https://developer.mozilla.org/en-US/docs/Web/API/Response/url
[Response.ok]: https://developer.mozilla.org/en-US/docs/Web/API/Response/ok
[Response.redirected]: https://developer.mozilla.org/en-US/docs/Web/API/Response/redirected
[Response.status]: https://developer.mozilla.org/en-US/docs/Web/API/Response/status
[Response.text()]: https://developer.mozilla.org/en-US/docs/Web/API/Response/text
[Content-Type]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type

</details>

## `FormSubmission`

<!-- TODO: reference/events を最新版に更新後、URLの参照先を events#フォーム に変更 -->
Turbo は HTTP リクエストの実行中に、さまざまな[イベント](https://everyleaf.github.io/hotwire_ja/turbo/reference/events)を発火します。
これらのイベントでは、次のプロパティを持つ `FormSubmission` オブジェクトを参照します。

| Property          | Type                                                                             | Description
|-------------------|----------------------------------------------------------------------------------|------------
| `action`          | `string`                                                                         |  `<form>` 要素が送信先とする場所
| `body`            | [FormData][] \| [URLSearchParams][]                                              | 基盤となる [Request][] のペイロード
| `enctype`         | `"application/x-www-form-urlencoded" \| "multipart/form-data" \| "text/plain"`   | [HTMLFormElement.enctype][]
| `fetchRequest`    | [FetchRequest][]                                                                 | 基盤となる [FetchRequest][] インスタンス
| `formElement`     | [HTMLFormElement][]                                                              | 送信する `<form>` 要素
| `isSafe`          | `boolean`                                                                        | `method` が `"get"` なら `true`、それ以外は `false`
| `location`        | [URL][]                                                                          | `action` 文字列を [URL][] インスタンスに変換したもの
| `method`          | `"get" \| "post" \| "put" \| "patch" \| "delete"`                                | HTTPメソッド
| `submitter`       | [HTMLButtonElement][] \| [HTMLInputElement][] \| `undefined`                     | `<form>` 要素の送信を担当する要素

[FetchRequest]: #fetchrequest
[FormData]: https://developer.mozilla.org/ja/docs/Web/API/FormData
[HTMLFormElement]: https://developer.mozilla.org/ja/docs/Web/API/HTMLFormElement
[URLSearchParams]: https://developer.mozilla.org/ja/docs/Web/API/URLSearchParams
[URL]: https://developer.mozilla.org/ja/docs/Web/API/URL
[HTMLButtonElement]: https://developer.mozilla.org/ja/docs/Web/API/HTMLButtonElement
[HTMLInputElement]: https://developer.mozilla.org/ja/docs/Web/API/HTMLInputElement
[Request]: https://developer.mozilla.org/ja/docs/Web/API/Request

<details>
<summary>原文</summary>

## `FormSubmission`

Turbo dispatches a variety of [events while submitting forms](https://turbo.hotwired.dev/reference/events#forms) that reference `FormSubmission` objects with the following properties:

| Property          | Type                                                                             | Description
|-------------------|----------------------------------------------------------------------------------|------------
| `action`          | `string`                                                                         | where the `<form>` element is submitting to
| `body`            | [FormData][] \| [URLSearchParams][]                                              | the underlying [Request][] payload
| `enctype`         | `"application/x-www-form-urlencoded" \| "multipart/form-data" \| "text/plain"`   | the [HTMLFormElement.enctype][]
| `fetchRequest`    | [FetchRequest][]                                                                 | the underlying [FetchRequest][] instance
| `formElement`     | [HTMLFormElement][]                                                              | the `<form>` element to that is submitting
| `isSafe`          | `boolean`                                                                        | `true` if the `method` is `"get"`, `false` otherwise
| `location`        | [URL][]                                                                          | the `action` string transformed into a [URL][] instance
| `method`          | `"get" \| "post" \| "put" \| "patch" \| "delete"`                                | the HTTP verb
| `submitter`       | [HTMLButtonElement][] \| [HTMLInputElement][] \| `undefined`                     | the element responsible for submitting the `<form>` element

[FetchRequest]: #fetchrequest
[FormData]: https://developer.mozilla.org/en-US/docs/Web/API/FormData
[HTMLFormElement]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLFormElement
[URLSearchParams]: https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams
[URL]: https://developer.mozilla.org/en-US/docs/Web/API/URL
[HTMLButtonElement]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLButtonElement
[HTMLInputElement]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement
[Request]: https://developer.mozilla.org/en-US/docs/Web/API/Request

</details>
