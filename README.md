# NPC 使用说明

以 Mojo-Webqq-Docker 为基础，具备 smartreply 和 openqq 等功能的 NPC。

## Mojo::Webqq项目地址:
[Mojo::Webqq](https://github.com/sjdy521/Mojo-Webqq)  
感谢[灰灰](https://github.com/sjdy521)的倾情付出.

## 包含功能

1. 智能回复消息；
2. 代码测试功能；
3. 群管理功能（入群提醒，退群提示，改名通知等）；
4. 定时发送消息；
5. 自定义回复消息；
6. 习题发送及定期回顾功能。

## 使用前提

需要自行安装 docker 运行环境。

## 简单使用

简单使用不需要配置数据库，克隆代码后，修改 build.sh 里面的相关内容，设置二维码发送的邮箱信息及 QQ 登录的密码：

```bash
# 邮箱服务器地址
SMTP_SERVER="smtp.qq.com" 
# 邮箱服务器端口
SMTP_PORT="465" 
# 邮件来源
SMTP_FROM="2774984XXX@qq.com" 
# 发送到的邮箱
MAIL_TO="hzz1989@XXX.com" 
# 邮箱服务器账号
SMTP_USER="2774984XXX" 
# 邮箱服务器密码，QQ邮箱需要填授权码
SMTP_PASSWD="rwkbsbruwqhldXXX" 
# 运行的QQ密码
QQ_PASSWD="ABCD" 
```

更改完成后创建镜像并运行即可：

```bash
bash build.sh run
```

执行完成后，设定 MAIL_TO 的邮箱会收到一封包含的二维码邮件，用 手机QQ 提前登录需要变成 NPC 的 QQ，然后扫描二维码登录即可。

* 简单使用方式只包含前3个功能，后面的功能需依托数据库配置。

## 待完善。
