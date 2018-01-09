#!/usr/bin/perl

use Mojo::Webqq;

my $client=Mojo::Webqq->new(
    ua_debug    => 0,         #是否打印详细的debug信息
    log_level   => "debug",     #日志打印级别
    login_type  =>  "qrlogin", #"qrlogin"表示二维码登录
    poll_failure_count_max  =>  100, #获取信息失败重试次数
    pwd  =>  "$ARGV[6]", #你的QQ账号密码的md5值，shell下通过echo -n xxx|md5sum生成md5值
#   tmpdir  =>  "/tmp", #二维码存放目录
);

#注意: 腾讯可能已经关闭了帐号密码的登录方式，这种情况下只能使用二维码扫描登录

#发送二维码到邮箱
$client->load("PostQRcode",data=>{
        smtp    =>  "$ARGV[0]", #邮箱的smtp地址
        port    =>  "$ARGV[1]", #smtp服务器端口，默认25
        from    =>  "$ARGV[2]", #发件人
        to      =>  "$ARGV[3]", #收件人
        user    =>  "$ARGV[4]", #smtp登录帐号，建议使用要登录的QQ作为发送邮件的账号
        pass    =>  "$ARGV[5]", #smtp登录密码，若使用QQ邮箱，需手动在 设置-账户 中生成授权码
    });

$client->login();

$client->load("ShowMsg");

$client->on(receive_message=>sub{
my $msg = $_[1];
  $client->relogin() if $msg->content eq "relogin";
  $client->_relink() if $msg->content eq "_relink";
  $client->relink() if $msg->content eq "relink";
  $client->update_user() if $msg->content eq "update_user";
  $client->update_group() if $msg->content eq "update_group";
  $client->update_group_ext() if $msg->content eq "update_group_ext";
  $client->update_friend() if $msg->content eq "update_friend";
  $client->update_friend_ext() if $msg->content eq "update_friend_ext";
  $client->update_discuss() if $msg->content eq "update_discuss";
});

$client->load("GroupManage",data=>{
        # allow_group => [423837909,438891576,651047263],  #可选，允许插件的群，可以是群名称或群号码
        # ban_group   => ["私人群",123456], #可选，禁用该插件的群，可以是群名称或群号码
        new_group_member => '欢迎新童鞋 @%s 入群[鼓掌][鼓掌][鼓掌]', #新成员入群欢迎语，%s会被替换成群成员名称
        lose_group_member => '很遗憾 @%s 童鞋离开了本群[流泪][流泪][流泪]', #成员离群提醒
        speak_limit => {#发送消息频率限制
            period          => 10, #统计周期，单位是秒
            warn_limit      => 8, #统计周期内达到该次数，发送警告信息
            warn_message    => '@%s 警告, 您发言过于频繁，可能会被禁言或踢出本群', #警告内容
            shutup_limit    => 10, #统计周期内达到该次数，成员会被禁言
            shutup_time     => 600, #禁言时长
            #kick_limit      => 15,   #统计周期内达到该次数，成员会被踢出本群
        },
        pic_limit => {#发图频率限制
            period          => 600,
            warn_limit      => 6,
            warn_message   => '@%s 警告, 您发图过多，可能会被禁言或踢出本群',
            shutup_limit    => 8,
            kick_limit      => 10,
        },
        keyword_limit => {
            period=> 600,
            keyword=>[qw(fuck 傻逼 你妹 滚)],
            warn_limit=>3,
            shutup_limit=>5,
            #kick_limit=>undef,
        },
    });

# smartQQ
$client->load("SmartReply", data => {
  apikey => 'd288214dcba801d180167635f3a8deb7', # 可选，参考http://www.tuling123.com/html/doc/apikey.html
});

$client->load("ProgramCode");

$client->load("KnowledgeBase",data=>{
    file => '/root/KnowledgeBase.txt', #数据库保存路径，纯文本形式，可以编辑
    learn_command  => 'learn',     #可选，自定义学习指令关键字
    delete_command =>'del',      #可选，自定义删除指令关键字
    learn_operator => [284759461], #允许学习权限的操作人qq号
    delete_operator => [284759461], #允许删除权限的操作人qq号
    mode => 'fuzzy', # fuzzy|regex|exact 分别表示模糊|正则|精确, 默认模糊
    check_time => 10, #默认10秒检查一次文件变更
    show_keyword => 0, #消息是否包含触发关键字信息，默认开启
});

$client->load("Openqq",data=>{
listen => [ {host=>"0.0.0.0",port=>5011}, ] , #监听的地址和端口，支持多个
});

#客户端开始运行
$client->run();
