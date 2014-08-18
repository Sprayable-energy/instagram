module Sinatra
	module Instagram_bot		
		module Routing
			def self.registered(app)	
						
				home = lambda do
					@follow_by, @follows, @posts = follow_count
					haml :index
				end
		
				ironworker = lambda do
					@list = list_scheduled_tasks
					haml :ironworker
				end
				
				schedcancel = lambda do
					
					cancel = params[:cancel_id]
					cancel_task(cancel)
					redirect "/ironworker"
					
				end
				
				schedule = lambda do
				
					timelag = params[:timelag].to_i
					run_every = params[:run_every].to_i
					run_times = params[:run_times].to_i
					schedule_task(timelag, run_every, run_times)
					redirect "/ironworker"
					
				end
				
				tags = lambda do
					@tags = get_current_tags
					haml :tags		
				end
				
				change_tags = lambda do
					tags = params["tag"]
					change_tags(tags)
					redirect "/tags"
				end
				
				app.get "/", &home
				app.get "/home", &home
				app.get "/ironworker", &ironworker
				app.get "/tags", &tags #store tag search, location search, set amount days here
				
				app.post "/cancel", &schedcancel
				app.post "/schedule", &schedule
				app.post "/change", &change_tags
			end			
		end
	end
end