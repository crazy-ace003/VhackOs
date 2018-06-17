require_relative 'lib/vhackOs'
require 'colorize'
require'csv'
require'json'
require_relative 'lib/parse'
username = ""
password = ""
login_info = VhackXt.login(username, password)
puts login_info["username"]
if File.file?("database/test.csv")
    puts""
else
    File.open("database/test.csv", "w")
end
array = []
while true
    network = VhackXt.GetNetwork(username)["ips"]
    for i in 0..network.length
        if i.to_i == network.length.to_i
            break
        end
        array = [
                    network[i]["ip"], 
                    network[i]["level"], 
                    network[i]["fw"], 
                    network[i]["open"]
                ]
        if File.readlines("database/test.csv").grep(/#{network[i]["ip"]}/).any?
            puts"Already in it".yellow

        else
            puts network[i]["ip"]
            CSV.open('database/test.csv', 'a') do |csv|
                csv << array
            end
        end
    end
end
