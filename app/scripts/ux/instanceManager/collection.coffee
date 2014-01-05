###
 * Created with JetBrains PhpStorm.
 * User: nickbespalov
 * Date: 28.08.13
 * Time: 10:27
###

define ['backbone','ux/instanceManager/model','underscore'], (Backbone,Model)->
  class InstanceManagerCollection extends Backbone.Collection
    model:Model
    # TODO Refactor to mixins router - method wrapper
    get:()->
      required = arguments[0]
      result = switch
        when typeof required is 'object' and required['sub'] then @getSubModules required['sub']
        when required is undefined then @models
        else super required
      return result
    # Получить вложенные экземпляры модулей
    getSubModules:($parent)->
      result = []
      @each (model)->
        isSubModule = ($parent.find model.get('rootElement'))[0] != undefined
        if isSubModule then result.push model.attributes
        return
      return result

  return InstanceManagerCollection