require 'json'
require 'uri'
require 'net/http'
get '/' do
  erb :index
end
get '/oauth' do
  auth_code = params['code']
  client_id = "19358800983.40999931552"
  client_secret = ENV['client_secret']
  uri = URI("https://slack.com/api/oauth.access")
  params = {:code => auth_code, :client_id=>client_id, :client_secret => client_secret}
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  "Success!" if res.is_a?(Net::HTTPSuccess)
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
  {:text => message, :response_type => "in_channel"}.to_json
end
