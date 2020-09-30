# <center>数据仓库工具脚本封装以及目录规划</center>



---

[TOC]





## 简介

​	对大数据相关常用的命令进行封装,满足日常工作中进行数据处理的需求。

​	并且提供了一些常用的功能进行了封装，比如说获取时间区间工具，按指定分隔符截取字符串，加载配置文件，shell日志输出规范等。



## 目录结构



```
.
├── bin														//可执行脚本目录
│   ├── project												//子项目可执行目录
│   └── test												//测试脚本目录
├── conf													//配置目录
│   ├── db_conf												//数据库配置文件目录
│   │   └── mysql-test.properties
│   └── sql_file											//sql文件
│       └── create_sql										//建表语句
├── env														//脚本环境相关
│   └── common_setting.sh									//通用环境设置
├── init.sh													//初始化脚本
├── lib														//外部依赖目录
├── logs													//日志目录
├── README.md												//readme
├── script_template.sh										//脚本模板
├── tmp														//临时目录
└── tools													//工具目录
    ├── build_date_list.sh
    ├── date_tools.sh
    ├── find_file.sh
    ├── hbase_tools.sh
    ├── hdfs_tools.sh
    ├── hive_tools.sh
    ├── kafka_tools.sh
    ├── load_db_conf.sh
    ├── replace_str.sh
    ├── scp.sh
    ├── split_str.sh
    ├── sqoop_export_tools.sh
    ├── sqoop_import_tools.sh
    └── ssh.sh
```



## 封装的工具

### 工具列表

| 脚本名称              | 用途            | 备注         |
| --------------------- | --------------- | ------------ |
| build_date_list.sh    | 获取时间列表    |              |
| date_tools.sh         | 日期工具        |              |
| find_file.sh          | 查找文件        |              |
| hbase_tools.sh        | hbase操作       |              |
| hdfs_tools.sh         | hdfs操作        |              |
| hive_tools.sh         | hive操作        |              |
| kafka_tools.sh        | kafka操作       |              |
| load_db_conf.sh       | 加载数据库配置  |              |
| replace_str.sh        | 替换字符串      | 文本或者文件 |
| scp.sh                | 分发文件        |              |
| split_str.sh          | 切割字符串      |              |
| sqoop_export_tools.sh | 导出数据到mysql |              |
| sqoop_import_tools.sh | 导入数据到hive  |              |
| ssh.sh                | 分发命令        |              |



### 工具介绍

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


* **build_date_list.sh**

  获得一个时间区间,方便进行需要遍历日期的时候获取日期序列

  | 参数顺序 | 示例       | 是否可选 | 备注     |
  | -------- | ---------- | -------- | -------- |
  | 参数一   | yyyy-MM-dd | N        | 开始时间 |
  | 参数二   | yyyy-MM-dd | N        | 结束时间 |
  | 参数三   | -          | Y        | 分隔符   |

  

* **date_tools.sh**

  获取日期相关的方法

  ​	today: 获得今天日期

  ​	yesterday: 获得昨天日期

  ​	tomorrow: 获得明天日期

  

* **find_file.sh**

  直接传入目录,输入要查找的文件

  

* **hbase_tools.sh**

  hbase操作脚本，封装了如创建表，清空表，删除表，添加表属性，压缩表，开启关闭负载均衡器，get，scan等操作

  | 方法名称      | 参数                                                         | 操作                     | 备注 |
  | ------------- | ------------------------------------------------------------ | ------------------------ | ---- |
  | get_row       | 参数一:table_name<br />参数二:family_name<br />参数三:row_key<br />参数四:column | 从Hbase读取一条数据      |      |
  | create_table  | 参数一:create_file                                           | 从文件读取建表语句并执行 |      |
  | disable_table | 参数一:table_name                                            | 禁用表                   |      |
  | drop_table    | 参数一:table_name                                            | 删除表                   |      |
  | count_table   | 参数一:table_name                                            | 统计表条数               |      |
  | enable_table  | 参数一:table_name                                            | 启用表                   |      |

  

* **hdfs_tools.sh**

  hdfs操作脚本,封装了如上传下载文件,创建删除目录,以及dfsadmin相关的一些命令

  | 命令名称   | 操作             | 是否有可选参数 | 备注                                                         | 示例                                                   |
  | ---------- | ---------------- | -------------- | ------------------------------------------------------------ | ------------------------------------------------------ |
  | get_file   | 从HDFS下载文件   | Y              | 参数一:HDFS路径<br />参数二:本地目标路径<br />参数三[可选]:是否合并文件 | hdfs_tools.sh get_file /sourcepath /targetpath [merge] |
  | put_file   | 从本地上传文件   | N              | 参数一:本地路径<br />参数二:HDFS路径                         | hdfs_tools.sh put_file /loacalpath /targetpath         |
  | del_file   | 从HDFS删除       | N              | 参数一:HDFS路径                                              | hdfs_tools.sh del_file /delpath                        |
  | create_dir | 创建HDFS目录     | N              | 参数一:HDFS路径(可以是多级目录)                              | hdfs_tools.sh create_dir /new_path                     |
  | copy_dir   | 复制HDFS文件     | N              | 参数一:HDFS源目录<br />参数二:HDFS目标目录(目标目录不能存在) | hdfs_tools.sh copu_dir /source_path /target_path       |
  | look_usage | 查看DHFS使用量   | Y              | 参数一[可选]:要查看的HDFS目录                                | hdfs_tools.sh look_usage [/look_path]                  |
  | report     | 查看hdfs集群状态 | N              | 无                                                           | hdfs_tools.sh report                                   |
  | safemode   | HDFS安全模式操作 | N              | 参数一[可选]:enter<br />参数二[可选]:leave<br />参数三[可选]:get<br />参数四[可选]:wait | hdfs_tools.sh [enter] [leave] [get][wait]              |



* **hive_tools.sh**

  hive的操作脚本,封装了基本上可以用到的hive命令,可以在测试脚本test_hive.sh中查看相关的使用例子

  封装了常用的如执行sql,执行sql文件,数据导入导出,表的crud等

  | 命令名称          | 操作           | 是否有可选参数 | 备注                                                         | 示例                                                         |
  | ----------------- | -------------- | -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | executor_sql_file | 执行sql文件    | Y              | 参数二传入sql文件路径<br />参数三[可选] 传入参数值           | hive_tools.sh executor_sql_file home/sql.sql a=a,b=b         |
                                                                 | executor_sql      | 执行sql        | N              | sql字符串(需要在sql中约束数据库)                             | hive_tools.sh executor_sql sql字符串                         |
                                                                 | truncate_table    | 执行truncate表 | N              | 参数二传入数据库名<br />参数三传入数据库表名                 | hive_tools.sh truncate_table database table                  |
                                                                 | drop_table        | 删除表         | N              | 参数二传入数据库名<br />参数三传入数据表名                   | hive_tools.sh drop_table database table                      |
                                                                 | drop_partition    | 删除表分区     | N              | 参数二传入数据库名<br />参数三传入数据表名<br />参数四传入分区条件 | hive_tools.sh drop_partition database table day=2019-12-21   |
                                                                 | create_table      | 创建表         | Y              | 参数二传入数据库名<br />参数三传入建表语句或建表文件         | hive_tools.sh exec_create_table [sql] [sqlfile]              |
                                                                 | import_data       | 导入数据       | N              | 参数二传入数据库名<br />参数三传入数据表名<br />参数四传入数据文件路径 | hive_tools.sh import_data database table data_path           |
                                                                 | export_data       | 导出数据       | N              | 参数二传入数据库名<br />参数三传入导出文件路径<br />参数四传入导出SQL | hive_tools.sh export_data database /home/export.dat selectSql |

* **kafka_tools.sh**

  kafka操作脚本,主要是作为开发中一种快捷工具,提供了诸如查看topic列表,创建临时topic,启动控制台产生测试数据等用途。

  | 命令名称 | 操作                        | 是否有可选参数 | 备注                                                         | 示例                                                    |
  | -------- | --------------------------- | -------------- | ------------------------------------------------------------ | ------------------------------------------------------- |
  | list     | 查看kafkaTopic              | N              | 无                                                           | kafka_tools.sh list                                     |
  | pull     | 消费某个topic(默认消费组)   | N              | 参数:topic                                                   | kafka_tools.sh pull topicName                           |
  | push     | 向某个topic生产数据从控制台 | N              | 参数:topic                                                   | kafka_tools.sh push topicName                           |
  | delete   | 删除某个topic               | N              | 参数:topic                                                   | kafka_tools.sh delete topicName                         |
  | create   | 创建topic                   | Y              | 参数一:topicName<br />参数二[可选]:副本数<br />参数三[可选]:分区数 | kafla_tools.sh create topicName [replication][partions] |

* **load_db_conf.sh**

  * 参数

    加载数据库的工具脚本，主要用来读取mysql配置文件，配置文件中key为固定写法

    db.server: 数据库id

    db.port: 数据库端口

    db.username: 数据库用户名

    db.password: 数据库密码

    db.database: 默认数据库

  * 注意事项

    使用时需要传入mysql配置文件的名称，默认配置文件存放在$SCRIPT_HOME/conf/db_conf/下

  

* **replace_str.sh**

  一个简单的替换字符串的工具，支持替换文件里所有字符串和替换字符串变量中的字符串

  | 参数       | 参数作用             | 是否可选 | 备注                                                         |
  | ---------- | -------------------- | -------- | ------------------------------------------------------------ |
  | 文件\|变量 | 被替换的主体         | N        | 可以是文件或者字符串变量                                     |
  | old_str    | 需要被替换的字符串   | N        |                                                              |
  | new_str    | 需要替换成的字符串   | N        |                                                              |
  | new_file   | 替换后生成的新文件名 | Y        | 如果传入文件名 默认替换内容输出到新文件<br />否则在源文件的基础上直接替换 |

  

* **scp.sh**

  多机器分发文件的脚本，对scp命令进行封装

* **split_str.sh**

  一个简单的分割字符串变量的工具，支持默认分隔符"," 和自定义分隔符

  ​	参数一：需要被分割的字符串

  ​	参数二[可选]: 指定分隔符

  | 参数   | 是否可选 | 示例                  | 备注                     |
  | ------ | -------- | --------------------- | ------------------------ |
  | 参数一 | N        | "aaa,bbbbb,cccc,dddd" | 按指定分隔符分割的字符串 |
  | 参数二 | Y        | ,\|.\|-               | 分隔符                   |

* **sqoop_export_tools.sh**

  ​	sqoop导出工具,主要用来从hive导出数据到mysql，目前主要支持三种导出模式，导出时不支持指定分隔符，等特殊参数，如果需要特殊参数化，可以根据项目不同对脚本进行修改，相关变量定义在脚本头。

  * 导出模式

    * 全量导出

      需要hive和mysql表结构完全一致，不需要指定columns

    * 从文件全量导出

      需要指定columns

    * 增量导出

      需要指定分区的相关信息

  * 参数

    | 方法名称        | 参数列表                                                     | 操作                                 | 备注                               |
    | --------------- | ------------------------------------------------------------ | ------------------------------------ | ---------------------------------- |
    | export_all      | 参数一：target_db<br />参数二：target_table<br />参数三：source_db<br />参数四：source_table | 全量源表数<br />据导出到目标表       | 表结构需要完全一致                 |
    | export_incr     | 参数一：target_db<br />参数二：target_table<br />参数三：source_db<br />参数四：source_table<br />参数五：partition_key<br />参数六：partition_value | 导出分区表某<br />一天的数据到目标表 | 需要指定分区字段和值               |
    | export_all_file | 参数一：target_db<br />参数二：target_table<br />参数三:export_dir<br />参数三：columns | 导出文件到mysql数据库                | 需要指定文件目录<br />和列对应关系 |

    

  * 注意事项

    1. 使用工具时，需要声明mysql配置文件名称，如：

       ```
       export mysql_conf_file=mysql-test.properties
       ```

    2. 为了防止数据传输过程中中断等问题导致数据不一致，不支持直接导出到目标表

       需要在mysql创建接收数据的临时表，临时表的命名规则如下：

       ​	目标表: test_export_table

       ​	临时表: test_export_table_tmp

       

* **sqoop_import_tools.sh**

  ​	Sqoop导入工具,用来将mysql数据导入到hive中,主要支持三种导入模式，导入时不支持指定分隔符等特殊参数，如果需要特殊参数化，可以根据项目不同对脚本进行修改，相关变量定义在脚本头。

  * 导入模式

    * 全量导入

      表结构完全一致的两张表做数据同步

    * 全量导入（执行SQL）

      可以在导入时执行自定义的sql进行数据过滤

    * 增量导入

      采用SqoopJob的方式进行增量导入,不需要手动维护增量字段,不支持指定查询sql，根据指定的检查列，做数据增量拉取，第一次创建任务需要传入last_value

  * 参数

    | 方法名称        | 参数                                                         | 操作                                 | 备注                                                         |
    | --------------- | ------------------------------------------------------------ | ------------------------------------ | ------------------------------------------------------------ |
    | import_all      | 参数一：target_db<br />参数二：target_table<br />参数三：source_db<br />参数四：source_table | 全量导出mysql数据                    | 两边表结构一致<br />如果hive不存在表会创建<br />每次导入会覆盖 |
    | import_query    | 参数一：target_db<br />参数二：target_table<br />参数三：source_db<br />参数四：source_table<br />参数五：sql | 根据sql导入数据<br />到hive          | 传入的sql不需要写<br />CONDITIONS<br />导出的临时文件存放<br />/tmp/hive/target_table_日期 |
    | import_incr_job | 参数一：target_db<br />参数二：target_table<br />参数三：source_db<br />参数四：source_table<br />参数五：check_column<br />参数六[可选]：last_value | 对数据按指定检查<br />列进行增量导出 | 检查列可以是时间,自增id等<br />                              |

    

  * 注意事项

    1. 使用工具时，需要声明mysql配置文件名称，如

       ```
       export mysql_conf_file=mysql-test.properties
       ```

    2. 增量导出基于SqoopJob,需要配置sqoop保存密码到元数据库

       ```
       <property>
           <name>sqoop.metastore.client.record.password</name>
           <value>true</value>
           <description>If true, allow saved passwords in the metastore.
           </description>
       </property>
       ```

    3. 生成的临时文件

       默认输出到$SCRIPT_HOME/tmp/sqoop

    4. 默认导入map数量为1

       如果需要修改map数量时,需要指定split_by参数

    5. Sqoop 1.46版本不支持 incremental 为[*lastmodified*](https://www.google.com/search?newwindow=1&sxsrf=ACYBGNTv21xT_TEeDZWuYF-d6dMwq6_YAQ:1578471966646&q=sqoop+lastmodified&spell=1&sa=X&ved=2ahUKEwjdh_CmyvPmAhVLhuAKHS1YBlcQBSgAegQIDBAr)  的同时指定 --hive-import等参数,详见官方文档

       

* **ssh.sh**

  一个方便工作的工具,可以在多服务器执行相同命令



### 使用方法

​	在脚手架工程中,基本上所有工具都可以通过下面的方式进行引用,在工程类,可以直接通过$TOOLS_DIR获取到工具目录。根据不同的工具，提供不同的参数结果。操作类脚本(如hive_tools/hdfs_tools等)一般没有返回值，可以通过$?获得返回值是否为0判断命令执行是否成功。

```

$TOOLS_DIR/sqoop_import_tools.sh
$TOOLS_DIR/hive_tools.sh
db_conf=`$TOOLS_DIR/load_db_conf.sh $mysql_conf_file`
today=`$TOOLS_DIR/date_tools.sh today`
```



## 其它

​	还有一些其它的工具,会陆陆续续封装出来,在进行新的数据需求开发时,能够减少这些重复的工作内容,同时也使大数据脚本更容易维护,对于后期平台化能够起到一个支撑作用。