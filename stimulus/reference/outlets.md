---
title: Outlets
description: "Outletを使うとコントローラが別のコントローラ(と要素)を参照することができます"

---

# Outlets

_アウトレット_ を使用すると、コントローラから別のコントローラのインスタンスとそのコントローラ要素を参照することができます。

アウトレットを使用することで、コントローラの連携や調整をカスタムイベントなしに行うことができます。

[ターゲット](/stimulus/reference/targets)と概念的には似ていますが、コントローラのインスタンスとそれに関連するコントローラ要素を参照するという違いがあります。

```html
<div>
  <div class="online-user" data-controller="user-status">...</div>
  <div class="online-user" data-controller="user-status">...</div>
  ...
</div>

...

<div data-controller="chat" data-chat-user-status-outlet=".online-user">
  ...
</div>
```

**ターゲット**は、そのコントローラ要素のスコープ内でマークされた要素を参照しますが、アウトレットで参照したいコントローラ要素はページ上のどこにでも置くことができ、必ずしもコントローラのスコープ内にある必要はありません。

<details>
    <summary>原文</summary>
_Outlets_ let you reference Stimulus _controller instances_ and their _controller element_ from within another Stimulus Controller by using CSS selectors.

The use of Outlets helps with cross-controller communication and coordination as an alternative to dispatching custom events on controller elements.

They are conceptually similar to [Stimulus Targets](https://stimulus.hotwired.dev/reference/targets) but with the difference that they reference a Stimulus controller instance plus its associated controller element.

```html
<div>
  <div class="online-user" data-controller="user-status">...</div>
  <div class="online-user" data-controller="user-status">...</div>
  ...
</div>

...

<div data-controller="chat" data-chat-user-status-outlet=".online-user">
  ...
</div>
```

While a **target** is a specifically marked element **within the scope** of its own controller element, an **outlet** can be located **anywhere on the page** and doesn't necessarily have to be within the controller scope.
</details>

## 属性と名前

`data-chat-user-status-outlet`属性は、_アウトレット属性_ と呼ばれ、その値は参照先のコントローラ要素を指し示す[CSSセレクタ](https://developer.mozilla.org/ja/docs/Web/CSS/CSS_Selectors)です。 参照元コントローラのアウトレット識別子は、参照先のコントローラの識別子と同じでなければなりません。

```html
data-[identifier]-[outlet]-outlet="[selector]"
```

```html
<div data-controller="chat" data-chat-user-status-outlet=".online-user"></div>
```

<details>
    <summary>原文</summary>
The `data-chat-user-status-outlet` attribute is called an _outlet attribute_, and its value is a [CSS selector](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors) which you can use to refer to other controller elements which should be available as outlets on the _host controller_. The outlet identifier in the host controller must be the same as the target controller's identifier.

```html
data-[identifier]-[outlet]-outlet="[selector]"
```

```html
<div data-controller="chat" data-chat-user-status-outlet=".online-user"></div>
```

</details>

## 定義の仕方

コントローラクラスで、`static outlets`配列を定義して参照したいコントローラの識別子を列挙します。 この配列の各要素であるコントローラ識別子に対応するコントローラをアウトレットとして使用できることを宣言します：

```js
// chat_controller.js

export default class extends Controller {
  static outlets = [ "user-status" ]

  connect () {
    this.userStatusOutlets.forEach(status => ...)
  }
}
```

<details>
    <summary>原文</summary>
Define controller identifiers in your controller class using the `static outlets` array. This array declares which other controller identifiers can be used as outlets on this controller:


```js
// chat_controller.js

export default class extends Controller {
  static outlets = [ "user-status" ]

  connect () {
    this.userStatusOutlets.forEach(status => ...)
  }
}
```
</details>

## プロパティ

Stimulusは`static outlets`配列で定義された各アウトレットに対応した5つのプロパティをコントローラに追加します：

| 種類 | プロパティ名 | 返り値の型 | 説明
| ---- | ------------- | ----------- | -----------
| 存在有無 | `has[Name]Outlet` | `Boolean` | `[name]`アウトレットの有無をテストする
| 単数 | `[name]Outlet` | `Controller` | 最初の `[name]`アウトレットのControllerインスタンスを返します。 もし存在しない場合はエラーをスローします
| 複数 | `[name]Outlets` | `Array<Controller>` | すべての`[name]` アウトレットのControllerインスタンスを返します。
| 単数 | `[name]OutletElement` | `Element` | 最初の`[name]`アウトレットのコントローラ要素を返します。 もし存在しない場合はエラーをスローします
| 複数 | `[name]OutletElements` | `Array<Element>` | すべての`[name]`アウトレットのコントローラ要素を返します。

**注:** ネストされた Stimulusコントローラプロパティ(識別子に`--`を含むもの)をアウトレットで参照する場合は名前空間の区切り文字を省略してください：

```js
// chat_controller.js

export default class extends Controller {
  static outlets = [ "admin--user-status" ]

  selectAll(event) {
    // これはundefinedとなります
    this.admin__UserStatusOutlets

    // adomin--user-statusコントローラインスタンスの配列が得られます
    this.adminUserStatusOutlets
  }
}
```

<details>
    <summary>原文</summary>
For each outlet defined in the `static outlets` array, Stimulus adds five properties to your controller, where `[name]` corresponds to the outlet's controller identifier:

| Kind | Property name | Return Type | Effect
| ---- | ------------- | ----------- | -----------
| Existential | `has[Name]Outlet` | `Boolean` | Tests for presence of a `[name]` outlet
| Singular | `[name]Outlet` | `Controller` | Returns the `Controller` instance of the first `[name]` outlet or throws an exception if none is present
| Plural | `[name]Outlets` | `Array<Controller>` | Returns the `Controller` instances of all `[name]` outlets
| Singular | `[name]OutletElement` | `Element` | Returns the Controller `Element` of the first `[name]` outlet or throws an exception if none is present
| Plural | `[name]OutletElements` | `Array<Element>` | Returns the Controller `Element`'s of all `[name]` outlets

**Note:** For nested Stimulus controller properties, make sure to omit namespace delimiters in order to correctly access the referenced outlet:

```js
// chat_controller.js

export default class extends Controller {
  static outlets = [ "admin--user-status" ]

  selectAll(event) {
    // returns undefined
    this.admin__UserStatusOutlets

    // returns controller reference
    this.adminUserStatusOutlets
  }
}
```
</details>

## コントローラとコントローラ要素にアクセスする

`[name]Outlet`と`[name]Outlets`のプロパティからコントローラのインスタンスが返されるので、そのコントローラインスタンスが定義する`Values`、`Classes`、`Targets`、その他すべてのプロパティや関数にアクセスすることもできます：

```js
this.userStatusOutlet.idValue
this.userStatusOutlet.imageTarget
this.userStatusOutlet.activeClasses
```

また、アウトレットで参照する先のコントローラで独自に定義した関数を呼び出すこともできます：

```js
// user_status_controller.js

export default class extends Controller {
  markAsSelected(event) {
    // ...
  }
}

// chat_controller.js

export default class extends Controller {
  static outlets = [ "user-status" ]

  selectAll(event) {
    this.userStatusOutlets.forEach(status => status.markAsSelected(event))
  }
}
```

同様に、アウトレット要素では、[Element](https://developer.mozilla.org/ja/docs/Web/API/Element)の任意の関数またはプロパティを呼び出すことができます。

```js
this.userStatusOutletElement.dataset.value
this.userStatusOutletElement.getAttribute("id")
this.userStatusOutletElements.map(status => status.hasAttribute("selected"))
```

<details>
    <summary>原文</summary>
Since you get back a `Controller` instance from the `[name]Outlet` and `[name]Outlets` properties you are also able to access the Values, Classes, Targets and all of the other properties and functions that controller instance defines:

```js
this.userStatusOutlet.idValue
this.userStatusOutlet.imageTarget
this.userStatusOutlet.activeClasses
```

You are also able to invoke any function the outlet controller may define:

```js
// user_status_controller.js

export default class extends Controller {
  markAsSelected(event) {
    // ...
  }
}

// chat_controller.js

export default class extends Controller {
  static outlets = [ "user-status" ]

  selectAll(event) {
    this.userStatusOutlets.forEach(status => status.markAsSelected(event))
  }
}
```

Similarly with the Outlet Element, it allows you to call any function or property on [`Element`](https://developer.mozilla.org/en-US/docs/Web/API/Element):

```js
this.userStatusOutletElement.dataset.value
this.userStatusOutletElement.getAttribute("id")
this.userStatusOutletElements.map(status => status.hasAttribute("selected"))
```
</details>

## アウトレットのコールバック

アウトレットコールバックは、Stimulusによって呼び出される特別な名前の関数で、アウトレットがページに追加または削除されるたびに実行したい処理を記述できます。

アウトレットの変化を監視するには、`[name]OutletConnected()`または`[name]OutletDisconnected()` という名前の関数を定義します。

```js
// chat_controller.js

export default class extends Controller {
  static outlets = [ "user-status" ]

  userStatusOutletConnected(outlet, element) {
    // ...
  }

  userStatusOutletDisconnected(outlet, element) {
    // ...
  }
}
```

<details>
    <summary>原文</summary>
Outlet callbacks are specially named functions called by Stimulus to let you respond to whenever an outlet is added or removed from the page.

To observe outlet changes, define a function named `[name]OutletConnected()` or `[name]OutletDisconnected()`.

```js
// chat_controller.js

export default class extends Controller {
  static outlets = [ "user-status" ]

  userStatusOutletConnected(outlet, element) {
    // ...
  }

  userStatusOutletDisconnected(outlet, element) {
    // ...
  }
}
```
</details>

### アウトレットは存在するものとして扱われる

ControllerのOutletプロパティにアクセスする際、対応するアウトレットが少なくとも1つ存在することを検証します。 一致するアウトレットが見つからない場合、Stimulusはエラーをスローします。

```html
Missing outlet element "user-status" for "chat" controller
```

<details>
    <summary>原文</summary>
When you access an Outlet property in a Controller, you assert that at least one corresponding Outlet is present. If the declaration is missing and no matching outlet is found Stimulus will throw an exception:

```html
Missing outlet element "user-status" for "chat" controller
```
</details>

### オプショナルなアウトレット

アウトレットがオプショナルである場合、または少なくともアウトレットが一つは存在することを保証したい場合は、まず`has[Name]Outlet`プロパティを使用してアウトレットの存在を確認する必要があります：

```js
if (this.hasUserStatusOutlet) {
  this.userStatusOutlet.safelyCallSomethingOnTheOutlet()
}
```

<details>
    <summary>原文</summary>
If an Outlet is optional or you want to assert that at least Outlet is present, you must first check the presence of the Outlet using the existential property:

```js
if (this.hasUserStatusOutlet) {
  this.userStatusOutlet.safelyCallSomethingOnTheOutlet()
}
```
</details>

### コントローラ識別子を持たない要素を参照した場合

Stimulusは、対応する`data-controller`と識別子を持たない要素をアウトレットとして宣言しようとすると、エラーをスローします。

```html
<div data-controller="chat" data-chat-user-status-outlet="#user-column"></div>

<div id="user-column"></div>
```

この場合、結果は次のようになります。

```html
Missing "data-controller=user-status" attribute on outlet element for "chat" controller`
```

<details>
    <summary>原文</summary>
Stimulus will throw an exception if you try to declare an element as an outlet which doesn't have a corresponding `data-controller` and identifier on it:


```html
<div data-controller="chat" data-chat-user-status-outlet="#user-column"></div>

<div id="user-column"></div>
```

Would result in:
```html
Missing "data-controller=user-status" attribute on outlet element for "chat" controller`
```
</details>
