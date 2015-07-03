require 'zabby'
require 'json'
require 'active_support/core_ext/numeric/time'

SCHEDULER.every '5s' do

  serv = Zabby.init do
    set :server => "http://zabbix.guu.ru/zabbix"
    set :user => "admin"
    set :password => "guu_zabbix"
    login
  end

  graph_req = serv.run { Zabby::Item.get "filter" => {"itemid" => ["30399", "30449"]}}
  graph = JSON.parse(graph_req.to_json)
  time = Time.now.strftime("%H:%M")
  download = (graph[0]["lastvalue"].to_i/1000000.0)
  upload = (graph[1]["lastvalue"].to_i/1000000.0)
  download = download > 200 ? "200.0" : download.to_s
  upload = upload > 200 ? "200.0" : upload.to_s
  r1 = rand(200);
  r2 = rand(200);
  send_event( 'traff_in_net', { value1: upload[0..4].to_f, value2: download[0..4].to_f, subtitle1: "Исходящий", subtitle2: "Входящий", updatedAt: time, fromInfo: "Zabbix"} )

end

