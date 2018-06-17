require_relative 'lib/vhackOs'
require_relative 'lib/parse'
require'time'
# TO CREATE THE CRON JOB THAT WILL RUN THE SCRIPT TO COLLECT USE:
# */15 * * * * /usr/bin/ruby /path to file/CollectPackages.rb >> /var/log/cron.log
# To start it use: /etc/init.d/cron restart
puts "++++++++++++++++++++++++++++++++++++++++++++++++"
username = ""
password = ""
login_info = VhackXt.login(username, password)
puts VhackXt.OpenAllPackages(username)
puts "++++++++++++++++++++++++++++++++++++++++++++++++"
