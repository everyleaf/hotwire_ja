---
permalink: /reference/events.html
order: 04
description: "A reference of everything you can do with Turbo Events."
description: "Turbo イベントでできるすべてのことのレファレンス"
---

# イベント

Turboは、ナビゲーション・ライフサイクルを追跡しページの読み込みに返答できるイベントを発行します。
特記がない限り、`Turboはdocument.documentElement`オブジェクト（つまり、<html>要素）でイベントを発生させます。これにより、ページの読み込みやナビゲーションのさまざまな段階でイベントをキャッチして処理することが可能になります。

（jQuery を利用する際は、イベント上のデータが `$event.originalEvent.detail` としてアクセスできなければならないことに注意してください）


<details>
    <summary>原文</summary>
# Events

Turbo emits events that allow you to track the navigation lifecycle and respond to page loading. Except where noted, Turbo fires events on the `document.documentElement` object (i.e., the `<html>` element).

(Note that when using jQuery, the data on the event must be accessed as `$event.originalEvent.detail`.)
</details>

* `turbo:click` は Turbo が有効になったリンクがクリックされた際に発火します。クリックされた要素がイベントのターゲットとなります。リンク先は `event.detail.url` で取得できます。このイベントをキャンセルすると、クリックはブラウザに普通のナビゲーションとしてそのまま渡されます。

<details>
    <summary>原文</summary>
* `turbo:click` fires when you click a Turbo-enabled link. The clicked element is the event target. Access the requested location with `event.detail.url`. Cancel this event to let the click fall through to the browser as normal navigation.

</details>
* `turbo:before-visit` はあるロケーションへアクセスする前に発火します（ブラウザの履歴からのナビゲーションはのぞきます）。`event.detail.url` でリクエストされたロケーションが取得できます。このイベントをキャンセルすると、ナビゲーションが中止されます。

<details>
    <summary>原文</summary>

* `turbo:before-visit` fires before visiting a location, except when navigating by history. Access the requested location with `event.detail.url`. Cancel this event to prevent navigation.

</details>


* `turbo:visit` はナビゲーションが開始した直後に発火します。`event.detail.url` でリクエストされたロケーションが、 `event.detail.action` でアクションが取得できます。

<details>
    <summary>原文</summary>

* `turbo:visit` fires immediately after a visit starts. Access the requested location with `event.detail.url` and action with `event.detail.action`.

</details>

* `turbo:submit-start` はフォームがサブミットされる間に発火します。`FormSubmission` オブジェクトには `event.detail.formSubmission` でアクセスできます。サブミッションを棄却する（例えばバリデーションに失敗した後など）には、 `event.detail.formSubmission.stop()` が使えます（jQueryを使っている場合は`event.originalEvent.detail.formSubmission.stop()` を使いましょう）。

<details>
    <summary>原文</summary>
* `turbo:submit-start` fires during a form submission. Access the `FormSubmission` object with `event.detail.formSubmission`. Abort form submission (e.g. after validation failure) with `event.detail.formSubmission.stop()`. (use `event.originalEvent.detail.formSubmission.stop()` if you're using jQuery).

</details>

* `turbo:before-fetch-request` は、Turbo がページの取得のためにネットワークリクエストを発行する前に発火します。リクエスト先は `event.detail.url` で取得できます。また、オプションオブジェクトは `event.detail.fetchOptions` で取得できます。このイベントが発火されるのは、そのイベントを引き起こしたそれぞれの要素（turboフレームあるいはフォーム要素）です。要素は、`event.target` プロパティでアクセスできます。リクエストは `event.detail.resume` によってキャンセル、あるいは継続されます（詳細は [リクエストの停止](/handbook/drive#リクエストの停止)参照)。


<details>
    <summary>原文</summary>
* `turbo:before-fetch-request` fires before Turbo issues a network request to fetch the page. Access the requested location with `event.detail.url` and the fetch options object with `event.detail.fetchOptions`. This event fires on the respective element (turbo-frame or form element) which triggers it and can be accessed with `event.target` property. Request can be canceled and continued with `event.detail.resume` (see [Pausing Requests](/handbook/drive#pausing-requests)).

</details>

* `turbo:before-fetch-response`  はネットワークリクエストの完了前に発火します。フェッチのオプションオブジェクトは `event.detail` で取得できます。このイベントが発火されるのは、そのイベントを引き起こしたそれぞれの要素（turboフレームあるいはフォーム要素）です。その要素には、`event.target` プロパティでアクセスできます。


<details>
    <summary>原文</summary>

* `turbo:before-fetch-response` fires after the network request completes. Access the fetch options object with `event.detail`. This event fires on the respective element (turbo-frame or form element) which triggers it and can be accessed with `event.target` property.

</details>

* `turbo:submit-end` はフォームのサブミッションによって開始したネットワークリクエストが完了した後に発火します。`FormSubmission` オブジェクトは `event.detail.formSubmission` でアクセスできます。また、 `event.detail` 内に含まれる `FormSubmissionResult` プロパティも同様にアクセスできます。


<details>
    <summary>原文</summary>

* `turbo:submit-end` fires after the form submission-initiated network request completes. Access the `FormSubmission` object with `event.detail.formSubmission` along with `FormSubmissionResult` properties included within `event.detail`.

</details>


* `turbo:before-cache`  は Turbo が現在のページをキャッシュする前に発火します。

<details>
    <summary>原文</summary>
* `turbo:before-cache` fires before Turbo saves the current page to cache.
</details>

* `turbo:before-render` はページの描画前に発火します。新しい`<body>` 要素には  `event.detail.newBody` でアクセスできます。描画は `event.detail.resume` でキャンセルまたは継続できます(詳細は [描画の停止](/handbook/drive#pausing-rendering))。
 Turbo ドライブがレスポンスを描画する方法は、`event.detail.render` 関数で上書きしてカスタマイズできます (詳細は [描画のカスタマイズ](/handbook/drive#custom-rendering))。

<details>
    <summary>原文</summary>
* `turbo:before-render` fires before rendering the page. Access the new `<body>` element with `event.detail.newBody`. Rendering can be canceled and continued with `event.detail.resume` (see [Pausing Rendering](/handbook/drive#pausing-rendering)). Customize how Turbo Drive renders the response by overriding the `event.detail.render` function (see [Custom Rendering](/handbook/drive#custom-rendering)).

</details>

* `turbo:before-stream-render` は Turbo ストリームがページの更新を描画する前に発火します。新しい `<turbo-stream>` には、`event.detail.newStream` でアクセスできます。要素の振る舞いをカスタマイズするには、`event.detail.render` 関数を上書きしてください（詳細は[アクションのカスタマイズ](/handbook/streams#custom-actions))。


<details>
    <summary>原文</summary>
* `turbo:before-stream-render` fires before rendering a Turbo Stream page update. Access the new `<turbo-stream>` element with `event.detail.newStream`. Customize the element's behavior by overriding the `event.detail.render` function (see [Custom Actions](/handbook/streams#custom-actions)).

</details>

* `turbo:render`は Turbo がページを描画した後に発火します。このイベントは、アプリケーションがキャッシュされたロケーションにアクセスする間、二度発火します。一度目はキャッシュされたバージョンが描画された後、二度目は新しいバージョンが描画された後です。

<details>
    <summary>原文</summary>

* `turbo:render` fires after Turbo renders the page. This event fires twice during an application visit to a cached location: once after rendering the cached version, and again after rendering the fresh version.

</details>

* `turbo:load` は初めてのページがロードされた後に発火し、それからTurboがvisitするごとに発火します。`event.detail.timing` オブジェクトを使って、visitのタイムングのメトリクスを取得できます。

<details>
    <summary>原文</summary>
* `turbo:load` fires once after the initial page load, and again after every Turbo visit. Access visit timing metrics with the `event.detail.timing` object.
</details>

* `turbo:before-frame-render` は `<turbo-frame>` 要素を描画する前に発火します。新しい `<turbo-frame>` 要素は `event.detail.newFrame` で取得できます。描画は `event.detail.resume` によってキャンセルまたは継続できます。(詳細は [描画の一時停止](https://turbo.hotwired.dev/handbook/frames#pausing-rendering))。Turbo ドライブがレスポンスをどのように描画するかは、`event.detail.render` 関数を上書きしてカスタマイズできます。 （詳細は [描画のカスタマイズ](https://turbo.hotwired.dev/handbook/frames#custom-rendering))。

<details>
    <summary>原文</summary>

* `turbo:before-frame-render` fires before rendering the `<turbo-frame>` element. Access the new `<turbo-frame>` element with `event.detail.newFrame`. Rendering can be canceled and continued with `event.detail.resume` (see [Pausing Rendering](/handbook/frames#pausing-rendering)). Customize how Turbo Drive renders the response by overriding the `event.detail.render` function (see [Custom Rendering](/handbook/frames#custom-rendering)).

</details>

* `turbo:frame-render` は `<turbo-frame>` 要素が描画された直後に発火します。特定の `<turbo-frame>` 要素がイベントの対象になります。 `FetchResponse` オブジェクトは、`event.detail.fetchResponse` プロパティで取得できます。

<details>
    <summary>原文</summary>

* `turbo:frame-render` fires right after a `<turbo-frame>` element renders its view. The specific `<turbo-frame>` element is the event target. Access the `FetchResponse` object with `event.detail.fetchResponse` property.

</details>


* `turbo:frame-load` は `<turbo-frame>` 要素がナビゲートされ、ロードが終了した時点で発火します（`turbo:frame-render` の後です）。特定の `<turbo-frame>` 要素がイベントの対象になります。

<details>
    <summary>原文</summary>

* `turbo:frame-load` fires when a `<turbo-frame>` element is navigated and finishes loading (fires after `turbo:frame-render`). The specific `<turbo-frame>` element is the event target.

</details>


* `turbo:frame-missing` は、`<turbo-frame>` 要素へのリクエストのレスポンスが、マッチする `<turbo-frame>` 要素を含んでいなかったときに発火します。デフォルトでは、Turbo はフレームに対してメッセージの形で情報を提供し、例外を投げます。この挙動をキャンセルするにはこの取り扱いを上書きします。[レスポンス](https://developer.mozilla.org/ja/docs/Web/API/Response)インスタンスには `event.detail.response` でアクセスでき、`event.detail.visit(...)` を呼ぶことでvisitできます。


<details>
    <summary>原文</summary>
* `turbo:frame-missing` fires when the response to a `<turbo-frame>` element request does not contain a matching `<turbo-frame>` element. By default, Turbo writes an informational message into the frame and throws an exception. Cancel this event to override this handling. You can access the [Response](https://developer.mozilla.org/en-US/docs/Web/API/Response) instance with `event.detail.response`, and perform a visit by calling `event.detail.visit(...)`.
</details>

* `turbo:fetch-request-error` はフォームかフレームが取ってこようとしたリクエストが、ネットワークエラーで失敗したときに発火します。このイベントはイベントを起動した各々の要素（turboフレームかフォーム要素）上に発火し、`event.target` プロパティでアクセスできます。このイベントはキャンセルできます。

<details>
    <summary>原文</summary>

* `turbo:fetch-request-error` fires when a form or frame fetch request fails due to network errors. This event fires on the respective element (turbo-frame or form element) which triggers it and can be accessed with `event.target` property. This event can be canceled.

</details>
