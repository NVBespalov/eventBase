###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 05.08.13
* Time: 16:31
###

define [], ()->
  class ModuleManager
    # @method #constructor(vent,modules) Конструктор класса.
    # @param [Bakcbone.Events] vent Шина событий.
    # @param [Array<Object>] modules Коллекция модулей.
    # @author nickbespalov
    # @example (Инициализировать менеджер модулей.)
    #   new ModuleManager Backbone.Events, [getDomSelector:->]
    # @throw 'Event bus is not presented.'
    # @version 1.0
    constructor:(vent,modules)->
      @modules = []
      if vent.trigger
        @vent = vent
      else
        throw new TypeError('Event bus is not presented.')
      vent.on 'getModule', @onGetModule, @
      vent.on 'getModules', @onGetModules, @
      if typeof modules is 'object' and modules.length
        vent.trigger 'iterate', modules, @setAndDefineModule, @
      return @
    # @method onGetModule
    # Обработчик события getModule.
    # @author nickbespalov
    # @param requiredModule[Object,integer] Описание требуемого объекта.
    # @param callback[Function] Функция обратного вызова.
    # @param scope[Object] Контекст обратного вызова.
    # @example (Получить модуль через шину событий)
    #   eventBuss = Backbone.Events
    #   Foo = callbackFunction: ->
    #   eventBuss.trigger('getModule',0,Foo.callbackFunction,Foo)
    #   eventBuss = Backbone.Events
    #   Foo = callbackFunction: ->
    #   eventBuss.trigger('getModule',0,Foo.callbackFunction,Foo)
    # @version 1.0
    onGetModule:(requiredModule,callback,scope)->
      if callback then callback.call scope, @getModule(requiredModule)
    # @method onGetModules
    # Обработчик события getModules.
    # @author nickbespalov
    # @param requiredModules[Array] Описание требуемого объекта.
    # @param callback[Function] Функция обратного вызова.
    # @param scope[Object] Контекст обратного вызова.
    # @example (Получить модули через шину событий)
    #   eventBuss = Backbone.Events
    #   Foo = callbackFunction: ->
    #   eventBuss.trigger('getModule',0,Foo.callbackFunction,Foo)
    #   eventBuss = Backbone.Events
    #   Foo = callbackFunction: ->
    #   eventBuss.trigger('getModule',0,Foo.callbackFunction,Foo)
    # @version 1.0
    onGetModules:(requiredModules,callback,scope)->
      result = []
      for RequiredModule in requiredModules
        result.push(@getModule(RequiredModule))
      if callback then callback.call scope, result
    # Метод для получения класса модуля по индексу.
    # @param [Object,Array] requiredModule Требуемый модуль.
    # @todo refactor to collection.
    # @return [AbstractModule] Класс модуля.
    getModule: (requiredModule) ->
      if typeof requiredModule is 'number'
        result = @modules[requiredModule]
      else
        @modules.every((module)->
          result = if module.getName() == requiredModule.name then module else undefined
          return !result
        )
      return result
    # Метод для установки класса модуля.
    #
    # @return [ModuleManager] экземпляр класса ModuleManager
    setModule: (Module)->
      if Module.getDomSelector then @modules.push Module
      return this
    # Метод для установки и инициализации класса модуля.
    #
    # @return [ModuleManager] экземпляр класса ModuleManager
    setAndDefineModule: (Module)->
      @setModule Module
      options = Module.options
      if options.autoInitialize then @vent.trigger 'gotModule', Module
      return this
    # Метод для получения всех классов модулей.
    #
    # @return [Array]
    getModules:->
      result = @modules
      return result
  return ModuleManager