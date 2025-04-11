---
title: "はじめに"
description: "Stimulusはすでに持っているHTMLに簡単なアノテーションを加えることで要素とJavaScriptオブジェクトを接続することができるフレームワークです。"
order: 1
---

# はじめに

## Stimulusについて

Stimulusは控えめな野心を持ったJavaScriptフレームワークです。 他のフロントエンドフレームワークとは異なり、Stimulusは静的、またはサーバーレンダリングされたHTML、つまり「すでに持っているHTML」にシンプルなアノテーションを与えることで要素とJavaScriptオブジェクトを接続させるように設計されています。

これらのJavaScriptオブジェクトはコントローラと呼びます。 Stimulusはページを監視し、HTML中に`data-controller`属性が表れるのを待ちます。 Stimulusはこの属性の値から対応するコントローラクラスを見つけ、そのクラスの新しいインスタンスを作成し、要素に接続します。

class属性がHTMLとCSSをつなぐ橋であるように、Stimulusの`data-controller`属性はHTMLとJavaScript をつなぐ橋なのです。

<details>
    <summary>原文</summary>
Stimulus is a JavaScript framework with modest ambitions. Unlike other front-end frameworks, Stimulus is designed to enhance static or server-rendered HTML—the “HTML you already have”—by connecting JavaScript objects to elements on the page using simple annotations.

These JavaScript objects are called controllers, and Stimulus continuously monitors the page waiting for HTML data-controller attributes to appear. For each attribute, Stimulus looks at the attribute’s value to find a corresponding controller class, creates a new instance of that class, and connects it to the element.

You can think of it this way: just like the class attribute is a bridge connecting HTML to CSS, Stimulus’s data-controller attribute is a bridge connecting HTML to JavaScript.
</details>


コントローラーの他にも、3つの主要なStimulusのコンセプトがあります。

* actions: `data-action`属性を使用してコントローラのメソッドをDOM イベントに接続します。
* targets: コントローラ内の重要な要素を取得します。
* values: コントローラの設定された要素のデータ属性の読み取り、書き込み、変更監視を行います。

Stimulus のデータ属性の使用は、CSSがコンテンツとプレゼンテーションを分離するのと同じように、コンテンツと振る舞いを分離するのに役立ちます。さらに、Stimulus の規約は関連するコードを名前によってグループ化することを自然に促します。

その結果、Stimulus は小さくて再利用可能なコントローラを構築するのに役立ち、コードがごった煮になるのを防いでくれます。

<details>
    <summary>原文</summary>

Aside from controllers, the three other major Stimulus concepts are:

actions, which connect controller methods to DOM events using data-action attributes
targets, which locate elements of significance within a controller
values, which read, write, and observe data attributes on the controller’s element
Stimulus’s use of data attributes helps separate content from behavior in the same way CSS separates content from presentation. Further, Stimulus’s conventions naturally encourage you to group related code by name.

In turn, Stimulus helps you build small, reusable controllers, giving you just enough structure to keep your code from devolving into “JavaScript soup.”
</details>

## このドキュメントについて

このハンドブックは、いくつかの完全に機能するコントローラを書く方法を示すことによって、Stimulusのコアコンセプトをガイドします。各章はその前の章を土台としています。最初から最後まで、あなたは以下の方法を学ぶことができます：

* テキストフィールド入力された名前宛の挨拶テキストを表示する
* ボタンがクリックされたときに、テキストフィールドからクリップボードにテキストをコピーする
* 複数のスライドを持つスライドショーをナビゲートする
* サーバからHTMLをページの要素に自動的に取り込む
* 自分のアプリケーションにStimulusをセットアップする

ここでの演習を終えた後はStimulus APIに関する技術的な詳細を理解するために<a href="/stimulus/reference/controllers">リファレンスドキュメント</a>が役に立つかもしれません。

それでは始めましょう！

<details>
    <summary>原文</summary>
This handbook will guide you through Stimulus’s core concepts by demonstrating how to write several fully functional controllers. Each chapter builds on the one before it; from start to finish, you’ll learn how to:

print a greeting addressed to the name in a text field
copy text from a text field to the system clipboard when a button is clicked
navigate through a slide show with multiple slides
fetch HTML from the server into an element on the page automatically
set up Stimulus in your own application
Once you’ve completed the exercises here, you may find the reference documentation helpful for understanding technical details about the Stimulus API.

Let’s get started!
</details>
