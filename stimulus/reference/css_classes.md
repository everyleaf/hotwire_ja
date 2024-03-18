---
title: CSS Classes
description: CSSクラスを論理名でコントローラから参照できるようにする"
layout: "base.html"
---

# CSS Classes

HTMLの _CSSクラス_ は、`class`属性を使用して要素にスタイルのセットを定義します。

CSSクラスは、プログラムでスタイルを変更したりアニメーションを再生したりするのに便利です。 例えば、Stimulusコントローラで、バックグラウンドでなんらかの操作を実行しているときに読み込み中のUIを表示させるために`loading`を要素につけるといったこともできます。

```html
<form data-controller="search" class="search--busy">
```

```css
.search--busy {
  background-image: url(throbber.svg) no-repeat;
}
```

Stimulusでは、JavaScript内でCSSクラスを文字列としてハードコーディングする代わりに、データ属性とコントローラプロパティの組み合わせを使用して、 _論理名_ で参照することができます。

<details>
    <summary>原文</summary>
In HTML, a _CSS class_ defines a set of styles which can be applied to elements using the `class` attribute.

CSS classes are a convenient tool for changing styles and playing animations programmatically. For example, a Stimulus controller might add a "loading" class to an element when it is performing an operation in the background, and then style that class in CSS to display a progress indicator:

```html
<form data-controller="search" class="search--busy">
```

```css
.search--busy {
  background-image: url(throbber.svg) no-repeat;
}
```

As an alternative to hard-coding classes with JavaScript strings, Stimulus lets you refer to CSS classes by _logical name_ using a combination of data attributes and controller properties.
</details>

## 定義の仕方

`static classes`配列を使用して、コントローラでCSSクラスの論理名を定義します。

```js
// controllers/search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ "loading" ]

  // …
}
```

<details>
    <summary>原文</summary>
Define CSS classes by logical name in your controller using the `static classes` array:

```js
// controllers/search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ "loading" ]

  // …
}
```
</details>

## 属性

コントローラの`static classes`配列で定義されている論理名は、コントローラ要素の _classデータ属性_ にマップされます。

```html
<form data-controller="search"
      data-search-loading-class="search--busy">
  <input data-action="search#loadResults">
</form>
```

コントローラ識別子と論理名を`data-[identifier]-[logical-name]-class`の形式で結合して、classデータ属性を作ります。 この属性の値には、単一のCSSクラス名または複数のクラス名のリストを指定することができます。

**注:** classデータ属性は、`data-controller`属性と同じ要素に指定する必要があります。

論理名に複数のCSSクラスを指定する場合は、クラスをスペースで区切ります。

```html
<form data-controller="search"
      data-search-loading-class="bg-gray-500 animate-spinner cursor-busy">
  <input data-action="search#loadResults">
</form>
```

<details>
    <summary>原文</summary>

The logical names defined in the controller's `static classes` array map to _CSS class attributes_ on the controller's element.

```html
<form data-controller="search"
      data-search-loading-class="search--busy">
  <input data-action="search#loadResults">
</form>
```

Construct a CSS class attribute by joining together the controller identifier and logical name in the format `data-[identifier]-[logical-name]-class`. The attribute's value can be a single CSS class name or a list of multiple class names.

**Note:** CSS class attributes must be specified on the same element as the `data-controller` attribute.

If you want to specify multiple CSS classes for a logical name, separate the classes with spaces:

```html
<form data-controller="search"
      data-search-loading-class="bg-gray-500 animate-spinner cursor-busy">
  <input data-action="search#loadResults">
</form>
```
</details>

## プロパティ

`static classes`配列で定義された論理名ごとに、Stimulusは次のプロパティをコントローラに追加します。

Kind        | Name                         | Value
-------- | ---------------------------- | -----
単数     | `this.[logicalName]Class`    | `logicalName`に対応するclassデータ属性の値
複数形   | `this.[logicalName]Classes`  | 対応するclassデータ属性に含まれる全てのクラスをスペースで分割した配列
存在有無 | `this.has[LogicalName]Class` | classデータ属性が存在するかどうかを示すbool値

<br>これらのプロパティと [DOM classList API](https://developer.mozilla.org/ja/docs/Web/API/Element/classList) の`add() `および`remove() `メソッドを使用して要素にCSSクラスを適用します。

たとえば、(ajax通信などの)結果をフェッチする前に`search`コントローラの要素に読み込みインジケータを表示するには、次のように`loadResults`関数を実装します。

```js
export default class extends Controller {
  static classes = [ "loading" ]

  loadResults() {
    this.element.classList.add(this.loadingClass)

    fetch(/* … */)
  }
}
```

classデータ属性にクラス名のリストが含まれている場合、単数系のcss-classプロパティ(`loadingClass`)はリスト内の最初のクラスを返します。

classデータ属性に記述された全てのクラス名に配列としてアクセスするには、複数形のcss-classプロパティを使用します。 これを [スプレッド構文](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Operators/Spread_syntax) と組み合わせると、複数のクラスを一度に適用することができます。

```js
export default class extends Controller {
  static classes = [ "loading" ]

  loadResults() {
    this.element.classList.add(...this.loadingClasses)

    fetch(/* … */)
  }
}
```

**注:** 一致するclassデータ属性が存在しない場合にcss-classプロパティにアクセスしようとすると、Stimulusはエラーをスローします。

<details>
    <summary>原文</summary>
For each logical name defined in the `static classes` array, Stimulus adds the following _CSS class properties_ to your controller:

Kind        | Name                         | Value
----------- | ---------------------------- | -----
Singular    | `this.[logicalName]Class`    | The value of the CSS class attribute corresponding to `logicalName`
Plural      | `this.[logicalName]Classes`  | An array of all classes in the corresponding CSS class attribute, split by spaces
Existential | `this.has[LogicalName]Class` | A boolean indicating whether or not the CSS class attribute is present

<br>Use these properties to apply CSS classes to elements with the `add()` and `remove()` methods of the [DOM `classList` API](https://developer.mozilla.org/en-US/docs/Web/API/Element/classList).

For example, to display a loading indicator on the `search` controller's element before fetching results, you might implement the `loadResults` action like so:

```js
export default class extends Controller {
  static classes = [ "loading" ]

  loadResults() {
    this.element.classList.add(this.loadingClass)

    fetch(/* … */)
  }
}
```

If a CSS class attribute contains a list of class names, its singular CSS class property returns the first class in the list.

Use the plural CSS class property to access all class names as an array. Combine this with [spread syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax) to apply multiple classes at once:

```js
export default class extends Controller {
  static classes = [ "loading" ]

  loadResults() {
    this.element.classList.add(...this.loadingClasses)

    fetch(/* … */)
  }
}
```

**Note:** Stimulus will throw an error if you attempt to access a CSS class property when a matching CSS class attribute is not present.

</details>

## 命名規則

`static classes`定義で論理名を指定する際はキャメルケースを使用します。 論理名はキャメルケースのままcss-classプロパティにマップされます。

```js
export default class extends Controller {
  static classes = [ "loading", "noResults" ]

  loadResults() {
    // …
    if (results.length == 0) {
      this.element.classList.add(this.noResultsClass)
    }
  }
}
```

HTMLでは、classデータ属性をケバブケースで記述します。

```html
<form data-controller="search"
      data-search-loading-class="search--busy"
      data-search-no-results-class="search--empty">
```

classデータ属性を作成する場合は、[コントローラ:命名規則](/stimulus/reference/controllers/#%E5%91%BD%E5%90%8D%E8%A6%8F%E5%89%87)で説明されている識別子の規則に従います。

<details>
    <summary>原文</summary>
Use camelCase to specify logical names in CSS class definitions. Logical names map to camelCase CSS class properties:

```js
export default class extends Controller {
  static classes = [ "loading", "noResults" ]

  loadResults() {
    // …
    if (results.length == 0) {
      this.element.classList.add(this.noResultsClass)
    }
  }
}
```

In HTML, write CSS class attributes in kebab-case:

```html
<form data-controller="search"
      data-search-loading-class="search--busy"
      data-search-no-results-class="search--empty">
```

When constructing CSS class attributes, follow the conventions for identifiers as described in [Controllers: Naming Conventions](controllers#naming-conventions).
</details>
