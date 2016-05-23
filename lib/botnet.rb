require 'json'
require 'uri'
require 'net/http'
require_relative './dns'
require 'uri'
require 'whois'
require 'net/ping'
require 'pony'
require 'dotenv'
require 'json'
require 'keen'

# Load environment variables
Dotenv.load


get '/' do
  client_id = ENV["client_id"]
  erb :index, :locals => {:client_id => client_id}
end
get '/oauth/' do
  auth_code = params['code']
  client_id = ENV['client_id']
  client_secret = ENV['client_secret']
  uri = URI("https://slack.com/api/oauth.access")
  params = {:code => auth_code, :client_id=>client_id, :client_secret => client_secret}
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)

  response = res.body
  json_response = JSON.parse(response)
  access_token = json_response["access_token"]
  team_id = json_response["team_id"]

  keen.publish("New Install", {:access_token => access_token, :team_id => team_id})

  #TODO: add a success view
  erb :success if res.is_a?(Net::HTTPSuccess)
end
get '/support' do
    erb :support
end
get '/privacy' do
    erb :privacy
end
get '/success' do
    erb :success
end
post '/dns/' do
  # A, CNAME, AAAA, MX, NS
  domain = params["text"]
  records = DNS.get_formatted_records domain
  respond_message "DNS Lookup for #{domain}:\n" + "```" + records + "```"
end
post '/domain/' do
    # is domain taken or not, suggest to use whois if not
    domain = params['text']
    result = Whois.whois(domain)
    available = result.available?
    message = available ? "#{domain} is available" : "#{domain} is not available"
    respond_message message
end
post '/whois/' do
    domain = params['text']
    result = Whois.whois(domain)
    respond_message "Whois:\n```#{result}```"
end
post '/ping/' do
    domain = params['text']
    check = Net::Ping::TCP.new(domain, 'http').ping?
    message = check ? "#{domain} is up" : "#{domain} is down"
    respond_message message
end
post '/net/' do
    if params["text"].downcase.include? "feedback"
        #Pony.mail(:to => 'will@awebots.com,hugo@awebots.com', :from => 'botnet@botnet.awebots.com', :subject => 'feedback', :body => params["text"])
        respond_message "Thanks for the feedback :simple_smile:"
    else
        respond_message "Commands in botnet:\n\n`/dns [hostname]` Returns all publicly visible DNS record for the.\n`/domain [domain]` Returns whether the domain is available for purchase.\n`/net [feedback [your feedback]]` Give us feedback :+1:.\n`/up [hostname]` Returns whether the give host is up or down.\n`/whois [domain]` Returns the full whois record associated with the given domain.\n Have fun :smile:"
    end
end

def respond_message message
  content_type :json
  {:text => message, :response_type => "in_channel"}.to_json
end
