---
title: Targets
description: "Targetを使うとコントローラで扱いたい重要な要素を参照することができます"
layout: "base.html"
---

# Targets

_ターゲット_ を使えば、重要な要素を論理名で参照することができます。

```html
<div data-controller="search">
  <input type="text" data-search-target="query">
  <div data-search-target="errorMessage"></div>
  <div data-search-target="results"></div>
</div>
```

<details>
    <summary>原文</summary>
_Targets_ let you reference important elements by name.

```html
<div data-controller="search">
  <input type="text" data-search-target="query">
  <div data-search-target="errorMessage"></div>
  <div data-search-target="results"></div>
</div>
```
</details>

## 属性と論理名

`data-search-target`属性は _ターゲット属性_ と呼ばれます。 その値はスペースで区切られたターゲットの論理名のリストで、`search`コントローラ内の要素を参照するために使用できます。

```html
<div data-controller="search">
  <div data-search-target="results"></div>
</div>
```

<details>
    <summary>原文</summary>
The `data-search-target` attribute is called a _target attribute_, and its value is a space-separated list of _target names_ which you can use to refer to the element in the `search` controller.

```html
<div data-controller="s​earch">
  <div data-search-target="results"></div>
</div>
```
</details>

## 定義の仕方

コントローラクラスで、`static targets`配列を定義してターゲットの論理名を列挙します：

```js
// controllers/search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "query", "errorMessage", "results" ]
  // …
}
```

<details>
    <summary>原文</summary>
Define target names in your controller class using the `static targets` array:

```js
// controllers/search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "query", "errorMessage", "results" ]
  // …
}
```
</details>

## プロパティ

`static targets`で定義された各ターゲットの論理名に対して、Stimulusは以下のプロパティをコントローラに追加します(ここで、`[name]`はターゲットの論理名に対応します)：

Kind        | Name                   | Value
----------- | ---------------------- | -----
単数      | `this.[name]Target`    | スコープ内で最初にマッチしたターゲット
複数      | `this.[name]Targets`   | スコープ内でマッチした全てのターゲットの配列
存在有無  | `this.has[Name]Target` | スコープ内に一致するターゲットがあるかどうかを示すbool値

<br>**注：** 単数系のターゲットプロパティにアクセスすると、一致する要素がない場合にエラーがスローされます。

<details>
    <summary>原文</summary>
For each target name defined in the `static targets` array, Stimulus adds the following properties to your controller, where `[name]` corresponds to the target's name:

Kind        | Name                   | Value
----------- | ---------------------- | -----
Singular    | `this.[name]Target`    | The first matching target in scope
Plural      | `this.[name]Targets`   | An array of all matching targets in scope
Existential | `this.has[Name]Target` | A boolean indicating whether there is a matching target in scope

<br>**Note:** Accessing the singular target property will throw an error when there is no matching element.
</details>

## ターゲットの共有

要素は複数のターゲット属性を持つことができ、そうすることで複数のコントローラで同じ要素を参照するターゲットを持つことができます。

```html
<form data-controller="search checkbox">
  <input type="checkbox" data-search-target="projects" data-checkbox-target="input">
  <input type="checkbox" data-search-target="messages" data-checkbox-target="input">
  …
</form>
```

上記のチェックボックス要素はそれぞれ`this.projectsTarget`と`this.messagesTarget`として`search`コントローラ内でアクセスできます。

また、`checkbox`コントローラの内部では、`this.inputTargets`は両方のチェックボックスを含む配列を返します。

<details>
    <summary>原文</summary>
Elements can have more than one target attribute, and it's common for targets to be shared by multiple controllers.

```html
<form data-controller="search checkbox">
  <input type="checkbox" data-search-target="projects" data-checkbox-target="input">
  <input type="checkbox" data-search-target="messages" data-checkbox-target="input">
  …
</form>
```

In the example above, the checkboxes are accessible inside the `search` controller as `this.projectsTarget` and `this.messagesTarget`, respectively.

Inside the `checkbox` controller, `this.inputTargets` returns an array with both checkboxes.

</details>

## オプショナルなターゲット

コントローラが、存在するかどうかわからないターゲットと連携する必要がある場合は、`has[name]Target`プロパティの値に基づいてコードを条件付けします：

```js
if (this.hasResultsTarget) {
  this.resultsTarget.innerHTML = "…"
}
```

<details>
    <summary>原文</summary>
If your controller needs to work with a target which may or may not be present, condition your code based on the value of the existential target property:

```js
if (this.hasResultsTarget) {
  this.resultsTarget.innerHTML = "…"
}
```
</details>

## 接続/切断時のコールバック

_ターゲット要素のコールバック_ を使用すると、コントローラのスコープ内にターゲット要素が追加または削除されるたびに実行したい処理を記述することができます。

このコールバック関数はコントローラに`[name]TargetConnected`または`[name]TargetDisconnected`というメソッドとして定義します。 これらのメソッドは、最初の引数として対象の`target`要素を受け取ります。

Stimulusは、`connect()`ライフサイクルフックの実行後、`disconnect()` ライフサイクルフックが呼び出されるまでの間、ターゲット要素が追加または削除されるたびに各ターゲット要素のコールバックを呼び出します。

```js
export default class extends Controller {
  static targets = [ "item" ]

  itemTargetConnected(element) {
    this.sortElements(this.itemTargets)
  }

  itemTargetDisconnected(element) {
    this.sortElements(this.itemTargets)
  }

  // Private
  sortElements(itemTargets) { /* ... */ }
}
```

**注** `[name]TargetConnected`および`[name]TargetDisconnected`コールバックの実行中、ターゲット要素の監視に使われている`MutationObserver`インスタンスは一時的に停止します。 つまり、コールバックの中で同名のターゲットを追加または削除した場合、対応するコールバックは呼び出されません。

<details>
    <summary>原文</summary>
Target _element callbacks_ let you respond whenever a target element is added or
removed within the controller's element.

Define a method `[name]TargetConnected` or `[name]TargetDisconnected` in the controller, where `[name]` is the name of the target you want to observe for additions or removals. The method receives the element as the first argument.

Stimulus invokes each element callback any time its target elements are added or removed after `connect()` and before `disconnect()` lifecycle hooks.

```js
export default class extends Controller {
  static targets = [ "item" ]

  itemTargetConnected(element) {
    this.sortElements(this.itemTargets)
  }

  itemTargetDisconnected(element) {
    this.sortElements(this.itemTargets)
  }

  // Private
  sortElements(itemTargets) { /* ... */ }
}
```

**Note** During the execution of `[name]TargetConnected` and
`[name]TargetDisconnected` callbacks, the `MutationObserver` instances behind
the scenes are paused. This means that if a callback add or removes a target
with a matching name, the corresponding callback _will not_ be invoked again.
</details>

## 命名規則

ターゲットの論理名は、コントローラのプロパティに直接対応するため、常にキャメルケースを使用して指定します：

```html
<span data-search-target="camelCase" />
<span data-search-target="do-not-do-this" />
```

```js
export default class extends Controller {
  static targets = [ "camelCase" ]
}
```

<details>
    <summary>原文</summary>
Always use camelCase to specify target names, since they map directly to properties on your controller:

```html
<span data-search-target="camelCase" /> 
<span data-search-target="do-not-do-this" />
```

```js
export default class extends Controller {
  static targets = [ "camelCase" ]  
}
```
</details>
