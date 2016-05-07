require 'json'
get '/' do
  erb :index
end
post '/dns/' do
  repond_message "DNS Lookup"
end
post '/domain/' do
  # is domain taken or not, suggest to use whois if not
  repond_message "domain"
end
post '/whois/' do
  repond_message "whois"
end
post '/ping/' do 
  repond_message "ping"
end
post '/net/' do
  repond_message "Help & feedback"
end
def respond_message message
  content_type :json
  {:text => message}.to_json
end