# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
hour_dinner = 14
hour_end = 17

SCHEDULER.every '1s' do
  today = Time.now 
  if today.hour > hour_dinner
    hour_dinner += 24
  end
  if today.hour > hour_end
    hour_end += 24
  end

  toh = hour_dinner - today.hour
  tom = 59 - today.min
  tom = tom > 9 ? tom.to_s : "0"+tom.to_s
  tos = 59 - today.sec
  tos = tos > 9 ? tos.to_s : "0"+tos.to_s

  to_d = toh.to_s+":"+tom.to_s+":"+tos.to_s
  toh = hour_end - today.hour
  to_e = toh.to_s+":"+tom.to_s+":"+tos.to_s
  
  send_event('toDinner', { text: to_d })
  send_event('toEnd', { text:to_e })

end
