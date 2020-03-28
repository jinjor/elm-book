# 「基礎からわかる Elm」サンプルコード集

[基礎からわかる Elm](https://www.amazon.co.jp/%E5%9F%BA%E7%A4%8E%E3%81%8B%E3%82%89%E3%82%8F%E3%81%8B%E3%82%8B-Elm-%E9%B3%A5%E5%B1%85-%E9%99%BD%E4%BB%8B/dp/4863542224) のサンプルコードです。

## 本書正誤表

### p44

- （誤） `(1 :: (2 :: (3 :: []))`と解釈されます
- （正） `(1 :: (2 :: (3 :: [])))`と解釈されます

### p76

- （誤） showNumbersUntil =\n    String.join \",\" << List.map String.fromInt << List.range 1 max
- （正） showNumbersUntil =\n    String.join \",\" << List.map String.fromInt << List.range 1

### p78

- （誤） `<|`と`|>`は優先順位かつ結合の向きが逆なので、
- （正） `<|`と`|>`は優先順位が同じかつ結合の向きが逆なので、
