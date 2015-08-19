require 'zabby'
require 'json'
require 'active_support/core_ext/numeric/time'

log = Logger.new("/home/di_kirilovskiy/dash/log/zabbix.log")

SCHEDULER.every '20s' do

  serv = Zabby.init do
    set :server => "http://zabbix.guu.ru/zabbix"
    set :user => "admin"
    set :password => "guu_zabbix"
    login
  end

  hostRS_req = serv.run { Zabby::Host.get "output" => "extend", "groupids" => [14] }
  env = serv.run { Zabby::Trigger.get "filter" => { "priority" => [ 4, 5 ] }, "output" => "extend", "only_true" => "true", "monitored" => 1, "withUnacknowledgedEvents" => 1, "skipDependent" => 1, "expandData" => "host" } 
  hosts_req = serv.run { Zabby::Host.get "monitored_hosts" => 1}
  temp1_req = serv.run { Zabby::Item.get "filter" => {"itemid" => "45443"}}
  temp2_req = serv.run { Zabby::Item.get "filter" => {"itemid" => "45444"}}
  cpu6_req = serv.run { Zabby::Item.get "filter" => {"itemid" => "44016"} }
  hostNum_req = serv.run { Zabby::Item.get "filter" => { "itemid" => "47234" } }

  # Корпуса
  # Лабораторный
  labKorpus_req = serv.run { Zabby::Trigger.get "group" => "Лабораторный корпус", "only_true" => "true", "monitored" => "true" }
  

  adminKorpus_req = serv.run { Zabby::Trigger.get "group" => "Административный корпус", "only_true" => "true", "monitored" => "true" }
  studyKorpus_req = serv.run { Zabby::Trigger.get "group" => "Учебный корпус", "only_true" => "true", "monitored" => "true" }
  businessKorpus_req = serv.run { Zabby::Trigger.get "group" => "Бизнес-центр", "only_true" => "true", "monitored" => "true" }
  twoKorpus_req = serv.run { Zabby::Trigger.get "group" => "Корпус 2", "only_true" => "true", "monitored" => "true" }
  sixKorpus_req = serv.run { Zabby::Trigger.get "group" => "Корпус 6", "only_true" => "true", "monitored" => "true" }
  cuvp_req = serv.run { Zabby::Trigger.get "group" => "ЦУВП", "only_true" => "true", "monitored" => "true" }


  hostRS = JSON.parse(hostRS_req.to_json)
  hostNum = JSON.parse(hostNum_req.to_json)
  hosts = JSON.parse(hosts_req.to_json)
  trig = JSON.parse(env.to_json)
  temp1 = JSON.parse(temp1_req.to_json)
  temp2 = JSON.parse(temp2_req.to_json)  
  cpu6 = JSON.parse(cpu6_req.to_json)[0]["lastvalue"]

  tempf = temp1[0]["lastvalue"]
  tempb = temp2[0]["lastvalue"]

  hostn = hostNum[0]["lastvalue"]
  hostc = hosts.count 
  probs = trig.count 
  hostRandS = hostRS.count

  if (tempb.to_i > 31) then status2 = "high" 
  elsif (tempb.to_i >28) then status2 = "warn"
  else status2 = "ok" end

  if (tempf.to_i > 31) then status1 = "high"
  elsif (tempf.to_i > 28) then status1 = "warn"
  else status1 = "ok" end

  if probs > 0 then probstats = "high" else probstats = "ok" end

  if (cpu6.to_i > 80) then cpu6stats = "high" 
  elsif (cpu6.to_i > 60) then cpu6stats = "warn"
  else cpu6stats = "ok" end

  time = Time.now.strftime("%H:%M")

  log.info("Temperature Front: #{tempf}")
  log.info("Temperature Rear: #{tempb}")
  log.info("Number of hosts: #{hostn}")
  log.info("Number of devices: #{hostc}")
  log.info("Number of problems: #{probs}")
  log.info("Number of R&S: #{hostRandS}")

  send_event( 'temps', { temp1: tempf, temp2: tempb, updatedAt: time, suffix: "°", status1: status1, status2: status2 })
  send_event( 'amount', { current: hostc, updatedAt: time } )
  send_event( 'problems', { current: probs, status: probstats, updatedAt: time } )
  send_event( 'cpu6', {current: cpu6, status: cpu6stats, updatedAt: time, suffix: "%"  } )
  send_event( 'hosts', { value: hostn, updatedAt: time } ) 

end
