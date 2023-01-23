---
permalink: /handbook/installing.html
description: "Learn how to install Turbo in your application."
---

[DHH の許諾](https://github.com/hotwired/turbo-site/issues/96)のもと、[公式の TurboHandbook](https://turbo.hotwired.dev/handbook/introduction)を[オリジナル](https://github.com/hotwired/turbo-site/commit/8d5105992ae576e7757bbf695d2a0d9e003fe3dc)として、翻訳をしています。
このサイトの全ての文責は、[株式会社万葉](https://everyleaf.com/)にあります。

# Installing Turbo in Your Application

# アプリケーションに Turbo をインストール

Turbo can either be installed in compiled form by referencing the Turbo distributable script directly in the `<head>` of your application or through npm via a bundler like Webpack.
Turbo は、アプリケーションの`<head>`内で直接 Turbo 配布スクリプトを参照してコンパイルされた形でインストールするか、Webpack などのバンドル経由で npm を使用してインストールすることができます。

## In Compiled Form

## コンパイル形式

You can download the latest distributable script from the GitHub releases page, then reference that in your `<script>` tag on your page. Or you can float on the latest release of Turbo using a CDN bundler like Skypack. See <a href="https://cdn.skypack.dev/@hotwired/turbo">https://cdn.skypack.dev/@hotwired/turbo</a> for more details.
最新の配布スクリプトは、GitHub のリリースページからダウンロードできます。そして、ページ内の`<script>`タグ内で参照できます。または、Skypack のような CDN バンドラーを利用してリリースされた最新の Turbo を使用できます。詳細は、[https://cdn.skypack.dev/@hotwired/turbo](https://cdn.skypack.dev/@hotwired/turbo)を参照してください。

## As An npm Package

You can install Turbo from npm via the `npm` or `yarn` packaging tools. Then require or import that in your code:

```javascript
import * as Turbo from "@hotwired/turbo";
```

## In a Ruby on Rails application

The Turbo JavaScript framework is included with [the turbo-rails gem](https://github.com/hotwired/turbo-rails) for direct use with the asset pipeline.
