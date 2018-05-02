require_relative 'vhackOs'
begin
    require 'terminal-table'
rescue LoadError => e
  puts e.message
  puts"installing ... terminal table..."
  `gem install terminal-table`
end
begin
    require'colorize'
rescue LoadError => e
  puts e.message
  puts"Installing colorize...."
end
begin
    require 'pastel'
rescue LoadError => e
  puts e.message
  puts"installing pastel.."
  `gem install pastel`
end
begin
    require'tty-table'
rescue LoadError => e
  puts e.message
  puts"installing TTY-Table..."
  `gem install tty-table`
end
require'csv'
module Parse
  class << self
    public
    def Comma(*args)
        begin
            string = args.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse.gsub('[', "").gsub(']', "").gsub('"', "")
            return string
        rescue => e
            puts "#{e}".red
        end
    end
    def WithdrawType(*args)
        args = args.shift
        case args 
        when "0"
            return "Able to withdraw from target"
        when "1"
            return "Unable to withdraw from target"
        end
    end
    def CheckBrute(*args)
        args = args.shift
        case args
        when "0"
            return "Running Brute"
        when "1"
            return "Brute successful"
        when "2"
            return "Not Bruted"
        end
    end
    def ExploitStatus(*args)
        args = args.shift
        case args
        when "0"
            return "Have not exploited."
        when "1"
            return "Exploited already."
        end
    end
    def IsRunning(*args)
        args = args.shift
        case args
        when "0"
            return "Off"
        when "1"
            return "On"
        end
    end
    def AnonymousRed(args)
        if args == "ANONYMOUS"
            message = "ANONYMOUS"
            return message.red
        else
            return args
        end
    end
    def UnixConvert(*args)
        args = args.shift
        return Time.at(args.to_i).strftime("%b %e %I:%M %p").gsub('[', "").gsub(']', "").gsub('"', "")
    end
    def check_string(*args)
        a = args.shift.scan(/\D/).empty?
        if a != true
            return "ERROR: Please enter A Number".red
        end
    end
    def ParseBankingOne(username)
        rows = TTY::Table.new header: ['Money', 'Savings', 'total', 'Max Saving', 'Trans Count']
        bank = VhackXt.Banking(username)
        table = Terminal::Table.new do |t1|
        rows << [
                    Comma(bank["money"]) , 
                    Comma(bank["savings"]), 
                    Comma(bank["total"]), 
                    Comma(bank["maxsavings"]), 
                    Comma(bank["transcount"])
                ]
            puts"\n"
            puts rows.render(:unicode, alignment: [:center])
        end
    end
    def ParseMassAccountCreator()
        rows = TTY::Table.new
        rows << ["1.", "Prefix"]
        rows << ["2.", "Random Names"]
        rows << ["3.", "Install gem"]
        puts rows.render(:unicode, alignment: [:center])
    end
    def ParseRemoteBanking(username, target)
        rows = TTY::Table.new
        banking = VhackXt.RemoteBanking(username, target)
        rows << ["Username",        banking["remoteusername"]]
        rows << ["UID",             banking["target_id"]]
        rows << ["Money",           Comma(banking["money"])]
        rows << ["Status",          VhackXt.GetRemoteBankingType(banking["open"])]
        puts"                             Remote Bank Target Info                                   ".green
        puts rows.render(:unicode, alignment: [:center])
    end
    def ParseBanking(username)
        bank = VhackXt.Banking(username)
        rows2 = []
        table2 = Terminal::Table.new do |t|
        length = bank["transactions"].length
            puts length
            for i in 0..length
                if i.to_i == length.to_i
                    break
                end
                rows2 << [
                            AnonymousRed(bank["transactions"][i]["to_ip"]),
                            Comma(bank["transactions"][i]["amount"]),
                            bank["transactions"][i]["to_id"],
                            UnixConvert(bank["transactions"][i]["time"])
                         ]
                t.headings  = ['To Ip', 'Amount', 'To ID', 'Time']
                t.rows      = rows2
                t.style = {:width => 100, :border_x => "=", :border_i => "x", :alignment => :center}
            end
            table = ParseBankingOne(username)
            return table, table2
        end
    end
    def ParseUserApps(username)
        rows = []
        apps = VhackXt.GetUserApps(username)["apps"]
        length = apps.length
        appType = 
        for i in 0..length.to_i
            if i.to_i == length.to_i
                break
            end
        rows << [
                    VhackXt.GetAppType(apps[i]["appid"]),
                    apps[i]["level"]
                ]
        table = Terminal::Table.new :rows => rows, :headings => ["App Name", "Level"], :style => {:width => 30, :border_x => "=", :border_i => "x", :alignment => :center}
        end
        puts table
    end
    def ParseExploitedList(username)
        user_data = VhackXt.ExploitedList(username)
        begin
            length = user_data.length
            rows = []
                for i in 0..length
                    if i.to_i == length.to_i
                        break
                    end
                    array = [
                                user_data[i]["ip"],
                                user_data[i]["username"]
                            ]
                    if File.readlines("database/Username.csv").grep(/#{user_data[i]["ip"]}/).any?
                        puts
                    else
                        CSV.open('database/Username.csv', 'a') do |csv|
                            csv << array
                        end
                    end 
                rows << [ 
                            user_data[i]["ip"],
                            user_data[i]["username"],
                            CheckBrute(user_data[i]["brute"])
                        ]
            table = Terminal::Table.new :rows => rows, :headings => ["IP", "Username", " Brute"], :style => {:width => 80, :border_x => "=", :border_i => "x", :alignment => :center}
                end
            puts"                             Connection Manager                                   ".green
            puts table
        rescue => e
                puts e
                puts"You have no exploited users" 
        end

    end
    def ParseExploit(username, target)
        exploit = VhackXt.ExploitTarget(username, target)
        info = [
                    "#{exploit}",
                    "Ip: #{exploit["cm"]}",
                    "Username: #{exploit["cm"]["username"]}",
                    "Brute: #{exploit["cm"]["brute"]}",
                    "Exploits Left: #{exploit["exploits"]}"
               ]
               return info
    end
    def ParseNetwork(username)
        row = TTY::Table.new header: ['Ip', 'fw', 'Level', 'Open']
        network = VhackXt.GetNetwork(username)
        length  = network["ips"].length
        for i in 0..length.to_i
            if i.to_i == length.to_i
                break
            end
        row << [
                    network["ips"][i]["ip"],
                    Comma(network["ips"][i]["fw"]),
                    network["ips"][i]["level"],
                    ExploitStatus(network["ips"][i]["open"])
                ]
        end
             puts row.render(:unicode, alignment: [:center])
    end
    def ParseMoneyExploit(username, target, amount)
        remote = VhackXt.MoneyExploit(username, target, amount)
        row = TTY::Table.new
        row  << ["Remote IP",        target]
        row  << ["Remote ID",        remote["target_id"]]
        row  << ["Remote Username",  remote["remoteusername"]]
        row << ["Remote Money",     Comma(remote["money"])]
        puts row.render(:unicode)
        VhackXt.StealRemoteMoney(username, target, amount)
    end
    def ParseBrute(username)
        row = TTY::Table.new header: ['IP', 'Username', 'Start', 'End', 'Now', 'Status']
        brute  = VhackXt.BruteList(username)
        if brute["brutes"].nil?
            puts "NO brute runing"
        else
            length = brute["brutes"].length
            for i in 0..length
                if i.to_i == length.to_i
                    break
                end
            result = VhackXt.BruteTypes(brute["brutes"][i]["result"])
            row << [
                      brute["brutes"][i]["user_ip"],
                      brute["brutes"][i]["username"],
                      UnixConvert(brute["brutes"][i]["start"]),
                      UnixConvert(brute["brutes"][i]["end"]),   
                      UnixConvert(brute["brutes"][i]["now"]),      
                      result
                    ]
            end                                 
        end
            puts row.render(:unicode)
    end
    def Main()
        rows = TTY::Table.new 
        f = ["",
                    "UserInfo",
                    "Get Spam",
                    "Store",
                    "Exploit Target", 
                    "Start Brute", 
                    "Remote Log", 
                    "My Log",
                    "My Banking",
                    "Buy Apps",
                    "Current Task",
                    "Search Ip",
                    "Create User",
                    "Scan Network",
                    "Connection Manger",
                    "Steal Money",
                    'Miner',
                    "Auto Steal",
                    "Auto Upgrade",
                    "Retry Tasks",
                    "Auto Scan",
                    "Packages",
                    "Smart Buy",
                    "Server Info",
                    "Custom Log",
                    "Get SDK",
                    "Speed Tasks",
                    "Download Apps",
                    "quit"
                ]
                    for i in 1..f.length 
                        rows << [
                                   i, f[i]
                                ]
                    end
                    puts rows.render(:unicode, alignment: [:center])
                end
    def ParseMinerInfo(username)
        mineInfo = VhackXt.GetMiner(username)
        rows = TTY::Table.new 
        rows << ["Running",  IsRunning(mineInfo["running"])]
        rows << ["Applied",  IsRunning(mineInfo["applied"])]
        rows << ["Claimed",  IsRunning(mineInfo["claimed"])]
        rows << ["Started",  IsRunning(mineInfo["started"])]
        rows << ["NetCoins", Comma(mineInfo["netcoins"])]
        puts rows.render(:unicode, alignment: [:center])
    end
    def ParseStoreStats(username, total, amount)
        rows = TTY::Table.new 
        bank = VhackXt.Banking(username)
        rows << ['Current Balance',  Comma(bank['money'])]
        rows << ['Total Spent',      Comma(total)]
        rows << ['Amount Upgraded',  Comma(amount)]
        puts rows.render(:unicode, alignment: [:center])
    end
    def ParseSpeedUp(username)
        rows = TTY::Table.new 
        speed = VhackXt.SpeedUpUpgrades(username)
        rows << ["Level",      speed["level"]]
        rows << ["Netcoins",   Comma(speed["netcoins"])]
        rows << ["Boosters",   Comma(speed["boosters"])]
        puts rows.render(:unicode, alignment: [:center])
    end
    def ParseSDK(username)
        rows = TTY::Table.new 
        sdk = VhackXt.GetSDK(username)
        rows << ['SDK Level',   Comma(sdk["sdk"])]
        rows << ['Exploits',    Comma(sdk["exploits"])]
        puts rows.render(:unicode)
    end
    def SDKOptions()
        rows = TTY::Table.new 
        rows << ["1", "Buy Bulk"]
        rows << ["2", "Buy single"]
        puts rows.render(:unicode)
    end
    def ParseUpgrades(username)
        rows = TTY::Table.new header: ["App Name", "Level", "start", "End", "Now"]
        upgrade = VhackXt.GetTasks(username)
        if upgrade["updates"].nil?
            puts" No Apps are upgrading"
        else
            length = upgrade["updates"].length
            for i in 0..length
                if i.to_i == length.to_i
                    break
                end   
            rows << [
                        VhackXt.GetAppType(upgrade["updates"][i]["appid"]),
                        upgrade["updates"][i]["level"],
                        UnixConvert(upgrade["updates"][i]["start"]),
                        UnixConvert(upgrade["updates"][i]["end"]),
                        UnixConvert(upgrade["updates"][i]["now"]),
                    ]   
            end
        end
            puts rows.render(:unicode, alignment: [:center])
    end
    def SeverPieces(username)
        server = VhackXt.Server(username)
        rows = TTY::Table.new header: ['Server', 'Server Pieces', 'Av Pieces', 'FW Pieces']
        rows <<    [
                        server["server_str"],
                        server["server_pieces"],
                        server["av_pieces"],
                        server["fw_pieces"]
                    ]
         puts rows.render(:unicode, alignment: [:center])
    end
    def ParseServerLevel(username)
        server = VhackXt.Server(username)
        rows = TTY::Table.new 
        rows << ['Av1',  server["av1_str"], ' ', 'Fw1',  server["fw1_str"]]
        rows << ['Av2',  server["av2_str"], ' ', 'Fw2',  server["fw2_str"]]
        rows << ['Av3',  server["av3_str"], ' ', 'Fw3',  server["fw3_str"]]
        puts rows.render(:unicode, alignment: [:center])
    end
    def ServerUpgradeInfos()
        rows = TTY::Table.new 
        rows << ['1.',  'Single Upgrade']
        rows << ['2.',  '5 Upgrade']
        rows << ['3.',  'Mass upgrade']
        puts rows.render(:unicode)
    end
    def ServerInfoOptions()
        rows = TTY::Table.new 
        rows << ['1.',  'Colect Packages']
        rows << ['2.',  'Upgrade AV']
        rows << ['3.',  'Upgrade FW']
        puts rows.render(:unicode)
    end
    def ParseLogIn()
        rows = TTY::Table.new 
        rows << ['1',    'Login Normal']
        rows << ['2',    'File Login']
        puts rows.render(:unicode, alignment: [:center])
    end
    def ParseCreateLog()
        row = TTY::Table.new
        rows << ['1.',  'Create new Log']
        rows << ['2.',  'Delete log']
        rows << ['3.',  'View Files']
        puts "     RANK      "
        puts rows.render(:unicode, alignment: [:center])
    end
    def ParseServer(username)
        server = VhackXt.Server(username)
        rows   = []
        rows1  = []
        rows << [
                    server["av1_str"],
                    server["av2_str"],
                    server["av3_str"],
                    server["fw1_str"],
                    server["fw2_str"],
                    server["fw3_str"]
                ]
        rows1  << [
                    server["server_str"],
                    server["server_pieces"],
                    server["av_pieces"],
                    server["server_pieces"]
                  ]
                table = Terminal::Table.new :rows => rows, :headings => ["AV 1", "AV 2", "AV 3", "FW 1", "FW 2", "FW 3"], :style => {:width => 70, :border_x => "=", :border_i => "x", :alignment => :center}
                puts table
                table1 = Terminal::Table.new :rows => rows1, :headings => ["Server", "Server Pieces", "AV Pieces", "FW Pieces"], :style => {:width => 70, :border_x => "=", :border_i => "x", :alignment => :center}
                puts table1
    end
    def RankOrder()
        row = TTY::Table.new 
        rows << ['1.',  'FW']
        rows << ['2.',  'BP']
        rows << ['3.',  'SDK']
        rows << ['4.',  'Brute']
        rows << ['5.',  'Spam']
        puts rows.render(:unicode)
    end
    def ParseStore(username)
        rows2 = TTY::Table.new header: ['App Type', 'Level', 'Price','Base Price', 'Factor', 'Running']
        store = VhackXt.GetStore(username)
        table = Terminal::Table.new do |t|
        length = store["apps"].length
            for i in 1..length
                if i.to_i == length.to_i
                    break
                end
                rows2 << [
                            VhackXt.GetAppType(store["apps"][i]["appid"]),
                            Comma(store["apps"][i]["level"]),
                            Comma(store["apps"][i]["price"]),
                            Comma(store["apps"][i]["baseprice"]),
                            Comma(store["apps"][i]["factor"]),
                            store["apps"][i]["running"], 
                         ]
            end
        end
        puts rows2.render(:unicode, alignment: [:center])
    end
    def SpamTable(username)
        row = TTY::Table.new 
        spam  = VhackXt.GetSpam(username)
        row  << ['Spam Level ',    Comma(spam["spamlvl"])]
        row  << ['Income ',        Comma(spam["income"])]
        row  << ['Base Income ',   Comma(spam["baseincome"])]
        row  << ['Total Income ',  Comma(spam["totalincome"])]
        row  << ['PayOut',         Comma(spam["payout"])]
        puts row.render(:unicode)
    end
    def ParseDownloadApp()
        row = TTY::Table.new 
        row  << ['1)',  'Download AV']
        row  << ['2)',  'Download Firewall']
        row  << ['3)',  'Download Spam']
        row  << ['4)',  'Download Brute']
        row  << ['5)',  'Download Bank']
        row  << ['6)',  'Download SDK']
        row  << ['7)',  'Download Spoofing']
        puts row.render(:unicode)
    end
    def AppsListTable()
        rows = TTY::Table.new
        rows << ['AntiVirus',       1]
        rows << ['Firewall',        2]
        rows << ['Spam',            3]
        rows << ['Brute Force',     4]
        rows << ['Bank Protection', 5]
        rows << ['SDK',             6]
        rows << ['Ip Spoofing',     7]
        puts rows.render(:unicode)
    end
    def ParseSpam(username)
        spam = VhackXt.GetSpam(username)
        spam_info = [
                        "Spam Level: #{spam["spamlvl"]}",
                        "Income: $ #{spam["income"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}",
                        "Base Income: $ #{spam["baseincome"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}",
                        "Total Income: $ #{spam["totalincome"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}",
                        "PayOut: $ #{spam["payout"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
                    ]
                  return spam_info
    end
    def ParseUserInfo(login_info)
        rows = TTY::Table.new
        rows << ["Username",         login_info["username"]]
        rows << ["IP",               login_info["ipaddress"]]
        rows << ["Money",            Comma(login_info["money"])]
        rows << ["User Id",          login_info["uid"]]
        rows << ["Level",            login_info["level"]]
        rows << ["NetCoins",         Comma(login_info["netcoins"])]
        rows << ["Exploits",         login_info["exploits"]]
        rows << ["EXP",              Comma(login_info["exp"])]
        rows << ["EXP Require",      Comma(login_info["expreq"])]
        puts rows.render(:unicode, alignment: [:center])
        rows1 = TTY::Table.new
        rows1 << ["FireWall",   Comma(login_info["fw"])]
        rows1 << ["AntiVirus",  Comma(login_info["av"])]
        rows1 << ["SDK",        Comma(login_info["sdk"])]
        rows1 << ["Brute",      Comma(login_info["brute"])]
        rows1 << ["Spam",       Comma(login_info["spam"])]
        puts rows1.render(:unicode, alignment: [:center])
    end

    def ParseUserInfo1(login_info)
    	user = [
    		    "=======================================",
    		    "                USER INFO              ",
    		    "=======================================",
    	        "Username: #{login_info["username"]}",
    	        "User Id: #{login_info["uid"]}",
    	        "Exploits: #{login_info["exploits"]}",
    	        "EXP: #{login_info["exp"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}",
    	        "Exp Require #{login_info["expreq"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}",
    	        "ExPCC: #{login_info["exppc"]}",
    	        "Netcoins: #{login_info["netcoins"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}",
    	        "Level: #{login_info["level"]}",
    	        "Money: $#{login_info["money"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}}",
    	        "IP address: #{login_info["ipaddress"]}",
    	        "Task Finish: #{login_info["taskfinish"]}",
    	        "Internet: #{login_info["inet"]}",
    	        "CColor:#{login_info["ccolor"]}",
    	        "\n",
    	        "=======================================",
    		    "                APPS                   ",
    		    "=======================================",
    		    "Firewall: #{login_info["fw"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}",
    		    "Anti Virus: #{login_info["av"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}",
    		    "SDK: #{login_info["sdk"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}",
    		    "Brute Force: #{login_info["brute"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}",
    		    "Spam: #{login_info["spam"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
    	    ]
    	    return user
    end
end
end
