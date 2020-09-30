#!/usr/bin/python
# -*- coding: UTF-8 -*-


import os
import sys
from glob import glob
from os import path

# filePath = sys.argv[1]
filePath = "F:\Project\easylife_dw\conf\sql\create_sql"

def readFile(path):
    f = open(path, "r", encoding='UTF-8')  # 设置文件对象
    data = f.readlines()  # 直接将文件中按行读到list里，效果与方法2一样
    f.close()
    return data


def writeFile(path, data):
    with open(path, 'w', encoding='UTF-8') as f:  # 设置文件对象
        for tableStr in data:
            for tableLine in tableStr:
                f.write(tableLine)





def dirlist(path):
    filelist = os.listdir(path)
    print(path)
    pathDirName = path[path.rindex(os.sep) + 1:len(path)]
    final_path = path + os.sep + pathDirName + "_all_table.cql"
    if os.path.exists(final_path):
        os.remove(final_path)

    allContent = []
    for filename in filelist:
        filepath = os.path.join(path, filename)
        if os.path.isdir(filepath):
            dirlist(filepath)
        else:
            if filepath.endswith(".cql"):
                sqlFileName = filepath[filepath.rindex(os.sep) + 1:len(filepath)]
                if (sqlFileName.startswith("all") | sqlFileName.endswith("all_table.cql")):
                    continue
                else:
                    print(sqlFileName)
                    allContent.append(readFile(filepath))
                    allContent.append(";\n")
                    allContent.append("\n")

            else:
                print("")
    if len(allContent) > 0:
        writeFile(final_path, allContent)


print(dirlist(filePath))
