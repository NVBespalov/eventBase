define ['backbone', 'underscore'],(Backbone, _) ->
  ###
    # Module vent.
    The vent is simple object. Extends Backbone.Event Object.
    Will be used for communications of components.
  ###

  # Extend vent by Backbone.Event Object
  vent = {}
  _.extend vent, Backbone.Events
  return vent