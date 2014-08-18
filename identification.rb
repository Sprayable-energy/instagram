module Identification
	class Platform	
		class Instagr_am
			
			def access
				#You Can Skip This this is just for yoshiluk
				client_id = "f89e4247ac204aed99855016519eedf6"
				client_secret = "c952eae1f5094b2f85c2cf7a3a48b530"
			
				#Your instagram id
				my_id = "968519967"
				username = "sprayable_energy"
				password = "sprayable15"

				#MAKE SURE YOU CHANGE THESE OR YOU WILL BE REQUESTING ON MY BEHALF
				access_token = [
				"968519967.f89e424.10fd2616b15a442f977492b8c3aedda9",
				"968519967.d5ee040.73ebffc21d0d4abcbeb843185a72f5c4",
				"968519967.f86d574.f39b00e9261b4f83929e614904c0d918",
				"968519967.856a922.6089a300e8f64cbbb0441208ed1c5316",
				"968519967.af1b70c.1e0ae71fa59c441bae2b842d938cc241"]
			
				client = Instagram.client(:access_token => access_token[rand(0..4)])
			
				return client, my_id
			end
			
		end
	
		class Ironworker
			
			def client
				io_token = "il1QzE4qfGe3t0Yg3S40HzUXBXQ"
				io_project_id = "53da0ab8876d9a0005000063"
				return IronWorkerNG::Client.new(:token => io_token, :project_id => io_project_id)
			end
			
			def endpoint
				
				io_token = "il1QzE4qfGe3t0Yg3S40HzUXBXQ"
				io_project_id = "53da0ab8876d9a0005000063"
				begin_point = "https://worker-aws-us-east-1.iron.io/2/projects/" + io_project_id
				oauth = "?oauth=" + io_token
				scheduleid = "53da980d5b1cfd21d501a116"
				
				return begin_point, oauth, scheduleid
				
			end
			
		end	
		
		class Database
			include Mongo
			
			def get_connection			
				
				return @db_connection if @db_connection
				  db = URI.parse(ENV['MONGOHQ_URL'])
				  db_name = db.path.gsub(/^\//, '')
				  @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
				  @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
				  @db_connection
			
			end
			
		end
			
	end
end