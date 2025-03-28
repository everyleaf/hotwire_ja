---
title: Values
description: "Valuesを使うことでコントローラ要素に設定したデータ属性を読み書きすることができます"
order: 5
---

# Values

コントローラ要素に設定された[HTMLデータ属性](https://developer.mozilla.org/ja/docs/Web/HTML/Global_attributes/data-*)は、コントローラの特別なプロパティを使用して、型付けされた値として読み書きできます。

```html
<div data-controller="loader" data-loader-url-value="/messages">
</div>
```

上記のHTMLスニペットを参考にして、valueデータ属性を`data-controller`属性を設定したのと同じ要素に設置しましょう。

```js
// controllers/loader_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String
  }

  connect() {
    fetch(this.urlValue).then(/* … */)
  }
}
```

<details>
    <summary>原文</summary>
You can read and write [HTML data attributes](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/data-*) on controller elements as typed _values_ using special controller properties.

```html
<div data-controller="loader" data-loader-url-value="/messages">
</div>
```

As per the given HTML snippet, remember to place the data attributes for values on the same element as the `data-controller` attribute.

```js
// controllers/loader_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String
  }

  connect() {
    fetch(this.urlValue).then(/* … */)
  }
}
```
</details>

## 定義の仕方

`static values`オブジェクトを使用して、コントローラ内で`values`を定義します。 各valueの論理名を左側に、その型を右側に記述します。

```js
export default class extends Controller {
  static values = {
    url: String,
    interval: Number,
    params: Object
  }

  // …
}
```

<details>
    <summary>原文</summary>
Define values in a controller using the `static values` object. Put each value's _name_ on the left and its _type_ on the right.

```js
export default class extends Controller {
  static values = {
    url: String,
    interval: Number,
    params: Object
  }

  // …
}
```
</details>

## 型

valueの型は、`Array`、`Boolean`、`Number`、`Object`、または`String`のいずれかです。 型は、JavaScriptとHTMLのデータ属性間で相互に値を変換する方法を決定します。

| 型      | エンコード方法           | デコード方法                            |
| ------- | ------------------------ | --------------------------------------- |
| Array   | `JSON.stringify(array)`  | `JSON.parse(value)`                     |
| Boolean | `boolean.toString()`     | `!(value == "0" \|\| value == "false")` |
| Number  | `number.toString()`      | `Number(value.replace(/_/g, ""))`       |
| Object  | `JSON.stringify(object)` | `JSON.parse(value)`                     |
| String  | Itself                   | Itself                                  |

<details>
    <summary>原文</summary>
A value's type is one of `Array`, `Boolean`, `Number`, `Object`, or `String`. The type determines how the value is transcoded between JavaScript and HTML.

| Type    | Encoded as…              | Decoded as…                             |
| ------- | ------------------------ | --------------------------------------- |
| Array   | `JSON.stringify(array)`  | `JSON.parse(value)`                     |
| Boolean | `boolean.toString()`     | `!(value == "0" \|\| value == "false")` |
| Number  | `number.toString()`      | `Number(value.replace(/_/g, ""))`       |
| Object  | `JSON.stringify(object)` | `JSON.parse(value)`                     |
| String  | Itself                   | Itself                                  |

</details>

## プロパティと属性

Stimulus はコントローラで定義された各valueのゲッター、セッター、および存在有無を示すプロパティを自動的に生成します。 これらのプロパティは、コントローラ要素のデータ属性にリンクされます：

種類 | プロパティ名  | 振る舞い
---- | ------------- | ------
Getter | `this.[name]Value` | `data-[identifier]-[name]-value`を読み取る
Setter | `this.[name]Value=` | `data-[identifier]-[name]-value`に書き込む
Existential | `this.has[Name]Value` | `data-[identifier]-[name]-value`があるかどうか検証する

<details>
    <summary>原文</summary>
Stimulus automatically generates getter, setter, and existential properties for each value defined in a controller. These properties are linked to data attributes on the controller's element:

Kind | Property name | Effect
---- | ------------- | ------
Getter | `this.[name]Value` | Reads `data-[identifier]-[name]-value`
Setter | `this.[name]Value=` | Writes `data-[identifier]-[name]-value`
Existential | `this.has[Name]Value` | Tests for `data-[identifier]-[name]-value`
</details>

### ゲッター

valueのゲッターは、関連付けられたデータ属性の値を指定した型にデコードします。

コントローラの要素にdata属性がない場合、ゲッターはvalueの型に応じた _デフォルト値_ を返します：

型   | デフォルト値
---- | -------------
Array | `[]`
Boolean | `false`
Number | `0`
Object | `{}`
String | `""`

<details>
    <summary>原文</summary>
The getter for a value decodes the associated data attribute into an instance of the value's type.

If the data attribute is missing from the controller's element, the getter returns a _default value_, depending on the value's type:

Type | Default value
---- | -------------
Array | `[]`
Boolean | `false`
Number | `0`
Object | `{}`
String | `""`
</details>

### セッター

valueのセッターは、コントローラの要素に関連付けられたデータ属性に書き込みをします。

コントローラの要素からvaluesデータ属性を削除するには、valueセッターに`undefined`を代入します。

<details>
    <summary>原文</summary>
The setter for a value sets the associated data attribute on the controller's element.

To remove the data attribute from the controller's element, assign `undefined` to the value.

</details>

### 存在有無プロパティ

valueの存在有無プロパティは、関連付けられたデータ属性がコントローラーの要素に存在する場合は`true`、しない場合に`false`を返します。

<details>
    <summary>原文</summary>
The existential property for a value evaluates to `true` when the associated data attribute is present on the controller's element and `false` when it is absent.

</details>

## 変更コールバック

_ValueChangedコールバック_ を使用すると、対応するvalueデータ属性が変更されるたびに処理を呼び出すことができます。

まずコントローラーでメソッド`[name]ValueChanged`を定義します。 この`[name]`は変更を監視するvalueの論理名です。 このメソッドは、最初の引数としてデコード済みの現在の値を受け取り、2番目の引数としてデコード済みの変更前の値を受け取ります。

Stimulusは、コントローラが初期化された後、関連付けられているデータ属性が変更されるたびに、それぞれの`ValueChangedコールバック`を呼び出します。 これには、valueセッターへの代入の結果としての変更も含まれます。

```js
export default class extends Controller {
  static values = { url: String }

  urlValueChanged() {
    fetch(this.urlValue).then(/* … */)
  }
}
```

<details>
    <summary>原文</summary>
Value _change callbacks_ let you respond whenever a value's data attribute changes.

Define a method `[name]ValueChanged` in the controller, where `[name]` is the name of the value you want to observe for changes. The method receives its decoded value as the first argument and the decoded previous value as the second argument.

Stimulus invokes each change callback after the controller is initialized and again any time its associated data attribute changes. This includes changes as a result of assignment to the value's setter.

```js
export default class extends Controller {
  static values = { url: String }

  urlValueChanged() {
    fetch(this.urlValue).then(/* … */)
  }
}
```
</details>

### 変更前のvalue

`[name]ValueChanged`コールバックで変更前の値にアクセスするには、第二引数を指定します。

```js
export default class extends Controller {
  static values = { url: String }

  urlValueChanged(value, previousValue) {
    /* … */
  }
}
```

この第二引数には好きな名前を付けることができます。 例として`urlValueChanged(current, old)`のように定義できます。

<details>
    <summary>原文</summary>
You can access the previous value of a `[name]ValueChanged` callback by defining the callback method with two arguments in your controller.

```js
export default class extends Controller {
  static values = { url: String }

  urlValueChanged(value, previousValue) {
    /* … */
  }
}
```

The two arguments can be named as you like. You could also use `urlValueChanged(current, old)`.

</details>

## デフォルト値

コントローラ要素で指定されていないvalueデータ属性の値は、コントローラ側で定義されたデフォルト値があればそれが適用されます。

```js
export default class extends Controller {
  static values = {
    url: { type: String, default: '/bill' },
    interval: { type: Number, default: 5 },
    clicked: Boolean
  }
}
```

デフォルト値を使用する場合、valueの定義は`{ type, default }`の展開形式を使用します。 この形式は、デフォルト値を使用しない通常の形式と混在させることができます。

<details>
    <summary>原文</summary>
Values that have not been specified on the controller element can be set by defaults specified in the controller definition:

```js
export default class extends Controller {
  static values = {
    url: { type: String, default: '/bill' },
    interval: { type: Number, default: 5 },
    clicked: Boolean
  }
}
```

When a default is used, the expanded form of `{ type, default }` is used. This form can be mixed with the regular form that does not use a default.

</details>

## 命名規則

valueの名前は、JavaScriptではキャメルケース、HTMLではケバブケースで記述します。 例えば、`loader`コントローラの`contentType`というvalueは、関連するデータ属性として`data-loader-content-type-value`を持ちます。

<details>
    <summary>原文</summary>
Write value names as camelCase in JavaScript and kebab-case in HTML. For example, a value named `contentType` in the `loader` controller will have the associated data attribute `data-loader-content-type-value`.
</details>
