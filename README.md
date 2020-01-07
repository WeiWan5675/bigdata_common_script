# <center>数据仓库工具脚本封装以及目录规划</center>



---

[TOC]





## 简介

对大数据相关常用的命令进行封装,满足日常工作中进行数据处理的需求。

并且提供了一些常用的功能进行了封装，比如说获取时间区间工具，按指定分隔符截取字符串，加载配置文件，shell日志输出规范等。



## 目录结构



```
.
├── bin                                                    //任务脚本
│   └── project                                            //项目任务
├── conf                                                   //配置目录
│   ├── db_conf                                            //数据库配置
│   │   └── mysql.properties                               //mysql配置文件
│   └── sql_file                                           //sql文件目录
│       └── a.sql                                          //sql文件
├── env                                                    //脚本环境目录
│   └── common_setting.sh                                  //通用环境设置
├── init.sh                                                //初始化脚本
├── lib                                                    //依赖目录
├── logs                                                   //日志目录
│   └── init.log                                           //日志
├── run_test.sh                                            //环境测试脚本
├── script_template                                        //模板脚本
├── tmp                                                    //临时目录
└── tools                                                  //工具目录
    ├── build_date_list.sh                                 //获取时间区间工具
    ├── hbase_tools.sh                                     //hbase操作
    ├── hdfs_tools.sh                                      //hdfs操作
    ├── hive_tools.sh                                      //hive操作
    ├── kafka_tools.sh                                     //kafka操作
    ├── scp.sh                                             //分发文件
    ├── split_str.sh                                       //切割字符串
    ├── sqoop_export_tools.sh                              //sqoop导出
    ├── sqoop_import_tools.sh                              //sqoop导入
    └── ssh.sh                                             //多节点执行命令
```



## 工具说明

* **common_settion.sh**

  设置通用环境变量，包括SCRIPT_HOME，TMP_HOME，TOOLS_HOME等，同时声明日志输出方法

  

* 定义的环境变量
```
#定义环境相关
export SCRIPT_HOME=$(cd `dirname ./`; pwd)
#临时目录
export TMP_DIR=$SCRIPT_HOME/tmp
#日志目录
export LOG_DIR=$SCRIPT_HOME/logs
#工具目录
export TOOLS_DIR=$SCRIPT_HOME/tools
#配置目录
export CONF_DIR=$SCRIPT_HOME/conf
#环境目录
export ENV_DIR=$SCRIPT_HOME/env
#外部依赖目录
export LIB_DIR=$SCRIPT_HOME/lib

```


* 定义的方法

```
loggger_info 	//传入要输出的日志

logger_err		//传入要输出的错误信息

logger_warn		//传入要输出的警告信息
```

* 使用方法

  通过 source $ENV_DIR/common_setting.sh 引用相关环境



* **run_test.sh**

  用来测试脚本环境是否正常，直接运行输出当前脚本环境变量，以及系统相关信息等。

  

* **build_date_list.sh**

  | 参数顺序 | 示例       | 是否可选 | 备注     |
  | -------- | ---------- | -------- | -------- |
  | 参数一   | yyyy-MM-dd | N        | 开始时间 |
  | 参数二   | yyyy-MM-dd | N        | 结束时间 |
  | 参数三   | -          | Y        | 分隔符   |



* **hbase_tools.sh**

  hbase操作脚本，封装了如创建表，清空表，删除表，添加表属性，压缩表，开启关闭负载均衡器，get，scan等操作



* **hdfs_tools.sh**

  hdfs操作脚本,封装了如上传下载文件,创建删除目录,以及dfsadmin相关的一些命令


| 命令名称   | 操作             | 是否有可选参数 | 备注                                                         | 示例                                                     |
| ---------- | ---------------- | -------------- | ------------------------------------------------------------ | -------------------------------------------------------- |
| get_file   | 从HDFS下载文件   | Y              | 参数一:HDFS路径<br />参数二:本地目标路径<br />参数三[可选]:是否合并文件 | hdfs_tools.sh get_file /sourcepath /targetpath \[merge\] |
| put_file   | 从本地上传文件   | N              | 参数一:本地路径<br />参数二:HDFS路径                         | hdfs_tools.sh put_file /loacalpath /targetpath           |
| del_file   | 从HDFS删除       | N              | 参数一:HDFS路径                                              | hdfs_tools.sh del_file /delpath                          |
| create_dir | 创建HDFS目录     | N              | 参数一:HDFS路径(可以是多级目录)                              | hdfs_tools.sh create_dir /new_path                       |
| copy_dir   | 复制HDFS文件     | N              | 参数一:HDFS源目录<br />参数二:HDFS目标目录(目标目录不能存在) | hdfs_tools.sh copu_dir /source_path /target_path         |
| look_usage | 查看DHFS使用量   | Y              | 参数一[可选]:要查看的HDFS目录                                | hdfs_tools.sh look_usage [/look_path]                    |
| report     | 查看hdfs集群状态 | N              | 无                                                           | hdfs_tools.sh report                                     |
| safemode   | HDFS安全模式操作 | N              | 参数一[可选]:enter<br />参数二[可选]:leave<br />参数三[可选]:get<br />参数四[可选]:wait | hdfs_tools.sh [enter] \[leave\] \[get\]\[wait\]          |



* **hive_tools.sh**

| 命令名称          | 操作           | 是否有可选参数 | 备注                                                         | 示例                                                         |
| ----------------- | -------------- | -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| executor_sql_file | 执行sql文件    | Y              | 参数二传入sql文件路径<br />参数三[可选] 传入参数值           | hive_tools.sh executor_sql_file home/sql.sql a=a,b=b         |
| executor_sql      | 执行sql        | N              | sql字符串(需要在sql中约束数据库)                             | hive_tools.sh executor_sql sql字符串                         |
| truncate_table    | 执行truncate表 | N              | 参数二传入数据库名<br />参数三传入数据库表名                 | hive_tools.sh truncate_table database table                  |
| drop_table        | 删除表         | N              | 参数二传入数据库名<br />参数三传入数据表名                   | hive_tools.sh drop_table database table                      |
| drop_partition    | 删除表分区     | N              | 参数二传入数据库名<br />参数三传入数据表名<br />参数四传入分区条件 | hive_tools.sh drop_partition database table day=2019-12-21   |
| create_table      | 创建表         | Y              | 参数二传入数据库名<br />参数三传入建表语句或建表文件         | hive_tools.sh exec_create_table [sql\] [sqlfile]             |
| import_data       | 导入数据       | N              | 参数二传入数据库名<br />参数三传入数据表名<br />参数四传入数据文件路径 | hive_tools.sh import_data database table data_path           |
| export_data       | 导出数据       | N              | 参数二传入数据库名<br />参数三传入导出文件路径<br />参数四传入导出SQL | hive_tools.sh export_data database /home/export.dat selectSql |



* **kafka_tools.sh**

  封装了一些如topic创建删除,命令行消费相关的操作,因为kafka没有特别需要命令行操作的工作,所以简单封装一下就可以了

  | 命令名称 | 操作                        | 是否有可选参数 | 备注                                                         | 示例                                                       |
  | -------- | --------------------------- | -------------- | ------------------------------------------------------------ | ---------------------------------------------------------- |
  | list     | 查看kafkaTopic              | N              | 无                                                           | kafka_tools.sh list                                        |
  | pull     | 消费某个topic(默认消费组)   | N              | 参数:topic                                                   | kafka_tools.sh pull topicName                              |
  | push     | 向某个topic生产数据从控制台 | N              | 参数:topic                                                   | kafka_tools.sh push topicName                              |
  | delete   | 删除某个topic               | N              | 参数:topic                                                   | kafka_tools.sh delete topicName                            |
  | create   | 创建topic                   | Y              | 参数一:topicName<br />参数二[可选]:副本数<br />参数三[可选]:分区数 | kafla_tools.sh create topicName [replication\] \[partions] |

  

* **sqoop_export.sh**

  

* **sqoop_import.sh**

  sqoop导入工具脚本

* **split_str.sh**

| 参数   | 是否可选 | 示例                  | 备注                     |
| ------ | -------- | --------------------- | ------------------------ |
| 参数一 | N        | "aaa,bbbbb,cccc,dddd" | 按指定分隔符分割的字符串 |
| 参数二 | Y        | ,\|.\|-               | 分隔符                   |

* ssh.sh

  多台机器一次性执行某些命令

  ```
  for node in $nodes
  do
  ssh -tt $node << EOF
  	echo "测试"
  exit
  EOF
  done
  
  ```

  

* scp.sh

  多台机器分发文件

  ```
  for node in $nodes
  do
          echo "开始推送${node}"
          scp -r $1 hdata@${node}:$2
  done
  
  ```

  

## 其它



还有一些其它的工具,会陆陆续续封装出来,在进行新的数据需求开发时,能够减少这些重复的工作内容,同时也使大数据脚本更容易维护,对于后期平台化能够起到一个支撑作用。