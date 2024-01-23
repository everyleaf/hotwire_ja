---
title: "Stimulusの原点"
description: "Stimulusが他のフレームワークとどう違うか、何を求められて生まれたものかについて"
layout: "stimulus--base.html"
---

# Stimulusの原点

[Basecamp](https://basecamp.com/)ではJavaScriptをたくさん書いていますが、現代的な意味での「JavaScriptアプリケーション」を作るためにJavaScriptを使っているわけではありません。 Basecampのアプリケーションは、サーバーサイドでレンダリングされたHTMLを核に、JavaScriptを散りばめるようにしてできています。

これが、[Majestic Monolith](https://m.signalvnoise.com/the-majestic-monolith/)のやり方です。 Basecampは、Ruby on Railsで作成された単一のコントローラ、ビュー、モデルで、ネイティブモバイルアプリを含む6つのプラットフォームで動作しています。 一箇所で更新可能な単一の共有インターフェイスを持つということは、多くのプラットフォームがあるにもかかわらず、少人数のチームで業務を遂行するための鍵となっています。

それによって、昔のような高い生産性を体験できます。 一人のプログラマーが、間接的なレイヤーや分散システムに囚われることなく、貪欲に前進することができた時代に戻るのです。 JavaScriptベースのクライアントアプリケーションのために、サーバーサイドアプリケーションに、ただただJSONの生成だけをさせることが正しい方法だと皆が考える前の時代です。

だからと言って、そのような現代のアプローチに一切価値がないと言っているわけではありません。 多くのアプリケーション、そしてBasecampのようなものへの一般的なアプローチとしては、全体的なシンプルさと生産性が後退しているというだけです。

また、シングルページのJavaScriptアプリケーションが増えたからといって、本当にメリットがないわけでもありません。 主なメリットとして、フルページリフレッシュから解放された、より高速でより滑らかなインターフェースです。

私たちは、Basecampもそんな風にしたかった。 まるで私たちがそういったムーブメントの後追いをして、すべてをクライアント側のレンダリングに書き直したり、フルネイティブのアプリにしたのかとみんなが錯覚するように。

この思いが、私たちを2つの解決策へと導きました：[Turbo](/)とStimulusです。


<details>
    <summary>原文</summary>
We write a lot of JavaScript at Basecamp, but we don’t use it to create “JavaScript applications” in the contemporary sense. All our applications have server-side rendered HTML at their core, then add sprinkles of JavaScript to make them sparkle.

This is the way of the majestic monolith. Basecamp runs across half a dozen platforms, including native mobile apps, with a single set of controllers, views, and models created using Ruby on Rails. Having a single, shared interface that can be updated in a single place is key to being able to perform with a small team, despite the many platforms.

It allows us to party with productivity like days of yore. A throwback to when a single programmer could make rapacious progress without getting stuck in layers of indirection or distributed systems. A time before everyone thought the holy grail was to confine their server-side application to producing JSON for a JavaScript-based client application.

That’s not to say that there isn’t value in such an approach for some people, some of the time. Just that as a general approach to many applications, and certainly the likes of Basecamp, it’s a regression in overall simplicity and productivity.

And it’s also not to say that the proliferation of single-page JavaScript applications hasn’t brought real benefits. Chief amongst which has been faster, more fluid interfaces set free from the full-page refresh.

We wanted Basecamp to feel like that too. As though we had followed the herd and rewritten everything with client-side rendering or gone full-native on mobile.

This desire led us to a two-punch solution: Turbo and Stimulus.
</details>

## Turboは高く、Stimulusは低く

新しい控えめなJavaScriptフレームワークであるStimulusの説明に入る前に、Turboの命題をおさらいしておきましょう。

Turboは、GitHubで開発された[pjax](https://github.com/defunkt/jquery-pjax)というアプローチから派生したものです。 基本的なコンセプトは変わりません。 ページのリフレッシュがしばしば遅く感じられるのは、ブラウザがサーバーから送られてくる大量のHTMLを処理しなければならないからというわけではありません。 ブラウザーは本当に優秀で高速です。 また、ほとんどの場合、HTMLのペイロードがJSONのペイロードよりも大きくなる傾向があるということも重要ではありません（特にgzipの場合）。 そうではなく、遅く感じる本当の理由はCSSとJavaScriptを再初期化してページに再適用しなければならないというところにあります。 ファイル自体がキャッシュされているかどうかは関係ありません。 かなりの量のCSSやJavaScriptがある場合、これによってかなり遅くなります。

この再初期化を回避するために、Turboはシングルページのアプリケーションと同じように永続的なプロセスを維持します。 しかし、動作の大部分は透過的で目に見えないものです。 リンクをインターセプトし、Ajax経由で新しいページをロードします。 サーバーは依然として完全な形のHTMLドキュメントを返します。

この戦略だけで、たいていのアプリケーションのほとんどのアクションが、(100〜200msで(キャッシュを使えば実現可能)サーバのレスポンスを返すことができれば)とても速く感じられるようになります。 Basecampでは、ページ間の遷移が約3倍速くなりました。  シングルページアプリケーションの魅力の大部分であった応答性と流動性をアプリケーションに与えることができました。

しかし、Turboだけではまだまだ話の半分に過ぎません。 ページの全更新よりももっと細かいものの実装にも目を向ける必要があります。 要素の表示・非表示の切り替え、クリップボードへのコンテンツのコピー、リストへの新しいTODOの追加といった私たちがモダンなウェブアプリケーションでイメージするようなインタラクションの実現の方法についてです。

Stimulus以前は、Basecampは様々なスタイルやパターンを使って、これらのモダンインタラクションを実現していました。 あるコードはjQueryをひとつまみ、あるコードはバニラJavaScriptを同じ大きさでひとつまみ、またあるコードはより大きなオブジェクト指向のサブシステムを使いました。 それらはすべて、[`data-behavior`属性](https://signalvnoise.com/posts/3167-code-spelunking-in-the-all-new-basecamp#:~:text=javascript%20behaviors)に指定した明示的なイベント処理で動かしていました。

このように新しいコードを追加するのは簡単でしたが、包括的な解決策にはならず、社内にはあまりにも多くのスタイルやパターンが共存していました。 そのためコードを再利用することが難しく、新しい開発者が一貫したアプローチを学ぶことも難しかったのです。

<details>
    <summary>原文</summary>
Before I get to Stimulus, our new modest JavaScript framework, allow me to recap the proposition of Turbo.

Turbo descends from an approach called pjax, developed at GitHub. The basic concept remains the same. The reason full-page refreshes often feel slow is not so much because the browser has to process a bunch of HTML sent from a server. Browsers are really good and really fast at that. And in most cases, the fact that an HTML payload tends to be larger than a JSON payload doesn’t matter either (especially with gzipping). No, the reason is that CSS and JavaScript has to be reinitialized and reapplied to the page again. Regardless of whether the files themselves are cached. This can be pretty slow if you have a fair amount of CSS and JavaScript.

To get around this reinitialization, Turbo maintains a persistent process, just like single-page applications do. But largely an invisible one. It intercepts links and loads new pages via Ajax. The server still returns fully-formed HTML documents.

This strategy alone can make most actions in most applications feel really fast (if they’re able to return server responses in 100-200ms, which is eminently possible with caching). For Basecamp, it sped up the page-to-page transition by ~3x. It gives the application that feel of responsiveness and fluidity that was a massive part of the appeal for single-page applications.

But Turbo alone is only half the story. The coarsely grained one. Below the grade of a full page change lies all the fine-grained fidelity within a single page. The behavior that shows and hides elements, copies content to a clipboard, adds a new todo to a list, and all the other interactions we associate with a modern web application.

Prior to Stimulus, Basecamp used a smattering of different styles and patterns to apply these sprinkles. Some code was just a pinch of jQuery, some code was a similarly sized pinch of vanilla JavaScript, and some again was larger object-oriented subsystems. They all usually worked off explicit event handling hanging off a data-behavior attribute.

While it was easy to add new code like this, it wasn’t a comprehensive solution, and we had too many in-house styles and patterns coexisting. That made it hard to reuse code, and it made it hard for new developers to learn a consistent approach.
</details>

## Stimulusの3つのコアコンセプト

Stimulusは、これらのパターンの良いところをまとめあげ、コントローラー、アクション、ターゲットという3つの主要な概念だけを中心とした、控えめで小さなフレームワークです。

Stimulusが適用されたHTMLを見ると、プログレッシブエンハンスメントとして読めるように設計されています。 1つのテンプレートを見るだけで、どんな振る舞いが要素に作用しているのかを知ることができます。 以下に例を示します。

```html
<div data-controller="clipboard">
  PIN: <input data-clipboard-target="source" type="text" value="1234" readonly>
  <button data-action="clipboard#copy">クリップボードにコピー</button>
</div>
```

これを読めば、何が起こっているのかがよく分かると思います。 Stimulusについて何も知らなくても、コントローラのコードそのものを見なくても。 ほとんど擬似コードのようなものですね。 これは、イベントハンドラが外部のJavaScriptファイルで設定されているHTMLを読み取ることとは大きく異なります。 また、現代のJavaScriptフレームワークの多くで失われている関心ごとの分離も維持されています。

見てわかるように、StimulusはHTMLの作成に悩まされることはありません。 JavaScriptでHTMLを作成する代わりに、既存のHTMLドキュメントにアタッチします。 HTMLは、ほとんどの場合、ページロード時（最初のヒットまたはTurbo経由）、またはDOMを変更するAjaxリクエスト経由のいずれかの時にサーバ側でレンダリングされます。

Stimulusは、こうして作られた既存のHTML文書を操作することに主眼をおいています。 時にStimulusは、要素を隠したり、アニメーションさせたり、ハイライトさせたりするCSSクラスを追加したりします。 グループ化された要素を再配置することもあります。 キャッシュ可能なUTC時間を表示可能なローカル時間に変換する場合もそうです。

時にはStimulusに新しいDOM要素を作成させたい場合もあるでしょう。 将来的には、それを簡単にするための方法も追加するかもしれません。 しかし、それはあまり多くない使用例です。 私たちは要素を作成するのではなく、操作することに重点を置いています。

<details>
    <summary>原文</summary>
Stimulus rolls up the best of those patterns into a modest, small framework revolving around just three main concepts: Controllers, actions, and targets.

It’s designed to read as a progressive enhancement when you look at the HTML it’s addressing. Such that you can look at a single template and know which behavior is acting upon it. Here’s an example:

```html
<div data-controller="clipboard">
  PIN: <input data-clipboard-target="source" type="text" value="1234" readonly>
  <button data-action="clipboard#copy">Copy to Clipboard</button>
</div>
```

You can read that and have a pretty good idea of what’s going on. Even without knowing anything about Stimulus or looking at the controller code itself. It’s almost like pseudocode. That’s very different from reading a slice of HTML that has an external JavaScript file apply event handlers to it. It also maintains the separation of concerns that has been lost in many contemporary JavaScript frameworks.

As you can see, Stimulus doesn’t bother itself with creating the HTML. Rather, it attaches itself to an existing HTML document. The HTML is, in the majority of cases, rendered on the server either on the page load (first hit or via Turbo) or via an Ajax request that changes the DOM.

Stimulus is concerned with manipulating this existing HTML document. Sometimes that means adding a CSS class that hides an element or animates it or highlights it. Sometimes it means rearranging elements in groupings. Sometimes it means manipulating the content of an element, like when we transform UTC times that can be cached into local times that can be displayed.

There are cases where you’d want Stimulus to create new DOM elements, and you’re definitely free to do that. We might even add some sugar to make it easier in the future. But it’s the minority use case. The focus is on manipulating, not creating elements.
</details>

## Stimulusと主流のJavaScriptフレームワークとの違い

そのため、Stimulusは現代のJavaScriptフレームワークの大半とは大きく異なっています。 ほとんどすべてのフレームワークは、ある種のテンプレート言語を介してJSONをDOM要素に変換することに重点を置いています。 これらのフレームワークの多くは、空のページを作成し、そのページをJSONを元にしたテンプレートレンダリングによって作成された要素のみで埋めるために使用します。

Stimulusはまた、ステートの扱いに関しても他のフレームワークと大きく異なります。 ほとんどのフレームワークは、JavaScriptオブジェクト内に状態を保持する方法を持ち、その状態に基づいてHTMLをレンダリングします。Stimulusは正反対の方法をとります。 ステートはHTML上に保存されるため、コントローラーはページの変更の間に破棄されますが、キャッシュされたHTMLが再び表示されたときに元の状態のまま再初期化されます。

これは本当に驚くほど異なるパラダイムです。 現代のフレームワークを使い慣れたJavaScript開発者の多くは、これを馬鹿にし、あざ笑うことだと思います。  React + Reduxのような大混乱の中でアプリケーションを維持するのにかかる複雑さと労力に満足しているなら、Turbo + Stimulusはあなたにとって魅力的なものではないかもしれません。

その一方で、あなたが今取り組んでいることが、そのような現代的なテクニックが意味するような強烈な複雑さやアプリケーションの分離を正当化するものではないと強く感じているのであれば、私たちのアプローチに救いを見出すことができるでしょう。

<details>
    <summary>原文</summary>
This makes Stimulus very different from the majority of contemporary JavaScript frameworks. Almost all are focused on turning JSON into DOM elements via a template language of some sort. Many use these frameworks to birth an empty page, which is then filled exclusively with elements created through this JSON-to-template rendering.

Stimulus also differs on the question of state. Most frameworks have ways of maintaining state within JavaScript objects, and then render HTML based on that state. Stimulus is the exact opposite. State is stored in the HTML, so that controllers can be discarded between page changes, but still reinitialize as they were when the cached HTML appears again.

It really is a remarkably different paradigm. One that I’m sure many veteran JavaScript developers who’ve been used to work with contemporary frameworks will scoff at. And hey, scoff away. If you’re happy with the complexity and effort it takes to maintain an application within the maelstrom of, say, React + Redux, then Turbo + Stimulus will not appeal to you.

If, on the other hand, you have nagging sense that what you’re working on does not warrant the intense complexity and application separation such contemporary techniques imply, then you’re likely to find refuge in our approach.
</details>

## Stimulusとそれに関連するアイデアは、自然に抽出されたもの

Basecampでは、このアーキテクチャをBasecampのいくつかのバージョンや他のアプリケーションで長年使ってきました。 GitHubも同様のアプローチで大きな効果を上げています。 これは、 「モダンな」 Webアプリケーションがどのようなものであるかについての主流の考え方に対する有効な代替案であるだけでなく、信じられないほど説得力のあるものです。

実際のところ、現代の主流なアプローチは無駄に複雑で、もっと速く、もっと少ないコストでできるはずだという、私たちがBasecampで[Ruby on Rails](https://rubyonrails.org/)を開発した時と同じような感覚があるのです。

しかも、選ぶ必要もありません。 StimulusとTurboは、他の重いアプローチと組み合わせても効果的です。アプリケーションの80％が重たいアプローチを必要としない場合は、当社の2パックパンチ(Stimulus/Turbo)の使用をご検討ください。 そして、アプリケーションの中でそれをすることで本当にメリットがある部分にだけ、重たいアプローチを導入してもよいでしょう。

Basecampでも、必要に応じて、いくつかの重たいアプローチを採用しています。 たとえばカレンダーみたいなものははクライアントサイドレンダリングを使っています。 Basecamp上のテキストエディタは[Trix](https://trix-editor.org/)で、これはStimulusのコントローラとは関係のない完全なテキストプロセッサです。

この一連の代替フレームワークのセットは、重い仕事をできるだけ避けるためのものです。 このシンプルなモデルでうまく機能する多くのインタラクションのために、リクエスト-レスポンスパラダイムに留まるのです。 そして、最高の忠実度が求められるときだけ、高価なツールに手を伸ばせばよいのです。

とりわけ、このツールキットは、より手間のかかる主流のアプローチを用いる大規模なチームと、忠実さと到達度で競い合いたい小規模チームのためのものです。

ぜひお試しください。

<details>
    <summary>原文</summary>
At Basecamp we’ve used this architecture across several different versions of Basecamp and other applications for years. GitHub has used a similar approach to great effect. This is not only a valid alternative to the mainstream understanding of what a “modern” web application looks like, it’s an incredibly compelling one.

In fact, it feels like the same kind of secret sauce we had at Basecamp when we developed Ruby on Rails. The sense that contemporary mainstream approaches are needlessly convoluted, and that we can do more, faster, with far less.

Furthermore, you don’t even have to choose. Stimulus and Turbo work great in conjunction with other, heavier approaches. If 80% of your application does not warrant the big rig, consider using our two-pack punch for that. Then roll out the heavy machinery for the part of your application that can really benefit from it.

At Basecamp, we have and do use several heavier-duty approaches when the occasion calls for it. Our calendars tend to use client-side rendering. Our text editor is Trix, a fully formed text processor that wouldn’t make sense as a set of Stimulus controllers.

This set of alternative frameworks is about avoiding the heavy lifting as much as possible. To stay within the request-response paradigm for all the many, many interactions that work well with that simple model. Then reaching for the expensive tooling when there’s a call for peak fidelity.

Above all, it’s a toolkit for small teams who want to compete on fidelity and reach with much larger teams using more laborious, mainstream approaches.

Give it a go.
</details>
