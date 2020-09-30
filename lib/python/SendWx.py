#!/usr/bin/python
# -*- coding: UTF-8 -*-
import io
import sys
import os
import traceback

try:
    # Python2
    from ConfigParser import ConfigParser
except ImportError:
    # Python3
    from configparser import ConfigParser


title = sys.argv[1]
msg = sys.argv[2]

message = title + "\n" + msg

send_message(message)

'''
  功能：调用接口发送消息
'''
def send_message(message):
    try:
        r = requests.post("https://alarm.lifeat.cn/wx/cp/msg/1000014", data=bytes(message, 'UTF-8'))
        print(r.text)
    except:
        print(traceback.print_exc())





