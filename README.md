# 「基礎からわかる Elm」サンプルコード集

[基礎からわかる Elm](https://www.amazon.co.jp/%E5%9F%BA%E7%A4%8E%E3%81%8B%E3%82%89%E3%82%8F%E3%81%8B%E3%82%8B-Elm-%E9%B3%A5%E5%B1%85-%E9%99%BD%E4%BB%8B/dp/4863542224) のサンプルコードです。

## 本書正誤表

### p39

- （誤） ラムダ記号(`λ`、`\`)を使って記述します。
- （正） ラムダ記号(`\`)を使って記述します。

elm 0.19 から `λ` 記号が使えなくなったようです。

### p44

- （誤） `(1 :: (2 :: (3 :: []))`と解釈されます
- （正） `(1 :: (2 :: (3 :: [])))`と解釈されます

### p76

（誤）
```elm
showNumbersUntil =
    String.join "," << List.map String.fromInt << List.range 1 max
```
（正）
```elm
showNumbersUntil =
    String.join "," << List.map String.fromInt << List.range 1
```

### p78

- （誤） `<|`と`|>`は優先順位かつ結合の向きが逆なので、
- （正） `<|`と`|>`は優先順位が同じかつ結合の向きが逆なので、

### p88

（誤）
```elm
List.map toString [1,2,3]
```
（正）
```elm
List.map String.fromInt [1,2,3]
```

### p93

#### Set

（誤）
```elm
Set.length set -- 3
```
（正）
```elm
Set.size set -- 3
```

#### Array

（誤）
```elm
Array.get 0 -- Just "one"

Array.get 3 -- Nothing
```
（正）
```elm
Array.get 0 array -- Just "one"

Array.get 3 array -- Nothing
```

### p135

（誤）
```elm
decodeString (at ["person", "age" ] int   ) json == Ok "42
```
（正）
```elm
decodeString (at ["person", "age" ] int   ) json == Ok 42
```

### p154

（誤）
```elm
view : Html msg
view model =
...
```
（正）
```elm
view : Model -> Html msg
view model =
...
```

p156からp159にかけて、同様に型注釈が誤っている箇所が複数あります。

### p168

- （誤）詳細は《Task》(p150)を参照してください。
- （正）詳細は《Browser.applicationの制約》(p186)を参照してください。

### p187

- （誤）hhtps://github.com/elm/browser/blob/master/src/Elm/Kernel/Browser.js
- （正）https://github.com/elm/browser/blob/master/src/Elm/Kernel/Browser.js

### p191

（誤）
```elm
import Url.Parser exposing ((</>), (<?>), s, int, top, map)
```
（正）
```elm
import Url.Parser exposing ((</>), (<?>), Parser, int, map, oneOf, s, top)
```

### p192

（誤）
```elm
type Route
    = Top
    | Login
    | Articles (Maybe String)
    | ArticleSettings Int
```
（正）
```elm
type Route
    = Top
    | Login
    | Articles (Maybe String)
    | Article Int
    | ArticleSettings Int
```
※上記の記述はp191〜p192に跨っています


---

（誤）
```elm
urlToRoute url =
    Url.Parser.perse routeParser url
```
（正）
```elm
urlToRoute url =
    Url.Parser.parse routeParser url
```
