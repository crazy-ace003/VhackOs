require_relative 'lib/vhackOs'
require_relative 'lib/parse'
begin
	require 'colorize'
rescue LoadError => e
	puts e.message
	puts"Installing Colorize..."
	`gem insall colorize`
end

username = ""
password = ""
print"Enter Username: "
username = gets.chomp
print"Enter Password: "
password = gets.chomp




login_info = VhackXt.login(username, password)
while true
	login_info = VhackXt.login(username, password)
	puts Parse.Main()
	print "root>"
	option = gets.chomp
	case option 
		when "1"
			parseUser = Parse.ParseUserInfo(login_info)
			puts parseUser
			puts
			puts
		when "2"
			spam = Parse.SpamTable(username)
			puts spam
		when "3"
			store_info = Parse.ParseStore(username)
			puts store_info
			puts
			puts Parse.ParseUpgrades(username)
		when "4"
			print
			puts"Enter 0 for no flase flag attack"
			puts"Enter 1 for default flase flag attack"
			puts"Enter 2 for custom flase flag attack"
			puts"Enter 3 for file flag"
			print"Do you want to plant a false flag?: "
			falseFlag = gets.chomp
			fn = ""
			print"Enter target IP: " 
			target = gets.chomp
			if falseFlag == "0"
				VhackXt.ExploitTarget(username, target)
				puts
			elsif falseFlag == "1"
				fn = ""
				puts VhackXt.ExploitTarget(username, target)
				VhackXt.FalseFlag(username, target, "1", fn)
				puts
			elsif falseFlag== "3"
				print"Enter the filename of the custom file ( no .txt ): "
				fn = gets.chomp
				VhackXt.ExploitTarget(username, target)
				VhackXt.FalseFlag(username, target, "3", fn)
				puts
			elsif falseFlag == "2"
				print"Enter custom text: "
				log = gets.chomp
				VhackXt.ExploitTarget(username, target)
				VhackXt.FalseFlag(username, target, log, fn)
				puts
			end
		when "5"
			    print"Enter target you want to brute:"
			    target = gets.chomp
			    VhackXt.FalseFlag(username, target, "3", fn)
			    VhackXt.StartBrute(username, target)
				Parse.ParseBrute(username)
		when "6"
			print"Enter remote Target:" 
			target = gets.chomp
			remoteLog = VhackXt.RemoteLog(username, target)
			puts
			puts "#{remoteLog["logs"]}"
			puts
		when "7"
			myLog = VhackXt.MyLog(username)
			if myLog.nil? or myLog.empty?
				puts""
				puts"You're log is empty!"
			else
				puts myLog
				puts
			end
		when "8"
			puts Parse.ParseBanking(username)
		when "9"
			    puts Parse.ParseUserApps(username)
			    store = VhackXt.GetStore(username)
			    puts"Current Amount: $" + Parse.Comma(store["money"])
			    Parse.AppsListTable()
			    puts"Enter Apps Id you want upgrade "
			    print"root@Store>".green
			    appid = gets.chomp
			    puts
			    puts
			    puts"Enter amount you want to upgrade "
			    print"root@Store>".green
			    amount = gets.chomp.to_i
			    i = 0
			    amount_spent = 0
			    total = 0
			    for i in 1..amount
				    if  store["money"].to_i <= store["apps"][appid.to_i]["price"].to_i
				        puts"App price: $" + Parse.Comma(store["apps"][appid.to_i]["price"])
				        puts"Amount Needed: $" + Parse.Comma(store["money"].to_i - store["apps"][appid.to_i]["price"].to_i)
				        puts"Error: You dont have enought money to upgrade!".red
				        appcode = appid
				        VhackXt.Store(username, appcode)
				    else
				    	a = store["apps"][appid.to_i]["price"] += amount_spent
				    	total += a
				    	appcode = appid
				    	VhackXt.Store(username, appcode)
				    	puts"Succesfully Bought: " + VhackXt.GetAppType(appcode)
				    end
				end
				puts

				Parse.ParseStoreStats(username, total, amount)
		when "10"
			puts"\t\t\t\t\t\t\t\t\tBRUTE FORCED\t\t\t\t\t\t\t\t\t"
			Parse.ParseBrute(username)
			puts
			Parse.ParseUpgrades(username)
			puts
		when "11"
			puts"Enter IP you want to scan: "
			ipaddress = gets.chomp
			puts VhackXt.SearchIp(username, ipaddress)
			puts
		when "12"
			print"Enter Username:"
			username = gets.chomp
			print"Enter Password:"
			password = gets.chomp
			print"Enter Email:"
			email = gets.chomp
			VhackXt.CreateUser(username, password, email)
			VhackXt.NewAccountBuy(username)
			puts"[+] Succesfully created user, #{username}"
			puts
		when "13"
			puts"Enter 0 to output"
			puts"Enter anything else to not output"
			print"Output the scan?: "
			action = gets.chomp
			if action == "0"
				print("Enter file name (no extension): ")
				filename = gets.chomp
				VhackXt.DumpNetwork(username, filename)
			else
				Parse.ParseNetwork(username)
				puts
			end
		when "14"
			puts Parse.ParseExploitedList(username)
			puts"1) auto brute"
			print"Root@Brute>"
			option = gets.chomp
			if option == "1"
				VhackXt.AutoBrute(username)
			else
				puts
			end
		when "15"
			print"Enter Target: "
			target = gets.chomp
			bankingInfo = VhackXt.RemoteBanking(username, target)
			Parse.ParseRemoteBanking(username, target)
			puts"Enter 0 for all: " 
			print"Enter 1 for custom amount:"
			amount = gets.chomp
			if amount == "0"
				amount = bankingInfo["money"]
				after_hack = VhackXt.StealRemoteMoney(username, target, amount)
				log = ""
				VhackXt.FalseFlag(username, target, log)
				puts
				puts"Remote User current Balance: #{after_hack["money"]}"
				puts "Your Money #{login_info["money"]}"
			else 
				print"Enter amount: "
				amount = gets.chomp
				after_hack = VhackXt.StealRemoteMoney(username, target, amount)
				log = ""
				puts 
				fn = ""
				VhackXt.FalseFlag(username, target, log, fn )
				puts"Remote User current Balance: #{after_hack["money"]}"
				puts "Your Money #{login_info["money"]}"
			end
		when "16"
			startingNetcoins = VhackXt.GetMiner(username)
			puts "Starting Netcoins: " +  Parse.Comma(startingNetcoins["netcoins"])
			puts"1) Auto decide"
			puts"2) Start Miner"
			puts"3) Collect"
			print"Action: "
			action = gets.chomp
			puts VhackXt.Miner(username, action)
		when "17"
			puts"[+] This just gets all the users that you already have brute forced and steals all the money from them, \n"
			puts
			bruteList = VhackXt.BruteList(username)["brutes"]
			if bruteList.nil?
				puts
				puts"[+] There are no brute forced Tasks" 
				puts
			else
				for i in 0..bruteList.length.to_i
					if i.to_i == bruteList.length.to_i
	                    break
	                end
	                target = bruteList[i]["user_ip"]
			    	bankingInfo = VhackXt.RemoteBanking(username, target)
					Parse.ParseRemoteBanking(username, target)
					if bankingInfo["money"] == "0" or bankingInfo["money"] == nil
						VhackXt.FalseFlag(username, target, "1", "0")
						puts"[+] The User doesnt have any money"
						puts
					else
						log = ""
						VhackXt.FalseFlag(username, target, "1", "0")
						myBanking = VhackXt.Banking(username)
						amount = bankingInfo["money"]
						after_hack = VhackXt.StealRemoteMoney(username, target, amount)
						VhackXt.FalseFlag(username, target, "", "0")
						puts"Remote User current Balance: #{after_hack["money"]}"
						puts"Your Money #{Parse.Comma(myBanking["money"])}"
						puts
					end
				end
			end
		when "18"
			puts "[+] This will keep on upgrading as long as you have the money"
			puts"[+] It will sleep for 5 minutes to let the processes finish and so we dont send too many packets to their server."
			puts
			Parse.AppsListTable()
			puts"Enter Apps Id you want upgrade "
			print"root@Store>".green
			appid = gets.chomp
			while true
				store = VhackXt.GetStore(username)
				if store["money"] == "0"
					puts"[+] Sorry, dude you ran out of money."
					break
				else
					upgrade = VhackXt.GetTasks(username)
					if upgrade["updates"].nil?
						i = 0
						store = VhackXt.GetStore(username)
						for i in 1..10
							store = VhackXt.Store(username, appid)
						
						puts"Current Amount: $" + Parse.Comma(store["money"])
						puts
						end
						puts"Added 10 new tasks"
					elsif upgrade["updates"].length.to_i < 10
						amountOfNewTasks = 10 - upgrade["updates"].length
						for i in 0..amountOfNewTasks.to_i
							store = VhackXt.Store(username, appid)
						puts"Added #{amountOfNewTasks} new tasks"
						puts"Current Amount: $" + Parse.Comma(store["money"])
						puts
						end
					elsif upgrade["updates"].length.to_i == 10
						puts"[+] Already 10 upgrades running"
						break
						puts
					end
					sleep 300
				end
			end
		when "19"
			puts"[+] This will go through all you brute tasks and retry those bastards. Hopefully they fail again."
			bruteList = VhackXt.BruteList(username)["brutes"]
			if bruteList.nil?
				puts"[+] No failed brute forced attacks"
				puts
			else
				for i in 0..bruteList.length
					if i.to_i == bruteList.length.to_i
	                    break
	                end
					if bruteList[i]["result"] == "2"
						VhackXt.BruteRetry(username, bruteList[i]["user_ip"])
						puts"Retrying #{bruteList[i]["user_ip"]}"
					else
						puts"You have no failed tasks"
					end
				end
			end
		when "20"
			puts"[+] Will auto scan and exploit targets that are within your app range. "
			puts"[+] False flag is default 1. "
			puts
			network = VhackXt.GetNetwork(username)["ips"]
			fwLevel = VhackXt.GetStore(username)["apps"][6]["level"].to_i
			for i in 0..network.length
				if i.to_i == network.length.to_i
	                break
	            end
				if fwLevel >= network[i]["fw"].to_i
					puts"===================================="
					target = network[i]["ip"]
					VhackXt.ExploitTarget(username, target)
					VhackXt.FalseFlag(username, target, "1", fn)
					puts"===================================="
					puts

				else
					puts"===================================="
					puts"Victim IP: #{target}"
					puts"Victim Fw: #{network[i]["fw"]}"
					puts"[+] Your SDK is not high enough"
					puts"===================================="
					puts
				end
			end
		when "21"
			puts"[+] Auto Open packages."
			puts 
			puts VhackXt.OpenAllPackages(username)
			puts ""
		when "22"
			puts
			i = 0
			for i in 0..10
				store = VhackXt.GetStore(username)
				puts"[+] Loop #{i}"
				# FIREWALL
				if  store["money"].to_i >= store["apps"]["2".to_i]["price"].to_i
					puts"[+] Rank: 1"
					VhackXt.Store(username, "2")
					puts"[+] Bought Firewall"
					store = VhackXt.GetStore(username)
					puts"Current Amount: $" + Parse.Comma(store["money"])
					puts
				# Bank Protection
				elsif store["money"].to_i >= store["apps"]["5".to_i]["price"].to_i
					puts"[+] Rank: 2"
					VhackXt.Store(username, "5")
					puts"[+] Bought Bank Protection"
					store = VhackXt.GetStore(username)
					puts"Current Amount: $" + Parse.Comma(store["money"])
					puts
					#SDK
				elsif store["money"].to_i >= store["apps"]["6".to_i]["price"].to_i
					puts"[+] Rank: 3"
					VhackXt.Store(username, "6")
					puts"[+] Bought SDK"
					store = VhackXt.GetStore(username)
					puts"Current Amount: $" + Parse.Comma(store["money"])
					puts
				#Brute Forced
				elsif store["money"].to_i >= store["apps"]["4".to_i]["price"].to_i
					puts"[+] Rank: 4"
					VhackXt.Store(username, "4")
					puts"[+] Bought Brute Force"
					store = VhackXt.GetStore(username)
					puts"Current Amount: $" + Parse.Comma(store["money"])
					puts
				#Spam
				elsif store["money"].to_i >= store["apps"]["3".to_i]["price"].to_i
					puts"[+] Rank: 5"
					VhackXt.Store(username, "3")
					puts"[+] Bought Spam"
					store = VhackXt.GetStore(username)
					puts"Current Amount: $" + Parse.Comma(store["money"])
					puts
				else
					puts"[+] You dont have enought money"
					break
				end
			i += 1
			break if i == 10
			end
		when "23"
			puts Parse.ParseServer(username)
			puts
			puts Parse.ServerInfoOptions()
		    print "root@Server> "
		    option = gets.chomp
		    case option
		    when "1"
		    	puts VhackXt.OpenAllPackages(username)
		    when "2"
		    	puts"[+] Upgrade 1 AntiVirus"
		    	puts
		    	serverInfo = VhackXt.Server(username)
		    	if serverInfo["av_pieces"].to_i >= 0
		    		VhackXt.BuyServerNode(username, "1", "1", "500")
		    		puts" Upgraded 1 AV"
		    	else
		    		puts "You do not have enought AV Pieces"
		    	end
		    when "3"
		    	puts "[+] Upgrade 5 AntiVirus"
		    	puts
		    	serverInfo = VhackXt.Server(username)
		    	if serverInfo["av_pieces"].to_i >= 5
		    		VhackXt.BuyServerNode(username, "1", "1", "600")
		    		puts" Upgraded 5 AV"
		    	else
		    		puts"You do not have enough AV Pieces"
		    	end
		    when "4"
		    	puts"[+] Mass upgrade"
		    	puts
		    	print"Enter amount:"
		    	amount = gets.chomp
		    	i = 0
		    	while i < amount.to_i
		    		until i == amount.to_i
			    		a = 0
			    		puts"[+] Upgrade 1 AntiVirus"
			    		puts
				    	serverInfo = VhackXt.Server(username)
				    	if serverInfo["av_pieces"].to_i >= 0
				    		VhackXt.BuyServerNode(username, "1", "1", "500")
				    	    a+=1
				    	else
				    		puts "You do not have enought AV Pieces"
				    		break
				    	end
				    i+=1
				    end
		    	end
			    puts Parse.ParseServer(username)
		    end
		when "24"
			    puts Parse.ParseCreateLog()
			    print "root@Log> "
		    	option = gets.chomp
		    	if option == "1"
		    		puts"[+] Create file... "
		    		puts
		    		print"Enter filename you want to create: " 
		    		fileName = gets.chomp
		    		print"Enter the text you want to add to file: "
		    		text = gets.chomp
		    		puts VhackXt.AddCustomLog(fileName, text)
		    	elsif option == "2"
		    		puts"[+] Delete File..."
		    		puts
		    		puts VhackXt.ListCustomLog()
		    		puts
		    		puts"Enter filename you want to delete: " 
		    		filename = gets.chomp
		    		puts VhackXt.DeleteCustomLog(filename)
		    	elsif option == "3"
		    		puts"[+] Listing File names......"
		    		puts VhackXt.ListCustomLog()
		    	end
		when "25"
			puts Parse.ParseSDK(username)
			puts
			puts Parse.SDKOptions()
			print"root@SDK> ".green
			options = gets.chomp
			case options
			when "1"
				puts
				print"root@amount> ".green
				amount = gets.chomp
				puts VhackXt.BuyBulkSDK(username, amount)
			when "2"
				puts VhackXt.BuySingleSDK(username)
			end
		when "26"
			puts"[+] Amount of booster you want to speed"
			task = VhackXt.GetTasks(username)
			puts"Starting Boosters: " + task["boosters"]
			puts""
			print"root@AmountOfBoosters> "
			amount = gets.chomp
			i = 0
			while i < amount.to_i
				until i == amount.to_i
					puts"=============================="
					puts "Loop Number: #{i}"
					VhackXt.SpeedUpUpgrades(username)
					puts"==============================="
					puts
					i+=1
				task = VhackXt.GetTasks(username)
				puts"Ending Boosters: #{task["boosters"]}"
			    end
			end
		when "27"
			puts"[+] Downloading app center"
			puts Parse.ParseDownloadApp()
			puts
			puts"Enter options: "
			print"Root@Download> ".green
			option = gets.chomp
			case option
				when "1"
					puts"[+] DOWNLOAD ANTIVIRUS [+]"
					VhackXt.DownloadApp(username, "1")
				when "2"
					puts"[+] DOWNLOAD FIREWALL [+]"
					VhackXt.DownloadApp(username, "2")
				when "3"
					puts"[+] DOWNLOAD SPAM [+]"
					VhackXt.DownloadApp(username, "3")
				when "4"
					puts"[+] DOWNLOAD BRUTE [+]"
					VhackXt.DownloadApp(username, "4")
				when "5"
					puts"[+] DOWNLOAD BANK PROTECTION [+]"
					VhackXt.DownloadApp(username, "5")
				when "6"
					puts"[+] DOWNLOAD SDK [+]"
					VhackXt.DownloadApp(username, "6")
				when "7"
					puts"[+] DOWNLOAD IP SPOOFING [+]"
					VhackXt.DownloadApp(username, "7")
				when "8"
					puts"[+] DOWNLOAD MINER [+]"
					VhackXt.DownloadMiner(username)
				end
		when "quit"
			puts
			puts"Bye!"
			exit
		end
end
