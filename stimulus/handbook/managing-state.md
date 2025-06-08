---
title: "ステート管理"
description: "Stimulusでアプリケーションのステート管理はどのように行われるのかを見ていきましょう"
order: 5
---

# ステート管理

近年のフレームワークのほとんどは、JavaScriptでステートを保持することを推奨しています。 DOMを書き込み専用のレンダリングターゲットとして扱い、サーバから送られてくるJSONを使用するクライアントサイドのテンプレートによってUIを構築するアプローチです。

一方でStimulus は異なるアプローチをとります。 StimulusアプリケーションのステートはDOM内の属性として存在し、コントローラ自体はほとんどステートを持ちません。 このアプローチにより、初期状態のドキュメント、Ajaxリクエスト、Turbo visit、あるいは別のJavaScriptライブラリなど、どこからでも HTML を扱うことができ、明示的な初期化ステップなしに、関連するコントローラが自動的に起動させることができます。

<details>
    <summary>原文</summary/>
Most contemporary frameworks encourage you to keep state in JavaScript at all times. They treat the DOM as a write-only rendering target, reconciled by client-side templates consuming JSON from the server.

Stimulus takes a different approach. A Stimulus application’s state lives as attributes in the DOM; controllers themselves are largely stateless. This approach makes it possible to work with HTML from anywhere—the initial document, an Ajax request, a Turbo visit, or even another JavaScript library—and have associated controllers spring to life automatically without any explicit initialization step.
</details>

## スライドショーの構築

前章では、Stimulus コントローラで要素にクラス名を追加することで、ドキュメント内の単純な状態を管理する方法を学びました。 しかし、単純なフラグだけでなく、値を保存する必要がある場合はどうすればよいのでしょうか？

ここでは、現在選択されているスライドのインデックスを属性に保持するスライドショーコントローラを作成することで、この疑問を解決します。

いつものように、HTMLから始めましょう：

```html
<div data-controller="slideshow">
  <button data-action="slideshow#previous"> ← </button>
  <button data-action="slideshow#next"> → </button>

  <div data-slideshow-target="slide">🐵</div>
  <div data-slideshow-target="slide">🙈</div>
  <div data-slideshow-target="slide">🙉</div>
  <div data-slideshow-target="slide">🙊</div>
</div>
```

各スライドターゲットは、スライドショー内の1つのスライドを表します。 今回つくるコントローラは、一度に1つのスライドだけを表示する責務を負います。

それではコントローラを作成しましょう。 `src/controllers/slideshow_controller.js` を作成し、以下のように記述します：

```javascript
// src/controllers/slideshow_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "slide" ]

  initialize() {
    this.index = 0
    this.showCurrentSlide()
  }

  next() {
    this.index++
    this.showCurrentSlide()
  }

  previous() {
    this.index--
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    this.slideTargets.forEach((element, index) => {
      element.hidden = index !== this.index
    })
  }
}
```

このコントローラは`showCurrentSlide()`を定義し、各スライドターゲットをループし、インデックスが一致すれば`hidden`属性をトグルします。

最初のスライドを表示してコントローラを初期化し、`next()`と`previous()` で現在のスライドを進めたり巻き戻したりします。

> ### ライフサイクル・コールバックの説明
>
> `initialize()`メソッドは何をするもので、以前に使用した`connect()`メソッドとどう違うのでしょうか
>
> これらのメソッドはStimulusのライフサイクルコールバックメソッドで、コントローラがドキュメントに入ったり出たりするときに、関連する状態をセットアップしたりテールダウンしたりするのに便利です。
>
> | メソッド         | Stimulusによって呼び出されるタイミング...   |
> |--------------|------------------------------|
> | initialize() | コントローラが最初にインスタンス化されたとき(一度だけ) |
> | connect()    | コントローラが DOM に接続されたとき(何度でも)   |
> | disconnect() | コントローラが DOM から切断されたとき(何度でも)  | 

ページを再読み込みし、Next ボタンが次のスライドに進むことを確認します。



<details>
    <summary>原文</summary/>
## Building a Slideshow

In the last chapter, we learned how a Stimulus controller can maintain simple state in the document by adding a class name to an element. But what do we do when we need to store a value, not just a simple flag?

We’ll investigate this question by building a slideshow controller which keeps its currently selected slide index in an attribute.

As usual, we’ll begin with HTML:

```html
<div data-controller="slideshow">
  <button data-action="slideshow#previous"> ← </button>
  <button data-action="slideshow#next"> → </button>

  <div data-slideshow-target="slide">🐵</div>
  <div data-slideshow-target="slide">🙈</div>
  <div data-slideshow-target="slide">🙉</div>
  <div data-slideshow-target="slide">🙊</div>
</div>
```

Each slide target represents a single slide in the slideshow. Our controller will be responsible for making sure only one slide is visible at a time.

Let’s draft our controller. Create a new file, src/controllers/slideshow_controller.js, as follows:

```javascript
// src/controllers/slideshow_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "slide" ]

  initialize() {
    this.index = 0
    this.showCurrentSlide()
  }

  next() {
    this.index++
    this.showCurrentSlide()
  }

  previous() {
    this.index--
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    this.slideTargets.forEach((element, index) => {
      element.hidden = index !== this.index
    })
  }
}
```

Our controller defines a method, showCurrentSlide(), which loops over each slide target, toggling the hidden attribute if its index matches.

We initialize the controller by showing the first slide, and the next() and previous() action methods advance and rewind the current slide.

> ### Lifecycle Callbacks Explained
> 
> What does the initialize() method do? How is it different from the connect() method we’ve used before?
> 
> These are Stimulus lifecycle callback methods, and they’re useful for setting up or tearing down associated state when your controller enters or leaves the document.
> 
> Method	Invoked by Stimulus…
> initialize()	Once, when the controller is first instantiated
> connect()	Anytime the controller is connected to the DOM
> disconnect()	Anytime the controller is disconnected from the DOM
> Reload the page and confirm that the Next button advances to the next slide.
</details>



## Reading Initial State from the DOM

コントローラが、`this.index`プロパティで、その状態（現在選択されているスライド）をどのように追跡しているかに注目してください。

ここで、スライドショーの1つを最初のスライドではなく2番目のスライドを表示した状態で開始したいとします。 マークアップで開始インデックスを指示するにはどうすればよいでしょうか？

1つの方法は、HTMLデータ属性を利用して初期インデックスを受け渡すことです。 例えば、以下のようにコントローラの要素に`data-index`属性を追加します：

```html
<div data-controller="slideshow" data-index="1">
```

そして、`initialize()`メソッドでその属性を読み込んで整数に変換し、`showCurrentSlide()`から参照できるようにします：

```javascript
initialize() {
  this.index = Number(this.element.dataset.index)
  this.showCurrentSlide()
}
```

これでやりたいことは実現できるかもしれませんが、これではまだ幾分扱いにくく感じます。 インデックスをインクリメントして結果をDOMに永続化することができなかったり、属性名を考えたりする必要があります。

<details>
    <summary>原文</summary/>

Notice how our controller tracks its state—the currently selected slide—in the this.index property.

Now say we’d like to start one of our slideshows with the second slide visible instead of the first. How can we encode the start index in our markup?

One way might be to load the initial index with an HTML data attribute. For example, we could add a data-index attribute to the controller’s element:

```html
<div data-controller="slideshow" data-index="1">
```

Then, in our initialize() method, we could read that attribute, convert it to an integer, and pass it to showCurrentSlide():

```javascript
initialize() {
  this.index = Number(this.element.dataset.index)
  this.showCurrentSlide()
}
```

This might get the job done, but it’s clunky, requires us to make a decision about what to name the attribute, and doesn’t help us if we want to access the index again or increment it and persist the result in the DOM.
</details>


### Valuesを使う

Stimulusコントローラはデータ属性に自動的にマッピングされる型付き値プロパティをサポートしています。 コントローラクラスの先頭に`values`の定義を追加します：

```javascript
static values = { index: Number }
```

Stimulusは、`data-slideshow-index-value`属性に関連付けられた`this.indexValue`プロパティを作成し、数値にキャストした結果にアクセスできるようにしてくれます。

実際に見てみましょう。関連するdata属性をHTMLに追加します：

```html
<div data-controller="slideshow" data-slideshow-index-value="1">
```

次に、コントローラに静的な`values`の定義を追加し、`initialize()`メソッドを変更して`this.indexValu`の値をログにだすようにしてみましょう：

```javascript
export default class extends Controller {
  static values = { index: Number }

  initialize() {
    console.log(this.indexValue)
    console.log(typeof this.indexValue)
  }

  // …
}
```

ページをリロードし、コンソールを確認してみましょう。 `1`と`Number`が表示されているはずです。


<details>
    <summary>原文</summary/>
Stimulus controllers support typed value properties which automatically map to data attributes. When we add a value definition to the top of our controller class:

```javascript
  static values = { index: Number }
```

Stimulus will create a this.indexValue controller property associated with a data-slideshow-index-value attribute, and handle the numeric conversion for us.

Let’s see that in action. Add the associated data attribute to our HTML:

```html
<div data-controller="slideshow" data-slideshow-index-value="1">
```

Then add a static values definition to the controller and change the initialize() method to log this.indexValue:

```javascript
export default class extends Controller {
  static values = { index: Number }

  initialize() {
    console.log(this.indexValue)
    console.log(typeof this.indexValue)
  }

  // …
}
```

Reload the page and verify that the console shows 1 and Number.
</details>

## static valuesの行の意味

ターゲットと同様に、`values`という静的オブジェクトプロパティに値を記述して定義します。 ここでは、`index`という単一の数値を定義しています。 値の定義については、リファレンスを参照してください。

それでは、コントローラの`initialize()`と他のメソッドを修正して、`this.index`の代わりに`this.indexValue`を使用するようにしましょう：

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "slide" ]
  static values = { index: Number }

  initialize() {
    this.showCurrentSlide()
  }

  next() {
    this.indexValue++
    this.showCurrentSlide()
  }

  previous() {
    this.indexValue--
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    this.slideTargets.forEach((element, index) => {
      element.hidden = index !== this.indexValue
    })
  }
}
```

ページをリロードし、Webインスペクタを使って、controller要素の`data-slideshow-index-value`属性が、次のスライドに移るたびに変化することを確認しましょう。


<details>
    <summary>原文</summary/>
Similar to targets, you define values in a Stimulus controller by describing them in a static object property called values. In this case, we’ve defined a single numeric value called index. You can read more about value definitions in the reference documentation.

Now let’s update initialize() and the other methods in the controller to use this.indexValue instead of this.index. Here’s how the controller should look when we’re done:

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "slide" ]
  static values = { index: Number }

  initialize() {
    this.showCurrentSlide()
  }

  next() {
    this.indexValue++
    this.showCurrentSlide()
  }

  previous() {
    this.indexValue--
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    this.slideTargets.forEach((element, index) => {
      element.hidden = index !== this.indexValue
    })
  }
}
```

Reload the page and use the web inspector to confirm the controller element’s data-slideshow-index-value attribute changes as you move from one slide to the next.
</details>

## Change Callbacks

修正したコントローラは元のバージョンより改善されていますが、`this.showCurrentSlide()`を繰り返し呼び出しているのが目立ちます。 コントローラの初期化時と、`this.indexValue`を更新した時にたびたびドキュメントの状態を手動で更新しなければなりません。

Stimulusの`ValueChanged`コールバックを定義することで、繰り返しを一掃し、インデックス値が変更されるたびにコントローラがどのように応答すべきかを指定することができます。

まず、`initialize()`メソッドを削除し、新しいメソッド`indexValueChanged()`を定義します。 次に、`next()`と`previous()`から`this.showCurrentSlide()`の呼び出しを削除します：

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "slide" ]
  static values = { index: Number }

  next() {
    this.indexValue++
  }

  previous() {
    this.indexValue--
  }

  indexValueChanged() {
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    this.slideTargets.forEach((element, index) => {
      element.hidden = index !== this.indexValue
    })
  }
}
```

ページをリロードし、スライドショーの動作が同じであることを確認しましょう。

Stimulusは初期化時および`data-slideshow-index-value`属性の変更に応じて`indexValueChanged()`メソッドを呼び出します。 Webインスペクタで属性をいじれば、コントローラがそれに応答してスライドを変更します。 ぜひ試してみてください！

<details>
    <summary>原文</summary/>
Our revised controller improves on the original version, but the repeated calls to this.showCurrentSlide() stand out. We have to manually update the state of the document when the controller initializes and after every place where we update this.indexValue.

We can define a Stimulus value change callback to clean up the repetition and specify how the controller should respond whenever the index value changes.

First, remove the initialize() method and define a new method, indexValueChanged(). Then remove the calls to this.showCurrentSlide() from next() and previous():

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "slide" ]
  static values = { index: Number }

  next() {
    this.indexValue++
  }

  previous() {
    this.indexValue--
  }

  indexValueChanged() {
    this.showCurrentSlide()
  }

  showCurrentSlide() {
    this.slideTargets.forEach((element, index) => {
      element.hidden = index !== this.indexValue
    })
  }
}
```

Reload the page and confirm the slideshow behavior is the same.

Stimulus calls the indexValueChanged() method at initialization and in response to any change to the data-slideshow-index-value attribute. You can even fiddle with the attribute in the web inspector and the controller will change slides in response. Go ahead—try it out!
</details>

### デフォルト値を指定する

`static values`の行を少し変更すればデフォルト値を設定することも可能です。 デフォルト値の指定は次のように行います：

```javascript
static values = { index: { type: Number, default: 2 } }
```

controller要素に`data-slideshow-index-value`属性が定義されていなければ、インデックスを2から開始します。 他の値があれば、デフォルトが必要なものとそうでないものを混在させることができます：

```javascript
static values = { index: Number, effect: { type: String, default: "kenburns" } }
```

<details>
    <summary>原文</summary/>
It’s also possible to set a default values as part of the static definition. This is done like so:

```javascript
  static values = { index: { type: Number, default: 2 } }
```

That would start the index at 2, if no data-slideshow-index-value attribute was defined on the controller element. If you had other values, you can mix and match what needs a default and what doesn’t:

```javascript
  static values = { index: Number, effect: { type: String, default: "kenburns" } }
```
</details>

## おさらいと次のステップ

この章では、`values`を使用してスライドショーコントローラの現在のインデックス値を読み取り、永続化する方法について見てきました。

ユーザビリティの観点からは、このコントローラは不完全です。最初のスライドを表示している時、Previousボタンは何もしてくれません。 内部的には、`indexValue`は`0`から`-1`まで減少します。 `-1`の代わりに、値を最後のスライドインデックスにして、ループするようにしたいですね(Nextボタンにも同様の問題があります)。

次の章では、Stimulusコントローラで外部リソースにアクセスする方法を見ていきます。


<details>
    <summary>原文</summary/>
In this chapter we’ve seen how to use the values to load and persist the current index of a slideshow controller.

From a usability perspective, our controller is incomplete. The Previous button appears to do nothing when you are looking at the first slide. Internally, indexValue decrements from 0 to -1. Could we make the value wrap around to the last slide index instead? (There’s a similar problem with the Next button.)

Next we’ll look at how to keep track of external resources, such as timers and HTTP requests, in Stimulus controllers.
</details>
