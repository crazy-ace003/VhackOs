require 'digest/md5'
require 'json'
require 'base64'
require 'open-uri'
require 'time'
require 'uri'
require 'json'
require "net/http"
require 'colorize'
require 'csv'
module VhackXt
  class << self
    public
    def Main(php, username, userAndPass)
        user = userAndPass[0]
        pass = userAndPass[1]
        url = "https://api.vhack.cc/mobile/15/#{php}?user=#{user}&pass=#{pass}"
        response = open(url, 'User-Agent' => 'Dalvik/1.6.0 (Linux; U; Android 4.1.1; BroadSign Xpress 1.0.14 B- (720) Build/JRO03H)').read
        json = JSON.parse(response)
        return json
    end
    def GenerateUserAndPass(login_info)
    	hashed_info = (JSON[login_info]+JSON[login_info]+Digest::MD5.hexdigest(JSON[login_info]))
        pass = Digest::MD5.hexdigest(hashed_info).gsub("==", "").gsub("=", "")
        user = Base64.encode64(JSON[login_info]).gsub("==", "").gsub("=", "")
        return user, pass
    end
    def CreateUser(username, password, email)
        login_info = {'username' => username, 'password' => Digest::MD5.hexdigest(password), 'email' => email, 'lang' => "en"}
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("register.php", username, userAndPass)
        Dir.mkdir("accounts") unless Dir.exist?("accounts")
        f = File.open("accounts/#{username}.json", "w") unless File.exist?("accounts/#{username}")
        f << JSON[user_data]
        f.close
        q = File.open("accounts/#{username}.txt", "w") unless File.exist?("accounts/#{username}.txt")
        q << username + ":" + password
        q.close
        login(username, password)     
    end
    def login(username, password)
    	password = Digest::MD5.hexdigest(password)
    	login_info = {'username' => username, 'password' => password, 'lang' => "en"}
    	userAndPass = GenerateUserAndPass(login_info)
    	user = userAndPass[0]
        pass = userAndPass[1]
        url = "https://api.vhack.cc/mobile/15/login.php?user=#{user}&pass=#{pass}"
        response = open(url, 'User-Agent' => 'Mozilla/5.0 (Linux; Android 5.1.1; SM-G928X Build/LMY47X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.83 Mobile Safari/537.36').read
		json = JSON.parse(response)
		if json.nil?
			puts"error in login"
		else
			login_info = {
				"uid" => json['uid'], 
				"accesstoken" => json['accesstoken']
			}
			Dir.mkdir("accounts") unless Dir.exist?("accounts")
			f = File.open("accounts/#{username}.json", "w") unless File.exist?("accounts/#{username}")
			f << JSON[login_info]
			f.close
			login_info["lastread"] = 0
			login_info["notify"] = 1
            login_info["token"] = ""
			getUserInfo = GenerateUserAndPass(login_info)
			user = getUserInfo[0]
			pass = getUserInfo[1]
			url = "https://api.vhack.cc/mobile/15/update.php?user=#{user}&pass=#{pass}"
	        response = open(url, 'User-Agent' => 'Mozilla/5.0 (Linux; Android 5.1.1; SM-G928X Build/LMY47X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.83 Mobile Safari/537.36').read
			user_data = JSON.parse(response)
			return user_data
		end
    end
    def FileLogin(filename)
        f = File.open("accounts/#{filename}.txt", "r").each do |login|
            a= login.split(':');
            username = a[0]
            password = a[1]
            puts username
            puts password
            password = Digest::MD5.hexdigest(password)
            login_info = {'username' => username, 'password' => password, 'lang' => "en"}
            userAndPass = GenerateUserAndPass(login_info)
            user = userAndPass[0]
            pass = userAndPass[1]
            url = "https://api.vhack.cc/mobile/15/login.php?user=#{user}&pass=#{pass}"
            response = open(url, 'User-Agent' => 'Mozilla/5.0 (Linux; Android 5.1.1; SM-G928X Build/LMY47X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.83 Mobile Safari/537.36').read
            json = JSON.parse(response)

            if json.nil?
                puts"Error in login"
            else
                login_info = {
                    "uid" => json['uid'], 
                    "accesstoken" => json['accesstoken']
                }
                Dir.mkdir("accounts") unless Dir.exist?("accounts")
                begin
                        File.delete("accounts/#{username}.json")
                rescue
                end
                f = File.open("accounts/#{username}.json", "w") unless File.exist?("accounts/#{username}.json")
                f << JSON[login_info]
                f.close
                login_info["lastread"] = 0
                login_info["notify"] = 1
                login_info["token"] = ""
                getUserInfo = GenerateUserAndPass(login_info)
                user = getUserInfo[0]
                pass = getUserInfo[1]
                url = "https://api.vhack.cc/mobile/15/update.php?user=#{user}&pass=#{pass}"
                response = open(url, 'User-Agent' => 'Mozilla/5.0 (Linux; Android 5.1.1; SM-G928X Build/LMY47X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.83 Mobile Safari/537.36', 'api-version' => '2').read
                user_data = JSON.parse(response)
                return user_data, username
            end
        end
    end
    def ReadJson(username)
        file = File.read("accounts/#{username}.json")
        data_hash = JSON.parse(file)
        return data_hash
    end
    def RandomEmailBase()
        emailBase = ["@gmail.com", 
                    "@gmail.co.uk",
                    "@gmail.nl",
                    "@gmail.fr",
                    "@gmail.jp",
                    "@gmail.de",
                    "@gmai.br",
                    "@aol.com",
                    "@yahoo.com",
                    "@yahoo.nl",
                    "@yahoo.fr",
                    "@rpi.edu",
                    "@harvard.edu",
                    "@cam.ac.uk",
                    "@msn.com",
                    "@vhack.cc",
                    "@admin.com",
                    "@tacobell.com",
                    "@mcdonald.com",
                    "@beer.com",
                    "@gmx.com", 
                    "@mac.com",
                    "@naver.com",
                    "@mail.ru",
                    "@protonmail.com",
                    "@hotmai.com",
                    "@rocketmail.com",
                    "@europa-uni.de",
                    "@facebook.com",
                    "@rz.hu-berlin.de"]
                return emailBase.shuffle.first
    end
    def RandomSleep()
        time = rand(1..180)
        puts"About to sleep for #{time}....."
        sleep time.to_i
    end
    def NewAccountBuy(username)
            login_info = ReadJson(username)
            login_info["appcode"] = "0"
            login_info["action"] = "200"
            userAndPass = GenerateUserAndPass(login_info)
            user_data = VhackXt.Main("store.php", username, userAndPass)
            login_info["appcode"] = "3"
            login_info["action"] = "200"
            userAndPass = GenerateUserAndPass(login_info)
            user_data = VhackXt.Main("store.php", username, userAndPass)
            for i in 0..10
                VhackXt.Store(username, "3")
                #buying 10 spam, you need to do this
                #when you make an new account before you buy other shit
            end

    end
    def ParseUserInfo(login_info)
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

   
    def GetTasks(username)
    	login_info = ReadJson(username)
    	userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("tasks.php", username, userAndPass)
	    return user_data
    end
    def GetEndUpdateTime(username)
        upgrade =  GetTasks(username)
        if upgrade["updates"].nil?
            puts" No Apps are upgrading"
        else
            length = upgrade["updates"].length
            for i in 0..length
                if i.to_i == length.to_i
                    break
                end
                time1 = Time.new
                puts "Current Time : " + time1.inspect
                currentTime = time1.inspect
                if currentTime.to_i >= UnixConvert(upgrade["updates"][i]["end"])
                    puts"[+] Updates has finished"
                    return "0"
                else 
                    puts"[+] Updates are still going"
                    return "1"
                end
            end
        end
    end
    def GetMiner(username)
        login_info = ReadJson(username)
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("mining.php", username, userAndPass)
        return user_data
    end
    def SendMinerData(username, action)
        login_info = ReadJson(username)
        login_info["action"] = action
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("mining.php", username, userAndPass)
        return user_data
    end
    def DownloadMiner(username)
        login_info = ReadJson(username)
        login_info["action"]  = "200"
        login_info["appcode"] = "11"
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("store.php", username, userAndPass)
        store     = GetStore(username)["apps"][11]["level"]
        if store == "1" or store == 1
            return "[+] Downloaded Miner"
        else 
            return "[+] Error: Miner was not downloaded"
        end

    end
    def Miner(username, action)
        user_data = GetMiner(username)
        if action == "1"
            if user_data["running"] == "0"
                SendMinerData(username, "100")
                return "Starting Miner."
            elsif user_data["running"] == "1"
                return "Its Running!"
            elsif  user_data["running"] == "2"
                SendMinerData(username, "200")
                SendMinerData(username, "100")
                return "Collecting Your Netcoins."
            end
        elsif action == "2"
            SendMinerData(username, "100")
            return "Starting Miner."
        elsif action == "3"
            SendMinerData(username, "200")
            return "Collecting Your Netcoins."
            SendMinerData(username, "100")
        else
            return "Invalid action"
        end
        return user_data
    end
    def SearchIp(username, ipaddress)
        login_info = ReadJson(username)
        login_info["ipaddress"] = ipaddress
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("scan.php", username, userAndPass)
        return user_data
    end
    def FunScan(username, fileName, amount)
        # this was an failed idea...
        while true
            ipaddress = "#{rand(99)}.#{rand(100)}.#{rand(10)}.#{rand(255)}"
            user_data = VhackXt.SearchIp(username, ipaddress)
            puts user_data
            puts ipaddress
            if user_data["result"] == "1"
                puts"Not an IP".red
            else
                Dir.mkdir("database") unless Dir.exist?("database")
                f = File.open("database/#{fileName}.json", "w") unless File.exist?("database/#{fileName}.json")
                ip = {
                    "Firewall"   => user_data['fw'],
                    "Ip Adress"  => user_data['ipaddress'],
                    "Level"      => user_data['level']
                }
                f << ip 
                f <<"\n"
            end
        end
    end
    def GetSpam(username)
    	login_info = ReadJson(username)
    	userAndPass = GenerateUserAndPass(login_info)
    	user_data = VhackXt.Main("spam.php", username, userAndPass)
		return user_data
    end
    def GetSDK(username)
        login_info = ReadJson(username)
        userAndPass = GenerateUserAndPass(login_info)
        begin
            user_data = VhackXt.Main("sdk.php", username, userAndPass)
            return user_data
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 10 seconds.".red
            sleep(10)
            retry
        end
    end
    def UnixConvert()
    	return Time.at(time.to_i).strftime("%B %e, %Y at %I:%M %p")
    end
    def BruteTypes(*args)
        args = args.shift
        case args
        when "0"
            return "Brute attack is currently  running"
        when "1"
            return "Brute attack Finished"
        when "2"
            return "Not brute"
        when "4"
        end
    end
    def GetRemoteBankingType(*args)
        args = args.shift
        case args
        when "0"
            return "[+] Unable to steal."
            puts
        when "1"
            return "[+] Able to steal from user"
        end
    end
    def GetAppType(appid)
    	case appid
        when "0"
            return "NotePad"
    	when "1"
    		return "Anti Virus"
    	when "2"
    		return "Firewall"
    	when "3"
    		return "Spam"
    	when "4"
    		return "Brute Force"
    	when "5"
    		return "Bank Protection"
    	when "6"
    		return "SDK"
        when "7"
            return "Community"
        when "8"
            return "Missions"
        when "9"
            return "Leaderboards"
        when "10"
            return "Ip Spoofing"
        when "11"
            return "Mining"
        when "12"
            return "Malware Kit"
        when "14"
            return "Jobs"
    	end
    end
    def NodeType(*args)
        args = args.shift
        case args
        when "1"
            return "Anti-Virus"
        when "2"
            return "Firewall"
        end
    end
    def MalwareKit(username)
        login_info = ReadJson(username)
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("mwk.php", username, userAndPass)
    end
    def GetLog(username)
    	login_info = ReadJson(username)
    	getUserInfo = GenerateUserAndPass(login_info)
    	user = getUserInfo[0]
		pass = getUserInfo[1]
    	url = "https://api.vhack.cc/mobile/15/log.php?user=#{user}&pass=#{pass}"
        response = open(url, 'User-Agent' => 'Mozilla/5.0 (Linux; Android 5.1.1; SM-G928X Build/LMY47X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.83 Mobile Safari/537.36').read
		user_data = JSON.parse(response)
		return user_data
    end
    def BruteList(username)
        login_info = ReadJson(username)
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("tasks.php", username, userAndPass)
        return user_data
    end
    def GetUserApps(username)
        login_info = ReadJson(username)
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("store.php", username, userAndPass)
        return user_data
    end
    def ConvertSecondsToMinutes(*args)
        seconds = args.shift
        return seconds.to_i / 60
    end
    def BuyServerNode(username, node_type, node_number, action)
        login_info = ReadJson(username)
        login_info["node_type"] = node_type
        login_info["node_number"] = node_number
        login_info["action"] = action
        # 500 => one buy
        # 600 => 5 buy
        userAndPass = GenerateUserAndPass(login_info)
        begin
            user_data = VhackXt.Main("server.php", username, userAndPass)
            return user_data
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 10 seconds.".red
            sleep(10)
            retry
        end
    end
    def AddCustomLog(fileName, text)
        Dir.mkdir("logs") unless Dir.exist?("logs")
        f = File.open("logs/#{fileName}.txt", "w") unless File.exist?("logs/#{fileName}.txxt")
        f << text
        puts "Created the log."
    end
    def DeleteCustomLog(filename)
        File.delete(filename) if File.exist?(filename)
        puts"Succesfully Deleted file"
    end
    def ListCustomLog()
        puts Dir.entries("./logs")
    end
    def ReadCustomLog(filename)
        f = File.read("logs/#{filename}.txt") unless File.exist?("logs/#{filename}.txxt")
        return f
    end
    def OpenAllPackages(username)
        package = Server(username)
        if package["packs"] > "0"
            login_info = ReadJson(username)
            login_info["action"] = "2000"
            userAndPass = GenerateUserAndPass(login_info)
            user_data = VhackXt.Main("server.php", username, userAndPass)
            respond = "[+] Opened all packages \n [+] Packages: #{package["packs"]}"
            return respond
        elsif package["packs"] == "0"
            puts "[+] No packages to open."
            seconds = ConvertSecondsToMinutes(package["nextpackin"])
            puts "[+] Next package in " + seconds.to_s + " minutes."
        else
            puts"[+] ERROR!".red
        end
    end
    def Server(username)
        login_info = ReadJson(username)
        userAndPass = GenerateUserAndPass(login_info)
        begin
            user_data = VhackXt.Main("server.php", username, userAndPass)
            return user_data
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def Store(username, appcode)
    	login_info = ReadJson(username)
    	login_info["appcode"] = "#{appcode}"
    	login_info["action"]  = 100
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("store.php", username, userAndPass)

    	return user_data
    end
    def BuySingleSDK(username)
        login_info = ReadJson(username)
        login_info["action"]  = 100
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("sdk.php", username, userAndPass)
        return "[+] Succesfully bought SDK"
    end
    def BuyBulkSDK(username, amount)
        netcoins = GetTasks(username)["netcoins"]
        amountCosted = 50 * amount.to_i
        if netcoins.to_i <= amountCosted.to_i
            puts"[+] Sorry, you don't have enough netcoins!"
        elsif netcoins.to_i >= amountCosted.to_i
            i = 0
            for i in 1..amount.to_i
                login_info = ReadJson(username)
                login_info["action"]  = 100
                userAndPass = GenerateUserAndPass(login_info)
                user_data = VhackXt.Main("sdk.php", username, userAndPass)
                puts"[+] Succesfully bought, #{amount} SDK's"
                nil
            end
        else
            puts"[+] Unknown error!"
        end
    end
    def SpeedUpUpgrades(username)
        task = GetTasks(username)["updates"]
        if task.nil?
            puts"[+] No upgrades to speed up"
        else
            login_info = ReadJson(username)
            login_info["action"] = "888"
            login_info["updateid"] = task[0]["id"]
            userAndPass = GenerateUserAndPass(login_info)
            begin
                user_data = VhackXt.Main("tasks.php", username, userAndPass)
                return user_data
            rescue => e
                puts "Exception Message: #{ e.message }".red
                puts "Retrying...... please wait 20 seconds.".red
                sleep(20)
                retry
            end
        end
    end
    def FinishTask(username)
        # UGGG too lazy....
        login_info = ReadJson(username)
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("tasks.php", username, userAndPass)
    end
    def GetMissions(username)
        login_info = ReadJson(username)
        userAndPass = GenerateUserAndPass(login_info)
        user_data = VhackXt.Main("missions.php", username, userAndPass)
    end
    def MoneyExploit(username, target, amount)
        begin
            Remote(username, target)
            remote_Banking = RemoteBanking(username, target)
            StealRemoteMoney(username, target, amount)
            return remote_Banking
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def StealRemoteMoney(username, target, amount)
        check = RemoteBanking(username, target)
        login_info = ReadJson(username)
        login_info["target"] = target
        login_info["action"] = 100
        login_info["amount"] = amount
        userAndPass = GenerateUserAndPass(login_info)
        begin
            user = VhackXt.Main("remotebanking.php", username, userAndPass)
            return user
        rescue OpenURI::HTTPError => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def Remote(username, target)
        login_info = ReadJson(username)
        login_info["target"] = target
        login_info["lang"] = "en"
        userAndPass = GenerateUserAndPass(login_info)
        begin
            user_data = VhackXt.Main("remote.php", username, userAndPass)
            return user_data
        rescue => e 
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry 
        end
    end
    def RemoteBanking(username, target)
        Remote(username, target)
        login_info = ReadJson(username)
        login_info["target"] = target
        userAndPass = GenerateUserAndPass(login_info)
        begin
            user_data = VhackXt.Main("remotebanking.php", username, userAndPass)
            return user_data
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def GetNetwork(username)
    	login_info = ReadJson(username)
    	userAndPass = GenerateUserAndPass(login_info)
        begin
            user_data = VhackXt.Main("network.php", username, userAndPass)
            return user_data
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def DumpNetwork(username, filename)
        network = GetNetwork(username)["ips"]
        Dir.mkdir("database") unless Dir.exist?("database")
        length = network.length.to_i
        for i in 0..length
            if i.to_i == length.to_i
                    break
                end
            login_info = 
                {'IP' => network[i]["ip"], 'level' => network[i]["level"], 'fw' => network[i]["fw"], 'Open' => network[i]["open"]}
        
        f = File.open("database/#{filename}.json", "a") unless File.exist?("database/#{filename}.json")
        f << JSON[login_info]
        end
    end
    def RemoteLog(username, target)
        begin
            login_info = ReadJson(username)
            login_info["target"] = target
            userAndPass = GenerateUserAndPass(login_info)
            json = Main("remotelog.php", username, userAndPass)
            return json
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def WriteToRemoteLog(username, log, target)
        login_info = ReadJson(username)
        login_info["target"] = target
        login_info["log"] = log
        login_info["action"] = 100
        userAndPass = GenerateUserAndPass(login_info)
        begin
            json = Main("remotelog.php", username, userAndPass)
            return json
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def GetStore(username)
        begin
            login_info = ReadJson(username)
            userAndPass = GenerateUserAndPass(login_info)
            json = Main("store.php", username, userAndPass)
            return json
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def DownloadApp(username, appcode)
        begin
            login_info = ReadJson(username)
            login_info["appcode"] = appcode
            login_info["action"] = "200"
            userAndPass = GenerateUserAndPass(login_info)
            user_data = VhackXt.Main("store.php", username, userAndPass)
            return user_data
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def ViewProfile(username, user_id)
        login_info = ReadJson(username)
        login_info["user_id"] = user_id
        userAndPass = GenerateUserAndPass(login_info)
        json = Main("profile.php", username, userAndPass)
        return json
    end
    def FalseFlag(username, target, log, fn)
    	# log 1 => Generate random ip
        # log 2 => normal
        # log 3 => file log
    	#Anything other your own message
        begin
            time = Time.new
            if log == 1 or log == "1"
                ip = "#{rand(99)}.#{rand(100)}.#{rand(10)}.#{rand(255)}"
                falseMessage1 = "[" + time.strftime("%m/%d %H:%M") + "] " + ip + " connected to your device."
                falseMessage2 = "[" + time.strftime("%m/%d %H:%M") + "] SECURITY ALERT " + ip + " just exploited your device"
                falseMessage3 = "[" + time.strftime("%m/%d %H:%M") + "] SECURITY ALERT " + ip + " accessed your Banking App!"
                log = falseMessage1  + "\n" + falseMessage2 + "\n" + falseMessage3
                remoteLog = WriteToRemoteLog(username, log, target)
                if remoteLog["result"] == "2"
                    puts"Succesfully wrote to remote log".green
                else
                    puts"Error in writing to log".red
                end
            elsif log == 2 or log == "2"
                remoteLog = WriteToRemoteLog(username, log, target)
                if remoteLog["result"] == "2"
                    puts"Succesfully wrote to remote log".green
                else
                    puts"Error in writing to log".red
                end
            elsif log == 3 or log =="3"
                filename = fn
                log =  ReadCustomLog(filename)
                remoteLog = WriteToRemoteLog(username, log, target)
                if remoteLog["result"] == "2"
                    puts"Succesfully wrote to remote log".green
                else
                    puts"Error in writing to log".red
                end
            else
                remoteLog = WriteToRemoteLog(username, log, target)
                if remoteLog["result"] == "2"
                    puts"Succesfully wrote to remote log".green
                else
                    puts"Error in writing to log".red
                end
            end
        rescue => e
            puts"FalseFlag Error: #{e}".red
        end
    end

    def MyLog(username)
        begin
            login_info = ReadJson(username)
            userAndPass = GenerateUserAndPass(login_info)
            json = Main("log.php", username, userAndPass)
            return json["logs"].green
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def AutoExploit(username)
        network = GetNetwork(username)
        length = network["ips"].length
        i = 0
        for i in 0..length
            if i.to_i == length.to_i
                #this is to stop the loop so it doesnt call that dumbass error
                break
            end
            target = network["ips"][i]["ip"]
            puts "[+] IP attacking: " + target
            ExploitTarget(username, target)
            log = ""
            WriteToRemoteLog(username, log, target)
        end
    end
    def AutoBrute(username)
        user_data = VhackXt.ExploitedList(username)
        length = user_data.length
        rows = []
        for i in 0..length
            if i.to_i == length.to_i
                break
            end
            target = user_data[i]["ip"]
            puts"==========================="
            puts "Target: #{target}"
            VhackXt.StartBrute(username, target)
            puts"==========================="

        end

    end
    def SaveUserName(username)
        user_data   = VhackXt.ExploitedList(username)
        length = user_data.length
        for i in 0..length
            if i.to_i == length.to_i
                break
            end
            array = [
                        user_data[i]["ip"],
                        user_data[i]["username"]
                    ]
            if File.readlines("database/Username.csv").grep(/#{user_data[i]["ip"]}/).any?
                puts"Already in it".yellow
            else
                puts user_data[i]["ip"]
                CSV.open('database/Username.csv', 'a') do |csv|
                    csv << array
                end
            end
        end
    end
    def ExploitedList(username)
        user_data = GetNetwork(username)["cm"]
        return user_data
    end
    def SendUsername(username, ip, uName)
        url = "http://159.89.186.14:8080/checkDb/" + ip + "/" + uName
        begin
            response = open(url.to_s, 'User-Agent' => 'Dalvik/1.6.0 (Linux; U; Android 4.1.1; BroadSign Xpress 1.0.14 B- (720) Build/JRO03H)', 'api-version' => '2').read
        rescue => e
            puts "Exception Message: #{ e.message }".red
        end
    end
    def AutoExploitTarget(username, target)
        login_info = ReadJson(username)
        login_info["target"] = target
        userAndPass = GenerateUserAndPass(login_info)
        begin
            json = Main("exploit.php", username, userAndPass)
            sdk = VhackXt.GetSDK(username)["exploits"]
            i = 0 
            for i in 0..sdk.to_i
                puts i
                if i.to_i == sdk.to_i
                    puts"Ending"
                    break
                end
                puts"[+]SDK Left: #{sdk}"
                if json["exploits"] == "0"
                    puts"[+] No exploits left"
                    break
                elsif json["result"] == "0"
                    ip       = json["cm"][0]["ip"]
                    uName    = json["cm"][0]["username"].to_s
                    SendUsername(username, ip, uName)
                    puts"IP: "       + json["cm"][0]["ip"]
                    puts"Username: " + uName
                    puts"Succesfully exploited target.".green

                end
            end
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def ExploitTarget(username, target)
        login_info = ReadJson(username)
        login_info["target"] = target
        userAndPass = GenerateUserAndPass(login_info)
        begin
            json = Main("exploit.php", username, userAndPass)
            if json["exploits"] == "0"
                puts"[+] You have zero Exploits."
            else
                if json["result"] == "3"
                    puts"Exploit was not Succesfully!."
                elsif json["result"] == "0"
                    ip       = json["cm"][0]["ip"]
                    uName    = json["cm"][0]["username"].to_s
                    SendUsername(username, ip, uName)
                    puts"IP: "       + json["cm"][0]["ip"]
                    puts"Username: " + uName
                    puts"Succesfully exploited target.".green
                end
            end
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def BruteRetry(username, target)
        # I THINK ITS ONLY FOR BRUTE NO 100% sure
        login_info = ReadJson(username)
        login_info["target"] = target
        login_info["action"] = "10005"
        userAndPass = GenerateUserAndPass(login_info)
        begin
            json = Main("tasks.php", username, userAndPass)
            return json
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
    def StartBrute(username, target)
    	login_info = ReadJson(username)
        login_info["target"] = target
        userAndPass = GenerateUserAndPass(login_info)
        begin
            json = Main("startbruteforce.php", username, userAndPass)
            if json["result"] == "0"
                puts"[+] Succesfully brute Ip".green
            elsif json["result"] == "2"
                puts"[+] Brute failed".red
            elsif json["result"] == "3"
                puts"[+] Brute List is full".red
            end
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end

    def Banking(username)
        login_info = ReadJson(username)
        userAndPass = GenerateUserAndPass(login_info)
        begin
            json = Main("banking.php", username, userAndPass)
            return json
        rescue => e
            puts "Exception Message: #{ e.message }".red
            puts "Retrying...... please wait 20 seconds.".red
            sleep(20)
            retry
        end
    end
end
end
