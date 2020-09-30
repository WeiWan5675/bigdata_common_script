#!/usr/bin/python
# -*- coding: UTF-8 -*-
import smtplib
import io
import sys
import os
from email.mime.text import MIMEText
from email.utils import formataddr
try:
    # Python2
    from ConfigParser import ConfigParser
except ImportError:
    # Python3
    from configparser import ConfigParser


project_home = os.path.join(os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + os.path.sep + "../../"))
config = ConfigParser()
config.read(project_home + '/conf/sys.properties')
report_mail_user = config.get("REPORT_WARN", "report_mail_user")
report_mail_pass = config.get("REPORT_WARN", "report_mail_pass")
report_mail_server = config.get("REPORT_WARN", "report_mail_server")
report_mail_port = config.get("REPORT_WARN", "report_mail_port")

subject = sys.argv[1]
address = sys.argv[2]
msg_path = sys.argv[3]
f = io.open(msg_path, "r", encoding='UTF-8')
msgstr = f.read()
f.close()


def mail():
    ret = True
    try:
        msg = MIMEText(msgstr, 'plain', 'utf-8')
        msg['From'] = formataddr(["DwReporter", report_mail_user])
        msg.add_header('To', address)
        msg.add_header('Subject', subject)
        server = smtplib.SMTP_SSL(report_mail_server, report_mail_port)
        server.login(report_mail_user, report_mail_pass)
        server.sendmail(report_mail_user, msg["To"].split(","), msg.as_string())
        server.quit()
    except Exception:
        ret = False
    return ret


ret = mail()
if ret:
    print("邮件发送成功")
else:
    print("邮件发送失败")
