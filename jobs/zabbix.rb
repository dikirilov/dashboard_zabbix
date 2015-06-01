require 'zabby'
require 'json'
require 'active_support/core_ext/numeric/time'

SCHEDULER.every '1m' do

  serv = Zabby.init do
    set :server => "http://zabbix.guu.ru/zabbix"
    set :user => "admin"
    set :password => "guu_zabbix"
    login
  end

  env = serv.run { Zabby::Trigger.get "filter" => { "priority" => [ 4, 5 ] }, "output" => "extend", "only_true" => "true", "monitored" => 1, "withUnacknowledgedEvents" => 1, "skipDependent" => 1, "expandData" => "host" } 
#  hosts_req = serv.run { Zabby::Host.get "monitored_hosts" => 1, "output" => "extend"}
  temp1_req = serv.run { Zabby::Item.get "filter" => {"itemid" => "45443"}}
  temp2_req = serv.run { Zabby::Item.get "filter" => {"itemid" => "45444"}}
  graph_req = serv.run { Zabby::Item.get "filter" => {"itemid" => ["30399", "30449"]}}
  cpu6_req = serv.run { Zabby::Item.get "filter" => {"itemid" => "44016"} }

#  hosts = JSON.parse(hosts_req.to_json)
  trig = JSON.parse(env.to_json)
  temp1 = JSON.parse(temp1_req.to_json)
  temp2 = JSON.parse(temp2_req.to_json)  
  graph = JSON.parse(graph_req.to_json)
  cpu6 = JSON.parse(cpu6_req.to_json)[0]["lastvalue"]

  tempf = temp1[0]["lastvalue"]
  tempb = temp2[0]["lastvalue"]
  temp = (tempf.to_i>tempb.to_i)? tempf : tempb
#  hostc = hosts.count 
  probs = trig.count 
  gdata = [{ "x" => Time.now, "y" => graph[0]["lastvalue"]}, {"x" => Time.now, "y" => graph[1]["lastvalue"]}]

#  warn = twarn - lav_warn 
#  avrg = tavrg - lav_avrg
#  hgh = thgh - lav_hgh 
#  dis = tdis - lav_dis 

  if (temp.to_i > 28) then tempstats = "high" 
  elsif (temp.to_i >22) then tempstats = "warn"
  else tempstats = "ok" end

  if probs > 0 then probstats = "high" else disstats = "ok" end
  time = Time.now.strftime("%H:%M")
#  temp += "°"
#  cpu6 += "%"

  send_event( 'temp', { current: temp, status: tempstats, updatedAt: time, suffix: "°" } )
#  send_event( 'amount', { current: hostc, status: "ok", updatedAt: time } )
  send_event( 'problems', { current: probs, status: probstats, updatedAt: time } )
  send_event( 'traffic', points: gdata ) 
  send_event( 'cpu6', {current: cpu6, status: "ok", updatedAt: time, suffix: "%"  } )

end
