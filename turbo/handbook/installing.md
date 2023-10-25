---
description: "Learn how to install Turbo in your application."
---

# アプリケーションに Turbo をインストール

Turbo は、アプリケーションの `<head>` 内で直接 Turbo 配布スクリプトを参照してコンパイルされた形でインストールするか、Webpack などのバンドル経由で npm を使用してインストールすることができます。

## コンパイル済みスクリプト

最新の配布スクリプトは、GitHub のリリースページからダウンロードできます。そして、ページ内の `<script>` タグ内で参照できます。または、Skypack のような CDN バンドラーを利用してリリースされた最新の Turbo を使用できます。詳細は、[https://cdn.skypack.dev/@hotwired/turbo](https://cdn.skypack.dev/@hotwired/turbo) を参照してください。

## npm パッケージ

パッケージングツールの `npm` や `yarn` を利用して npm から Turbo をインストールできます。下記のようにコード内で require や import できます。

```javascript
import * as Turbo from "@hotwired/turbo";
```

## Ruby on Rails アプリケーション

JavaScript フレームワークの Turbo は、アセットパイプラインで直接利用できるように [turbo-rails gem](https://github.com/hotwired/turbo-rails) に含まれています。
