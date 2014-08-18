require "mechanize"
require "open-uri"
require "nokogiri"
require "instagram"
require "iron_worker_ng"
require "sinatra/base"
require "rubygems"
require "mongo"
require "uri"
require "json"
#require "watir-webdriver"

require_relative "identification"

#mechanize
webstagram_link = "http://web.stagram.com/"
$username = "the_real_yoshii"
$password = "266266"

access_token_personal = "1424011621.539525e.3446806012154cc7bc3e2ada57bfbac1"

#Your instagram id
@@my_id = "1434311048"

module First
	class Blah
		def Blah.activateInstagram
			Instagram.new
		end
		
		class Ig
			
			def password
				 pw = "thisisthepassword"
				 pw2 = "jfdaksfjka"
				 return pw, pw2	 
			end
			
			def tag
				access_token_personal = "1424011621.539525e.3446806012154cc7bc3e2ada57bfbac1"
				c = Instagram.client(:access_token => access_token_personal)
				puts c.user(@@my_id).counts.followed_by
			end
			
			
			def get_connection			
				return @db_connection if @db_connection
				  db = URI.parse("mongodb://heroku:Ciuly1dTXI_oll7AcUiMq2osWaJle1-rTltAd-QfbOr17G48dZUxYd5PxSuIWxKFNKG-d26Qm70S0yRdUaUFQg@kahana.mongohq.com:10075/app27706211")
				  db_name = db.path.gsub(/^\//, '')
				  @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
				  @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
				  @db_connection	
			end

			
			
		end
		
	end
end

class Test
	include First
	include Mongo
	
	d = Blah::Ig.new
	d.tag
	<<-DOC
	js = JSON.load(open("https://worker-aws-us-east-1.iron.io/2/projects/53da0ab8876d9a0005000063/schedules?oauth=il1QzE4qfGe3t0Yg3S40HzUXBXQ"))	
	js["schedules"].each{ |s| 
		puts s["run_times"]
		puts s["run_count"] 
	}
	puts js["schedules"]
	
	mongo_client = d.get_connection
	tags = mongo_client.collection("tags")
	
	puts tags.find.to_a
	DOC
	
	
		
end