---
title: Controllers
description: "コントローラはStimulusアプリケーションの基本的な構成単位です"
order: 0
---

# Controllers

コントローラは、Stimulusアプリケーションの基本的な構成単位です。

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // …
}
```

コントローラーは、アプリケーションで定義するJavaScriptクラスのインスタンスです。 各コントローラクラスは、`@hotwired/stimulus`モジュールによってエクスポートされた`Controller`基底クラスを継承します。

<details>
  <summary>原文</summary>

A controller is the basic organizational unit of a Stimulus application.

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // …
}
```

Controllers are instances of JavaScript classes that you define in your application. Each controller class inherits from the Controller base class exported by the @hotwired/stimulus module.
</details>

## プロパティ

すべてのコントローラーはStimulus Applicationインスタンスに属し、HTML要素に関連付けられます。 コントローラクラス内では...

* `this.application`プロパティで`application`に
* `this.element`プロパティでコントローラを設定したHTML要素に
* `this.identifier`プロパティでコントローラ名に

それぞれアクセスすることができます。

<details>
  <summary>原文</summary>

Every controller belongs to a Stimulus Application instance and is associated with an HTML element. Within a controller class, you can access the controller’s:

* application, via the this.application property
* HTML element, via the this.element property
* identifier, via the this.identifier property
</details>

## モジュール

コントローラクラスは1ファイルに1つずつJavaScriptモジュール形式で定義します。 前述の例のように、各コントローラクラスをモジュールのデフォルトオブジェクトとしてエクスポートします。

これらのモジュールを`controllers/`ディレクトリに置きます。 ファイル名は`[識別子]_controller.js`とし、`[識別子]`には各コントローラの識別子が入ります。

<details>
  <summary>原文</summary>

Define your controller classes in JavaScript modules, one per file. Export each controller class as the module’s default object, as in the example above.

Place these modules in the controllers/ directory. Name the files [identifier]_controller.js, where [identifier] corresponds to each controller’s identifier.
</details>

## コントローラ識別子

`識別子`は、HTMLでコントローラークラスを参照するために使用する名前です。

要素に`data-controller`属性を追加すると、Stimulusは属性の値から識別子を読み取り、対応するコントローラークラスの新しいインスタンスを作成します。

たとえば、下記の要素には、`controllers/reference_controller.js` で定義されているコントローラクラスのインスタンスが割り当てられます。

```html
<div data-controller="reference"></div>
```

以下に、Stimulusが識別子に対応するコントローラファイルを特定する時の対応関係を示します。

| コントローラーファイルの名前 | 対応するコントローラ名 |
|---|---|
| clipboard_controller.js | clipboard |
| date_picker_controller.js | date-picker |
| users/list_item_controller.js | users--list-item |
| local-time-controller.js| local-time |


<details>
  <summary>原文</summary>
An identifier is the name you use to reference a controller class in HTML.

When you add a data-controller attribute to an element, Stimulus reads the identifier from the attribute’s value and creates a new instance of the corresponding controller class.

For example, this element has a controller which is an instance of the class defined in controllers/reference_controller.js:

```html
<div data-controller="reference"></div>
```

The following is an example of how Stimulus will generate identifiers for controllers in its require context:

| If your controller file is named…| its identifier will be… |
|---|---|
| clipboard_controller.js | clipboard |
| date_picker_controller.js | date-picker |
| users/list_item_controller.js | users--list-item |
| local-time-controller.js| local-time |
</details>

## スコープ

Stimulus がコントローラを要素に接続すると、その要素とすべての子孫要素がコントローラのスコープになります。

例えば、次のHTMLの`<div>`と`<h1>`はコントローラのスコープに含まれますが、その外側の`<main>`要素はスコープに含まれません。

```html
<main>
  <div data-controller="reference">
    <h1>Reference</h1>
  </div>
</main>
```

<details>
  <summary>原文</summary>

When Stimulus connects a controller to an element, that element and all of its children make up the controller’s scope.

For example, the `<div>` and `<h1>` below are part of the controller’s scope, but the surrounding `<main>` element is not.

```html
<main>
  <div data-controller="reference">
    <h1>Reference</h1>
  </div>
</main>
```
</details>

## ネスト時のスコープ

コントローラがネストしている場合、各コントローラは、内側のコントローラのスコープを除いた自分自身のスコープのみを認識します。

たとえば、以下の`#parent`に設定された`list`コントローラは、そのスコープ内にあるアイテムのターゲットのみを認識し、`#child`に設定された`list`コントローラのターゲットは自身のターゲットとは認識しません。

```html
<ul id="parent" data-controller="list">
  <li data-list-target="item">One</li>
  <li data-list-target="item">Two</li>
  <li>
    <ul id="child" data-controller="list">
      <li data-list-target="item">I am</li>
      <li data-list-target="item">a nested list</li>
    </ul>
  </li>
</ul>
```

<details>
  <summary>原文</summary>
When nested, each controller is only aware of its own scope excluding the scope of any controllers nested within.

For example, the #parent controller below is only aware of the item targets directly within its scope, but not any targets of the #child controller.

```html
<ul id="parent" data-controller="list">
  <li data-list-target="item">One</li>
  <li data-list-target="item">Two</li>
  <li>
    <ul id="child" data-controller="list">
      <li data-list-target="item">I am</li>
      <li data-list-target="item">a nested list</li>
    </ul>
  </li>
</ul>
```
</details>

## マルチコントローラ

`data-controller`属性の値は、スペースで区切られた識別子のリストです：

```html
<div data-controller="clipboard list-item"></div>
```

ページ上の要素に複数のコントローラが設定されるのはよくあることです。 上の例では、`<div>`には`clipboard`と`list-item`という2つのコントローラが設定されています。

同様に、ページ上の複数の要素に同じコントローラが適用されることもよくあります：

```html
<ul>
  <li data-controller="list-item">One</li>
  <li data-controller="list-item">Two</li>
  <li data-controller="list-item">Three</li>
</ul>
```

ここでは、それぞれの`<li>`ごとに`list-item`コントローラのインスタンスが生成されます。

<details>
  <summary>原文</summary>

The data-controller attribute’s value is a space-separated list of identifiers:

```html
<div data-controller="clipboard list-item"></div>
```

It’s common for any given element on the page to have many controllers. In the example above, the `<div>` has two connected controllers, clipboard and list-item.

Similarly, it’s common for multiple elements on the page to reference the same controller class:

```html
<ul>
  <li data-controller="list-item">One</li>
  <li data-controller="list-item">Two</li>
  <li data-controller="list-item">Three</li>
</ul>
```

Here, each `<li>` has its own instance of the list-item controller.
</details>

## 命名規則

コントローラクラスのメソッド名やプロパティ名には、常にキャメルケースを使用します。

識別子が複数の単語から構成される場合は、単語をケバブケースで記述します (つまり、次のようにダッシュを使用します: `date-picker`, `list-item`)。

ファイル名は、複数の単語をアンダースコアまたはダッシュで区切ります（snake_caseまたはkebab-case：`controllers/date_picker_controller.js`、`controllers/list-item-controller.js`）。

<details>
  <summary>原文</summary>

Always use camelCase for method and property names in a controller class.

When an identifier is composed of more than one word, write the words in kebab-case (i.e., by using dashes: date-picker, list-item).

In filenames, separate multiple words using either underscores or dashes (snake_case or kebab-case: controllers/date_picker_controller.js, controllers/list-item-controller.js).
</details>

## コントローラの登録

Stimulus for Railsをimport-maps と一緒に使うか、Webpackで`@hotwired/stimulus-webpack-helpers`パッケージを使うと、アプリケーションは自動的に上記の規約に従ってコントローラクラスをロードして登録します。

もしそれらを使わない場合、各コントローラクラスを手動で読み込んで登録する必要があります。

<details>
  <summary>原文</summary>
If you use Stimulus for Rails with an import map or Webpack together with the @hotwired/stimulus-webpack-helpers package, your application will automatically load and register controller classes following the conventions above.

If not, your application must manually load and register each controller class.
</details>

### コントローラの手動登録

コントローラクラスを手動で登録するには、まずクラスをインポートし、`application`オブジェクトの`register`メソッドを呼び出します：

```javascript
import ReferenceController from "./controllers/reference_controller"

application.register("reference", ReferenceController)
```

モジュールとしてインポートする代わりに、インラインでコントローラクラスを登録することもできます：

```javascript
import { Controller } from "@hotwired/stimulus"

application.register("reference", class extends Controller {
  // …
})
```

<details>
  <summary>原文</summary>
To manually register a controller class with an identifier, first import the class, then call the Application#register method on your application object:

```javascript
import ReferenceController from "./controllers/reference_controller"

application.register("reference", ReferenceController)
```

You can also register a controller class inline instead of importing it from a module:

```javascript
import { Controller } from "@hotwired/stimulus"

application.register("reference", class extends Controller {
  // …
})
```
</details>

### 環境要因に基づくコントローラの登録キャンセル

特定の環境要因 (たとえば指定したユーザーエージェントなど) が満たされた場合にのみコントローラを登録したい場合は、 `shouldLoad`(静的)ゲッターを上書きすることで可能です：

```javascript
class UnloadableController extends ApplicationController {
  static get shouldLoad() {
    return false
  }
}

// This controller will not be loaded
application.register("unloadable", UnloadableController)
```

<details>
  <summary>原文</summary>

If you only want a controller registered and loaded if certain environmental factors are met – such a given user agent – you can overwrite the static shouldLoad method:

```javascript
class UnloadableController extends ApplicationController {
  static get shouldLoad() {
    return false
  }
}

// This controller will not be loaded
application.register("unloadable", UnloadableController)
```
</details>

### コントローラ登録時に発火するコールバック

コントローラが登録された直後に何らかの動作をさせたい場合は、`afterLoad`(静的)メソッドを追加します：

```javascript
class SpinnerButton extends Controller {
  static legacySelector = ".legacy-spinner-button"

  static afterLoad(identifier, application) {
    // アプリケーションインスタンスにアクセスして、'data-controller' に当たる属性名を読み込む。
    const { controllerAttribute } = application.schema

    // レガシーボタンに本コントローラがアタッチされるように属性をセットする
    const updateLegacySpinners = () => {
      document.querySelector(this.legacySelector).forEach((element) => {
        element.setAttribute(controllerAttribute, identifier)
      })
    }

    // このafterLoadメソッドはこのとローラが登録されるとすぐに呼び出されるので、
    // DOMはまだロードされていないかもしれないのでそこをケアする
    if (document.readyState == "loading") {
      document.addEventListener("DOMContentLoaded", updateLegacySpinners)
    } else {
      updateLegacySpinners()
    }
  }
}

// このコントローラは、従来のスピナーボタンを変更し、本コントローラを適用させます。
application.register("spinner-button", SpinnerButton)
```

`afterLoad`メソッドはコントローラが登録されるとすぐに呼び出されます。 この関数には、2つの引数（コントローラの登録時に指定された識別子と登録先の`Application`のインスタンス）が渡ります。 実行時のコンテキストは元のコントローラクラスです。

<details>
  <summary>原文</summary>

If you want to trigger some behaviour once a controller has been registered you can add a static afterLoad method:

```javascript
class SpinnerButton extends Controller {
  static legacySelector = ".legacy-spinner-button"

  static afterLoad(identifier, application) {
    // use the application instance to read the configured 'data-controller' attribute
    const { controllerAttribute } = application.schema

    // update any legacy buttons with the controller's registered identifier
    const updateLegacySpinners = () => {
      document.querySelector(this.legacySelector).forEach((element) => {
        element.setAttribute(controllerAttribute, identifier)
      })
    }

    // called as soon as registered so DOM may not have loaded yet
    if (document.readyState == "loading") {
      document.addEventListener("DOMContentLoaded", updateLegacySpinners)
    } else {
      updateLegacySpinners()
    }
  }
}

// This controller will update any legacy spinner buttons to use the controller
application.register("spinner-button", SpinnerButton)
```

The afterLoad method will get called as soon as the controller has been registered, even if no controlled elements exist in the DOM. The function will be called bound to the original controller constructor along with two arguments; the identifier that was used when registering the controller and the Stimulus application instance.

</details>

## イベントを使ったコントローラ間の連携

コントローラ間で連携を行う必要がある場合はイベントを使用します。 コントローラクラスにはカスタムイベントを発生させるための`dispatch`という便利なメソッドが用意されています。 このメソッドは`eventName`を第1引数にとりますが、実際のイベント名は、プレフィックスとして自動的にコントローラの識別子をコロンで区切りで挿入したものになります。 ペイロードは`detail`に保持することができます。 これは次のように動作します：

```javascript
class ClipboardController extends Controller {
  static targets = [ "source" ]

  copy() {
    this.dispatch("copy", { detail: { content: this.sourceTarget.value } })
    navigator.clipboard.writeText(this.sourceTarget.value)
  }
}
```

このイベントは、次のようにして別のコントローラーのアクションにルーティングできます。

```html
<div data-controller="clipboard effects" data-action="clipboard:copy->effects#flash">
  PIN: <input data-clipboard-target="source" type="text" value="1234" readonly>
  <button data-action="clipboard#copy">クリップボードにコピー</button>
</div>
```

この指定により`Clipboard#copy`アクションが呼び出されると、`Effects#flash`アクションも呼び出されるようになります。

```javascript
class EffectsController extends Controller {
  flash({ detail: { content } }) {
    console.log(content) // 1234
  }
}
```

2つのコントローラが同じHTML要素に属していない場合は、イベント購読側のコントローラの要素に`data-action`属性を追加する必要があります。 また、購読側コントローラの要素がイベント発行側コントローラの要素の親 (または同じ) でない場合は、イベント名の後に`@window`を追加する必要があります。

```html
<div data-action="clipboard:copy@window->effects#flash">
```

`dispatch`は、第2引数として以下のような追加オプションを受け付ける：

| option | デフォルト値 | ノート |
|---|---|---|
| `detail` | `{}` (空オブジェクト) | [CustomEvent.detail](https://developer.mozilla.org/ja/docs/Web/API/CustomEvent/detail)を参照 |
| `target` | `this.element` | [See Event.target](https://developer.mozilla.org/ja/docs/Web/API/Event/target)を参照 |
| `prefix` | `this.identifier` | プレフィックスがfalseyの場合（`null`や`false`など）は`eventName`がそのまま使用される。文字列を指定した場合は、`eventName`の前に指定した文字列とコロンが付加されます。 |
| `bubbles` | `true` | [Event.bubbles](https://developer.mozilla.org/ja/docs/Web/API/Event/bubbles)を参照 |
| `cancelable` | `true` | [Event.cancelable](https://developer.mozilla.org/ja/docs/Web/API/Event/cancelable)を参照 |

`dispatch`は生成された`CustomEvent`を返すので、これを使って以下のように他のリスナからイベントをキャンセルさせることができます：

```javascript
class ClipboardController extends Controller {
  static targets = [ "source" ]

  copy() {
    const event = this.dispatch("copy", { cancelable: true })
    if (event.defaultPrevented) return
    navigator.clipboard.writeText(this.sourceTarget.value)
  }
}
```

```javascript
class EffectsController extends Controller {
  flash(event) {
    // ディスパッチされたイベントによって引き起こされるデフォルトの振る舞いを防ぎます
    event.preventDefault()
  }
}
```

<details>
  <summary>原文</summary>

If you need controllers to communicate with each other, you should use events. The Controller class has a convenience method called dispatch that makes this easier. It takes an eventName as the first argument, which is then automatically prefixed with the name of the controller separated by a colon. The payload is held in detail. It works like this:

```javascript
class ClipboardController extends Controller {
  static targets = [ "source" ]

  copy() {
    this.dispatch("copy", { detail: { content: this.sourceTarget.value } })
    navigator.clipboard.writeText(this.sourceTarget.value)
  }
}
```

And this event can then be routed to an action on another controller:

```html
<div data-controller="clipboard effects" data-action="clipboard:copy->effects#flash">
  PIN: <input data-clipboard-target="source" type="text" value="1234" readonly>
  <button data-action="clipboard#copy">Copy to Clipboard</button>
</div>
```

So when the Clipboard#copy action is invoked, the Effects#flash action will be too:

```javascript
class EffectsController extends Controller {
  flash({ detail: { content } }) {
    console.log(content) // 1234
  }
}
```

If the two controllers don’t belong to the same HTML element, the data-action attribute needs to be added to the receiving controller’s element. And if the receiving controller’s element is not a parent (or same) of the emitting controller’s element, you need to add @window to the event:

```html
<div data-action="clipboard:copy@window->effects#flash">
```

dispatch accepts additional options as the second parameter as follows:

| option | default | notes |
|---|---|
| detail | {} empty object | See CustomEvent.detail |
| target | this.element | See Event.target |
| prefix | this.identifier | If the prefix is falsey (e.g. null or false), only the eventName will be used. If you provide a string value the eventName will be prepended with the provided string and a colon. |
| bubbles | true | See Event.bubbles |
| cancelable | true | See Event.cancelable |

dispatch will return the generated CustomEvent, you can use this to provide a way for the event to be cancelled by any other listeners as follows:

```javascript
class ClipboardController extends Controller {
  static targets = [ "source" ]

  copy() {
    const event = this.dispatch("copy", { cancelable: true })
    if (event.defaultPrevented) return
    navigator.clipboard.writeText(this.sourceTarget.value)
  }
}
```

```javascript
class EffectsController extends Controller {
  flash(event) {
    // this will prevent the default behaviour as determined by the dispatched event
    event.preventDefault()
  }
}
```
</details>

## コントローラから別のコントローラを直接呼び出す

何らかの理由でコントローラ間の通信にイベントを使用できない場合は、`application`オブジェクトの`getControllerForElementAndIdentifier`メソッドを使うことができます。 これは、イベントを使用する一般的な方法では解決できないような特殊な問題がある場合にのみ使用すべきです：

```javascript
class MyController extends Controller {
  static targets = [ "other" ]

  copy() {
    const otherController = this.application.getControllerForElementAndIdentifier(this.otherTarget, 'other')
    otherController.otherMethod()
  }
}
```

<details>
  <summary>原文</summary>
If for some reason it is not possible to use events to communicate between controllers, you can reach a controller instance via the getControllerForElementAndIdentifier method from the application. This should only be used if you have a unique problem that cannot be solved through the more general way of using events, but if you must, this is how:

```javascript
class MyController extends Controller {
  static targets = [ "other" ]

  copy() {
    const otherController = this.application.getControllerForElementAndIdentifier(this.otherTarget, 'other')
    otherController.otherMethod()
  }
}
```
</details>
