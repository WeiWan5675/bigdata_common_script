#!/bin/bash

source $SCRIPT_HOME/env/common_setting.sh

############################################################
#
#       功能描述: 测试sqoop脚本
#       修改者: 肖振男
#       修改时间: 2019.1.7
#       版本: x
#
#
#
#############################################################

#---------------------导出hive--------------------------------------

#sqoop全量导出数据到mysql(直接文件导出方式)
export mysql_conf_file=mysql-test.properties
#$TOOLS_DIR/sqoop_export_tools.sh export_all_file dp_hopsonone_oneservice "test" /user/hive/warehouse/test_common_script.db/ods_test "id,name,amount,flag,create_date,update_date"

#sqoop基于hive分区表进行增量同步数据到mysql
#$TOOLS_DIR/sqoop_export_tools.sh export_incr dp_hopsonone_oneservice "test" test_common_script test_day day "2019-12-01" 

#sqoop导出全量数据到mysql
#$TOOLS_DIR/sqoop_export_tools.sh export_all dp_hopsonone_oneservice "test" test_common_script ods_test




#---------------------导入hive----------------------------------------
#sqoop全量导入数据到hive
#$TOOLS_DIR/sqoop_import_tools.sh import_all test_common_script "ods_test" dp_hopsonone_oneservice "test" 


#sqoop导入数据到hive(执行sql)
#sql1="select id,name,amount,flag,DATE_FORMAT(create_date,'%Y-%m-%d %H:%i:%s') from test;"
#$TOOLS_DIR/sqoop_import_tools.sh import_query_all test_common_script "test_sqoop_query_import" dp_hopsonone_oneservice "test" $sql1

#$TOOLS_DIR/hive_tools.sh truncate_table test_common_script ods_test

#sqoop增量导入到hive(基于更新时间)
#$TOOLS_DIR/sqoop_import_tools.sh import_incr_job test_common_script "ods_test" dp_hopsonone_oneservice "test" "update_date" "2019-01-01 00:00:00"
