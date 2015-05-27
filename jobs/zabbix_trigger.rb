require 'zabby'
require 'json'
require 'active_support/core_ext/numeric/time'

  swarn = []
  savrg = []
  shgh = []
  sdis = []

  twarn = 0
  tavrg = 0
  thgh = 0
  tdis = 0

  lav_warn = 0
  lav_avrg = 0
  lav_hgh = 0
  lav_dis = 0

SCHEDULER.every '1s' do

  serv = Zabby.init do
    set :server => "http://zabbix.guu.ru/zabbix"
    set :user => "admin"
    set :password => "guu_zabbix"
    login
  end

  env = serv.run { Zabby::Trigger.get "filter" => { "priority" => [ 4, 5 ] }, "output" => "extend", "only_true" => "true", "monitored" => 1, "withUnacknowledgedEvents" => 1, "skipDependent" => 1, "expandData" => "host" } 
  hosts_req = serv.run { Zabby::Host.get "monitored_hosts" => 1, "output" => "extend"}
  temp1_req = serv.run { Zabby::Item.get "filter" => {"itemid" => "45443"}}
  temp2_req = serv.run { Zabby::Item.get "filter" => {"itemid" => "45444"}}
  graph_req = serv.run { Zabby::Item.get "filter" => {"itemid" => ["30399", "30449"]}}

  hosts = JSON.parse(hosts_req.to_json)
  trig = JSON.parse(env.to_json)
  temp1 = JSON.parse(temp1_req.to_json)
  temp2 = JSON.parse(temp2_req.to_json)  
  graph = JSON.parse(graph_req.to_json)

#p trig

#  pas.each do |res|
#    if (res["priority"] == 4 || res["priority"] == 5)
#        sdis << res["hostname"]
#      end
#  end

#  lav_warn = twarn
#  lav_avrg = tavrg
#  lav_hgh = thgh
#  lav_dis = tdis

  warn = temp1[0]["lastvalue"] 
  avrg = temp2[0]["lastvalue"]
  hgh = hosts.count 
  dis = trig.count 
  gdata = [{ "x" => Time.now, "y" => graph[0]["lastvalue"]}, {"x" => Time.now, "y" => graph[1]["lastvalue"]}]

#  warn = twarn - lav_warn 
#  avrg = tavrg - lav_avrg
#  hgh = thgh - lav_hgh 
#  dis = tdis - lav_dis 

  if (warn.to_i > 28) then warnstats = "high" 
  elsif (warn.to_i >25) then warnstats = "warn"
  else warnstats = "ok" end
  if (avrg.to_i > 28) then avrgstats = "high" 
  elsif (avrg.to_i > 25) then avrgstatus = "warn"
  else  avrgstats = "ok" end
  #if hgh > 0 then hghstats = "high" else hghstats = "ok" end
  hghstats = "ok"
  if dis > 0 then disstats = "disaster" else disstats = "ok" end
  send_event( 'outwarn', { current: warn, status: warnstats } )
  send_event( 'outavrg', { current: avrg, status: avrgstats } )
  send_event( 'outhigh', { current: hgh, status: hghstats  } )
  send_event( 'outdis', { current: dis, status: disstats  } )
  send_event( 'traffic', points: gdata ) 

end
