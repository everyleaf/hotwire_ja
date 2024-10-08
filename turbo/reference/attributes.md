---
order: 5
title: "属性とメタタグ"
description: "属性とメタタグのリファレンス"
---

# 属性とメタタグ

## データ属性

次のデータ属性を要素に対して利用することで、Turbo の挙動をカスタマイズできます。

* `data-turbo="false"`は、リンクやフォーム、その子孫要素に対しても Turbo ドライブを無効にします。Turbo ドライブを有効にしたい場合は、`data-turbo="true"`を使います。Turbo ドライブを無効にする場合、振る舞いの違いに注意してください。ブラウザではリンクをクリックした時の振る舞いが通常通りになるだけですが、[native adapters][]ではアプリが終了するかもしれません。
* `data-turbo-track="reload"`はHTML要素を追跡し、それが変わったときに全ページをリロードします。通常、[`script`や`CSS`のリンクを最新の状態に保つために][]使われます。
* `data-turbo-frame`は、ナビゲートするための Turbo フレームを識別します。詳細は、[フレームのドキュメント][]を参照してください。
* `data-turbo-preload`は、Turbo ドライブに次のページのコンテンツをプリフェッチさせます。
* `data-turbo-action`は、[Visit][]アクションをカスタマイズします。有効な値は、`replace`あるいは`advance`のいずれかです。 Turbo フレームと一緒に使うことで、[フレームのナビゲーションをページアクセスに昇格][]できます。
* `data-turbo-permanent`は、[ページ・ロード間で要素を永続化します][]。その要素の`id`属性はユニークでないといけません。[モーフィングによるページ更新][]から要素を除外したい場合も、`data-turbo-permanent`を使います。
* `data-turbo-temporary`は、ドキュメントがキャッシュされる前に要素を削除します。これにより、`data-turbo-temporary`がある要素をキャッシュから復元しません。
* `data-turbo-eval="false"`を指定することで、ページを再表示したときにインラインの`script`要素を再評価しません。
* `data-turbo-method`で、リンクのリクエストタイプをデフォルトの`GET`から変更できます。理想的には、`GET`ではないリクエストはフォームで発行されるべきですが、`data-turbo-method`はフォームが使えない場合に便利かもしれません。
* `data-turbo-stream`により、リンクまたはフォームが Turbo ストリームのレスポンスを受け付けられます。Turbo は、`GET`でないメソッドによるフォーム送信に対して、[自動的にストリーム・レスポンスを要求します][]。`data-turbo-stream`により、`GET`リクエストに対しても Turbo ストリームを使えます。
* `data-turbo-confirm`は、指定された値で確認ダイアログを表示します。`data-turbo-method`を持つ`form`要素またはリンクで使えます。
* `data-turbo-submits-with`により、フォーム送信時に表示するテキストを指定できます。この属性は、`input`要素または`button`要素で使えます。フォーム送信中に、要素のテキストは`data-turbo-submits-with`の値を表示します。送信後は、元のテキストに戻ります。操作の進行中に「保存中...」のようなメッセージを表示すれば、ユーザーにフィードバックを与えられるので便利です。

[native adapters]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/native/
[`script`や`CSS`のリンクを最新の状態に保つために]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/drive/#アセット変更時のリロード
[フレームのドキュメント]: https://everyleaf.github.io/hotwire_ja/turbo/reference/frames
[Visit]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/drive/#ページ・ナビゲーションの基本
[フレームのナビゲーションをページアクセスに昇格]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/frames/#フレームのナビゲーションをページアクセスに昇格させる
[ページ・ロード間で要素を永続化します]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/building/#ページのロードにまたがって要素を永続化する
<!-- 以下のページの日本語化が終わったら、日本語版のURLに変更 -->
[モーフィングによるページ更新]: https://turbo.hotwired.dev/handbook/page_refreshes.html
[自動的にストリーム・レスポンスを要求します]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/streams/#http-レスポンスからのストリーミング

<details>
<summary>原文</summary>

The following data attributes can be applied to elements to customize Turbo's behaviour.

* `data-turbo="false"` disables Turbo Drive on links and forms including descendants. To reenable when an ancestor has opted out, use `data-turbo="true"`. Be careful: when  Turbo  Drive is disabled, browsers treat link clicks as normal, but [native adapters](/handbook/native) may exit the app.
* `data-turbo-track="reload"` tracks the element's HTML and performs a full page reload when it changes. Typically used to [keep `script` and CSS `link` elements up-to-date](/handbook/drive#reloading-when-assets-change).
* `data-turbo-frame` identifies the Turbo Frame to navigate. Refer to the [Frames documentation](/reference/frames) for further details.
* `data-turbo-preload` signals to [Drive](/handbook/drive#preload-links-into-the-cache) to pre-fetch the next page's content
* `data-turbo-action` customizes the [Visit](/handbook/drive#page-navigation-basics) action. Valid values are `replace` or `advance`. Can also be used with Turbo Frames to [promote frame navigations to page visits](/handbook/frames#promoting-a-frame-navigation-to-a-page-visit).
* `data-turbo-permanent` [persists the element between page loads](/handbook/building#persisting-elements-across-page-loads). The element must have a unique `id` attribute. It also serves to exclude elements from being morphed when using [page refreshes with morphing](/handbook/page_refreshes.html)
* `data-turbo-temporary` removes the element before the document is cached, preventing it from reappearing when restored.
* `data-turbo-eval="false"` prevents inline `script` elements from being re-evaluated on Visits.
* `data-turbo-method` changes the link request type from the default `GET`. Ideally, non-`GET` requests should be triggered with forms, but `data-turbo-method` might be useful where a form is not possible.
* `data-turbo-stream` specifies that a link or form can accept a Turbo Streams response. Turbo [automatically requests stream responses](/handbook/streams#streaming-from-http-responses) for form submissions with non-`GET` methods; `data-turbo-stream` allows Turbo Streams to be used with `GET` requests as well.
* `data-turbo-confirm` presents a confirm dialog with the given value. Can be used on `form` elements or links with `data-turbo-method`.
* `data-turbo-submits-with` specifies text to display when submitting a form. Can be used on `input` or `button` elements. While the form is submitting the text of the element will show the value of `data-turbo-submits-with`. After the submission, the original text will be restored. Useful for giving user feedback by showing a message like "Saving..." while an operation is in progress.
</details>

## 自動的に追加される属性 

次の属性は Turbo が自動的に追加します。ある瞬間の Visit の状態を判断するのに便利です。

* `disabled`は、フォーム送信中、フォームの送信ボタンに追加されます。これは、フォームの再送信を防ぐためです。
* `data-turbo-preview`は、Visit 中に[プレビュー][]を表示しているときに、`html`要素に追加されます。
* `data-turbo-visit-direction`は、Visit 中に`html`要素に追加されます。この属性の値には、`forward`、`back`、`none`のいずれかが入ります。これらは、Visitの方向を表しています。
* `aria-busy`は、ページ遷移中、`html`要素と`turbo-frame`要素に追加されます。

[プレビュー]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/building/#previewが表示しているかどうかの検出

<details>
<summary>原文</summary>

The following attributes are automatically added by Turbo and are useful to determine the Visit state at a given moment.

* `disabled` is added to the form submitter while the form request is in progress, to prevent repeat submissions.
* `data-turbo-preview` is added to the `html` element when displaying a [preview](/handbook/building#detecting-when-a-preview-is-visible) during a Visit.
* `data-turbo-visit-direction` is added to the `html` element during a visit, with a value of `forward` or `back` or `none`, to indicate its direction.
* `aria-busy` is added to `html` and `turbo-frame` elements when a navigation is in progress.
</details>

## メタタグ

次の`meta`要素を`head`要素に追加することで、キャッシュや Visit の振る舞いをカスタマイズできます。

* `<meta name="turbo-cache-control">`で、[キャッシュのオプトアウト][]ができます。
* `<meta name="turbo-visit-control" content="reload">`で、Turbo でページ遷移するたびに、全ページリロードします。これは、`<turbo-frame>`からリクエストした時も同様です。
* `<meta name="turbo-root">`で、[Turbo ドライブを適用するルートロケーションを設定][]できます。
* `<meta name="view-transition" content="same-origin">`により、[View Transition API][]をサポートしているブラウザでビュートランジションが動きます。
* `<meta name="turbo-refresh-method" content="morph">`で、[モーフィングによるページ更新][]が使えます。
* `<meta name="turbo-refresh-scroll" content="preserve">`で、[ページ更新時にスクロールの位置を保存][]します。

[キャッシュのオプトアウト]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/building/#キャッシュのオプトアウト
[Turbo ドライブを適用するルートロケーションを設定]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/drive/#ルートロケーションの設定
[View Transition API]: https://caniuse.com/view-transitions
[モーフィングによるページ更新]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/page_refreshes
[ページ更新時にスクロールの位置を保存]: https://everyleaf.github.io/hotwire_ja/turbo/handbook/page_refreshes

<details>
<summary>原文</summary>

The following `meta` elements, added to the `head`, can be used to customize caching and Visit behavior.

* `<meta name="turbo-cache-control">` to [opt out of caching](/handbook/building#opting-out-of-caching).
* `<meta name="turbo-visit-control" content="reload">` will perform a full page reload whenever Turbo navigates to the page, including when the request originates from a `<turbo-frame>`.
* `<meta name="turbo-root">` to [scope Turbo Drive to a particular root location](/handbook/drive#setting-a-root-location).
* `<meta name="view-transition" content="same-origin">` to trigger view transitions on browsers that support the [View Transition API](https://caniuse.com/view-transitions).
* `<meta name="turbo-refresh-method" content="morph">` will configure [page refreshes with morphing](/handbook/page_refreshes.html).
* `<meta name="turbo-refresh-scroll" content="preserve">` will enable [scroll preservation during page refreshes](/handbook/page_refreshes.html).
</details>
