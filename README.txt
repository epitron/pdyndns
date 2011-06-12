============================
      Power DynDNS
----------------------------

Usage:

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
  

HTTP interface:
  
  /nic/update
  
    Parameters:
      hostname or host:   which hostname to set (eg: "niagara1.ix")
      myip or ip:         IP address or CNAME target ("auto" will determine IP automatically)
      type:               record type (A or CNAME)
      cname:              shorthand for type=CNAME, myip=<what you set cname to> (eg: "niagara1.ix")
      ttl:                time to live in seconds (default: 90)
      
    Examples:

      Update domain.fake's IP to 192.168.1.1:      
        /nic/update?hostname=domain.fake&myip=192.168.1.1

      Create a CNAME from src.com to dest.com:
        /nic/update?hostname=src.com&cname=dest.com

      Create a CNAME from src.com to dest.com, with a TTL of 10:
        /nic/update?host=src.com&ip=dest.com&type=CNAME&ttl=10
      
      Update domain.fake's IP to whatever its current external IP is:
        /nic/update?host=domain.fake&ip=auto


Requires the following ruby gems:

  - sinatra
  - haml
  - mongrel
  - activerecord
  - activesupport
  - sqlite3-ruby

  (Note: Install with "gem install <gemname>")
