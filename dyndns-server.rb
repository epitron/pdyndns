%w[rubygems sinatra haml db auth pp].each{|m| require m}
__DIR__ = File.dirname(__FILE__)


############################################################
# Configuration
#   http://www.sinatrarb.com/configuration.html
############################################################

#set :server,   %w[mongrel thin webrick]
 set :public,   __DIR__ + '/public'
#set :port,     80
#set :host,     'localhost'

### Enable HTTP Auth logins (see auth.rb) 

#helpers do
#  include Sinatra::Authorization
#end

#before do
#  halt 401, 'Go away!' unless authenticated!  
#end

############################################################


############################################################
# Actions
############################################################

get "/" do
  @grouped_records = Record.pretty_sorted(:conditions=>{:domain_id=>nil}).group_by{|r| r.domain && r.domain.name}
  haml :index
end

get "/ip" do
  request.ip
end

get "/nic/delete" do
  if r = Record.find_by_id(params[:id])
    r.destroy
    redirect "/"
  else
    halt 401, "record not found"
  end
end

#
# DynDNS API reference:
#   http://www.dyndns.com/developers/specs/syntax.html
#   http://www.dyndns.com/developers/specs/return.html
#
# Action: /nic/update
#
#  hostname=yourhostname
#  myip=ipaddress
#  wildcard=NOCHG
#  mx=NOCHG
#  backmx=NOCHG 
#

VALID_RECORD_TYPES = %w[A CNAME]


get "/nic/update" do

  p params
  
  result = nil
  
  params[:hostname]   = params[:host]   if params[:host]
  params[:myip]       = params[:ip]     if params[:ip]
  
  if params[:myip] == "auto"
    params[:myip]       = request.ip
    params[:type]       = "A"
  end
  
  if params[:cname]
    params[:type] = "CNAME"
    params[:myip] = params[:cname]
  end
  
  raise "Invalid type"  if params[:type]  and not VALID_RECORD_TYPES.include?(params[:type])
  raise "Invalid TTL"   if params[:ttl]   and not params[:ttl] =~ /^\d+$/

  
  if params[:hostname] and params[:myip]
    
    if r = Record.find_or_create_by_name(params[:hostname])
      
      if r.content == params[:myip] and (params[:ttl] and r.ttl == params[:ttl])
        result = "nochg"
      else
        r.content       = params[:myip]
        r.type          = params[:type]   if params[:type]
        r.ttl           = params[:ttl]    if params[:ttl]
        
        result = "good" if r.save
      end
      
    else
      
      result = "nohost"
    end
    
  else
    result = "No 'hostname' and/or 'myip' paramters?! Get outta here, fool!"  
  end
  
  redirect "/" if params[:redirect]
  result
end


############################################################

