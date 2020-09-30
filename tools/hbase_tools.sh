#!/bin/bash

source ${SCRIPT_HOME}/env/common_setting.sh

############################################################
#
#	功能描述: hbase工具脚本
#	修改者: 肖振男
#	修改时间: 2019.1.3
#	版本: v1.0
#
#
#
#############################################################


get_row()
{
table_name="$1"
family_name="$2"
row_key="$3"
column="$4"
colstr="get '$table_name','$row_key','$family_name'"
if [ -n "$family_name" ];then

colstr=$colstr",'$family_name'"
	if [ -n "$column" ];then
		colstr=$colstr",'"$family_name":"$column"'"
	fi 
fi
hbase shell << EOF
get $colstr
EOF


}


scan_table()
{
table_name="$1"
family_name="$2"
start_key="$3"
end_key="$4"
hbase shell << EOF



EOF
}


create_table()
{
create_file="$1"
hbase shell $create_file
}


disable_table()
{
table_name="$1"
hbase shell << EOF
disable $table_name
EOF
}




drop_table()
{
hbase shell  << EOF

disable $table_name;
drop $table_name;

EOF
}


count_table()
{
table_name="$1"
hbase shell << EOF
count '$table_name'
EOF
}


enable_table()
{
table_name="$1"
hbase shell << EOF

enable '$table_name'

EOF
}



case "$1" in
	"get_row")
	get "$2" "$3" "$4" "$5"
;;
	"scan_table")
	scan_table "$2" "$3" "$4" "$5"
;;
	"create_table")
	create_tablle "$2"
;;
	"disable_table")
	disable_table $$2
;;
	""
