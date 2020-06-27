use 5.22.0;
use warnings;
use utf8;
use Encode        qw( encode decode );
use Data::Dumper  qw( Dumper );

use subs qw( sjenc sjdec u8enc u8dec sysenc sysdec u8dmp want_list my_eval_pl );

my $spacer = (' ' x 4);

MAIN: {
    print "\n";
    my_eval_pl;
    print "\n";
}
exit 0;


sub sjenc (_) { encode('cp932', $_[0]) }
sub sjdec (_) { decode('cp932', $_[0]) }
sub u8enc (_) { encode('utf8',  $_[0]) }
sub u8dec (_) { decode('utf8',  $_[0]) }
sub sysenc (_) { $_[0] };
sub sysdec (_) { $_[0] };

BEGIN {
    no warnings 'redefine';

    if ('MSWin32' eq $^O) {
        *sysenc = \&sjenc;
        *sysdec = \&sjdec;
    }
    else {
        *sysenc = \&u8enc;
        *sysdec = \&u8dec;
    }
}


sub u8dmp (_;@) {

    (my $str = Dumper @_) =~ s
        < ( \\ x \{ \p{IsXDigit}+ \} ) >
        < do { local $_ = eval "\"$1\""; $_ // $1; } >gex;
    $str;
}


sub want_list {

    (my $msg = shift) //= "リストを入力してください";
    print STDERR sysenc "$msg：\n↓$spacer";

    my @list = ();
    local $_;
    while ( <STDIN> ) {
        $_ = sysdec;
        last if $_ =~ /^\n$/;
        push @list, $_;
        print STDERR sysenc "↓$spacer";
    }

    return \@list;
}


sub my_eval_pl {

    # Read-Eval-Print Loop
    MY_EVAL_REPL: while (1) {
        my $aref = want_list 'Perl#Eval: コードを入力してください (空行で評価)';

        if ( !@$aref or ${$aref}[0] =~ /^x$/i ) {
            last MY_EVAL_REPL;
        }

        say STDERR sysenc "//////////// 実行結果↓ ////////////";

        my $code  = q{ no strict; local $_; };
        for ( @$aref ) {
            $_ = "$2\n"  if /^(↓$spacer)+(.*?)$/;  # 行頭の '↓    ' x N は無視する
            $code .= $_;
        }

        my $rslt = eval $code;

        my $stat = u8dmp $rslt;
        for ( $stat ) {
            s/^\s+|\s+$//gm;
            s/[\r\n]+/ /gs;
        }
        $stat = "  Last Evaluated : $stat\n";
        if ( $@ ) {
            my $errmsg = ($@ =~ s/\s+$//rgs);
            $stat .= "  !!! Error !!!  : $errmsg\n";
        }

        say STDERR sysenc "//////////// ↑実行結果 ////////////";
        say STDERR sysenc $stat;
    }
}
