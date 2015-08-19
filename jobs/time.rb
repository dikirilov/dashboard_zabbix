# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
mes = "ПОТРАЧЕНО"

SCHEDULER.every '1s' do
  hour_dinner = 15
  hour_end = 19
  today = Time.now 
  if today.hour > hour_dinner
    flag_dinner = true
  end
  if today.hour > hour_end
    flag_end = true
  end

  toh = hour_dinner - today.hour
  tom = 59 - today.min
  tom = tom > 9 ? tom.to_s : "0"+tom.to_s
  tos = 59 - today.sec
  tos = tos > 9 ? tos.to_s : "0"+tos.to_s

  to_d = flag_dinner ? mes : toh.to_s+":"+tom.to_s+":"+tos.to_s
  tohe = hour_end - today.hour
  to_e = flag_end ? mes : tohe.to_s+":"+tom.to_s+":"+tos.to_s
 
  color1 = flag_dinner ? "grey" : "green"
  color2 = flag_end ? "grey" : "green"
 
  send_event('toDinner', { value: to_d, color: color1 })
  send_event('toEnd', { value: to_e, color: color2 })

end
