# About

千葉県の地域別の詳細感染者統計(Excelファイル) をCSVに変換し、かつ地域別の日時感染者集計値を出力するスクリプトです。

# Requirement

* POSIX互換なシェル, e.g. GNU Bash (1)
* curl (1)
* python >= 3.8
* pandas >= 1.1.3  (debian derivatives: python3-pandas >= 1.1.3)
* xlrd >= 1.2.0 (debian derivatives: python3-xlrd >= 1.2.0)

上記以外のバージョンは動作保証の対象外となります。

# Run

読み書き権限のあるディレクトリ内で `conv.sh` を実行してください。詳細な利用方法はお問い合わせください。

# Testing

本スクリプトは、変換後のデータ形式のみをテスト対象としています。
conv.py へのコミットを行う場合には、生成データ(data.csv, data-analyzed.csv) の形式を検証頂きますようお願いします。

データ形式テストには [shellspec](@shellspec/shellspec) と GNU grep (1) が必要です。

# Credit

千葉県庁公式のコロナ統計公表ページ：[「新型コロナウイルス感染症患者等の県内発生状況について」](https://www.pref.chiba.lg.jp/shippei/press/2019/ncov-index.html)のページ内リンクより取得したxlsxファイルを利用しています。
感染症対策に尽力されている行政職員、医療従事者の皆様に心より敬意を表します。

`fixture`配下のテスト用データについては千葉県の公表統計に属するため、CC-BY-4.0 にてライセンス[されます](https://www.pref.chiba.lg.jp/seisaku/toukeidata/opendata/riyoukiyaku.html)。
`fixture`配下を除く本リポジトリの素材はCC-BY-SA-4.0 にて Conv4Japan Contributor によりライセンスされます。
