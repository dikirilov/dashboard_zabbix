class Dashing.Base extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered
#  @accessor 'num', ->
#    @get('value') > 0

  onData: (data) ->
#	alert(data);
    if data.color
      $(@node).css('background-color', data.color)
    else
      $(@node).css('background-color', "#222")
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
