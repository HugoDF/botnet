require 'resolv'
module DNS
  def DNS.format_records records
    #records.last.name.to_s
    records.last
    formatted_records = []
    records.each do |r|
      type = r.class.name.split(":").last
      record = {:ttl => r.ttl}
      formatted_record = "#{type}:\n"
      case type
      when "NS", "CNAME"
        record = {:ttl => r.ttl, :name => r.name.to_s}
        formatted_record += "Name: #{record[:name]}\nTTL: #{record[:ttl]}\n"
      when "MX"
        record = {:ttl => r.ttl, :exchange => r.exchange.to_s, :preference => r.preference}
        formatted_record += "Exchange: #{record[:exchange]}\nPreference: #{record[:preference]}\nTTL: #{record[:ttl]}"
      when "A"
        record = {:ttl => r.ttl, :address => r.address}
        formatted_record += "Address: #{record[:address]}\nTTL: #{record[:ttl]}"
      end
  
      formatted_records.push(formatted_record)
    end
    formatted_records.join("\n")
  end
  def DNS.get_records url
    dns = Resolv::DNS.new
    records = dns.getresources url, Resolv::DNS::Resource::IN::A
    records += dns.getresources url, Resolv::DNS::Resource::IN::AAAA
    records += dns.getresources url, Resolv::DNS::Resource::IN::NS
    records += dns.getresources url, Resolv::DNS::Resource::IN::CNAME
    records += dns.getresources url, Resolv::DNS::Resource::IN::MX
  end
  def DNS.get_formatted_records url
    format_records get_records url
  end
end
