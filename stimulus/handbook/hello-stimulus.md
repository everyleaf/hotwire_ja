---
title: "Hello, Stimulus"
description: "簡単なコントローラを作ってみましょう。"
order: 2
---

# Hello, Stimulus

Stimulus がどのように機能するかを学ぶ最良の方法は、簡単なコントローラを作ることです。この章ではその方法を紹介します。

<details>
    <summary>原文</summary>
The best way to learn how Stimulus works is to build a simple controller. This chapter will show you how.
</details>

## 前提条件

手順を進めていくために<a href="https://github.com/hotwired/stimulus-starter" target="_blank">Stimulus-starter</a>プロジェクトのコピーを用意してください。こは、Stimulus を使うためにあらかじめ設定された白紙のアプリケーションです。

おすすめのやり方は<a href="https://glitch.com/edit/#!/import/git?url=https://github.com/hotwired/stimulus-starter.git">Glitch上でstimulus-starterを編集する</a>ことです。 何もインストールせずにブラウザ上で作業することができます。

<a href="https://glitch.com/edit/#!/import/git?url=https://github.com/hotwired/stimulus-starter.git"><img src="https://cdn.glitch.com/2703baf2-b643-4da7-ab91-7ee2a2d00b5b%2Fremix-button.svg" alt="Remix on Glitch"></a>

Glitchではなくテキストエディタで快適に作業したい場合は、<a href="https://github.com/hotwired/stimulus-starter" target="_blank">Stimulus-starter</a>を手元にcloneしてセットアップする必要があります：

```sh
$ git clone https://github.com/hotwired/stimulus-starter.git
$ cd stimulus-starter
$ yarn install
$ yarn start
```

その後、ブラウザで http://localhost:9000/ にアクセスしてみてください

(`stimulus-starter`プロジェクトは依存関係の管理にYarnパッケージ・マネージャーを使用しているので、最初にYarnパッケージ・マネージャーがインストールされていることを確認してください)

<details>
    <summary>原文</summary>
Prerequisites
To follow along, you’ll need a running copy of the stimulus-starter project, which is a preconfigured blank slate for exploring Stimulus.

We recommend remixing stimulus-starter on Glitch so you can work entirely in your browser without installing anything:

Remix on Glitch

Or, if you’d prefer to work from the comfort of your own text editor, you’ll need to clone and set up stimulus-starter:

```sh
$ git clone https://github.com/hotwired/stimulus-starter.git
$ cd stimulus-starter
$ yarn install
$ yarn start
```

Then visit http://localhost:9000/ in your browser.

(Note that the stimulus-starter project uses the Yarn package manager for dependency management, so make sure you have that installed first.)
</details>



## すべての始まりはHTMLから

テキストフィールドとボタンを使った簡単な練習から始めましょう。ボタンをクリックすると、コンソールにテキストフィールドの値が表示されます。

すべてのStimulusプロジェクトはHTMLから始まります。public/index.htmlを開き、冒頭の<body>タグの直後に以下のマークアップを追加します：

```html
<div>
  <input type="text">
  <button>Greet</button>
</div>
```

ブラウザでページをリロードすると、テキストフィールドとボタンが表示されるはずです。

<details>
    <summary>原文</summary>
Let’s begin with a simple exercise using a text field and a button. When you click the button, we’ll display the value of the text field in the console.

Every Stimulus project starts with HTML. Open public/index.html and add the following markup just after the opening <body> tag:

```html
<div>
  <input type="text">
  <button>Greet</button>
</div>
```

Reload the page in your browser and you should see the text field and button.

</details>

## コントローラーでHTMLに命を吹き込む

Stimulusの最も重要なポイントはDOM 要素をJavaScript オブジェクトに自動的に接続することです。 これらのオブジェクトはコントローラと呼ばれます。

フレームワークの組み込みコントローラクラスを継承して、最初のコントローラを作成しましょう。src/controllers/ フォルダに hello_controller.js という名前の新しいファイルを作成します。そして、その中に以下のコードを記述します：

```javascript
// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
}
```

<details>
    <summary>原文</summary>
At its core, Stimulus’s purpose is to automatically connect DOM elements to JavaScript objects. Those objects are called controllers.

Let’s create our first controller by extending the framework’s built-in Controller class. Create a new file named hello_controller.js in the src/controllers/ folder. Then place the following code inside:

```javascript
// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
}
```
</details>


## コントローラとDOMをつなぐ識別子(identifier)

次に、このコントローラをどのようにHTMLに接続するかをStimulusに伝える必要があります。これを行うには、`<div>`の`data-controller`属性に識別子を記述します：

```html
<div data-controller="hello">
  <input type="text">
  <button>Greet</button>
</div>
```

識別子は要素とコントローラの間のリンクの役割を果たします。 この場合、識別子`hello`はStimulusにコントローラクラスのインスタンスを`hello_controller.js`に作成するよう指示します。 コントローラの自動ロードの仕組みについては、<a href="/stimulus/handbook/installing/">インストールガイド</a>を参照してください。

<details>
    <summary>原文</summary>
Next, we need to tell Stimulus how this controller should be connected to our HTML. We do this by placing an identifier in the data-controller attribute on our `div`:

```html
<div data-controller="hello">
  <input type="text">
  <button>Greet</button>
</div>
```

Identifiers serve as the link between elements and controllers. In this case, the identifier hello tells Stimulus to create an instance of the controller class in hello_controller.js. You can learn more about how automatic controller loading works in the Installation Guide.
</details>

## これでうまくいっているのか？

ブラウザでページをリロードすると何も変わっていないことがわかります。 コントローラーが動作しているかどうかを知るにはどうすればいいのでしょうか？

一つの方法は、コントローラがドキュメントに接続されるたびにStimulusが呼び出す`connect()` メソッドに`console.log`を記述することです。

`hello_controller.js`の`connect()`メソッドを次のように実装します：

```javascript
// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Hello, Stimulus!", this.element)
  }
}
```

ページを再度読み込み、開発者コンソールを開いてください。「Hello, Stimulus！」と表示され、その後に `<div>` が表示されるはずです。

<details>
    <summary>原文</summary>
Reload the page in your browser and you’ll see that nothing has changed. How do we know whether our controller is working or not?

One way is to put a log statement in the connect() method, which Stimulus calls each time a controller is connected to the document.

Implement the connect() method in hello_controller.js as follows:

```javascript
// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Hello, Stimulus!", this.element)
  }
}
```

Reload the page again and open the developer console. You should see Hello, Stimulus! followed by a representation of our `div`.
</details>

## ActionはDOMイベントに反応する

それでは、「Greet」ボタンをクリックしたときにログが表示されるようにコードを変更する方法を見てみましょう。

まず、`connect()`の名前を`greete()`に変更します：

```javascript
// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  greet() {
    console.log("Hello, Stimulus!", this.element)
  }
}
```

ボタンのクリックイベントが発生したときに`greet()` メソッドを呼び出したい。Stimulus では、イベントを処理するコントローラのメソッドをアクションメソッドと呼びます。

アクションメソッドをボタンのクリックイベントに接続するには、public/index.htmlを開き、ボタンに`data-action`属性を追加します：

```html
<div data-controller="hello">
  <input type="text">
  <button data-action="click->hello#greet">Greet</button>
</div>
```

> ### アクションの記述子について
>
> `data-action`属性の値である`click->hello#greet`はアクション記述子と呼びます。 この記述子は以下を表しています：
>
> * `click` はイベント名である
> * `hello` はコントローラの識別子である
> * `greet` は呼び出すアクションメソッドの名前である

ブラウザでページを読み込み、開発者コンソールを開いてください。Greet」ボタンをクリックすると、ログメッセージが表示されるはずです。

<details>
    <summary>原文</summary>
Now let’s see how to change the code so our log message appears when we click the “Greet” button instead.

Start by renaming connect() to greet():

```javascript
// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  greet() {
    console.log("Hello, Stimulus!", this.element)
  }
}
```

We want to call the greet() method when the button’s click event is triggered. In Stimulus, controller methods which handle events are called action methods.

To connect our action method to the button’s click event, open public/index.html and add a data-action attribute to the button:

```html
<div data-controller="hello">
  <input type="text">
  <button data-action="click->hello#greet">Greet</button>
</div>
```

> ﹟Action Descriptors Explained
>
> The data-action value click->hello#greet is called an action descriptor. This particular descriptor says:
>
> * click is the event name
> * hello is the controller identifier
> * greet is the name of the method to invoke

Load the page in your browser and open the developer console. You should see the log message appear when you click the “Greet” button.
</details>

## Targetsは重要な要素をコントローラのプロパティにマッピングする

テキストフィールドに入力した名前を使って「Hello, {名前}」と出力されるようにアクションを変更して、練習を終了します。

まずコントローラ内でinput要素を参照する必要があります。そして、`value`プロパティを読み込んでその内容を取得します。

Stimulusでは、重要な要素をターゲットとしてマークすることができるので、対応するプロパティを通してコントローラ内で簡単に参照することができます。`public/index.html`を開き、input 要素に`data-hello-target`属性を追加します：

```html
<div data-controller="hello">
  <input data-hello-target="name" type="text">
  <button data-action="click->hello#greet">Greet</button>
</div>
```

次に、コントローラのターゲット定義のリストに`name`を追加して、ターゲットのプロパティを作成します。 Stimulus は自動的に`this.nameTarget`プロパティを作成し、最初にマッチしたターゲット要素を返します。このプロパティを使用して要素の値を読み取り、挨拶文の文字列を作成します。

やってみましょう。 `hello_controller.js`を開き、次のように更新します：

```javascript
// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "name" ]

  greet() {
    const element = this.nameTarget
    const name = element.value
    console.log(`Hello, ${name}!`)
  }
}
```

次にブラウザでページをリロードし、開発者コンソールを開きます。 入力フィールドにあなたの名前を入力し、「Greet」ボタンをクリックしてください。 Hello world！

<details>
    <summary>原文</summary>

We’ll finish the exercise by changing our action to say hello to whatever name we’ve typed in the text field.

In order to do that, first we need a reference to the input element inside our controller. Then we can read the value property to get its contents.

Stimulus lets us mark important elements as targets so we can easily reference them in the controller through corresponding properties. Open public/index.html and add a data-hello-target attribute to the input element:

```html
<div data-controller="hello">
  <input data-hello-target="name" type="text">
  <button data-action="click->hello#greet">Greet</button>
</div>
```

Next, we’ll create a property for the target by adding name to our controller’s list of target definitions. Stimulus will automatically create a this.nameTarget property which returns the first matching target element. We can use this property to read the element’s value and build our greeting string.

Let’s try it out. Open hello_controller.js and update it like so:

```javascript
// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "name" ]

  greet() {
    const element = this.nameTarget
    const name = element.value
    console.log(`Hello, ${name}!`)
  }
}
```

Then reload the page in your browser and open the developer console. Enter your name in the input field and click the “Greet” button. Hello, world!
</details>

## コントローラをよりシンプルに

StimulusコントローラはJavaScriptのクラスのインスタンスであり、そのメソッドはイベントハンドラとして動作します。

つまり、標準的なリファクタリングテクニックを自由に使えるということです。 例えば、入力された名前を返す`name` getter を作ることで`greet()`メソッドをすっきりさせることができます：

```javascript
// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "name" ]

  greet() {
    console.log(`Hello, ${this.name}!`)
  }

  get name() {
    return this.nameTarget.value
  }
}
```

<details>
    <summary>原文</summary>
We’ve seen that Stimulus controllers are instances of JavaScript classes whose methods can act as event handlers.

That means we have an arsenal of standard refactoring techniques at our disposal. For example, we can clean up our greet() method by extracting a name getter:

```javascript
// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "name" ]

  greet() {
    console.log(`Hello, ${this.name}!`)
  }

  get name() {
    return this.nameTarget.value
  }
}
```
</details>


## おさらいと次のステップ

おめでとう！ あなたにとって最初のStimulusコントローラを書くことができました！

ここではフレームワークの最も重要な概念であるコントローラ、アクション、ターゲットについて説明しました。 次の章では、これらを組み合わせて、実際にBasecampから抽出したコントローラを作ってみましょう。


<details>
    <summary>原文</summary>
Congratulations—you’ve just written your first Stimulus controller!

We’ve covered the framework’s most important concepts: controllers, actions, and targets. In the next chapter, we’ll see how to put those together to build a real-life controller taken right from Basecamp.
</details>
