require 'sinatra'
require "./lib/botnet"

set :environment, :development
set :public_folder, Proc.new { File.join(root, "public") }
set :views, Proc.new { File.join(root, "templates") }

run Sinatra::Application
