require 'digest/md5'
require 'json'
require 'base64'
require 'open-uri'
require 'time'
require 'uri'
require'json'
require "net/http"
require 'colorize'
module Types
  class << self
    public
    def BruteTypes(*args)
        args = args.shift
        case args
        when "0"
            return "Brute attack is currently  running"
        when "1"
            return "Brute attack Finished"
        when "2"
            return "Brute  attack Failed"
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
            return "Ip Spoofing"
        when "13"
            return "Malware Kit"
        when "14"
            return "Jobs"
    	end
    end
end