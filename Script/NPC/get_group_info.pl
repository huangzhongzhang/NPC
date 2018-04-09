use Mojo::Webqq;
use Digest::MD5;
my $client = Mojo::Webqq->new(
    login_type=>'login',
    is_fetch_notice=>0,
    account=>"$ARGV[0]",
    pwd=>Digest::MD5::md5_hex("$ARGV[1]"),
);
$client->user(Mojo::Webqq::User->new(uid=>$client->account));
$client->model_ext_authorize();
my $group_list = $client->_get_group_list_info_ext();
printf "%-30s\t%-20s\t%-10s\n","群名称","群号码","当前群人数";
if(defined $group_list){
    for my $each (@$group_list){
        my $group = $client->_get_group_info_ext($each->{uid});
        printf "%-30s\t%-20s\t%-10s\n",$each->{name},$each->{uid},0+scalar(@{$group->{member}});
    }
}