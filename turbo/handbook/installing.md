---
title: "アプリケーションに Turbo をインストール"
description: "アプリケーションにTurboをインストールする方法を学びましょう。"
order: 8
---

# アプリケーションに Turbo をインストール

Turbo は、アプリケーションの `<head>` 内にて Turbo 配布スクリプトから直接、または esbuild などのバンドル経由で npm を使用することによりコンパイルされた形で参照することができます。

<details>
<summary>原文</summary>

# Installing Turbo in Your Application

Turbo can either be referenced in compiled form via the Turbo distributable script directly in the `<head>` of your application or through npm via a bundler like esbuild.

</details>

## コンパイル済みスクリプト

Skypack のような CDN バンドラーを利用してリリースされた最新の Turbo を使用できます。詳細は、[https://www.skypack.dev/view/@hotwired/turbo](https://www.skypack.dev/view/@hotwired/turbo) を参照してください。
または[unpkgからコンパイルされたパッケージをダウンロードできます](https://unpkg.com/browse/@hotwired/turbo@latest/dist/)。

<details>
<summary>原文</summary>

## In Compiled Form

You can float on the latest release of Turbo using a CDN bundler like Skypack. See <a href="https://www.skypack.dev/view/@hotwired/turbo">https://www.skypack.dev/view/@hotwired/turbo</a> for more details. Or <a href="https://unpkg.com/browse/@hotwired/turbo@latest/dist/">download the compiled packages from unpkg</a>.

</details>

## npm パッケージ

パッケージングツールの `npm` や `yarn` を利用して npm から Turbo をインストールできます。下記のようにコード内で require や import できます。

```javascript
import * as Turbo from "@hotwired/turbo";
```

## Ruby on Rails アプリケーション

JavaScript フレームワークの Turbo は、アセットパイプラインで直接利用できるように [turbo-rails gem](https://github.com/hotwired/turbo-rails) に含まれています。
