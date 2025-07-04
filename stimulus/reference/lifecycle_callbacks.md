---
title: ライフサイクルコールバック
description: "ライフサイクルコールバックは、コントローラや特定のターゲットがドキュメントに接続したり切断したりするたびに応答するメソッドです"
order: 1
---

# ライフサイクルコールバック

ライフサイクルコールバックと呼ばれる特別なメソッドを使用すると、コントローラや特定のターゲットがドキュメントに接続したり切断したりするたびに応答できるようになります。

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // …
  }
}
```

<details>
  <summary>原文</summary>
Special methods called _lifecycle callbacks_ allow you to respond whenever a controller or certain targets connects to and disconnects from the document.

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // …
  }
}
```
</details>

## メソッド一覧

コントローラには、以下のライフサイクルコールバックメソッドを定義することができます：

| Method       | Stimulusによって呼び出されるタイミング… |
| ------------ | -------------------- |
| initialize() | コントローラが最初にインスタンス化されたとき(一度だけ) |
| [name]TargetConnected(target: Element) | ターゲットがDOMに接続されるたび |
| connect()    | コントローラーがDOMに接続されるたび |
| [name]TargetDisconnected(target: Element) | ターゲットがDOMから切り離されるたび |
| disconnect() | コントローラーがDOMから切り離されるたび |

<details>
  <summary>原文</summary>

You may define any of the following methods in your controller:

| Method       | Invoked by Stimulus… |
| ------------ | -------------------- |
| initialize() | Once, when the controller is first instantiated |
| [name]TargetConnected(target: Element) | Anytime a target is connected to the DOM |
| connect()    | Anytime the controller is connected to the DOM |
| [name]TargetDisconnected(target: Element) | Anytime a target is disconnected from the DOM |
| disconnect() | Anytime the controller is disconnected from the DOM |
</details>


## Connection

コントローラがドキュメントに接続されるのは、以下の条件の両方が真の場合です：

* その要素がドキュメント内に存在する (つまり、`document.documentElement`である`<html>`要素の子孫である)
* 要素の`data-controller`属性にその識別子が存在する

コントローラが接続されると、Stimulusは`connect()`メソッドを呼び出します。

<details>
  <summary>原文</summary>
A controller is _connected_ to the document when both of the following conditions are true:

* its element is present in the document (i.e., a descendant of `document.documentElement`, the `<html>` element)
* its identifier is present in the element's `data-controller` attribute

When a controller becomes connected, Stimulus calls its `connect()` method.
</details>

### ターゲット

ターゲットがドキュメントに接続されるのは、以下の両方の条件が真である場合です：

* その要素が、対応するコントローラ要素の子孫としてドキュメントに存在する。
* その識別子が要素の`data-{identifier}-target`属性に存在する。

ターゲットが接続されると、Stimulusはコントローラの`[name]TargetConnected()`メソッドを呼び出し、ターゲット要素をパラメータとして渡します。 `name]TargetConnected()`ライフサイクルコールバックは、コントローラの`connect()`コールバックより *前に* 起動します。

<details>
  <summary>原文</summary>
A target is _connected_ to the document when both of the following conditions are true:

* its element is present in the document as a descendant of its corresponding controller's element
* its identifier is present in the element's `data-{identifier}-target` attribute

When a target becomes connected, Stimulus calls its controller's `[name]TargetConnected()` method, passing the target element as a parameter. The `[name]TargetConnected()` lifecycle callbacks will fire *before* the controller's `connect()` callback.
</details>

## Disconnection

接続されたコントローラは、以下のケースのように、前述の条件のいずれかが偽になると切断されます：

* その要素が`Node#removeChild()`または`ChildNode#remove()`で明示的にドキュメントから削除される
* 要素の親要素がドキュメントから削除される
* 要素の親要素が、`Element#innerHTML=`によってその内容を置き換えられる
* 要素の`data-controller`属性が削除または変更される
* Turboによるページ遷移時など、ドキュメントの`<body>`要素がまるっと更新される

コントローラが切断されると、Stimulus は`disconnect()`メソッドを呼び出します。

<details>
  <summary>原文</summary>
A connected controller will later become _disconnected_ when either of the preceding conditions becomes false, such as under any of the following scenarios:

* the element is explicitly removed from the document with `Node#removeChild()` or `ChildNode#remove()`
* one of the element's parent elements is removed from the document
* one of the element's parent elements has its contents replaced by `Element#innerHTML=`
* the element's `data-controller` attribute is removed or modified
* the document installs a new `<body>` element, such as during a Turbo page change

When a controller becomes disconnected, Stimulus calls its `disconnect()` method.
</details>

### ターゲット

接続されたターゲットは、以下のケースのように、前述の条件のいずれかが偽になると切断されます：

* その要素が`Node#removeChild()`または`ChildNode#remove()`で明示的にドキュメントから削除される
* 要素の親要素がドキュメントから削除される
* 要素の親要素が、`Element#innerHTML=`によってその内容を置き換えられる
* 要素の`data-{identifier}-target`属性が削除または変更される
* Turboによるページ遷移時など、ドキュメントの`<body>`要素がまるっと更新される

ターゲットが切断されると、Stimulusはコントローラの`[name]TargetDisconnected()`メソッドを呼び出し、ターゲット要素をパラメータとして渡します。 `name]TargetDisconnected()`ライフサイクルのコールバックは、コントローラの`disconnect()`コールバックより *前に* 起動します。

<details>
  <summary>原文</summary>

A connected target will later become _disconnected_ when either of the preceding conditions becomes false, such as under any of the following scenarios:

* the element is explicitly removed from the document with `Node#removeChild()` or `ChildNode#remove()`
* one of the element's parent elements is removed from the document
* one of the element's parent elements has its contents replaced by `Element#innerHTML=`
* the element's `data-{identifier}-target` attribute is removed or modified
* the document installs a new `<body>` element, such as during a Turbo page change

When a target becomes disconnected, Stimulus calls its controller's `[name]TargetDisconnected()` method, passing the target element as a parameter. The `[name]TargetDisconnected()` lifecycle callbacks will fire *before* the controller's `disconnect()` callback.
</details>

## Reconnection

切断されたコントローラは、後で再び接続される可能性があります。

これが発生した場合 (ドキュメントからコントローラーの要素を削除してから再アタッチした後など) 、Stimulusは要素の以前のコントローラーインスタンスを再利用し、その`connect()`メソッドを再び呼び出します。

同様に、切断されたターゲットも後で再び接続される可能性があります。 Stimulusはコントローラの`[name]TargetConnected()`メソッドも同様に再び呼び出します。

<details>
  <summary>原文</summary>

A disconnected controller may become connected again at a later time.

When this happens, such as after removing the controller's element from the document and then re-attaching it, Stimulus will reuse the element's previous controller instance, calling its `connect()` method multiple times.

Similarly, a disconnected target may be connected again at a later time. Stimulus will invoke its controller's `[name]TargetConnected()` method multiple times.
</details>

## 順序とタイミング

Stimulusは[DOM `MutationObserver` API](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver)を使用して非同期にページの変更を監視します。

つまりこれは、Stimulusがドキュメントに変更が加えられた際、各変更の次の[マイクロタスク](https://jakearchibald.com/2015/tasks-microtasks-queues-and-schedules/)でコントローラのライフサイクルメソッドを非同期に呼び出すことを意味します。

ライフサイクルメソッドは発生順に実行されるため、コントローラの`connect()`メソッドが2回呼び出されるような時は、常に`disconnect()`が間に1度呼び出されることになります。 同様に、特定のターゲットに対するコントローラーの`[name]TargetConnected()`が2回呼ばれる時は、同じターゲットに対する`[name]TargetDisconnected()`が間に1度呼ばれることになります。

<details>
  <summary>原文</summary>

Stimulus watches the page for changes asynchronously using the [DOM `MutationObserver` API](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver).

This means that Stimulus calls your controller's lifecycle methods asynchronously after changes are made to the document, in the next [microtask](https://jakearchibald.com/2015/tasks-microtasks-queues-and-schedules/) following each change.

Lifecycle methods still run in the order they occur, so two calls to a controller's `connect()` method will always be separated by one call to `disconnect()`. Similarly, two calls to a controller's `[name]TargetConnected()` for a given target will always be separated by one call to `[name]TargetDisconnected()` for that same target.
</details>
