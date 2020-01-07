#!/bin/bash
if [ $# -ge 2 ]; then
    datebeg=$1
    dateend=$2
else
    echo "请输入开始时间和结束日期，格式为yyyy-MM-dd"
    exit 1
fi
split=$3
if [ ! -n "$split" ]; then
split="-"
#echo "使用默认分隔符"
fi

beg_s=`date -d "$datebeg" +%s`
end_s=`date -d "$dateend" +%s`

#echo "处理时间范围：$beg_s 至 $end_s"

while [ "$beg_s" -le "$end_s" ];do
    day=`date -d @$beg_s +"%Y$split%m$split%d"`;
    echo "$day"
    beg_s=$((beg_s+86400));
done

#echo "日期全部处理完成!"


