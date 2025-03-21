---
title: "Hotwire ドキュメント（有志翻訳版）"
description: "HotwireはモダンなWebアプリケーションを構築するにあたっての新しいアプローチです。多量のJavaScriptを書くことなく、サーバーサイドからJSONではなくHTMLを送ります。このサイトでは、Hotwireの主要技術であるTurboとStimulusについて、公式ドキュメントのReferenceとHandbookの翻訳を掲載します"
layout: "base.html"
---

<main id="content">
  <h1>HOTWIRE - HTML Over The Wire</h1>
  <div class="description">
    <div>
      Hotwireは、モダンなWebアプリをつくるための”もう一つの"アプローチです。JavaScriptを多用しません。"wire"を通じて、JSONの代わりにHTMLを送ります。ページの読み込み速度は早く、テンプレートの描画はサーバー上で行い、よりシンプルで生産的な開発体験を提供します。あらゆるプログラミング言語で動き、そして従来のシングルページ・アプリケーションで想定されるスピードやレスポンシブ性はそのままです。
    </div>

    <div>
        HTML-over-the-wire のアプローチを単なるインスピレーションとして独自のツールに活かすこともできますし、37signals のチームが HEY のために設計した Hotwire フレームワークを活用することもできます。これらのフレームワークは互いに連携し、全プラットフォームをまたぐ完全なソリューションを提供します。
    </div>
  </div>
  <section>
    <h2>Turbo</h2>
    <div class="description">
      Hotwireの中心となるのがTurboです。Turboは、ページの切り替えやフォームの送信を高速化し、複雑なページをコンポーネントに分割し、WebSocketを使って部分的なページ更新をストリーミングするための一連の、それぞれを補完しあう技術です。しかも、一切JavaScriptを書く必要がありません。
    </div>
    <ul>
      <li> <a href="/turbo/handbook/introduction/">Handbook</a> </li>
      <li> <a href="/turbo/reference/drive/">Reference</a> </li>
      <li> <a href="/turbo/handbook/installing/">インストール</a> </li>
    </ul>
  </section>
  <section>
    <h2>Stimulus</h2>
    <div class="description">
      <details>
        Turboは通常、従来ならJavaScriptが必要だったインタラクティブな動作の少なくとも80%を担ってくれますが、それでも少しだけカスタムコードが必要になる場面はあります。そんなときに役立つのがStimulusです。Stimulusは、HTMLを中心としたアプローチで状態管理やサーバーとの連携を簡単に実現します。
        <summary>
        原文
        </summary>
        While Turbo usually takes care of at least 80% of the interactivity that traditionally would have required JavaScript, there are still cases where a dash of custom code is required. Stimulus makes this easy with a HTML-centric approach to state and wiring.
      </details>
    </div>
    <ul>
      <li> <a href="/stimulus/handbook/introduction/">Handbook</a> </li>
      <li> <a href="/stimulus/reference/controllers/">Reference</a> </li>
    </ul>
  </section>
</main>
<footer>
</footer>