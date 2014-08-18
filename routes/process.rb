module Processes	
	module Instagram #Follow.new.run
		include Identification
		
		instagram = Platform::Instagr_am.new
		db = Platform::Database.new
		
		CLIENT, MY_ID = instagram.access
		COLLECTION = db.get_connection.collection("tags")
		
		def follow_count #posts numbers for follower counts
			follow_by = CLIENT.user(MY_ID).counts.followed_by
			follows = CLIENT.user(MY_ID).counts.follows
			posts = CLIENT.user(MY_ID).counts.media
			return follow_by, follows, posts
		end
		
		def get_current_tags
			
			tag = COLLECTION.find( {}, {:fields => {"tags" => 1, "_id" => 0 }}).to_a
			
			tags = []
			#Get Key array first and then push values into array
			tag.each{ |key,values| key.each{ |k,v| tags.push(v)}}
			
			return tags
			
		end
		
		
		def change_tags(tags_arr)
			
			#drops current instagram tag collection
			COLLECTION.drop
			#creates new instagram tag collection
			tags = COLLECTION
			
			
			tags_arr.reject!(&:empty?) #gets rid of empty values in array
			#inserts
			tags_arr.count.to_i.times { |i| tags.insert("tags" => tags_arr[i]) }

			
			
		
		end
			
	end

	module Ironworker
		include Identification
		
		ironworker = Platform::Ironworker.new
		CLIENT = ironworker.client
		API, OAUTH, SCHEDID = ironworker.endpoint
		
		
		def list_scheduled_tasks
			list = JSON.load(open(API + "/schedules" + OAUTH))
			
			list_arr = []
			list["schedules"].each{ |schedule| 
				list_arr.push(
					schedule
				)	
			}
			
			return list_arr
			
		end
		
		def schedule_task(timelag, runevery, runtime)

			schedule = CLIENT.schedules.create("iron_schedule",  {}, {:start_at => Time.now + timelag, :run_every => runevery, :run_times => runtime})
			return schedule
			
		end
		
		def cancel_task(schedid)
			
			uri = URI(API + "/schedules/" + schedid + "/cancel" + OAUTH)
			req = Net::HTTP.post_form(uri, 'q' => 'ruby', 'max' => '50')
			#cancel_msg = JSON.load(open(API + "/schedules/" + schedid + "/cancel" + OAUTH))
			return req["msg"]
		
		end
		
		def get_logs
		
			#json = JSON.load(open(API + "/schedules/" + scheduleid + OAUTH))
			#json[]
			#pass whatever back as logs to page
			
		
		end
		
		
	end			
end
			

#Place all views in one section
