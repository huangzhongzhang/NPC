# NPC 使用说明

以 Mojo-Webqq-Docker 为基础，具备 smartreply 和 openqq 等功能的 NPC。

**由于腾讯接口限制，NPC 每次扫码登录只能维持在线48小时以内，若出现超时、掉线或网络异常，需重新扫码登录（若配置了邮件发送，会发送最多10次二维码邮件进行通知）。**

## Mojo::Webqq项目地址:
[Mojo::Webqq](https://github.com/sjdy521/Mojo-Webqq)  
感谢[灰灰](https://github.com/sjdy521)的倾情付出。

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

**依赖镜像下载时较慢，建议添加 docker 加速器后执行，比如 DaoCloud 的加速器：https://www.daocloud.io/mirror 。**

```bash
bash build.sh run
```

执行完成后，设定 MAIL_TO 的邮箱会收到一封包含的二维码邮件，用 手机QQ 提前登录需要变成 NPC 的 QQ，然后扫描二维码登录即可。

* 简单使用方式只包含前3个功能，后面的功能需依托数据库配置。

## 数据库配置

NPC_DATABASE 镜像运行后，会出现如下几张表：

`Crontab`：配置定时任务，配合脚本可实现若干功能；
`Information`：信息发送，用于配置定时发送消息的功能；
`KnowledgeBase`：知识库，用于配置触发回复的 key 和value；
`LinuxQuestion`：习题库，用于配置练习题以便定时发送。

### 定时信息发送

定时信息发送主要是实现定时向某些QQ群发送消息，以达到定时通知的功能。

`Information` 表配置示例如下：

| id | time | gnumber | gname | message | stat | comment |
| --- | --- | --- | --- | --- | --- | --- |
| 214 | "10 16 * * 1,3" | 361531259 | woego-全国版本 | 童鞋们，充饭卡的时间到啦！ :) | 1 | WOEGO |

各字段含义如下：

`id`：唯一，无实意；
`time`：发送时间，crontab 的格式；
`gnumber`：需要发送的群号码；
`gname`：需要发送的群名称；
`message`：发送的信息；
`stat`：状态：1，生效；0，失效；
`comment`：备注。

### 定时任务功能

若要实现 `自定义回复消息` 以及 `习题发送及定期回顾功能` ，我们需要配置 `Crontab`
定时任务。

示例如下：

| id | time | command | stat | comment |
| --- | --- | --- | --- | --- |
|213|*/10 * * * *|cd /root;bash -x set_knowledge.sh &> set_knowledge_exec.log|1|
|214|18 09 * * 1-5|cd /root;bash -x send_linux_questions.sh "51CTOLinux微职位-精英 51CTO学院Linux微职位" "question" &> TESTQ1|1|
|215|38 09 * * 1-5|cd /root;bash -x send_linux_questions.sh "51CTOLinux微职位-精英 51CTO学院Linux微职位" "answer" &> TESTA1|1|
|219|08 09 * * 2-6|cd /root;bash -x exercise_review.sh "51CTOLinux微职位-精英 51CTO学院Linux微职位"|1|




