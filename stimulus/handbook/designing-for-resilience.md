---
title: "弾力性のある設計"
description: "プログレッシブエンハンスメントな設計をしてネットワーク障害時やレガシーブラウザ環境でも使うことができるアプリケーションを作りましょう"
layout: "stimulus--base.html"
---

# 弾力性のある設計

クリップボードAPIは現在のブラウザでは十分にサポートされていますが、それでも古いブラウザを使用している少数の人々が私たちのアプリケーションを使用することが予想されます。

また、時々アプリケーションへのアクセスに問題が発生することも想定しておかなければなりません。 例えば、断続的なネットワーク接続やCDNの一時的な障害などによって、JavaScriptの一部またはすべてがロードされない可能性があります。

古いブラウザのサポートは労力に見合わないものと見なしたり、ネットワークの問題はブラウザをリフレッシュすることで解決する一時的な不具合と見なしたりしたくなるものです。 しかし、多くの場合、このようなタイプの問題の影響を優雅に回避するように機能を構築するのは簡単なことです。

一般的にプログレッシブ・エンハンスメントと呼ばれるこの弾力的なアプローチは、基本的な機能をHTMLとCSSで実装し、その基本的なエクスペリエンスに対する段階的なアップグレードをCSSとJavaScriptでレイヤー化します。 そして基礎となるテクノロジーがブラウザでサポートされるようになったときにそのアップグレードを段階的に提供するのです。

<details>
    <summary>原文</summary>
Although the clipboard API is well-supported in current browsers, we might still expect to have a small number of people with older browsers using our application.

We should also expect people to have problems accessing our application from time to time. For example, intermittent network connectivity or CDN availability could prevent some or all of our JavaScript from loading.

It’s tempting to write off support for older browsers as not worth the effort, or to dismiss network issues as temporary glitches that resolve themselves after a refresh. But often it’s trivially easy to build features in a way that’s gracefully resilient to these types of problems.

This resilient approach, commonly known as progressive enhancement, is the practice of delivering web interfaces such that the basic functionality is implemented in HTML and CSS, and tiered upgrades to that base experience are layered on top with CSS and JavaScript, progressively, when their underlying technologies are supported by the browser.
</details>

## プログレッシブエンハンスメントな作りのPINフィールド

PINフィールドを段階的に強化し、ブラウザがサポートしていない限りコピーボタンが見えないようにする方法を見てみましょう。 そうすれば、機能しないボタンを誰かに見せることを避けることができます。

まず、CSSでコピーボタンを隠すことから始めます。 それから、Stimulus コントローラでクリップボードAPIのサポート状況を機能テストします。 APIがサポートされていれば、ボタンを表示するためにコントローラ要素にクラス名を追加します。

まず、`data-controller`属性を持つ div 要素に`data-clipboard-supported-class="clipboard-supported"`を追加します：

```html
<div data-controller="clipboard" data-clipboard-supported-class="clipboard--supported">
```

次に、button要素に`class="clipboard-button"`を追加します：

```html
<button data-action="clipboard#copy" class="clipboard-button">Copy to Clipboard</button>
```

次に、以下のスタイルを`public/main.css`に追加します：

```css
.clipboard-button {
  display: none;
}

.clipboard--supported .clipboard-button {
  display: initial;
}
```

Stimulusコントローラ側では、まず`data-clipboard-supported-class`属性に記されている`supported`という名前を静的プロパティのclassesに追加します：

```javascript
static classes = [ "supported" ]
```

これで、HTML内の特定のCSSクラスを制御できるようになり、コントローラがさまざまなCSSアプローチに簡単に適応できるようになります。 このように追加されたクラスは、`this.supportedClass`という名前でアクセスすることができます。

次にクリップボードAPIがサポートされているかどうかをテストする`connect()`メソッドをコントローラに追加し、サポートされているようであればコントローラの要素にクラス名を追加します：


```javascript
connect() {
  if ("clipboard" in navigator) {
    this.element.classList.add(this.supportedClass);
  }
}
```

このメソッドは、コントローラのクラス本体のどこにでも置くことができます。

この実装により、ブラウザのJavaScriptを無効にしてページをリロードすると、コピーボタンが表示されなくなります。

これでPINフィールドを段階的に強化することができました。 コピーボタンの初期状態は非表示で、JavaScriptがクリップボードAPIのサポートを検出したときだけ表示されるようになります。

<details>
    <summary>原文</summary>
Let’s look at how we can progressively enhance our PIN field so that the Copy button is invisible unless it’s supported by the browser. That way we can avoid showing someone a button that doesn’t work.

We’ll start by hiding the Copy button in CSS. Then we’ll feature-test support for the Clipboard API in our Stimulus controller. If the API is supported, we’ll add a class name to the controller element to reveal the button.

We start off by adding data-clipboard-supported-class="clipboard--supported" to the div element that has the data-controller attribute:

```html
<div data-controller="clipboard" data-clipboard-supported-class="clipboard--supported">
```

Then add class="clipboard-button" to the button element:

```html
<button data-action="clipboard#copy" class="clipboard-button">Copy to Clipboard</button>
```

Then add the following styles to public/main.css:

```css
.clipboard-button {
  display: none;
}

.clipboard--supported .clipboard-button {
  display: initial;
}
```

First we’ll add the data-clipboard-supported-class attribute inside the controller as a static class:

```javascript
  static classes = [ "supported" ]
```

This will let us control the specific CSS class in the HTML, so our controller becomes even more easily adaptable to different CSS approaches. The specific class added like this can be accessed via this.supportedClass.

Now add a connect() method to the controller which will test to see if the clipboard API is supported and add a class name to the controller’s element:

```javascript
connect() {
  if ("clipboard" in navigator) {
    this.element.classList.add(this.supportedClass);
  }
}
```

You can place this method anywhere in the controller’s class body.

If you wish, disable JavaScript in your browser, reload the page, and notice the Copy button is no longer visible.

We have progressively enhanced the PIN field: its Copy button’s baseline state is hidden, becoming visible only when our JavaScript detects support for the clipboard API.

</details>

## おさらいと次のステップ

この章では、クリップボードコントローラーを、古いブラウザや劣悪なネットワーク環境にも耐えられるように優しく修正しました。

次は Stimulus コントローラでどのように状態を管理するかについて学びましょう。

<details>
    <summary>原文</summary>
In this chapter we gently modified our clipboard controller to be resilient against older browsers and degraded network conditions.

Next, we’ll learn about how Stimulus controllers manage state.
</details>


