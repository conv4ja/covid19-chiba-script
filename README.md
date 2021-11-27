# About

千葉県の地域別の詳細感染者統計(Excelファイル) をCSVに変換し、かつ地域別の日時感染者集計値を出力するスクリプトです。

# Requirement

* POSIX互換なシェル, e.g. GNU Bash (1)
* curl (1)
* python >= 3.8
* pandas >= 1.1.3  (debian derivatives: python3-pandas >= 1.1.3)
* xlrd >= 1.2.0 (debian derivatives: python3-xlrd >= 1.2.0)

上記以外のバージョンは動作保証の対象外となります。

# Usage

### 取得~変換まで一括

`fetch`を含む全工程を一括で実施する`conv.sh all`が便利です。

サーバに過度な負荷をかけることのないよう、手動で行うことをおすすめします。

```
./conv.sh all
```

### ファイル取得

昨日付で公開された地域別感染者数を含むxlsxファイルを取得します。
サーバに過度な負荷をかけることのないよう、手動で行うことをおすすめします。

```
./conv.sh fetch
```

### 取得ファイルの変換

`conv.sh target FILE` で千葉県の感染者データの解析結果を`out`配下に出力します。
実体としてはconv.py プラグインを呼び出しており、このスクリプトは千葉県専用の実装です。

```
./conv.sh target data/1013kansensya.xslx
```


# Testing

本スクリプトは、変換後のデータ形式のみをテスト対象としています。
conv.py へのコミットを行う場合には、生成データ(data.csv, data-analyzed.csv) の形式を検証頂きますようお願いします。

データ形式テストには [shellspec](@shellspec/shellspec) と GNU grep (1) が必要です。

データの正確性については、現時点で十分に確認できていません。ご協力いただける方はイシューを立てていただけますでしょうか。

# Credit

千葉県庁公式のコロナ統計公表ページ：[「新型コロナウイルス感染症患者等の県内発生状況について」](https://www.pref.chiba.lg.jp/shippei/press/2019/ncov-index.html)のページ内リンクより取得したxlsxファイルを利用しています。
感染症対策に尽力されている行政職員、医療従事者の皆様に心より敬意を表します。

`fixture`配下のテスト用データについては千葉県の公表統計に属するため、CC-BY-4.0 にてライセンス[されます](https://www.pref.chiba.lg.jp/seisaku/toukeidata/opendata/riyoukiyaku.html)。
`fixture`配下を除く本リポジトリの素材はCC-BY-SA-4.0 にて Conv4Japan Contributor によりライセンスされます。
