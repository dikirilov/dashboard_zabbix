# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require 'rubygems'
require 'json'
SCHEDULER.every '1h' do
  data_temp = Net::HTTP.get(URI.parse("http://api.openweathermap.org/data/2.5/weather?q=Moscow,ru&units=metric")).chomp
  data_cur = Net::HTTP.get(URI.parse("http://query.yahooapis.com/v1/public/yql?q=select+*+from+yahoo.finance.xchange+where+pair+=+%22USDRUB,EURRUB%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"))
  cur = JSON.parse(data_cur)
  usd = cur["query"]["results"]["rate"][0]["Rate"]
  eur = cur["query"]["results"]["rate"][1]["Rate"]
  if (data_temp == "failed to connect ")
    temp = "No connection :("
  else 
    temp = JSON.parse(data_temp)["main"]["temp"].round
  end
  send_event('temp', { text: temp.to_s })
  send_event('usd_cur', { text: usd.to_s })
  send_event('eur_cur', { text: eur.to_s })
end
