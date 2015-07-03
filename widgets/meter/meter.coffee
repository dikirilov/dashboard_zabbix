class Dashing.Meter extends Dashing.Widget

  @accessor 'value1', Dashing.AnimatedValue
  @accessor 'value2', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'value1', (value) ->
      $(@node).find("#meter1").val(value).trigger('change')

    @observe 'value2', (value) ->
      $(@node).find("#meter2").val(value).trigger('change')

  ready: ->
    meter = $(@node).find(".meter")
    meter.attr("data-bgcolor", meter.css("background-color"))
    meter.attr("data-fgcolor", meter.css("color"))
    meter.knob()
