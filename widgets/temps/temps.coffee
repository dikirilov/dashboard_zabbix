class Dashing.Temps extends Dashing.Widget
# @accessor 'temp1', Dashing.AnimatedValue
# @accessor 'temp2', Dashing.AnimatedValue

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    if data.status1 
#      $('#val1').classList.remove("/\bstatus-\S+\g");
#      $('#val1').attr 'class', (i,c) -> 
#        c.replace /\bstatus-\S+\g, ''
      $('#val1').addClass "status-#{data.status1}"
#    
    if data.status2
#      $('#val2').attr 'class', (i,c) ->
#        c.replace /\bstatus-\S+\g, ''
      $('#val2').addClass "status-#{data.status2}"

#    if data.status1
#      alert(data.status2)
#      val = $('$val1').val
#      alert(val);
#    alert($('#val1').val) #.attr 'class', (i,c) ->
#      c.replace /\bstatus-\S+/g, ''
#    $(@get('#val1')).addClass "status-#{data.status1}"
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
