require "sinatra/base"
require "instagram"
require "mechanize"
require "json"
require "open-uri"
require "net/http"
require "rubygems"
require "haml"
require "iron_worker_ng"
require "mongo"
require "uri"


require_relative "identification"
require_relative "routes/routing"
require_relative "routes/process"


class Instagram_bot < Sinatra::Base
	
	enable :sessions
	

	helpers Processes::Instagram
	helpers Processes::Ironworker
	register Sinatra::Instagram_bot::Routing
	
end
