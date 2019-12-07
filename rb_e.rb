


def want_list(msg='リストを入力して下さい')

    $stderr.print "#{msg}：\n↓    "

    list = []
    while line = gets() do
        break if /^\n$/ =~ line
        list.push line
        $stderr.print '↓    '
    end

    return list
end


def my_eval_rb

    # Read-Eval-Print Loop
    while true do
        codearr = want_list 'Ruby#Eval: コードを入力してください (空行で実行)'
        return if codearr.empty? or /^x$/i =~ codearr[0]

        $stderr.puts '//////////// 実行結果↓ ////////////'

        code = ''
        codearr.each do |c|
            # 行頭の '↓    ' x N は無視する
            c = "$2\n"  if /^(↓    )+(.*?)$/ =~ c
            code << c
        end

        errstr = ''
        begin
            rslt = eval code
        rescue => err
            errstr << "<#{err.class}> #{err.message}"
        end
        err = nil

        stat = rslt.inspect
        stat.gsub!(/^\s+|\s+$/, '')  # Perl での /m
        stat.gsub!(/[\r\n]+/, %q| |)
        stat = "  Last Evaluated : #{stat}\n";

        if !errstr.empty? then
            errstr.gsub!(/\s+$/, '')
            stat << "  !!! Error !!!  : #{errstr}\n";
        end

        $stderr.print "//////////// ↑実行結果 ////////////\n"
        $stderr.print stat
        $stderr.print "\n"
    end
end


$stderr.print "\n"
my_eval_rb()
$stderr.print "\n"
