---
title: "アプリケーションに Turbo をインストール"
description: "アプリケーションにTurboをインストールする方法を学びましょう。"
order: 8
commit: "14aafc8"
---

# アプリケーションに Turbo をインストール

Turbo は、アプリケーションの `<head>` 内にて Turbo 配布スクリプトから直接、または esbuild などのバンドル経由で npm を使用することにより、コンパイルされた形で参照することができます。

<details>
<summary>原文</summary>

# Installing Turbo in Your Application

Turbo can either be referenced in compiled form via the Turbo distributable script directly in the `<head>` of your application or through npm via a bundler like esbuild.

</details>

## コンパイル済みスクリプト

jsDelivr のような CDN バンドラーを利用してリリースされた最新の Turbo を使用できます。
下の `<script>` タグをアプリケーションの `<head>`　の中に含めるだけです。
または[unpkgからコンパイルされたパッケージをダウンロードできます](https://unpkg.com/browse/@hotwired/turbo@latest/dist/)。

<details>
<summary>原文</summary>

## In Compiled Form
You can float on the latest release of Turbo using a CDN bundler like jsDelivr. Just include a `<script>` tag in the `<head>` of your application:

```html
<head>
  <script type="module" src="https://cdn.jsdelivr.net/npm/@hotwired/turbo@latest/dist/turbo.es2017-esm.min.js"></script>
</head>
```

Or <a href="https://unpkg.com/browse/@hotwired/turbo@latest/dist/">download the compiled packages from unpkg</a>.

</details>

## npm パッケージ

パッケージングツールの `npm` や `yarn` を利用して npm から Turbo をインストールできます。
もし `Turbo.visit()` といった Turbo の関数を使うなら、下記のように Turbo の関数をコードにインポートします。

```javascript
import * as Turbo from "@hotwired/turbo";
```

もし `Turbo.visit()` のような Turbo　の関数を使わ *ない* 場合は、下記のようにTurbo の関数をインポートしてください。
これにより、一部のバンドラーにおいてツリーシェイクや未使用変数の問題を回避することができます。詳しくはMDNの [副作用のためだけにモジュールをインポートする](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Statements/import#%E5%89%AF%E4%BD%9C%E7%94%A8%E3%81%AE%E3%81%9F%E3%82%81%E3%81%A0%E3%81%91%E3%81%AB%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB%E3%82%92%E3%82%A4%E3%83%B3%E3%83%9D%E3%83%BC%E3%83%88%E3%81%99%E3%82%8B)をご覧ください。

```javascript
import "@hotwired/turbo";
```

<details>
<summary>原文</summary>

## As An npm Package

You can install Turbo from npm via the `npm` or `yarn` packaging tools. 

If you using any Turbo functions such as `Turbo.visit()` import the `Turbo` functions into your code:
```javascript
import * as Turbo from "@hotwired/turbo"
```

If you're *not* using any Turbo functions such as `Turbo.visit()` import the library. This avoids issues with tree-shaking and unused variables in some bundlers. See [Import a module for its side effects only](https://developer.mozilla.org/en-US/docs/web/javascript/reference/statements/import#import_a_module_for_its_side_effects_only) on MDN.

```javascript
import "@hotwired/turbo";
```

</details>

## Ruby on Rails アプリケーション

JavaScript フレームワークの Turbo は、アセットパイプラインで直接利用できるように [turbo-rails gem](https://github.com/hotwired/turbo-rails) に含まれています。

<details>
<summary>原文</summary>

## In a Ruby on Rails application

The Turbo JavaScript framework is included with [the turbo-rails gem](https://github.com/hotwired/turbo-rails) for direct use with the asset pipeline.

</details>
