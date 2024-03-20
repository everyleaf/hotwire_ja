---
permalink: /reference/drive.html
order: 01
description: "Turbo ドライブのリファレンス"
---

# Drive

## Turbo.visit

```js
Turbo.visit(location)
Turbo.visit(location, { action: action })
Turbo.visit(location, { frame: frame })
```

指定された _location_（URLまたはパスを含む文字列）に対して、指定された _action_（"advance" または "replace" のいずれかの文字列）で[アプリケーション・アクセス](/handbook/drive#application-visits)を行います。

_location_ がクロスオリジンなURLまたは、指定されたルートの範囲外にある場合（[ルート位置の設定](/handbook/drive#setting-a-root-location)を参照）、Turbo は、`window.location` を利用し画面全体の再読み込みを行います。

_action_ が指定されていない場合、Turbo ドライブは、`"advance"`が指定されたとみなします。

画面遷移が実行される前に、Turbo Driveは `document` に対して、 `turbo:before-visit` イベントを発火します。アプリケーション側では、このイベントを検知し、`event.preventDefault()` を利用して画面遷移をキャンセルできます。（[画面へのアクセスが開始される前にキャンセルする方法](/handbook/drive#canceling-visits-before-they-start)を参照）。」

_frame_ が指定されている場合、指定された値と一致する `[id]` 属性を持つ `<turbo-frame>` 要素を、指定された _location_ へナビゲートします。`<turbo-frame>` 要素が見つからない場合は、画面全体での[アプリケーション・アクセス](/handbook/drive#application-visits)を行います。

<details>
<summary>原文</summary>

# Drive

## Turbo.visit

Performs an [Application Visit][] to the given _location_ (a string containing a URL or path) with the specified _action_ (a string, either `"advance"` or `"replace"`).

If _location_ is a cross-origin URL, or falls outside of the specified root (see [Setting a Root Location](/handbook/drive#setting-a-root-location)), Turbo performs a full page load by setting `window.location`.

If _action_ is unspecified, Turbo Drive assumes a value of `"advance"`.

Before performing the visit, Turbo Drive fires a `turbo:before-visit` event on `document`. Your application can listen for this event and cancel the visit with `event.preventDefault()` (see [Canceling Visits Before They Start](/handbook/drive#canceling-visits-before-they-start)).

If _frame_ is specified, find a `<turbo-frame>` element with an `[id]` attribute that matches the provided value, and navigate it to the provided _location_. If the `<turbo-frame>` cannot be found, perform a page-level [Application Visit][].

</details>

## Turbo.cache.clear

```js
Turbo.cache.clear()
```

Turbo ドライブによってキャッシュされたページ情報を全て削除します。サーバー上の状態が変更され、キャッシュされたページに影響を与える可能性がある場合は、この `Turbo.cache.clear()` を呼んでください。

**注記:** この機能は以前 `Turbo.clearCache()` として公開されていましたが、トップレベルで非推奨となり、代わりに新しい `Turbo.cache.clear()` の利用を推奨しています。

<details>
<summary>原文</summary>

## Turbo.cache.clear

Removes all entries from the Turbo Drive page cache. Call this when state has changed on the server that may affect cached pages.

**Note:** This function was previously exposed as `Turbo.clearCache()`. The top-level function was deprecated in favor of the new `Turbo.cache.clear()` function.

</details>

## Turbo.setProgressBarDelay

```js
Turbo.setProgressBarDelay(delayInMilliseconds)
```

ナビゲーション中にプログレスバーが表示されるまでの遅延をミリ秒単位で設定できます。デフォルトでは、プログレスバーは500ミリ秒後に表示されます。

iOS または Android アダプターと併用した場合、このメソッドは動作しないので注意しましょう。

<details>
<summary>原文</summary>

## Turbo.setProgressBarDelay

Sets the delay after which the [progress bar](/handbook/drive#displaying-progress) will appear during navigation, in milliseconds. The progress bar appears after 500ms by default.

Note that this method has no effect when used with the iOS or Android adapters.

</deitals>

## Turbo.setConfirmMethod

```js
Turbo.setConfirmMethod(confirmMethod)
```

Sets the method that is called by links decorated with [`data-turbo-confirm`](/handbook/drive#requiring-confirmation-for-a-visit). The default is the browser's built in `confirm`. The method should return `true` if the visit can proceed.
[`data-turbo-confirm`](/handbook/drive#requiring-confirmation-for-a-visit) を指定したリンクによって呼び出されるメソッドを設定できます。デフォルトは、ブラウザのビルドインである `confirm` が設定されています。この設定したメソッドは、画面遷移可能な場合には `true` を返す必要があります。

## Turbo.session.drive

```js
Turbo.session.drive = false
```

Turns Turbo Drive off by default. You must now opt-in to Turbo Drive on a per-link and per-form basis using `data-turbo="true"`.
デフォルトで Turbo ドライブをオフに設定できます。この状況下で Turbo ドライブを部分的に利用したい場合は、`data-turbo="true"` を設定することで、リンクやフォームごとに Turbo ドライブをオプトインできます。
