---
title: Using Typescript
description: "Stimulusの各プロパティの型を定義する方法について"

---

# Typescriptを使う

Stimulus自体は[TypeScript](https://www.typescriptlang.org/)で記述されており、そのパッケージ上で直接型を提供します。 このドキュメントでは、Stimulusプロパティの型を定義する方法を示します。

<details>
    <summary>原文</summary>
Stimulus itself is written in [TypeScript](https://www.typescriptlang.org/) and provides types directly over its package.
The following documentation shows how to define types for Stimulus properties.
</details>

## コントローラ要素の型を定義する

デフォルトでは、コントローラー要素は`Element型`です。 コントローラ要素の型をオーバーライドするには、[Generic Type](https://www.typescriptlang.org/docs/handbook/2/generics.html)を指定します。 たとえば、要素の型を`HTMLFormElement`とすることを想定している場合は次のようにします。

```ts
import { Controller } from "@hotwired/stimulus"

export default class MyController extends Controller<HTMLFormElement> {
  submit() {
    new FormData(this.element)
  }
}
```

<details>
    <summary>原文</summary>
By default, the `element` of the controller is of type `Element`. You can override the type of the controller element by specifiying it as a [Generic Type](https://www.typescriptlang.org/docs/handbook/2/generics.html). For example, if the element type is expected to be a `HTMLFormElement`:

```ts
import { Controller } from "@hotwired/stimulus"

export default class MyController extends Controller<HTMLFormElement> {
  submit() {
    new FormData(this.element)
  }
}
```
</details>

## Valueプロパティの型定義

valuesの各プロパティは、Stimulusによって自動生成されるのでそれを上書きしないよう`declare`キーワードを使用して型定義します。

```ts
import { Controller } from "@hotwired/stimulus"

export default class MyController extends Controller {
  static values = {
    code: String
  }

  declare codeValue: string
  declare readonly hasCodeValue: boolean
}
```

> declareキーワードは、既存のStimulusプロパティのオーバーライドを回避し、TypeScriptの型を定義します。

<details>
    <summary>原文</summary>
You can define the properties of configured values using the TypeScript `declare` keyword. You just need to define the properties if you are making use of them within the controller.

```ts
import { Controller } from "@hotwired/stimulus"

export default class MyController extends Controller {
  static values = {
    code: String
  }

  declare codeValue: string
  declare readonly hasCodeValue: boolean
}
```

> The `declare` keyword avoids overriding the existing Stimulus property, and just defines the type for TypeScript.
</details>

## Targetプロパティの型定義

ターゲットの各プロパティは、Stimulusによって自動生成されるのでそれを上書きしないよう`declare`キーワードを使用して型定義します。

`[name]Target`および`[name]Targets`プロパティの戻り値の型は、`Element型`を継承したものであれば何でも構いません。 その時々に合った最適な型をお選びください。 汎用HTML要素として定義する場合は、`Element`または`HTMLElement`を使います。

```ts
import { Controller } from "@hotwired/stimulus"

export default class MyController extends Controller {
  static targets = [ "input" ]

  declare readonly hasInputTarget: boolean
  declare readonly inputTarget: HTMLInputElement
  declare readonly inputTargets: HTMLInputElement[]
}
```

> declareキーワードは、既存のStimulusプロパティのオーバーライドを回避し、TypeScriptの型を定義します。

<details>
    <summary>原文</summary>
You can define the properties of configured targets using the TypeScript `declare` keyword. You just need to define the properties if you are making use of them within the controller.

 The return types of the `[name]Target` and `[name]Targets` properties can be any inheriting from the `Element` type. Choose the best type which fits your needs. Pick either `Element` or `HTMLElement` if you want to define it as a generic HTML element.

```ts
import { Controller } from "@hotwired/stimulus"

export default class MyController extends Controller {
  static targets = [ "input" ]

  declare readonly hasInputTarget: boolean
  declare readonly inputTarget: HTMLInputElement
  declare readonly inputTargets: HTMLInputElement[]
}
```

> The `declare` keyword avoids overriding the existing Stimulus property, and just defines the type for TypeScript.
</details>

## カスタムプロパティやメソッドの型定義

その他のカスタムなプロパティは、コントローラクラスにTypeScriptのやり方で直接定義することができます：

```ts
import { Controller } from "@hotwired/stimulus"

export default class MyController extends Controller {
  container: HTMLElement
}
```

詳細については、[TypeScriptドキュメント](https://www.typescriptlang.org/docs/handbook/intro.html)を参照してください。

<details>
    <summary>原文</summary>
Other custom properties can be defined the TypeScript way on the controller class:

```ts
import { Controller } from "@hotwired/stimulus"

export default class MyController extends Controller {
  container: HTMLElement
}
```

Read more in the [TypeScript Documentation](https://www.typescriptlang.org/docs/handbook/intro.html).
</details>
