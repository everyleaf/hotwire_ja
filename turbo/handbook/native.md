---
title: "iOS と Android をネイティブにやる"
description: "Turbo ネイティブは、モノリシック構造をネイティブのiOSおよびAndroidアプリの中心とし、ウェブとネイティブのセクション間でシームレスな遷移を実現します。"
order: 6
commit: "0b2c287"
---

# iOS と Android をネイティブにやる

iOS のための Turbo ネイティブは、 Turbo 対応の Web アプリケーションをネイティブな iOS のシェルにラップするためのツールを提供します。そのツールは複数の View Controller にまたがった単一の WKWebView インスタンス(※1)を管理し、 Turbo によって最適化されたクライアントサイドのパフォーマンスを備えたネイティブなナビゲーション UI を提供します。詳細は <a href="https://github.com/hotwired/turbo-ios">Turbo Native: iOS</a> をご覧ください。

Android のための Turbo ネイティブも、複数のデスティネーションにまたがった単一の WebView のインスタンスを管理するための同様のツールを提供します。詳細は <a href="https://github.com/hotwired/turbo-android">Turbo Native: Android</a> をご覧ください。

ネイティブアダプタで何ができるのか調べるのに最も良い方法は、デモのネイティブアプリケーションを設定してみることです。 [iOS 用](https://github.com/hotwired/turbo-ios/blob/main/Demo/README.md)と [Android 用](https://github.com/hotwired/turbo-android/blob/main/demo/README.md)を用意しています。手元のネイティブ環境でコードを開いてみて、すべての機能を試してみてください。

-----
※1: [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview) は iOS アプリから WEB ページを見るために利用されるクラスです。

<details>
<summary>原文</summary>

# Go Native on iOS & Android

Hotwire Native for iOS provides the tooling to wrap your Turbo-enabled web app in a native iOS shell. It manages a single WKWebView instance across multiple view controllers, giving you native navigation UI with all the client-side performance benefits of Turbo. See <a href="https://github.com/hotwired/hotwire-native-ios/">Hotwire Native: iOS</a> for more details.

Hotwire Native for Android provides the same kind of tooling, managing a single WebView instance across multiple Fragment destinations. See <a href="https://github.com/hotwired/hotwire-native-android/">Hotwire Native: Android</a> for more details.

The best way to see what's possible with the native adapters is to setup the demo native application. We have one [for iOS](https://native.hotwired.dev/ios/getting-started) and [for Android](https://native.hotwired.dev/android/getting-started). You can open the code in your native environments and follow along to explore all the features.

</details>
