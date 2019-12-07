


$stdin.set_encoding 'Windows-31J'
$spacer = (' ' * 4)


def want_list(msg='リストを入力してください')

    $stderr.print "#{msg}：\n↓#{$spacer}"

    list = []
    while l = gets() do
        l.encode! 'UTF-8'
        break  if /^\r?\n$/ =~ l
        list.push l
        $stderr.print "↓#{$spacer}"
    end

    return list
end


def my_eval_rb

    # Read-Eval-Print Loop
    while true do
        code = ''; rslt = ''; stat = ''; errstr = ''
        err = nil

        codearr = want_list 'Ruby#Eval: コードを入力してください (空行で評価)'
        return  if (codearr.empty?) or (/^x$/i =~ codearr[0])

        $stderr.puts '//////////// 実行結果↓ ////////////'

        codearr.each do |cl|
            cl = "$2\n"  if /^(↓#{$spacer})+(.*?)$/ =~ cl
            code << cl
        end

        begin
            rslt = eval code
        rescue => err
            errstr << "<#{err.class}> #{err.message}"
        end

        stat = rslt.inspect()
        stat.gsub!(/^\s+|\s+$/, '')
        stat.gsub!(/[\r\n]+/,  ' ')
        stat = "  Last Evaluated : #{stat}\n";

        unless errstr.empty? then
            stat << "  !!! Error !!!  : #{errstr}\n";
        end

        $stderr.puts "//////////// ↑実行結果 ////////////"
        $stderr.puts stat + "\n"
    end
end


$stderr.puts
my_eval_rb()
$stderr.puts
