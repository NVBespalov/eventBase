###
 * Created with JetBrains PhpStorm.
 * User: nickbespalov
 * Date: 28.08.13
 * Time: 10:32
###

define ['backbone'], (Backbone)->
  class InstanceManagerModel extends Backbone.Model
    initialize:->
      given = arguments[0]
      if given then moduleRootElement = given.getRootElement()
      if moduleRootElement and moduleRootElement[0]
#        @id = moduleRootElement.attr('id')
        @instance = given
      return @
  return InstanceManagerModel