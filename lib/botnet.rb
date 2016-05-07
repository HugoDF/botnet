require 'json'
require 'whois'


get '/' do
  erb :index
end
post '/dns/' do
  # A, CNAME, AAAA, MX, NS
  respond_message "DNS Lookup"
end
post '/domain/' do
  # is domain taken or not, suggest to use whois if not
  respond_message "domain"
end

post '/whois/' do
  respond_message "whois"
end
post '/ping/' do 
  respond_message "ping"
end
post '/net/' do
  respond_message "Help & feedback"
end
# for now only
get '/whois/?' do
    result = Whois.whois("simplepoll.rocks")
    puts result
    result.to_json
end

get '/ping/?' do # can't work on this, because windows :(
    check = Net::Ping::External.new(host)
    puts check
    "Done"
end

get '/domain/:domain/?' do
    result = Whois.whois(params[:domain])
    is_available = result.available? ? "yes" : "no"
    "Is " + params[:domain] + " available? " + is_available.to_s # this is some really messed up shit
end
def respond_message message
  content_type :json
  {:text => message}.to_json
end
