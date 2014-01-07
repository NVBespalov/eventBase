###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 06.08.13
* Time: 10:45
###

define ['underscore','ux/instanceManager/collection','jquery'], (_,Collection,$)->
  # Класс InstanceManager создает экземпляры модулей.
  #
  # @example Как пользоваться классом.
  #  new InstanceManager(vent)
  #  vent.trigger('gotModules',[Modules])
  class InstanceManager

    # Экземпляры инициализированных классов модулей.
#    instances = undefined

    # Создать экземпляр класса.
    #
    # @param [Backbone.Events] Общаяя шина событий.
    #
    constructor:(vent)->
      @instances = new Collection
      # Если в конструктор не передать общуюю шину событий будет брошенно исключение.
      if vent && vent.trigger then @vent = vent
      else throw new TypeError('Event bus is not presented.')
      # Подписываемся на события.
      @vent.on 'gotModules', @processModules, @
      @vent.on 'gotModule', @processModule, @
      @vent.on 'getInstances', @getInstances, @
      return
    # Получить экземпляр класса модуля
    #
    # @param [Integer] Индекс в массиве.
    #
    # @return [AbstractModule] Экземпляр класса модуль.
    getInstance:(indexOrId)->
      result = @instances.get(indexOrId)
      return result

    # Добавить экземпляр класса модуля
    #
    # @param [AbstractModule] Модули для инициализации.
    #
    # @example Set modle instance.
    #   vent = _.clone Backbone.Events
    #   instanceManager = new InstanceManager vent
    #   class Module
    #     @getDomSelector:->
    #     rootElement:undefined
    #     setRootElement:(rootElement)->
    #     getRootElement:->
    #     setRestSelector:->
    #     getRestSelector:->
    #     setRestElements:(@restElements)->
    #     initialize:->
    #
    #   instanceManager.setInstance new Module().setRootElement($('#someId'))
    setInstance:(moduleInstance)->
      @instances.add moduleInstance
      return

    # Получить экземпляры классов модулей
    #
    # @param [Object] Параметры выборки.
    #
    # @example
    #   vent = _.clone Backbone.Events
    #   instanceManager = new InstanceManager vent
    #
    #   Get modle instance by her id attribute.
    #   instanceManager.getInstance 'someId'
    #
    #   Get modle instance by her cid.
    #   instanceManager.getInstance 'c1'
    #
    #   Get model or models by passing an object as config.
    #   config:
    #     sub:$('#ovnerElement')
    #   instanceManager.getInstance config
    #
    # @return [Array<AbstractModule>] Массив экземпляров класса модуль.
    getInstances:(config,callback,scope)->
      result = @instances.get(config)
      if callback then callback.apply(scope,[result])
      return result

    # Обработать массив модулей.
    #
    # @example processModules
    #   new InstanceManager(vent)
    #   vent.trigger('gotModules',[Modules])
    #
    # @param [Array<Modules>] Модули для инициализации.
    #
    processModules:(modules)->
      if typeof modules is 'object' and modules.length
        @vent.trigger 'iterate', modules, @processModule, @
      return

    # Обработать модуль.
    #
    # @example processModule
    #   new InstanceManager(vent)
    #   vent.trigger('gotModule',Module)
    #
    # @param [Object] Модули для инициализации.
    #
    processModule:(Module,ModuleScope)->
      if Module then moduleRootElementsSelector = Module.getDomSelector()
      typeOfSelector = typeof moduleRootElementsSelector
      if moduleRootElementsSelector and  typeOfSelector is 'string' or typeOfSelector is 'object'
        @vent.trigger 'getDom', moduleRootElementsSelector,ModuleScope, _.partial(@assemblyPhaseOne,Module), @
      return

    # Первая фаза сборки модуля.
    # На первой фазе сборки перебераются все DOM элементы полученные с помощью селектора - domSelector модуля,
    # для каждого dom элемента вызывается вторая фаза сборки.
    #
    # @param [AbstractModule] Класс модули для сборки.
    # @param [jquery] Все dom элементы удовлетворяющие domSelector текущего модуля.
    #
    assemblyPhaseOne: (Module,rootElements)->
      if Module? and rootElements?  and rootElements.length
        @vent.trigger 'iterate', rootElements, _.partial(@assemblyPhaseTwo,Module), @
      return

    # Вторая фаза сборки модуля.
    # На второй фазе сборки создается экземпляр модуля, устанавливается корневой элемент модуля,
    # получается dom селектор вспомогательных элементов модуля и вызывается третья фаза сборки.
    #
    # @param [AbstractModule] Класс модуля для сборки.
    # @param [jquery] Корневой dom элемент для сборки текущего модуля.
    #
    assemblyPhaseTwo:(Module,rootElement)->
      $rootElement = if rootElement.jquery then rootElement else $(rootElement)
      if Module then module = new Module @vent
      if module && rootElement
        module.rootElement = $rootElement
        moduleHelpersSelector = module.restSelector
      if moduleHelpersSelector then @vent.trigger 'getDom', moduleHelpersSelector, undefined, _.partial(@assemblyPhaseThree,module), @
      return

    # Третья фаза сборки модуля.
    # На третьей фазе сборки в модуль устанавливаются вспомогательные элементы, вызывается инициализация.
    #
    # @param [module] Экземпляр модуля.
    # @param [jquery] Вспомогательные элементы.
    #
    assemblyPhaseThree:(module,helperElements)->
      if module and helperElements
        module.setRestElements helperElements
        @setInstance(module.initialize())
      return

  return InstanceManager