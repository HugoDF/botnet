require 'json'
get '/' do
  erb :index
end
get '/oauth' do
  "Success!"
end
post '/dns' do
  # A, CNAME, AAAA, MX, NS
  respond_message "DNS Lookup"
end
post '/domain/' do
  # is domain taken or not, suggest to use whois if not
  respond_message "domain"
end

post '/whois' do
  respond_message "whois"
end
post '/ping' do 
  respond_message "ping"
end
post '/net' do
  respond_message "Help & feedback"
end
def respond_message message
  content_type :json
  {:text => message}.to_json
end
