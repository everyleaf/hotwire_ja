# 翻訳作業の進め方について
## はじめに
翻訳作業は、このリポジトリをフォークして、フォークしたリポジトリで作業を行ってください。
どのページを翻訳するかは[issues](https://github.com/everyleaf/hotwire_ja/issues)ベースで行います。

「新規翻訳」というラベルのついているissueで着手の宣言を行ってから作業を始めてください。
すでに着手宣言されている、もしくはアサインされているissueしかない場合は、しばらくお待ちください。

レビュワーの対応可能時間が限られているため、新規ページの翻訳に関してはissueベースで活動を行いたいと思っています。

既存の訳文に対する修正PRは随時歓迎いたします。

## 手順
1. このリポジトリをフォークします
2. issueのdescriptionにある翻訳対象のリンクとファイルの設置場所を参考に、mdファイルをブランチに追加します
3. レビュー時のために英文を残しておいてほしいので、原文の１行下に訳文を記述する形でコミットを作ってください（[見本](https://github.com/everyleaf/hotwire_ja/blob/a205170001cdf132abef928a1d9b7abea6293328/turbo/handbook/streams.md?plain=1)）
4. PRを作成する際は該当issueへのリンクと、着手した原文のコミットハッシュをdescriptionに記載の上、レビューに出してください

## 気にしていただきたいこと
- 文中のリンク先について
  - handbook、及びリファレンス内へのリンク
    - 翻訳済みであれば [Github Pages](https://everyleaf.github.io/hotwire_ja/) 内のリンクになるように修正をお願いします
  - 他サイトへのリンク
    - MDNなどで日本語ページがあるようなら、日本語ページへのリンクになるように修正をお願いします
- mdファイル先頭のメタデータについて
    ```
    ---
    permalink: /reference/events.html
    order: 04
    description: "A reference of everything you can do with Turbo Events."
    ---
    ```
  - 上記は [Front Matter Data](https://www.11ty.dev/docs/data-frontmatter/) と呼ばれるもので、Eleventyでビルドする際に必要な情報です。以下の対応をお願いします
    - permalinkの行は削除してください（本家と階層構造が異なるため）
    - titleやdescriptionがある場合は翻訳してください
    - orderはそのまま残すようにしてください。これはリファレンスのページの並び順を指定するためのものです


# PRの応対について
## 体制

限られた時間でPRのレビューを進めております。対応にお時間をいただくことがありますので、ご了承ください。

## 方針

最初のレスポンスを1week以内に、最初のレビューコメントは2weeks以内を目指して対応を進めます。

（年末年始やお盆など、連休の時期はレスポンスが遅くなることがあります）
