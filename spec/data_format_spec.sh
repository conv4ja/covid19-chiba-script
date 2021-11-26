#!/bin/sh

data=data.csv
lines=$(cat $data | wc -l)

Describe CSVカラム構造は
	It 行頭を１つのみ含む
		When call egrep -c "^(I_)?[[:digit:]]" $data
		The output should eq $(expr $lines - 1)
	End
	It すべての行が7列のセルで構成される
		When call egrep -c "([^,]*,){6}" $data
		The output should eq $lines
	End
	It 行頭以外のすべての行において、１列目は感染者IDである
		When call egrep -c \^\(I_\)\?\[0-9\]\+, $data
		The output should eq $(expr $lines - 1)
	End
	It 無症状病原体保有者の「発症日」フィールドについては、全て空セル（半角-）である
		When call echo $(egrep  \^I_\[0-9\]\+, $data | cut -d , -f 6 | egrep -vc \^-\$)
		The output should eq 0
		The status should eq 0
	End
	It すべてのセルが値を含む （空セルは半角-）
		When call grep -c ,, $data 
		The output should eq 0
		The status should eq 1
	End
End

##エクセル行番号から目視で算出 (感染者番号が連番でないことによる代替措置)
holder=$(expr 7046 - 3 + 1)
pat=$(expr 38528 - 5 - 1 + $holder)
excluded=10

Describe 7月25日時点でのデータのうち
	It 検査陽性登録数は$pat件である
		When call egrep -c "^(I_)?[0-9]+," $data
		The line 1 of output should eq $pat
	End
	It 無症状病原体保有者の登録数は$holder件である
		When call egrep -c "^I_[0-9\]+," $data
		The line 1 of output should eq $holder
	End
End
