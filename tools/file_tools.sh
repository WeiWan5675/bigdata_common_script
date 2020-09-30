#!/bin/bash

source ${SCRIPT_HOME}/env/common_setting.sh

############################################################
#
#       功能描述: 文件压缩处理脚本
#       修改者: 肖振男
#       修改时间: 2019.1.7
#       版本: v1.o
#
#
#
#############################################################


#--------------------------------------------------------------------

compress()
{
out_dir="${3}"
tar cvf - "${1}" | pigz -9 -p 24 > "${2}".tgz
if  [ ! -n "$out_dir" ] ;then
    out_dir="$TMP_DIR/compress_out"
    logger_info "没有指定输出目录,输出到临时目录: $TMP_DIR"
else
    logger_info "输出到指定目录: ${3}"
fi

mv #TODO 此处需要完善

}

sed_one_line(){
  sed -i '1d' "${@:1}"
}

case "$1" in
	"compress")
		compress "${2}" "${3}" "${4}"
	;;
	"sed_one_line")
		sed_one_line "${@:2}"
	;;
	*)
		exit
esac
