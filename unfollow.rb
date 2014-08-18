puts "This is Ironworker Unfollow working"
puts "**************************"

require "instagram"
require "mechanize"
require "json"
require "open-uri" #use to create action

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

#unfollow block ############

def get_user_ids(user_arr)
	us_arr = []
	user_arr.each{ |x|
		us_arr.push(x.id)
	}
	return us_arr
end

def get_user_paginations(follow_status)
#check to see if there is no next page
	
	if not follow_status.pagination.next_url.nil?
		
		#push initial set into array
		follow_arr = get_user_ids(follow_status)
		
		#initial next url set
		json = follow_status.pagination.next_url
		
		#loops until next url = nil this is needed because the instagram API only allows 50 users at a time
		loop do 
			
			#uses open uri to open link grab json and push into array
			user_arr = JSON.load(open(json))
			
			#pushes into array
			user_arr["data"].each{ |user| follow_arr.push(user["id"]) }
			
			#grabs next next_url for next page of json
			json = user_arr["pagination"]["next_url"]

			break if json == nil #stops if no next url 

		end #end loop
	else
		follow_arr = get_user_ids(follow_status)	
	end
	
	return follow_arr
end

def unfollow_and_unlike_media(unfollow_arr)
	
	#makes sure its less than 30 
	if unfollow_arr.count > 30
		unfollow_arr = unfollow_arr.sample(30)
	end
		
	unfollow_arr.each{ |user_id|	
		begin
		client_temp = Instagram.client(:access_token => $access_token[rand(0..4)])
		user_recent_media = $client.user_recent_media(user_id, :count => 100)
		user_recent_media.each{ |media| 
			current_media =  media.id
			user_likes = media.likes.data
			user_likes.each{ |like| 
				if $my_id == like.id
					client_temp.unlike_media(current_media)
					puts "media unliked"
					sleep(rand(3..6))
				end 
			}
		}
		#unfollows user
		client_temp.unfollow_user(user_id)
		puts "unfollowed"
		sleep(rand(5..15))
		rescue Exception => e
			e.message
			e.backtrace.inspect
		end	
	}
end


#get user ids in array. Follow_arr = people you follow, followed_by_arr = people who follow you
follow_arr = get_user_paginations($client.user_follows($my_id)) 
followed_by_arr = get_user_paginations($client.user_followed_by($my_id)) 

puts "Before you were following this many: " + follow_arr.count.to_s
#compare two arrays and see which ones do not match on the follow side

unfollow_arr = follow_arr - followed_by_arr
#randomizes number chosen in array from 20 - 30

unfollow_and_unlike_media(unfollow_arr)

puts "You are now following this many: " + get_user_paginations($client.user_follows($my_id)).count.to_s


