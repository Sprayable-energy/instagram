require "iron_worker_ng"

call_iron = IronWorkerNG::Client.new(:token => "il1QzE4qfGe3t0Yg3S40HzUXBXQ", :project_id => "53da0ab8876d9a0005000063" )

#Block to schedule batch of follows
follow = call_iron.schedules.create("follow", {}, {:start_at => Time.now, :run_every => rand(3600..6000), :run_times => rand(6..8)})
puts follow.id # post id or show list of tasks

#block to schedule batch of unfollows
unfollow = call_iron.schedules.create("unfollow", {}, {:start_at => Time.now + rand(36000..48000), :run_every => rand(3600..4800), :run_times => rand(2..4)})
puts unfollow.id

#This whole block should take ~16 hours to finish 


