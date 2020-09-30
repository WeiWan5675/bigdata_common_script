#!/usr/bin/python
# encoding:utf-8
import os, tarfile
import subprocess
import string
import sys
import datetime

try:
    # Python2
    from ConfigParser import ConfigParser
except ImportError:
    # Python3
    from configparser import ConfigParser

project_abs_path = os.path.join(os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + os.path.sep + "../"))
# 读取conf下的配置文件
config = ConfigParser()
config.read(project_abs_path + '/conf/sys.properties')
project_name = config.get("PROJECT", "project_name")
project_version = config.get("PROJECT", "project_version")
depoly_branch = config.get("PROJECT", "deploy_branch")

if os.path.exists("../" + project_name + "-" + project_version + ".tar.gz"):
    os.remove("../" + project_name + "-" + project_version + ".tar.gz")


# 遍历项目文件夹,过滤[.git .idea tmp logs] 打包文件命名格式: 项目名称-版本.tar
def make_targz_one_by_one(output_filename, source_dir):
    tar = tarfile.open(output_filename, "w:gz")
    for root, dir, files in os.walk(source_dir):
        for file in files:
            pathfile = os.path.join(root, file)
            if ".git" in pathfile \
                    or ".idea" in pathfile \
                    or ".gitignore" in pathfile \
                    or "/tmp/" in pathfile \
                    or "\\tmp\\" in pathfile \
                    or "/logs" in pathfile \
                    or "tar.gz" in pathfile \
                    or "\\logs" in pathfile:
                continue

            fi = pathfile.replace("\\", "/").strip('\u202a').replace("./", "")
            print("添加:[" + fi + "]")
            tar.add(fi)
    tar.close()
    print("压缩完成:[" + project_abs_path + "/" + output_filename + "]")


def check_code_status():
    # 执行打包前检查 如果本地有未提交改动 或者远程有改动等 都需要检查
    if subprocess.call(['git', 'checkout', depoly_branch]) != 0:
        print("error: 切换上线分支: [" + depoly_branch + "] 请检查!")
        sys.exit()
    else:
        print("切换到上线分支: [" + depoly_branch + "]")
    if subprocess.call(['git', 'pull']) != 0:
        print("error: 拉取远程分支: [" + depoly_branch + "] 最新改动失败,请检查")
        sys.exit()
    else:
        print("拉取远程分支: [" + depoly_branch + "] 最新改动完成!")


if __name__ == '__main__':
    bak_flag = ''
    bc = 'backup'
    bak_day = datetime.date.today().strftime('%Y%m%d')
    try:
        bak_flag = sys.argv[1]
    except:
        print("没有指定任何参数 --> default")
    if bak_flag == bc:
        print("开始备份 ---> start")
        make_targz_one_by_one(project_name + "-" + project_version + ".tar.gz." + bak_day + ".bak",
                              "./")  # 打包整个工程
        print("备份完成 ---> end")

    else:
        print("开始打包 ---> start")
        check_code_status()  # 检查当前分支
        os.chdir("..")
        make_targz_one_by_one(project_name + "-" + project_version + ".tar.gz", "./")  # 打包整个工程
        print("打包完成 ---> end")
