#!/usr/bin/python3
# conv.py
# [千葉県用] Covid19 感染者統計変換スクリプト
# 
# 
## 概要
##
## [基本処理]
##
## 1. pandas 変換: sheet1 については6行目以降、sheet2については 2行目以降を表頭＋データ範囲として切り出し
## -> この時点で改行コード、カンマ、NaNなど汎用CSVとして不正文字となりうるものを除去
## 2. 生CSV出力: RAW
## 3. 文字列一括変換:  同意なし・調査中・非公表 <-- 検査確定日以外のフィールドで - (ND) に変換
## 4. 発症日/検査確定日変換: [1] int -> 初感染日起点でtimedelta [2] datetime -> ISO8601 [3] ND -> 前段の値として置換 
## 5. マスタCSV出力: 
## -> この時点で不正文字を含まない、検査確定日がISO8601形式で正規化されたCSVが得られる
## (発症日については未確定日の正規化を行わない)

## [地域別集計]
##
## 6. 個別地域集計: 「居住地」フィールドをもとに地域別感染者の時系列データフレームを生成、listに格納
## 7. マージ: pd.concat
## 8. 合計値の追加: 各地域感染者数の合計値を日次集計
## 9. 集計済CSV出力
## -> 地域別の検査確定陽性者数を含む時系列感染者データ。感染者不在の日付は行そのものが存在しないことに注意。
##

import pandas as pd
import numpy as np
from datetime import date, time, datetime, timedelta
from math import nan
import sys, re, pathlib

## 不定形の日付値を整形 (正規化1)
def date_conv(d):
    if type(d) == type(1):
        base_date_det = date(2020,1,31) #初感染日
        base_seq_det = 43861            #初感染日int
        delta_det = d - base_seq_det
        d = base_date_det + timedelta(days = delta_det)
    elif type(d) == type(datetime(2020,2,2)):
        d = d.date()
    elif d == "--":
        d = nan
    return d

## 日付正規化 (正規化2)
def date_normarize(df, ffill=True):
    df = df.replace("不明","--")
    df = df.replace("非公表","--")
    df = df.replace("同意なし","--")
    df = df.replace("調査中","--")
    df = df.apply(date_conv)
    df = df.ffill() ##fill front
    return df

## 地域別集計
## 市町村ごとの日次感染者数＆合計数を計算し、pandas.DataFrameを返す
def analyze(df):
    df_anal = []
    df_sum = False
    for i in df["居住地"].unique():
        df_atom = df[df["居住地"] == i].groupby("検査確定日").agg({"検査確定日": (lambda n: (np.size(n)-1))})
        df_atom.columns = [i]
        df_anal.append(df_atom)
    result = pd.concat(df_anal, axis=1, sort=True).fillna(0)
    result["合計"] = result.sum(axis=1)

    return result

def usage():
    print(
    "conv.py - [千葉県用] 感染者データxslx 前処理スクリプト\n",
    "version: 0.1.0\n",
    "author: Nomura Suzume <suzume315[at]g00.g1e.org>\n",
    "usage: conv.py <hoge.xlsx>",
    )


def main():
    if len(sys.argv) < 2:
        usage()
        sys.stderr.write("エラー: xlsxファイルを引数として指定してください。\n")
        sys.exit(1)
    elif sys.argv[1] == ("-h" or "--help"):
        usage()
        sys.exit(0)
    elif pathlib.Path(sys.argv[1]).is_file() != True:
        sys.stderr.write("エラー: ファイル 「{}」 は存在しません。\n".format(sys.argv[1]))
        sys.exit(1)

    df1= pd.read_excel(sys.argv[1],header=5,sheet_name=0)
    df1 = df1[df1["年代"].notna()]

    df2= pd.read_excel(sys.argv[1],header=1,sheet_name=1)
    df2 = df2[df2["年代"].notna()]
    df2["No."] = df2["No."].apply(lambda x: re.compile(r'^').sub("I_",str(x),1) )  ##無症状陽性者
    df2["発症日"] = df2["No."].apply(lambda x: "-")

    data = pd.concat([df1,df2], sort=False)
    data = data.fillna("-")
    data["区分"] = data["区分"].apply(lambda x: re.compile('[,　\n ]').sub('、',x,1000))
    data.to_csv("./data-raw.csv")

    data["発症日"] = date_normarize(data["発症日"], ffill=False)
    data["検査確定日"] = date_normarize(data["検査確定日"])
    data.sort_values( by=['検査確定日'] )
    data.to_csv("./out/data.csv")

    resional_data = analyze(data)
    resional_data.to_csv("./out/chiba-plain.csv")

    resional_7d_mean = resional_data.rolling(window=7).mean()
    resional_7d_mean.to_csv("./out/chiba-7d-mean.csv")

main()
