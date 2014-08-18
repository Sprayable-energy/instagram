puts "This is Ironworker Follow working"
puts "**************************"

require "instagram"
require "mechanize"
require "mongo"
require "uri"


#for the database

mongo_db_url = "mongodb://heroku:Ciuly1dTXI_oll7AcUiMq2osWaJle1-rTltAd-QfbOr17G48dZUxYd5PxSuIWxKFNKG-d26Qm70S0yRdUaUFQg@kahana.mongohq.com:10075/app27706211"
collection = "tags"


def get_connection(mongo_db_url)							
	return @db_connection if @db_connection
	  db = URI.parse(mongo_db_url)
	  db_name = db.path.gsub(/^\//, '')
	  @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
	  @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
	  @db_connection
end

coll = get_connection(mongo_db_url).collection(collection)
tag = coll.find( {}, {:fields => {collection => 1, "_id" => 0 }}).to_a
			
tag_arr = []
#Get Key array first and then push values into array
tag.each{ |key,values| key.each{ |k,v| tag_arr.push(v)}}

#tag_arr = ["followforfollow", "follow4follow", "followback"]

#You Can Skip This this is just for yoshiluk
client_id = "f89e4247ac204aed99855016519eedf6"
client_secret = "c952eae1f5094b2f85c2cf7a3a48b530"
access_token_personal = "968519967.f89e424.10fd2616b15a442f977492b8c3aedda9"

#Your instagram id
$my_id = "968519967"
$username = "sprayable_energy"
$password = "sprayable15"


#MAKE SURE YOU CHANGE THESE OR YOU WILL BE REQUESTING ON MY BEHALF
$access_token = [
				"968519967.f89e424.10fd2616b15a442f977492b8c3aedda9",
				"968519967.d5ee040.73ebffc21d0d4abcbeb843185a72f5c4",
				"968519967.f86d574.f39b00e9261b4f83929e614904c0d918",
				"968519967.856a922.6089a300e8f64cbbb0441208ed1c5316",
				"968519967.af1b70c.1e0ae71fa59c441bae2b842d938cc241"]

#global variable
$client = Instagram.client(:access_token => access_token_personal)

def get_recent_media(tag_arr)
	ret_arr = []
	user_id_arr = []
	puts tag_searched = tag_arr[rand(0..(tag_arr.count - 1))]
	#33 is max
	tags = $client.tag_recent_media(tag_searched, :count => 100).each{ |tag|
		user_id_arr.push(tag.user.id)
	}
	return user_id_arr
end

#Check for outgoing_status (whether you follow them) and incoming status (whether they follow you) private = true can't see pictures false = can see pictures
#outgoing = none, false, none or follows, true, followed by
def get_user_relationship(user_id_arr)
	user_id_arr.each{ |user|
		begin
			relationship = $client.user_relationship(user)
			if relationship.target_user_is_private == true || relationship.incoming_status == "followed by" || relationship.outgoing_status == "follows"
				user_id_arr.delete(user)
			end
		rescue Exception => e
			puts e.message
			puts e.backtrace.inspect
		end #raises exception for relationships
	}
	pp user_id_arr.count
	return user_id_arr
end

#like and follow the user
def like_follow_user(user_id)
	client_temp = Instagram.client(:access_token => $access_token[rand(0..4)])
	
	media_id_arr = []
	#gets media id
	begin
	recent_media = $client.user_recent_media(user_id, :count => 10)
	recent_media.each{ |image_id|
		media_id_arr.push(image_id.id)
	}
	rescue Exception => e
		puts e.message
		puts e.backtrace.inspect
	end
	
	#randomizes number chosen in array
	media_id_arr = media_id_arr.sample(rand(1..2))

	#likes pictures
	media_id_arr.each{ |media_id|	
		begin
			client_temp.like_media(media_id)
			puts "liked " + client_temp.media_item(media_id).link
			sleep(rand(3..5))
		rescue Exception => e
			puts e.message			
			puts e.backtrace.inspect
		end #throws exception here
	}
	
	#follows user
	client_temp.follow_user(user_id)
	begin
	puts "Followed " + client_temp.user(user_id).username
	rescue Exception => e
		puts e.message
		puts e.backtrace.inspect
	end
	sleep(rand(2..4))
	
end


#Follows Users#################################
#Get's user ids from recent tags

user_id_arr = get_recent_media(tag_arr)
#inject user array into here scrub clean for people who have account private or are already following you
clean_user_id_arr = get_user_relationship(user_id_arr)

#goes through each user and likes 2-4 pictures and follows
clean_user_id_arr.each{ |user|
	like_follow_user(user)
	sleep(rand(15..30))
}