CREATE TABLE `test_common_script.test_day`(
`id` string, 
`name` string, 
`amount` bigint,
`flag` string,
`create_date` string, 
`update_date` string)
partitioned by(day string)
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
'field.delim'=',', 
'line.delim'='\n', 
'serialization.format'='\t') 
STORED AS INPUTFORMAT 
'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat';
