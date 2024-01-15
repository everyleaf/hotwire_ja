---
title: Values
description: ""
layout: "base.html"
---

# Values

コントローラ要素に設定された[HTMLデータ属性](https://developer.mozilla.org/ja/docs/Web/HTML/Global_attributes/data-*)は、コントローラの特別なプロパティを使用して、型付けされた値として読み書きできます。

You can read and write [HTML data attributes](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/data-*) on controller elements as typed _values_ using special controller properties.

```html
<div data-controller="loader" data-loader-url-value="/messages">
</div>
```

上記のHTMLスニペットを参考にして、valueデータ属性を`data-controller`属性を設定したのと同じ要素に設置しましょう。

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

## Definitions

`static values`オブジェクトを使用して、コントローラ内で`values`を定義します。 各valueの名前を左側に、その型を右側に記述します。

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

## Types

valueの型は、Array、Boolean、Number、Object、またはStringのいずれかです。 型は、JavaScriptとHTMLの間で値を変換する方法を決定します。

A value's type is one of `Array`, `Boolean`, `Number`, `Object`, or `String`. The type determines how the value is transcoded between JavaScript and HTML.

| 型      | エンコード方法           | デコード方法                            |
| ------- | ------------------------ | --------------------------------------- |
| Array   | `JSON.stringify(array)`  | `JSON.parse(value)`                     |
| Boolean | `boolean.toString()`     | `!(value == "0" \|\| value == "false")` |
| Number  | `number.toString()`      | `Number(value.replace(/_/g, ""))`       |
| Object  | `JSON.stringify(object)` | `JSON.parse(value)`                     |
| String  | Itself                   | Itself                                  |

## Properties and Attributes

Stimulus はコントローラで定義された各valueのゲッター、セッター、および存在有無を示すプロパティを自動的に生成します。 これらのプロパティは、コントローラ要素のデータ属性にリンクされます：

Stimulus automatically generates getter, setter, and existential properties for each value defined in a controller. These properties are linked to data attributes on the controller's element:

種類 | プロパティ名  | 振る舞い
---- | ------------- | ------
Getter | `this.[name]Value` | `data-[identifier]-[name]-value`を読み取る
Setter | `this.[name]Value=` | `data-[identifier]-[name]-value`に書き込む
Existential | `this.has[Name]Value` | `data-[identifier]-[name]-value`があるかどうか検証する

### Getters

valueのゲッターは、関連付けられたデータ属性の値を指定した型にデコードします。

The getter for a value decodes the associated data attribute into an instance of the value's type.


コントローラの要素にdata属性がない場合、ゲッターはvalueの型に応じた _デフォルト値_ を返します：

If the data attribute is missing from the controller's element, the getter returns a _default value_, depending on the value's type:

型   | デフォルト値
---- | -------------
Array | `[]`
Boolean | `false`
Number | `0`
Object | `{}`
String | `""`

### Setters

valueのセッターは、コントローラの要素に関連付けられたデータ属性に書き込みをします。

The setter for a value sets the associated data attribute on the controller's element.

コントローラの要素からデータ属性を削除するには、valueに`undefined`を代入します。

To remove the data attribute from the controller's element, assign `undefined` to the value.

### Existential Properties

valueの存在有無プロパティは、関連付けられたデータ属性がコントローラーの要素に存在する場合は`true`、存在しない場合に`false`を返します。

The existential property for a value evaluates to `true` when the associated data attribute is present on the controller's element and `false` when it is absent.

## Change Callbacks

_ValueChangedコールバック_ は、対応するvalueデータ属性が変更されるたびに呼び出されます。

Value _change callbacks_ let you respond whenever a value's data attribute changes.

コントローラーでメソッド`[name]ValueChanged`を定義します。 この`[name]`は変更を監視するvalueの名前です。 このメソッドは、最初の引数としてデコード済みの現在の値を受け取り、2番目の引数としてデコード済みの一つ前の値を受け取ります。

Define a method `[name]ValueChanged` in the controller, where `[name]` is the name of the value you want to observe for changes. The method receives its decoded value as the first argument and the decoded previous value as the second argument.

Stimulusは、コントローラが初期化された後、関連付けられているデータ属性が変更されるたびに、それぞれの`ValueChangedコールバック`を呼び出します。 これには、valueセッターへの代入の結果としての変更も含まれます。

Stimulus invokes each change callback after the controller is initialized and again any time its associated data attribute changes. This includes changes as a result of assignment to the value's setter.

```js
export default class extends Controller {
  static values = { url: String }

  urlValueChanged() {
    fetch(this.urlValue).then(/* … */)
  }
}
```

### Previous Values

コントローラのコールバックメソッドに2つの引数を定義することで、[name]ValueChangedコールバックの前の値にアクセスすることができます。

`[name]ValueChanged`コールバックで変更前の値にアクセスするには、第二引数を指定します。

You can access the previous value of a `[name]ValueChanged` callback by defining the callback method with two arguments in your controller.

```js
export default class extends Controller {
  static values = { url: String }

  urlValueChanged(value, previousValue) {
    /* … */
  }
}
```

この第二引数には好きな名前を付けることができます。`urlValueChanged(current, old)`のように定義できます。

The two arguments can be named as you like. You could also use `urlValueChanged(current, old)`.

## Default Values

コントローラ要素で指定されていないvalueデータ属性の値は、コントローラ側で定義されたデフォルト値があればそれが適用されます。

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

デフォルト値を使用する場合、`{ type, default }`の展開形式が使用されれます。 この形式は、デフォルト値を使用しない通常の形式と混在させることができます。

When a default is used, the expanded form of `{ type, default }` is used. This form can be mixed with the regular form that does not use a default.

## Naming Conventions

valueの名前は、JavaScriptではキャメルケース、HTMLではケバブケースで記述します。 例えば、`loader`コントローラの`contentType`というvalueは、関連するデータ属性として`data-loader-content-type-value`を持ちます。

Write value names as camelCase in JavaScript and kebab-case in HTML. For example, a value named `contentType` in the `loader` controller will have the associated data attribute `data-loader-content-type-value`.
