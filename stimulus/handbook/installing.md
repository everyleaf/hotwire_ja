---
title: "アプリケーションにStimulusをインストールする"
description: "様々なシステム環境のアプリケーションでStimulusをインストールする方法について"
order: 7
---

# アプリケーションにStimulusをインストールする

アプリケーションにStimulusをインストールするには、JavaScriptのバンドルに`@hotwired/stimulus` npm パッケージを追加します。あるいはバンドラーを利用してない場合は、`<script type="module">`タグを使ってstimulus.js をインポートしてください。

<details>
<summary>原文</summary>

# Installing Stimulus in Your Application

To install Stimulus in your application, add the @hotwired/stimulus npm package to your JavaScript bundle. Or, import stimulus.js in a `<script type="module">` tag.
</details>

## Stimulus for Railsを使う

Stimulus for Railsをimport-mapsと一緒に使用している場合、何もせずとも自動的に`app/javascript/controllers`からすべてのコントローラファイルを読み込むようになります。

### コントローラのファイル名と識別子の対応

コントローラファイルの名前は`[identifier]_controller.js`とします。`identifier`は、HTML内の各コントローラの data-controllerの値に設定する識別子に対応します。

Stimulus for Railsでは、ファイル名の複数の単語をアンダースコアで区切るのが一般的です。 コントローラのファイル名のアンダースコアは、識別子のダッシュ(`-`)に変換されます。

サブフォルダを使用してコントローラを名前空間で区切ることもできます。 名前空間を指定したコントローラファイルのパス中のスラッシュは、 識別子中の2つのダッシュ(`--`)に対応します。

お望みであれば、コントローラのファイル名でアンダースコアの代わりにダッシュを使用することもできます。 Stimulus はこれらを同じように扱います。

| If your controller file is named… | its identifier will be… |
|---|---|
| clipboard_controller.js | clipboard |
| date_picker_controller.js | date-picker |
| users/list_item_controller.js | users--list-item |
| local-time-controller.js | local-time |


<details>
<summary>原文</summary>

## Using Stimulus for Rails

If you’re using Stimulus for Rails together with an import map, the integration will automatically load all controller files from app/javascript/controllers.

### Controller Filenames Map to Identifiers

Name your controller files [identifier]_controller.js, where identifier corresponds to each controller’s data-controller identifier in your HTML.

Stimulus for Rails conventionally separates multiple words in filenames using underscores. Each underscore in a controller’s filename translates to a dash in its identifier.

You may also namespace your controllers using subfolders. Each forward slash in a namespaced controller file’s path becomes two dashes in its identifier.

If you prefer, you may use dashes instead of underscores anywhere in a controller’s filename. Stimulus treats them identically.

| If your controller file is named… | its identifier will be… |
|---|---|
| clipboard_controller.js | clipboard |
| date_picker_controller.js | date-picker |
| users/list_item_controller.js | users--list-item |
| local-time-controller.js | local-time |
</details>

## Webpack Helpersを使う

JavaScriptのバンドルにWebpackを使用している場合、`@hotwired/stimulus-webpack-helpers`パッケージを使用してと、Stimulus for Railsと同じ形式のオートロード動作を得ることができます。 まずパッケージを追加し、次のように使用します：

```javascript
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

window.Stimulus = Application.start()
const context = require.context("./controllers", true, /\.js$/)
Stimulus.load(definitionsFromContext(context))
```

<details>
<summary>原文</summary>

## Using Webpack Helpers

If you’re using Webpack as your JavaScript bundler, you can use the `@hotwired/stimulus-webpack-helpers` package to get the same form of autoloading behavior as Stimulus for Rails. First add the package, then use it like this:

```javascript
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

window.Stimulus = Application.start()
const context = require.context("./controllers", true, /\.js$/)
Stimulus.load(definitionsFromContext(context))
```
</details>

## その他のビルドシステムを使う

Stimulus は他のビルドシステムでも動作しますが、その場合コントローラのオートロードはサポートされません。 代わりに、明示的にアプリケーションインスタンスにコントローラファイルをimportして登録する必要があります：

```javascript
// src/application.js
import { Application } from "@hotwired/stimulus"

import HelloController from "./controllers/hello_controller"
import ClipboardController from "./controllers/clipboard_controller"

window.Stimulus = Application.start()
Stimulus.register("hello", HelloController)
Stimulus.register("clipboard", ClipboardController)
```

esbuildのようなビルダーでstimulus-railsを使用している場合、`stimulus:manifest:update` Rakeタスクと`./bin/rails generate stimulus [controller] generator`を使用して、`app/javascript/controllers/index.js`にあるコントローラのインデックスファイルを自動的に更新することができます。

<details>
<summary>原文</summary>

## Using Other Build Systems

Stimulus works with other build systems too, but without support for controller autoloading. Instead, you must explicitly load and register controller files with your application instance:

```javascript
// src/application.js
import { Application } from "@hotwired/stimulus"

import HelloController from "./controllers/hello_controller"
import ClipboardController from "./controllers/clipboard_controller"

window.Stimulus = Application.start()
Stimulus.register("hello", HelloController)
Stimulus.register("clipboard", ClipboardController)
```

If you’re using stimulus-rails with a builder like esbuild, you can use the stimulus:manifest:update Rake task and ./bin/rails generate stimulus [controller] generator to keep a controller index file located at app/javascript/controllers/index.js automatically updated.
</details>

## ビルドシステムを使わない場合

ビルドシステムを使用したくない場合は、`<script type="module">`タグでStimulusをロードすることもできます：

```html
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <script type="module">
    import { Application, Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"
    window.Stimulus = Application.start()

    Stimulus.register("hello", class extends Controller {
      static targets = [ "name" ]

      connect() {
      }
    })
  </script>
</head>
<body>
  <div data-controller="hello">
    <input data-hello-target="name" type="text">
    …
  </div>
</body>
</html>
```

<details>
<summary>原文</summary>

## Using Without a Build System

If you prefer not to use a build system, you can load Stimulus in a `<script type="module">` tag:

```html
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <script type="module">
    import { Application, Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"
    window.Stimulus = Application.start()

    Stimulus.register("hello", class extends Controller {
      static targets = [ "name" ]

      connect() {
      }
    })
  </script>
</head>
<body>
  <div data-controller="hello">
    <input data-hello-target="name" type="text">
    …
  </div>
</body>
</html>
```
</details>

## Stimulusのデフォルトの属性規則を上書きする

Stimulusが使用する`data-*`属性がプロジェクト内の他のライブラリと衝突する場合、Stimulus Applicationを作成する際に上書きして変更することができます。

* `data-controller`
* `data-action`
* `data-target`

これらのStimulusのコア属性はオーバーライドすることができます（参照：schema.ts）：

```javascript
// src/application.js
import { Application, defaultSchema } from "@hotwired/stimulus"

const customSchema = {
  ...defaultSchema,
  actionAttribute: 'data-stimulus-action'
}

window.Stimulus = Application.start(document.documentElement, customSchema);
```

<details>
<summary>原文</summary>

## Overriding Attribute Defaults

In case Stimulus data-* attributes conflict with another library in your project, they can be overridden when creating the Stimulus Application.

* data-controller
* data-action
* data-target

These core Stimulus attributes can be overridden (see: schema.ts):

```javascript
// src/application.js
import { Application, defaultSchema } from "@hotwired/stimulus"

const customSchema = {
  ...defaultSchema,
  actionAttribute: 'data-stimulus-action'
}

window.Stimulus = Application.start(document.documentElement, customSchema);
```
</details>

## エラーハンドリング

Stimulusからのアプリケーションコードへの呼び出しはすべて`try ... catch`ブロックでラップされます。

あなたのコードがエラーをスローした場合、それは Stimulus によってキャッチされ、コントローラ名、呼び出されたイベントまたはライフサイクル関数などの詳細情報を含め、ブラウザコンソールに記録されます。 `window.onerror`を定義したエラー追跡システムを使用している場合、Stimulusはそのシステムにもエラーを渡します。

`Application#handleError`を定義することで、Stimulus がエラーを処理する方法をオーバーライドすることもできます：

```javascript
// src/application.js
import { Application } from "@hotwired/stimulus"
window.Stimulus = Application.start()

Stimulus.handleError = (error, message, detail) => {
  console.warn(message, detail)
  ErrorTrackingSystem.captureException(error)
}
```

<details>
<summary>原文</summary>

## Error handling

All calls from Stimulus to your application’s code are wrapped in a try ... catch block.

If your code throws an error, it will be caught by Stimulus and logged to the browser console, including extra detail such as the controller name and event or lifecycle function being called. If you use an error tracking system that defines window.onerror, Stimulus will also pass the error on to it.

You can override how Stimulus handles errors by defining Application#handleError:

```javascript
// src/application.js
import { Application } from "@hotwired/stimulus"
window.Stimulus = Application.start()

Stimulus.handleError = (error, message, detail) => {
  console.warn(message, detail)
  ErrorTrackingSystem.captureException(error)
}
```
</details>

## デバッグ

Stimulusアプリケーションを`window.Stimulus`に割り当てている場合、`Stimulus.debug = true`でコンソールからデバッグモードをオンにすることができます。 このフラグはソースコードでアプリケーションインスタンスを作成するときにも設定できます。

<details>
<summary>原文</summary>

## Debugging

If you’ve assigned your Stimulus application to window.Stimulus, you can turn on debugging mode from the console with Stimulus.debug = true. You can also set this flag when you’re configuring your application instance in the source code.
</details>

## ブラウザサポート

Stimulusは、すべてのエバーグリーンブラウザ(デスクトップおよびモバイル)をサポートしています。 また、Stimulus 3+はInternet Explorer 11をサポートしていません（しかし、その場合`@stimulus/polyfills`とStimulus 2を使用することができます）。

<details>
<summary>原文</summary>

## Browser Support

Stimulus supports all evergreen, self-updating desktop and mobile browsers out of the box. Stimulus 3+ does not support Internet Explorer 11 (but you can use Stimulus 2 with the @stimulus/polyfills for that).
</details>
