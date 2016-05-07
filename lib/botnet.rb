require 'json'
require 'uri'
require 'net/http'
require_relative './dns'
require 'uri'
require 'whois'
require 'net/ping'


get '/' do
  erb :index
end
get '/oauth/' do
  auth_code = params['code']
  client_id = ENV['client_id']
  client_secret = ENV['client_secret']
  uri = URI("https://slack.com/api/oauth.access")
  params = {:code => auth_code, :client_id=>client_id, :client_secret => client_secret}
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  #TODO: add a success view
  "Success!" if res.is_a?(Net::HTTPSuccess)
end
post '/dns/' do
  # A, CNAME, AAAA, MX, NS
  domain = params["text"]
  records = DNS.get_formatted_records domain
  respond_message "DNS Lookup for #{domain}:\n" + records
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
  respond_message "Help & feedback:\nCommands:\n`/domain [url]` tells you if the url is available\n`/dns [url]` gives you record information for the url\n`/whois [url]` gives you the full whois information for url\n`/ping [url]` tells you whether url is up or not\n`/net help` displays this message\n`/net feedback [text]` allows you to send us feedback"
end

def respond_message message
  content_type :json
  {:text => message, :response_type => "in_channel"}.to_json
end
