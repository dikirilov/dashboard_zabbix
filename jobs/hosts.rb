require 'zabby'
require 'json'
require 'active_support/core_ext/numeric/time'

SCHEDULER.every '1d' do

  serv = Zabby.init do
    set :server => "http://zabbix.guu.ru/zabbix"
    set :user => "admin"
    set :password => "guu_zabbix"
    login
  end

  today = Time.now.strftime("%d.%m")

  hosts_req = serv.run { Zabby::Host.get "monitored_hosts" => 1, "output" => "extend"}
  hosts = JSON.parse(hosts_req.to_json)
  hostc = hosts.count
  send_event( 'amount', { current: hostc, status: "ok", updatedAt: today } )
end

