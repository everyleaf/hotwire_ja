---
title: "iOS と Android をネイティブにやる"
description: "Turbo ネイティブは、モノリシック構造をネイティブのiOSおよびAndroidアプリの中心とし、ウェブとネイティブのセクション間でシームレスな遷移を実現します。"
order: 6
commit: "8849e6b"
---

# iOS と Android をネイティブにやる

iOS のための Turbo ネイティブは、 Turbo 対応の Web アプリケーションをネイティブな iOS のシェルにラップするためのツールを提供します。そのツールは複数の View Controller にまたがった単一の WKWebView インスタンス(※1)を管理し、 Turbo によって最適化されたクライアントサイドのパフォーマンスを備えたネイティブなナビゲーション UI を提供します。詳細は <a href="https://github.com/hotwired/turbo-ios">Turbo Native: iOS</a> をご覧ください。

Android のための Turbo ネイティブも、複数のデスティネーションにまたがった単一の WebView のインスタンスを管理するための同様のツールを提供します。詳細は <a href="https://github.com/hotwired/turbo-android">Turbo Native: Android</a> をご覧ください。

ネイティブアダプタで何ができるのか調べるのに最も良い方法は、デモのネイティブアプリケーションを設定してみることです。 [iOS 用](https://github.com/hotwired/turbo-ios/blob/main/Demo/README.md)と [Android 用](https://github.com/hotwired/turbo-android/blob/main/demo/README.md)を用意しています。手元のネイティブ環境でコードを開いてみて、すべての機能を試してみてください。

-----
※1: [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview) は iOS アプリから WEB ページを見るために利用されるクラスです。
