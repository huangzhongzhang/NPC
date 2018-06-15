#!/usr/bin/perl

use Mojo::Webqq;

# 使用账号或二维码登录
# 注意: 原生的SmartQQ是不支持账号密码登录的
# 程序实际上是通过 http://qun.qq.com 页面账号密码登录然后和SmartQQ共享登录状态，从而实现账号密码登录
# 所以，账号密码的登录方式并不稳定，一旦失败，程序会再次自动尝试使用二维码扫描登录
# 请关闭帐号的密保功能，不支持密保登录
# 另外，基于账号密码的登录方式，一旦登录所在地发生较大变化，则腾讯服务器可能需要你输入图片验证码
# 这样就很难实现自动化操作，为了避免这种情况，你需要尽量在pl脚本所在的网络中用浏览器多登录一下 http://qun.qq.com

my $client=Mojo::Webqq->new(
    account     => "$ARGV[0]",      # QQ账号
    ua_debug    => 0,         # 是否打印详细的debug信息
    log_level   => "debug",     # 日志打印级别
    login_type  =>  "login", # "qrlogin"表示二维码登录，"login"表示账号密码登录。注意: 如果腾讯关闭了帐号密码的登录方式，这种情况下只能使用二维码扫描登录。
    poll_failure_count_max  =>  200, # 获取信息失败重试次数
    ignore_poll_retcode  =>  [102,109,110,1202,100012], # 忽略的错误码
    pwd  =>  "$ARGV[1]", # 你的QQ账号密码的md5值，shell下通过echo -n xxx|md5sum生成md5值
    tmpdir  =>  "/tmp", # 二维码存放目录
);

# 发送二维码到邮箱
$client->load("PostQRcode",data=>{
        smtp    =>  "$ARGV[2]", # 邮箱的smtp地址
        port    =>  "$ARGV[3]", # smtp服务器端口，默认25
        from    =>  "$ARGV[4]", # 发件人
        to      =>  "$ARGV[5]", # 收件人
        user    =>  "$ARGV[6]", # smtp登录帐号，建议使用要登录的QQ作为发送邮件的账号
        pass    =>  "$ARGV[7]", # smtp登录密码，若使用QQ邮箱，需手动在 设置-账户 中生成授权码
        max     =>  "1", # 设定最大发送次数为1，由启动脚本来控制发送次数。
});

$client->login();

$client->load("GroupManage",data=>{
        # allow_group => [423837909,438891576,651047263],  #可选，允许插件的群，可以是群名称或群号码
        # ban_group   => ["私人群",123456], #可选，禁用该插件的群，可以是群名称或群号码
        is_new_group_notice => 0,         #可选，是否发送新加入群提醒消息，默认 1
        is_new_group_member_notice => 0,  #可选，是否发送新增群成员提醒消息，默认 1
        is_lose_group_member_notice => 0, #可选，是否发送退出群成员离开提醒消息，默认 1
        is_group_member_property_change_notice => 0, #可选，是否发送群名片变更提醒消息，默认 0
        new_group_member => '欢迎新童鞋 @%s 入群！[鼓掌][鼓掌][鼓掌]', #新成员入群欢迎语，%s会被替换成群成员名称
        lose_group_member => '很遗憾 @%s 童鞋离开了本群……[流泪][流泪][流泪]', #成员离群提醒
        speak_limit => {# 发送消息频率限制
            period          => 10, # 统计周期，单位是秒
            warn_limit      => 8, # 统计周期内达到该次数，发送警告信息
            warn_message    => '@%s 警告, 您发言过于频繁，可能会被禁言或踢出本群！', #警告内容
            shutup_limit    => 10, # 统计周期内达到该次数，成员会被禁言
            shutup_time     => 600, # 禁言时长
            #kick_limit      => 15,   # 统计周期内达到该次数，成员会被踢出本群
        },
        pic_limit => {# 发图频率限制
            period          => 600,
            warn_limit      => 6,
            warn_message   => '@%s 警告, 您发图过多，可能会被禁言或踢出本群！',
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
$client->load("SmartReply",data=>{
        apikey          => 'd288214dcba801d180167635f3a8deb7', #可选，参考http://www.tuling123.com/html/doc/apikey.html
        #allow_group     => ["PERL学习交流"],  #可选，允许插件的群，可以是群名称或群号码
        #ban_group       => ["私人群",123456], #可选，禁用该插件的群，可以是群名称或群号码
        #ban_user        => ["坏蛋",123456], #可选，禁用该插件的用户，可以是用户的显示名称或qq号码
        notice_reply    => ["对不起，请不要这么频繁的艾特我！","对不起，您的艾特次数太多！"], #可选，提醒时用语
        notice_limit    => 8 ,  #可选，达到该次数提醒对话次数太多，提醒语来自默认或 notice_reply
        warn_limit      => 10,  #可选,达到该次数，会被警告
        ban_limit       => 12,  #可选,达到该次数会被列入黑名单不再进行回复
        ban_time        => 3600, #可选，拉入黑名单时间，默认1200秒
        period          => 600, #可选，限制周期，单位 秒
        is_need_at      => 1,  #默认是1 是否需要艾特才触发回复 仅针对群消息
        keyword         => [qw(NPC npc Npc 机器人)], #触发智能回复的关键字
    });

$client->load("ProgramCode");

$client->load("KnowledgeBase",data=>{
    file => '/root/KnowledgeBase.txt', # 数据库保存路径，纯文本形式，可以编辑
    learn_command  => 'learn',     # 可选，自定义学习指令关键字
    delete_command =>'del',      # 可选，自定义删除指令关键字
#    learn_operator => [284759XXX], # 允许学习权限的操作人qq号
#    delete_operator => [284759XXX], # 允许删除权限的操作人qq号
    mode => 'fuzzy', # fuzzy|regex|exact 分别表示模糊|正则|精确, 默认模糊
    check_time => 10, #默认10秒检查一次文件变更
    show_keyword => 0, #消息是否包含触发关键字信息，默认开启
});

$client->load("Openqq",data=>{
listen => [ {host=>"0.0.0.0",port=>5011}, ] , #监听的地址和端口，支持多个
});

#客户端开始运行
$client->run();
