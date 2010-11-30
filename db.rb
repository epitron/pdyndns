%w[rubygems active_record active_support].each{|m| require m}

############################################################

### Sqlite3
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => "pdns.db")

### MySQL
#ActiveRecord::Base.establish_connection(
#  :adapter  => "mysql",
#  :host     => "localhost",
#  :username => "root",
#  :password => "",
#  :database => "powerdns_dev"
#)


############################################################
#=> Domain(id: integer, name: string, master: string, last_check: integer, type: string, notified_serial: integer, account: string)

class Domain < ActiveRecord::Base
  has_many :records
  set_inheritance_column :___disabled
  
  def self.add(opts={})
    domain = new(opts)
    domain.content ||= domain.default_soa
    domain.save!
  end

  #
  # Generate a genericish SOA record
  #   http://www.zytrax.com/books/dns/ch8/soa.html
  #
  def default_soa
    "ns1.#{name} admin@#{name} 2009113007 10800 7200 604800 10800"
  end
  
end

############################################################
#=> Record(id: integer, domain_id: integer, name: string, type: string, content: string, ttl: integer, prio: integer, change_date: integer)

class Record < ActiveRecord::Base
  belongs_to :domain
  set_inheritance_column :___disabled
  
  def before_save
    self.change_date  = Time.now.to_i
    self.ttl          ||= 90
    self.type         ||= "A"
  end

  def last_update
    Time.at change_date
  end

  def self.pretty_sorted(options={})
    records = find(:all, options)
    records.sort_by do |record|
      parts = record.name.split(".")
      first = parts.pop(2)
      last = parts

      [first, last]
    end
  end
  
end

############################################################

if $0 == __FILE__
  p Domain.first.records
end
