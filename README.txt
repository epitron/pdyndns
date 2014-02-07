============================
      Power DynDNS
----------------------------

Run your own DynDNS-compatible dynamic IP address service!

Usage (setting up the server):

  1) Install PowerDNS and its SQLite3 backend
       eg: apt-get install pdns-server pdns-backend-sqlite3
  2) Setup PowerDNS to use "pdyndns/pdns.db" as its SQLite3 database
       (sample config files are locaed in "pdyndns/etc/powerdns")
  3) Start the server:
       ruby dyndns-server.rb
       
     OR
     
     Setup apache to run pdyndns (using the "passenger" gem and its apache plugin)
       (sample config file: "pdyndns/etc/apache.conf")
       
  4) Use it!
  
Usage (setting up a DynDNS client):

  1) Install a dyndns client, like ddclient
       eg: apt-get install ddclient
  2) Configure it to use your new pdyndns server
       (sample config file in "pdyndns/etc/ddclient.conf")

Usage (just using CURL and a cron job):

  1) Test if curl works:
       curl http://username:password@awesomedomain.com/nic/update?host=me.awesomedomain.com&ip=auto
  2) Edit your crontab so that it updates the IP every 5 minutes:
       Run "crontab -e" then paste in:
             */5 * * * *   curl http://username:password@awesomedomain.com/nic/update?host=me.awesomedomain.com&ip=auto


HTTP API interface:
  
  /nic/update
  
    Parameters:
      hostname or host:   which hostname to set (eg: "niagara1.ix")
      myip or ip:         IP address or CNAME target ("auto" will determine IP automatically)
      type:               record type (A or CNAME)
      cname:              shorthand for type=CNAME, myip=<what you set cname to> (eg: "niagara1.ix")
      ttl:                time to live in seconds (default: 90)
      
    Examples:

      Automatically detect the client's IP address and update domain.fake's IP:
        /nic/update?host=domain.fake&ip=auto

      Update domain.fake's IP to 192.168.1.1:      
        /nic/update?hostname=domain.fake&myip=192.168.1.1

      Create a CNAME from src.com to dest.com:
        /nic/update?hostname=src.com&cname=dest.com

      Create a CNAME from src.com to dest.com, with a TTL of 10:
        /nic/update?host=src.com&ip=dest.com&type=CNAME&ttl=10
      


Requires the following ruby gems:

  - sinatra
  - haml
  - mongrel
  - activerecord
  - activesupport
  - sqlite3-ruby

  (Note: Install with "gem install <gemname>")
