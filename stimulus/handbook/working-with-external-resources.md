---
title: "外部リソースの利用"
description: "Stimulusで外部リソースを取得して情報を更新したり、タイマーを使ったりする方法を見ていきましょう。"
order: 6
---

# 外部リソースの利用

前章では、valuesを使用してコントローラの内部状態をロードし、永続化する方法を学びました。

時折コントローラーは外部リソースの状態を取得しなければならない場合があります。 ここでの外部とは、DOMやStimulusの一部ではないものを指します。 例えば、HTTPリクエストを発行し、リクエストの状態の変化に応じて応答する必要があるかもしれません。 あるいは、タイマーを開始し、コントローラがdisconnectした時にタイマーを停止する必要があるかもしれません。 この章では、こういったケースに対応するための方法を説明します。

<details>
<summary>原文</summary>

# Working With External Resources

In the last chapter we learned how to load and persist a controller’s internal state using values.

Sometimes our controllers need to track the state of external resources, where by external we mean anything that isn’t in the DOM or a part of Stimulus. For example, we may need to issue an HTTP request and respond as the request’s state changes. Or we may want to start a timer and then stop it when the controller is no longer connected. In this chapter we’ll see how to do both of those things.
</details>

## HTMLの非同期読み込み

リモートのHTMLスニペットを読み込んで挿入することで、ページの一部を非同期に生成する方法を学びましょう。 Basecampでは、このテクニックを使うことで、最初のページ読み込みを高速に保ち、ビューにユーザー固有のコンテンツを含まないようにして、より効率的にキャッシュできるようにしています。

汎用のコンテンツローダーコントローラを作成し、サーバから取得したHTMLスニペットを要素に埋め込みます。 そして、それを使って、メールの受信トレイにあるような未読メッセージのリストを読み込みます。

`public/index.html`に受信トレイをスケッチすることから始めましょう：

```javascript
<div data-controller="content-loader"
     data-content-loader-url-value="/messages.html"></div>
```

次に、メッセージ・リスト用のHTMLを含む`public/messages.html`ファイルを新規作成します：

```javascript
<ol>
  <li>New Message: Stimulus Launch Party</li>
  <li>Overdue: Finish Stimulus 1.0</li>
</ol>
```

(実際のアプリケーションでは、このHTMLをサーバー上で動的に生成することになるが、デモでは静的なファイルを使うことにします)

これで、コントローラを実装できるようになりました：

```javascript
// src/controllers/content_loader_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.load()
  }

  load() {
    fetch(this.urlValue)
      .then(response => response.text())
      .then(html => this.element.innerHTML = html)
  }
}
```

コントローラが接続されると、要素の`data-content-loader-url-value`属性で指定されたURLへのFetchリクエストを開始します。 そして、返されたHTMLを要素の`innerHTML`プロパティに代入して表示させます。

ブラウザの開発者コンソールでネットワークタブを開き、ページをリロードします。 最初のページロードを表すリクエストと、それに続く`messages.html`へのリクエストが表示されましたね。

<details>
<summary>原文</summary>

## Asynchronously Loading HTML

Let’s learn how to populate parts of a page asynchronously by loading and inserting remote fragments of HTML. We use this technique in Basecamp to keep our initial page loads fast, and to keep our views free of user-specific content so they can be cached more effectively.

We’ll build a general-purpose content loader controller which populates its element with HTML fetched from the server. Then we’ll use it to load a list of unread messages like you’d see in an email inbox.

Begin by sketching the inbox in public/index.html:

```javascript
<div data-controller="content-loader"
     data-content-loader-url-value="/messages.html"></div>
```

Then create a new public/messages.html file with some HTML for our message list:

```javascript
<ol>
  <li>New Message: Stimulus Launch Party</li>
  <li>Overdue: Finish Stimulus 1.0</li>
</ol>
```

(In a real application you’d generate this HTML dynamically on the server, but for demonstration purposes we’ll just use a static file.)

Now we can implement our controller:

```javascript
// src/controllers/content_loader_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.load()
  }

  load() {
    fetch(this.urlValue)
      .then(response => response.text())
      .then(html => this.element.innerHTML = html)
  }
}
```

When the controller connects, we kick off a Fetch request to the URL specified in the element’s data-content-loader-url-value attribute. Then we load the returned HTML by assigning it to our element’s innerHTML property.

Open the network tab in your browser’s developer console and reload the page. You’ll see a request representing the initial page load, followed by our controller’s subsequent request to messages.html.
</details>

## タイマーを利用した自動更新

受信トレイを定期的に更新し、常に最新の状態にするようにコントローラを改善してみましょう。

`data-content-loader-refresh-interval-value`属性を新たに作り、コントローラの内容をリロードする頻度をミリ秒単位で指定できるようにしましょう：

```javascript
<div data-controller="content-loader"
     data-content-loader-url-value="/messages.html"
     data-content-loader-refresh-interval-value="5000"></div>
```

これで、設定したインターバルでコントローラをチェックし、存在すれば更新するように実装することができます。

コントローラで`static values`の定義に、HTML側に記述した`url`と`refreshInterval`の二つを追加し、新しいメソッド`startRefreshing()`を定義します：

```javascript
export default class extends Controller {
  static values = { url: String, refreshInterval: Number }

  startRefreshing() {
    setInterval(() => {
      this.load()
    }, this.refreshIntervalValue)
  }

  // …
}
```

次に、`connect()`メソッドを更新して、インターバル値が存在する場合は`startRefreshing()`メソッドを呼び出すようにしましょう：

```javascript
connect() {
  this.load()

  if (this.hasRefreshIntervalValue) {
    this.startRefreshing()
  }
}
```

ページをリロードし、開発者コンソールを見てみましょう。 5秒に一度、新しいリクエストが飛んでいることがわかります。 それが確認できたら`public/messages.html`に変更を加えて、その変更後のメッセージが受信箱に表示されるのを待ちましょう。


<details>
<summary>原文</summary>

## Refreshing Automatically With a Timer

Let’s improve our controller by changing it to periodically refresh the inbox so it’s always up-to-date.

We’ll use the data-content-loader-refresh-interval-value attribute to specify how often the controller should reload its contents, in milliseconds:

```javascript
<div data-controller="content-loader"
     data-content-loader-url-value="/messages.html"
     data-content-loader-refresh-interval-value="5000"></div>
```

Now we can update the controller to check for the interval and, if present, start a refresh timer.

Add a static values definition to the controller, and define a new method startRefreshing():

```javascript
export default class extends Controller {
  static values = { url: String, refreshInterval: Number }

  startRefreshing() {
    setInterval(() => {
      this.load()
    }, this.refreshIntervalValue)
  }

  // …
}
```

Then update the connect() method to call startRefreshing() if an interval value is present:

```javascript
  connect() {
    this.load()

    if (this.hasRefreshIntervalValue) {
      this.startRefreshing()
    }
  }
```

Reload the page and observe a new request once every five seconds in the developer console. Then make a change to public/messages.html and wait for it to appear in the inbox.
</details>

## リソースの取得のインターバルの解除

今のままではコントローラが接続されたときにタイマーは開始されますが、決して停止することはありません。 つまり、コントローラに対応する要素が消えてしまった場合でも、 コントローラはバックグラウンドでHTTPリクエストを投げ続けることになってしまいます。

この問題を解決するに、`startRefreshing()`メソッドを変更してタイマーへの参照を保持するようにします：

```javascript
startRefreshing() {
  this.refreshTimer = setInterval(() => {
    this.load()
  }, this.refreshIntervalValue)
}
```

そして、対応する`stopRefreshing()`メソッドを下に追加して、タイマーをキャンセルすることができるように実装します：

```javascript
stopRefreshing() {
  if (this.refreshTimer) {
    clearInterval(this.refreshTimer)
  }
}
```

最後に、コントローラが切断されたときにタイマーをキャンセルするようにStimulusに指示するために、`disconnect()`メソッドを追加します：

```javascript
disconnect() {
  this.stopRefreshing()
}
```

これで、コンテンツローダーコントローラーが、DOMに接続されている間だけリクエストを発行するように修正することができました。

完成系のコントローラを見てみましょう：

```javascript
// src/controllers/content_loader_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String, refreshInterval: Number }

  connect() {
    this.load()

    if (this.hasRefreshIntervalValue) {
      this.startRefreshing()
    }
  }

  disconnect() {
    this.stopRefreshing()
  }

  load() {
    fetch(this.urlValue)
      .then(response => response.text())
      .then(html => this.element.innerHTML = html)
  }

  startRefreshing() {
    this.refreshTimer = setInterval(() => {
      this.load()
    }, this.refreshIntervalValue)
  }

  stopRefreshing() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }
}
```

<details>
<summary>原文</summary>

## Releasing Tracked Resources

We start our timer when the controller connects, but we never stop it. That means if our controller’s element were to disappear, the controller would continue to issue HTTP requests in the background.

We can fix this issue by modifying our startRefreshing() method to keep a reference to the timer:

```javascript
  startRefreshing() {
    this.refreshTimer = setInterval(() => {
      this.load()
    }, this.refreshIntervalValue)
  }
```

Then we can add a corresponding stopRefreshing() method below to cancel the timer:

```javascript
  stopRefreshing() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }
```

Finally, to instruct Stimulus to cancel the timer when the controller disconnects, we’ll add a disconnect() method:

```javascript
  disconnect() {
    this.stopRefreshing()
  }
```

Now we can be sure a content loader controller will only issue requests when it’s connected to the DOM.

Let’s take a look at our final controller class:

```javascript
// src/controllers/content_loader_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String, refreshInterval: Number }

  connect() {
    this.load()

    if (this.hasRefreshIntervalValue) {
      this.startRefreshing()
    }
  }

  disconnect() {
    this.stopRefreshing()
  }

  load() {
    fetch(this.urlValue)
      .then(response => response.text())
      .then(html => this.element.innerHTML = html)
  }

  startRefreshing() {
    this.refreshTimer = setInterval(() => {
      this.load()
    }, this.refreshIntervalValue)
  }

  stopRefreshing() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }
}
```
</details>

## アクションパラメータを利用する

もしローダーを複数の異なるソースで動作させたいのであれば、アクションパラメーターが使えます。 次のHTMLを見てみましょう：

```html
<div data-controller="content-loader">
  <a href="#" data-content-loader-url-param="/messages.html" data-action="content-loader#load">Messages</a>
  <a href="#" data-content-loader-url-param="/comments.html" data-action="content-loader#load">Comments</a>
</div>
```

そうすれば、loadアクションでそのパラメーターを参照することができます：

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  load({ params }) {
    fetch(params.url)
      .then(response => response.text())
      .then(html => this.element.innerHTML = html)
  }
}
```

paramsを分解して`url`パラメータだけを取得することもできます：

```javascript
load({ params: { url } }) {
  fetch(url)
    .then(response => response.text())
    .then(html => this.element.innerHTML = html)
}
```

<details>
    <summary>原文</summary>

## Using action parameters

```html
<div data-controller="content-loader">
  <a href="#" data-content-loader-url-param="/messages.html" data-action="content-loader#load">Messages</a>
  <a href="#" data-content-loader-url-param="/comments.html" data-action="content-loader#load">Comments</a>
</div>
```

Then we can use those parameters through the load action:

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  load({ params }) {
    fetch(params.url)
      .then(response => response.text())
      .then(html => this.element.innerHTML = html)
  }
}
```

We could even destruct the params to just get the URL parameter:

```javascript
  load({ params: { url } }) {
    fetch(url)
      .then(response => response.text())
      .then(html => this.element.innerHTML = html)
  }
```
</details>

## おさらいと次のステップ

この章では、Stimulus のライフサイクルコールバックを使用して外部リソースを取得および解放する方法を見てきました。

次に、独自のアプリケーションにStimulus をインストールして設定する方法を説明します。

<details>
<summary>原文</summary>

## Wrap-Up and Next Steps

In this chapter we’ve seen how to acquire and release external resources using Stimulus lifecycle callbacks.

Next we’ll see how to install and configure Stimulus in your own application.
</details>
