---
title: Actions
description: "アクションはコントローラでDOMイベントを処理する方法です"
order: 2
---

# Actions

アクションは、コントローラでDOM イベントを処理する方法です。

```html
<div data-controller="gallery">
  <button data-action="click->gallery#next">…</button>
</div>
```

```javascript
// controllers/gallery_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  next(event) {
    // …
  }
}
```

アクションは次に示すものをつなぎあわせたものです。

* コントローラのメソッド
* コントロラー要素
* DOMイベントリスナ

<details>
  <summary>原文</summary>

_Actions_ are how you handle DOM events in your controllers.

```html
<div data-controller="gallery">
  <button data-action="click->gallery#next">…</button>
</div>
```

```javascript
// controllers/gallery_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  next(event) {
    // …
  }
}
```

An action is a connection between:

* a controller method
* the controller's element
* a DOM event listener
</details>

## Descriptors

`data-action`属性の値である`click->gallery#next`は _アクション記述子_ と呼ばれます。 この記述子の場合は:

* `click` は購読するDOMイベント名
* `gallery` はコントローラの識別子
* `next` は呼び出すメソッド前

になります。

<details>
  <summary>原文</summary>

The `data-action` value `click->gallery#next` is called an _action descriptor_. In this descriptor:

* `click` is the name of the DOM event to listen for
* `gallery` is the controller identifier
* `next` is the name of the method to invoke
</details>

### イベント省略記法

Stimulusでは要素ごとにデフォルトのイベントが定められています。　デフォルトのイベントを購読する場合はアクション記述子内のイベント名を省略して、記述子全体を短くすることができます。

上記のクリックイベントの購読はボタン要素に設定する場合、次のように記述できます。

```html
<button data-action="gallery#next">…</button>
```

以下の表は要素ごとのデフォルトイベントの一覧を示したものです。

要素              | デフォルトイベント
----------------- | -------------
a                 | click
button            | click
details           | toggle
form              | submit
input             | input
input type=submit | click
select            | change
textarea          | input


<details>
  <summary>原文</summary>

Stimulus lets you shorten the action descriptors for some common element/event pairs, such as the button/click pair above, by omitting the event name:

```html
<button data-action="gallery#next">…</button>
```

The full set of these shorthand pairs is as follows:

Element           | Default Event
----------------- | -------------
a                 | click
button            | click
details           | toggle
form              | submit
input             | input
input type=submit | click
select            | change
textarea          | input
</details>

## キーボードイベントのフィルタ構文

[KeyboardEvent](https://developer.mozilla.org/ja/docs/Web/API/KeyboardEvent)を購読する場合、特定のキーが押された時だけ処理を実行したいということもあると思います。

以下の例のように、アクション記述子のイベント名の後に`.esc`を追加することで、`Escapeキー`にのみ反応するイベントリスナを設置することができます。

```html
<div data-controller="modal"
     data-action="keydown.esc->modal#close" tabindex="0">
</div>
```

このフィルタ構文は、発生したイベントがキーボードイベントである場合にのみ機能します。

以下の表はフィルタとキーの対応の一覧です。

フィルタ  | キー名
--------- | --------
enter     | Enter
tab       | Tab
esc       | Escape
space     | " "
up        | ArrowUp
down      | ArrowDown
left      | ArrowLeft
right     | ArrowRight
home      | Home
end       | End
page_up   | PageUp
page_down | PageDown
[a-z]     | [a-z]
[0-9]     | [0-9]

ここにないキーをサポートする必要がある場合は、カスタムスキーマを使ってフィルタをカスタマイズすることができます。

```javascript
import { Application, defaultSchema } from "@hotwired/stimulus"

const customSchema = {
  ...defaultSchema,
  keyMappings: { ...defaultSchema.keyMappings, at: "@" },
}

const app = Application.start(document.documentElement, customSchema)
```

修飾キーを使った複合的なイベントを購読したい場合は、`ctrl+a`のように書くことができます。

```html
<div data-action="keydown.ctrl+a->listbox#selectAll" role="option" tabindex="0">...</div>
```

以下の表はStimulusがサポートする修飾キーの一覧です。

| 修飾キー | ノート             |
| -------- | ------------------ |
| `alt`    | `option`  (MacOS)  |
| `ctrl`   |                    |
| `meta`   | `Command` (MacOS)  |
| `shift`  |                    |

<details>
  <summary>原文</summary>
There may be cases where [KeyboardEvent](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent) Actions should only call the Controller method when certain keystrokes are used.

You can install an event listener that responds only to the `Escape` key by adding `.esc` to the event name of the action descriptor, as in the following example.

```html
<div data-controller="modal"
     data-action="keydown.esc->modal#close" tabindex="0">
</div>
```

This will only work if the event being fired is a keyboard event.

The correspondence between these filter and keys is shown below.

Filter    | Key Name
--------  | --------
enter     | Enter
tab       | Tab
esc       | Escape
space     | " "
up        | ArrowUp
down      | ArrowDown
left      | ArrowLeft
right     | ArrowRight
home      | Home
end       | End
page_up   | PageUp
page_down | PageDown
[a-z]     | [a-z]
[0-9]     | [0-9]

If you need to support other keys, you can customize the modifiers using a custom schema.

```javascript
import { Application, defaultSchema } from "@hotwired/stimulus"

const customSchema = {
  ...defaultSchema,
  keyMappings: { ...defaultSchema.keyMappings, at: "@" },
}

const app = Application.start(document.documentElement, customSchema)
```

If you want to subscribe to a compound filter using a modifier key, you can write it like `ctrl+a`.

```html
<div data-action="keydown.ctrl+a->listbox#selectAll" role="option" tabindex="0">...</div>
```

The list of supported modifier keys is shown below.

| Modifier | Notes              |
| -------- | ------------------ |
| `alt`    | `option` on MacOS  |
| `ctrl`   |                    |
| `meta`   | Command key on MacOS |
| `shift`  |                    |
</details>

### グローバルイベント

しばしば`window`や`document`オブジェクトで発生するイベントを購読したいことがあります。

次の例のように、アクション記述子のイベント名に（フィルター修飾子があっても良い）`@window`または`@document`を追加すると、それぞれ`window`または`document`にイベントを購読することができます：

```html
<div data-controller="gallery"
     data-action="resize@window->gallery#layout">
</div>
```

<details>
  <summary>原文</summary>

Sometimes a controller needs to listen for events dispatched on the global `window` or `document` objects.

You can append `@window` or `@document` to the event name (along with any filter modifier) in an action descriptor to install the event listener on `window` or `document`, respectively, as in the following example:

```html
<div data-controller="gallery"
     data-action="resize@window->gallery#layout">
</div>
```
</details>

### アクションオプション

[DOMイベントリスナのオプション](https://developer.mozilla.org/ja/docs/Web/API/EventTarget/addEventListener#Parameters)は、アクション記述子に1つ以上のアクションオプションを追加することで指定できます。

```html
<div data-controller="gallery"
     data-action="scroll->gallery#layout:!passive">
  <img data-action="click->gallery#open:capture">
```

Stimulusは次のアクションオプションをサポートしています。

アクションオプション | 対応するDOMイベントリスナのオプション
-------------------- | -----------------------------
`:capture`           | `{ capture: true }`
`:once`              | `{ once: true }`
`:passive`           | `{ passive: true }`
`:!passive`          | `{ passive: false }`

これに加えて、Stimulusではネイティブにサポートされていない以下のアクションオプションをサポートしています：

カスタムアクションオプション | 説明
---------------------------- | -----------
`:stop`                      | `.stopPropagation()` をメソッドの実行前に呼び出す
`:prevent`                   | `.preventDefault()` をメソッドの実行前に呼び出す
`:self`                      | イベントが自身の要素で発生した時のみメソッドを呼び出す

独自のアクションオプションを新規に登録したい場合は、`Application.registerActionOption`メソッドを使用します。

例えば、`<details>`要素が開閉されるたびにディスパッチする`toggleイベント`を、開かれた時だけにフィルタリングするカスタム`:open`アクションオプションを作れば、開かれた時だけにイベントをルーティングするのに役立ちます：

```javascript
import { Application } from "@hotwired/stimulus"

const application = Application.start()

application.registerActionOption("open", ({ event }) => {
  if (event.type == "toggle") {
    return event.target.open == true
  } else {
    return true
  }
})
```

アクションオプションに`!`のプレフィックスをつけた場合、アクションオプションを定義した関数の引数のプロパティ`value`に`false`が渡るため、以下のように変更すれば`:!open`アクションオプションで要素が閉じられる度にイベントをルーティングすることができるようになります。

```javascript
import { Application } from "@hotwired/stimulus"

const application = Application.start()

application.registerActionOption("open", ({ event, value }) => {
  if (event.type == "toggle") {
    return event.target.open == value
  } else {
    return true
  }
})
```

イベントがコントローラアクションにルーティングされないようにするには、`registerActionOption`のコールバック関数は`false`を返す必要があります。 逆に、イベントをコントローラのアクションにルーティングするためには、`true`を返します。

このコールバックは、以下のキーを持つオブジェクト引数を受け取ります：

| キー       | 説明                                                                                                  |
| ---------- | ----------------------------------------------------------------------------------------------------- |
| name       | String: オプション名 (例の場合であれば `"open"`)                                                      |
| value      | Boolean: オプションに`!`がついてるかどうか (`:open` であれば `true`, `:!open` なら `false` になる)    |
| event      | Event: イベントの実体 (後述のアクションパラメータ `params` を含む)                                    |
| element    | Element: アクション記述子を設定した要素                                                               |
| controller | 呼び出されるメソッドを持つコントローラの実体                                                          |

<details>
  <summary>原文</summary>

You can append one or more _action options_ to an action descriptor if you need to specify [DOM event listener options](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener#Parameters).

```html
<div data-controller="gallery"
     data-action="scroll->gallery#layout:!passive">
  <img data-action="click->gallery#open:capture">
```

Stimulus supports the following action options:

Action option | DOM event listener option
------------- | -------------------------
`:capture`    | `{ capture: true }`
`:once`       | `{ once: true }`
`:passive`    | `{ passive: true }`
`:!passive`   | `{ passive: false }`

On top of that, Stimulus also supports the following action options which are not natively supported by the DOM event listener options:

Custom action option | Description
-------------------- | -----------
`:stop`              | calls `.stopPropagation()` on the event before invoking the method
`:prevent`           | calls `.preventDefault()` on the event before invoking the method
`:self`              | only invokes the method if the event was fired by the element itself

You can register your own action options with the `Application.registerActionOption` method.

For example, consider that a `<details>` element will dispatch a [toggle][]
event whenever it's toggled. A custom `:open` action option would help
to route events whenever the element is toggled _open_:

```javascript
import { Application } from "@hotwired/stimulus"

const application = Application.start()

application.registerActionOption("open", ({ event }) => {
  if (event.type == "toggle") {
    return event.target.open == true
  } else {
    return true
  }
})
```

Similarly, a custom `:!open` action option could route events whenever the
element is toggled _closed_. Declaring the action descriptor option with a `!`
prefix will yield a `value` argument set to `false` in the callback:

```javascript
import { Application } from "@hotwired/stimulus"

const application = Application.start()

application.registerActionOption("open", ({ event, value }) => {
  if (event.type == "toggle") {
    return event.target.open == value
  } else {
    return true
  }
})
```

In order to prevent the event from being routed to the controller action, the
`registerActionOption` callback function must return `false`. Otherwise, to
route the event to the controller action, return `true`.

The callback accepts a single object argument with the following keys:

| Name       | Description                                                                                           |
| ---------- | ----------------------------------------------------------------------------------------------------- |
| name       | String: The option's name (`"open"` in the example above)                                             |
| value      | Boolean: The value of the option (`:open` would yield `true`, `:!open` would yield `false`)           |
| event      | [Event][]: The event instance, including with the `params` action parameters on the submitter element |
| element    | [Element]: The element where the action descriptor is declared                                        |
| controller | The `Controller` instance which would receive the method call                                         |

[toggle]: https://developer.mozilla.org/en-US/docs/Web/API/HTMLDetailsElement/toggle_event
[Event]: https://developer.mozilla.org/en-US/docs/web/api/event
[Element]: https://developer.mozilla.org/en-US/docs/Web/API/element
</details>


## イベントオブジェクト

_アクションメソッド_ は、アクションのイベントリスナとなるコントローラ内のメソッドです。

アクションメソッドの最初の引数は _DOMイベントオブジェクト_ です。 イベントにアクセスしたい理由は、次のようなものがあります：

* キーボードイベントからキーコードを読み取る
* マウスイベントの座標を読み取る
* 入力イベントからデータを読み取る
* `submitter`となる要素からパラメータを読み取る
* イベントに対するブラウザのデフォルト動作を阻止する
* どの要素がこのイベントをディスパッチしたかを調べる

以下の基本的なプロパティは、すべてのイベントに共通して存在します：

Eventのプロパティ   | 値
------------------- | -----
event.type          | イベント名 (例. `"click"`)
event.target        | イベントをディスパッチした要素 (つまり、クリックされた最も内側の要素)
event.currentTarget | イベントリスナが設定されてる要素 (`data-action`が設定されてる要素、あるいはグローバルリスナの場合 `document` か `window`)
event.params        | アクションの`submitter`となる要素から渡されるアクションパラメータ

以下のイベントの持つメソッドを使えば、イベントの処理方法を細かく制御できます：

Eventのメソッド         | 結果
----------------------- | ------
event.preventDefault()  | イベントのデフォルトの挙動をキャンセルする (例えばリンク先への遷移やフォームの送信など)
event.stopPropagation() | 親要素へのイベントの伝播をストップさせる

<details>
  <summary>原文</summary>

An _action method_ is the method in a controller which serves as an action's event listener.

The first argument to an action method is the DOM _event object_. You may want access to the event for a number of reasons, including:

* to read the key code from a keyboard event
* to read the coordinates of a mouse event
* to read data from an input event
* to read params from the action submitter element
* to prevent the browser's default behavior for an event
* to find out which element dispatched an event before it bubbled up to this action

The following basic properties are common to all events:

Event Property      | Value
------------------- | -----
event.type          | The name of the event (e.g. `"click"`)
event.target        | The target that dispatched the event (i.e. the innermost element that was clicked)
event.currentTarget | The target on which the event listener is installed (either the element with the `data-action` attribute, or `document` or `window`)
event.params        | The action params passed by the action submitter element

<br>The following event methods give you more control over how events are handled:

Event Method            | Result
----------------------- | ------
event.preventDefault()  | Cancels the event's default behavior (e.g. following a link or submitting a form)
event.stopPropagation() | Stops the event before it bubbles up to other listeners on parent elements
</details>


## マルチアクション

`data-action`属性の値は、スペースで区切られたアクション記述子のリストです。

任意の要素が複数のアクションを持つことはよくあります。 たとえば、次のinput要素は、フォーカスが当たった時に`field`コントローラの`highlight()` メソッドを呼び出し、要素の値が変わるたびに`search`コントローラの`update()`メソッドを呼び出します：

```html
<input type="text" data-action="focus->field#highlight input->search#update">
```

要素が同じイベントに対して複数のアクションを持つ場合、Stimulusは左から右へ、それらの記述子に記載示されている順にアクションを呼び出します。

アクションの呼び出しチェーンは、アクション内で`Event#stopImmediatePropagation()`を呼び出すことで、任意の時点で停止させることができます。 その場合、呼び出された関数より右側に追加されたアクションは無視されます：

```javascript
highlight: function(event) {
  event.stopImmediatePropagation()
  // ...
}
```

<details>
  <summary>原文</summary>

The `data-action` attribute's value is a space-separated list of action descriptors.

It's common for any given element to have many actions. For example, the following input element calls a `field` controller's `highlight()` method when it gains focus, and a `search` controller's `update()` method every time the element's value changes:

```html
<input type="text" data-action="focus->field#highlight input->search#update">
```

When an element has more than one action for the same event, Stimulus invokes the actions from left to right in the order that their descriptors appear.

The action chain can be stopped at any point by calling `Event#stopImmediatePropagation()` within an action. Any additional actions to the right will be ignored:

```javascript
highlight: function(event) {
  event.stopImmediatePropagation()
  // ...
}
```
</details>

## 命名規則

アクション名は、コントローラのメソッドに直接対応するので、常にキャメルケースで指定します。

`click`や`onClick`、`handleClick`のように、単にイベント名を繰り返しただけのアクション名は避けましょう：

```html
<button data-action="click->profile#click">Don't</button>
```

代わりに、呼び出された時に何が起こるかに基づいてアクションメソッドに名前をつけましょう：

```html
<button data-action="click->profile#showDialog">Do</button>
```

これによって、コントローラのソースを見ることなく、要素の持つ振る舞いが予測できるようになります。

<details>
  <summary>原文</summary>

Always use camelCase to specify action names, since they map directly to methods on your controller.

Avoid action names that simply repeat the event's name, such as `click`, `onClick`, or `handleClick`:

```html
<button data-action="click->profile#click">Don't</button>
```

Instead, name your action methods based on what will happen when they're called:

```html
<button data-action="click->profile#showDialog">Do</button>
```

This will help you reason about the behavior of a block of HTML without having to look at the controller source.
</details>


## アクションパラメータ

アクションは`submitter`要素から渡されるパラメータを受け取ることができます。 パラメータは`data-[識別子]-[パラメータ名]-param`の書式で記述します。 パラメータは、渡したい先のアクションが宣言されている要素に指定する必要があります。

すべてのパラメータは、その値から推測される`Number`、`String`、`Object`、`Boolean`のいずれかに自動的に型変換されます：

data属性                                        | パラメータ           | 型
----------------------------------------------- | -------------------- | --------
`data-item-id-param="12345"`                    | `12345`              | Number
`data-item-url-param="/votes"`                  | `"/votes"`           | String
`data-item-payload-param='{"value":"1234567"}'` | `{ value: 1234567 }` | Object
`data-item-active-param="true"`                 | `true`               | Boolean


<br>以下の設定について考えてみよう：

```html
<div data-controller="item spinner">
  <button data-action="item#upvote spinner#start"
    data-item-id-param="12345"
    data-item-url-param="/votes"
    data-item-payload-param='{"value":"1234567"}'
    data-item-active-param="true">…</button>
</div>
```

この時、`ItemController#upvote`と`SpinnerController#start`の両方が呼び出されますが、識別子が`item`なのでパラメータが渡されるのは前者だけです：

```javascript
// ItemController
upvote(event) {
  // { id: 12345, url: "/votes", active: true, payload: { value: 1234567 } }
  console.log(event.params)
}

// SpinnerController
start(event) {
  // {}
  console.log(event.params)
}
```

イベントオブジェクトの持つプロパティのうち、paramsの他に何も必要なければ、以下のように分解してparamsだけを受け取ることもできます：

```javascript
upvote({ params }) {
  // { id: 12345, url: "/votes", active: true, payload: { value: 1234567 } }
  console.log(params) 
}
```

Or destruct only the params we need, in case multiple actions on the same controller share the same submitter element:
または、同じコントローラの複数のアクションが同じ`submitter`要素を共有しており、一方には不必要であるパラメータが混在している場合、必要なパラメータのみに分解して受け取ることもできます：

```javascript
upvote({ params: { id, url } }) {
  console.log(id) // 12345
  console.log(url) // "/votes"
}
```

<details>
  <summary>原文</summary>

Actions can have parameters that are be passed from the submitter element. They follow the format of `data-[identifier]-[param-name]-param`. Parameters must be specified on the same element as the action they intend to be passed to is declared.

All parameters are automatically typecast to either a `Number`, `String`, `Object`, or `Boolean`, inferred by their value:

Data attribute                                  | Param                | Type
----------------------------------------------- | -------------------- | --------
`data-item-id-param="12345"`                    | `12345`              | Number
`data-item-url-param="/votes"`                  | `"/votes"`           | String
`data-item-payload-param='{"value":"1234567"}'` | `{ value: 1234567 }` | Object
`data-item-active-param="true"`                 | `true`               | Boolean


<br>Consider this setup:

```html
<div data-controller="item spinner">
  <button data-action="item#upvote spinner#start" 
    data-item-id-param="12345" 
    data-item-url-param="/votes"
    data-item-payload-param='{"value":"1234567"}' 
    data-item-active-param="true">…</button>
</div>
```

It will call both `ItemController#upvote` and `SpinnerController#start`, but only the former will have any parameters passed to it:

```javascript
// ItemController
upvote(event) {
  // { id: 12345, url: "/votes", active: true, payload: { value: 1234567 } }
  console.log(event.params) 
}

// SpinnerController
start(event) {
  // {}
  console.log(event.params) 
}
```

If we don't need anything else from the event, we can destruct the params:

```javascript
upvote({ params }) {
  // { id: 12345, url: "/votes", active: true, payload: { value: 1234567 } }
  console.log(params) 
}
```

Or destruct only the params we need, in case multiple actions on the same controller share the same submitter element:

```javascript
upvote({ params: { id, url } }) {
  console.log(id) // 12345
  console.log(url) // "/votes"
}
```
</details>
