define ['systemAbstract', 'templates/preloader/default', 'underscore', 'jquery'], (AbstractSystemClass, PreloaderTemplate, _, $)->

  # Класс AbstractModule Абстрактная реализация модуля.
  # Используется кдассом - медиатор: ModuleManager
  # @example Как пользоваться классом.
  #  class FormModule extends AbstractModule
  #    domSelector:'form'
  #  new ModuleManager(vent, [FormModule])
  #
  #
  class AbstractModule extends AbstractSystemClass
    _name: @moduleName
    # @property [Object] errorsMessages Все возможные ошибки сервера
    errorsMessages:
      403: 'Ошибка доступа'
      401: 'Ошибка доступа'
      413: 'Файл слишком большой'
      500: 'Внимание, Ошибка сервера'
      503: 'Сервер временно закрыт'
      0: 'Внимание, ошибка сети'

    # @property [Object] options Настройки модуля.
    @options:
      autoInitialize: true

    # @property [String] DOM селектор корневого элемента модуля.
    domSelector: '*'

    # @property [String] DOM селектор вспомогательных элементов модуля.
    restSelector: '*'

    # @property [jQuery] Корневой элемент модуля.
    rootElement: undefined

    # @property [jQuery] Вспомогательные элементы модуля.
    restElements: undefined

    # @property [Backbone.View] Класс основного представление модуля.
    View: undefined

    # @property [Backbone.Model] Класс основной модели модуля.
    Model: undefined

    # @property [Backbone.View] Экземпляр класса основного представление модуля.
    view: undefined

    # @todo documen as options
    # @todo add set and get events
    propertiesDescriptors:
      # @property [String] Получить селектор корневых элементов для инициализации вложенных модулей.
      subModulesRootElementsSelector:
        get: -> @_subModulesRootElementsSelector || '[data-module]'
        set: (@_subModulesRootElementsSelector) ->
      # @property [String] Получить селектор корневых элементов для инициализации вложенных модулей.
      name:
        get: -> @_name
        set: (@_name) ->
      # @property [Boolean] Только для чтения
      readOnly:
        get: -> @_readOnly || false
        set: (@_readOnly) ->
      # @property [String] Сообщение при попытке покинуть страницу если имеются не сохраненные данные.
      messageOnExitIfChanged:
        get: -> @_messageOnExitIfChanged or "Имеются не сохраненные данные, выйти без сохранения?"
        set: (@_messageOnExitIfChanged) ->
      # @property [Array] Вложенные модули.
      modules:
        get: -> @_modules || []
        set: (@_modules) ->
      # @property [Array<Template>] Классы шаблонов модуля.
      Templates:
        get: -> @_Templates or []
        set: (@_Templates) ->
      # @property [Boolean] changed Модуль удаляющий элементы списка
      changed:
        get: -> @_changed
        set: (@_changed) ->
      # @property [String] requestURL URL
      requestURL:
        value: '/'
        writable: true
      # @property [String] requestURL URL
      onParseResponseErrors:
        value: 'Внимание, ошибка сервера!'
        writable: true
      # @property [Object] requestConfig Настройки для выполнения запроса
      requestConfig:
        get: -> @_requestConfig
        set: (value) ->
          @_requestConfig = $.extend(true, @_requestConfig || {}, value) if value
          return
      requestProvider:
        value: $
        vritable: true
      requestProviderMethodName:
        value: 'ajax'
        writable: true
      $all:
        get: -> @getRestElements().add(@getRootElement())
      # @property [boolean] inProgress Модуль в процессе обработки данных пользователя
      inProgress:
        get: -> @_inProgress or false
        set: (@_inProgress) ->
      # @property [object] cantSubmitReasonsDescriptions Карта описаний причин отказа к отправке данных на сервер.
      cantSubmitReasonsDescriptions:
        get: -> @_cantSubmitReasonsDescriptions or inProgress: 'Внимание! Данные обрабатываются, пожалуйста дождитесь завершения обработки и отправьте данные снова.'
        set: (@_cantSubmitReasonsDescriptions) ->
    # Создать новый экземпляр класса AbstractModule
    #
    # @param [Backbone.Events] Общаяя шина событий.
    # @param [Object] defaults Настройки модуля.
    #
    constructor: (vent, defaults) ->
      if vent and vent.trigger then @vent = vent
      else throw new TypeError 'Event bus is not presented.'
      super
      @requestConfig = type: 'POST', data: {}
      # @param defaults Значения по умолчанию
      # @todo merge with properties and change to super with arguments
      @defaults = {}
      if defaults? then _.extend @defaults, defaults
      return @

    # Установить селектор DOM корневого элемента модуля.
    #
    # @param [string] DOM селектор корневого элемента модуля.
    # @return [this] Ссылка на экземпляр.
    setDomSelector: (domSelector) ->
      if @domSelector != domSelector then @domSelector = domSelector
      return @

    # Получить DOM селектор корневого элементов.
    #
    # @return [String] DOM селектор корневого элемента модуля.
    @getDomSelector: ->
      domSelector = @domSelector
      result = if domSelector then domSelector else @prototype.domSelector
      result = if result is '*' then undefined else result
      return result

    # Установить корневой элемент модуля.
    # @todo refactor SRP
    # @param [jquery] Корневой элемент модуля.
    # @return [this] Ссылка на экземпляр.
    setRootElement: (rootElement) ->
      if rootElement
        @rootElement = rootElement
        $rootElement = @getRootElement()
        inputId = $rootElement.attr('id') or $rootElement.data('id')
        @setRestSelector "[data-for=#{inputId}],[for=#{inputId}]"
        @vent.trigger 'getDom', @getRestSelector(), $rootElement, @setRestElements, @
      return @

    # Получить корневой элемент модуля.
    #
    # @return [jquery] корневой элемент модуля.
    getRootElement: ->
      result = @rootElement
      return result

    # Установить DOM селектор вспомогательных элементов модуля.
    #
    # @param [string] DOM селектор вспомогательных элементов модуля.
    # @return [this] Ссылка на экземпляр.
    setRestSelector: (restSelector) ->
      if typeof restSelector is 'string' and restSelector != @restSelector then @restSelector = restSelector
      return @

    # Получить DOM селектор вспомогательных элементов модуля.
    #
    # @return [String] DOM селектор вспомогательных элементов модуля.
    getRestSelector: ->
      result = @restSelector
      return result

    # Установить вспомогательные элементы модуля.
    #
    # @param [jquery] Коллекция вспомогательных элементов модуля.
    #
    # @return [this] Ссылка на экземпляр.
    setRestElements: (restElements) ->
      if restElements and typeof restElements is 'object' then @restElements = restElements
      return @

    # Получить вспомогательные элементы модуля.
    #
    # @return [jquery/undefined] Если вспомогательные элементы не определены вызывает событие getDom иначе Коллекция вспомогательных элементов модуля.
    getRestElements: ->
      return @restElements or $('')

    # Инициализация модуля.
    #
    initialize: ->
      # Предопределить шаблоны модуля для дальнейшего исспользования в представлении
      @defineTemplates()
      view = @initializeView()
      @vent.on("subscribe:#{@name}", @onSubscribe)
      @vent.on("get:#{@name}:value", @onGetValueRequest)
      @vent.on("get:#{@name}:dimensions", @onGetDimensionsRequest)
      if view isnt undefined
        view.$el.on 'notify', (event, data, type, notificationRecipient) =>
          @notify.apply(@,[data, type, notificationRecipient])
      return @

    # @method #initializeView Инициализировать основное представление
    # @author nickbespalov
    # @version 1.0
    initializeView: ->
      View = @View
      if typeof View is 'function'
        viewConfig = {}
        $rootElement = @rootElement
        viewConfig['el'] = $rootElement if $rootElement
        templates = @getInitializedTemplates()
        model = @getDefinedModel(templates)
        @model = viewConfig['model'] = model if model
        collection = @getInitializedCollection(templates)
        @collection = viewConfig['collection'] = collection if collection
        viewConfig['helpers'] = @restElements
        viewConfig['makeRequest'] = @makeRequest || ->
        viewConfig['templates'] = templates
        view = new View(viewConfig)
        view.templateName = @Template?.prototype._name
      @setView(view)

    # @method #getInitializedTemplates Получить список экземпляров шаблонов модуля
    # @author nickbespalov
    # @return [object] Список экземпляров шаблонов модуля
    # @version 1.0
    getInitializedTemplates: ->
      result = {}
      for Template in @Templates
        template = new Template(vent: @vent)
        result[template.name] = template
      return result

    # @method #getDefinedModel Получить экземпляр модели модуля
    # @author nickbespalov
    # @param [array] templates Шаблоны модуля
    # @return [Backbone.Model] Модель
    # @version 1.0
    getDefinedModel: (templates)->
      if @Model and typeof @model is 'undefined'
        new @Model(@serializePredefinedData(templates))
      else if typeof @model isnt 'undefined'
        @model

    # @method #getInitializedCollection Получить экземпляр коллекции модуля
    # @author nickbespalov
    # @param [array] templates Шаблоны модуля
    # @return [Backbone.Collection/undefined] Коллекция
    # @version 1.0
    getInitializedCollection: (templates) ->
      new @Collection(@serializePredefinedData(templates), silent: true) if @Collection


    # Получить значение модуля
    #
    # @return [Object] Значение модуля.
    getSubmitValue: ->
      @view.getValue()

    # Получить данные модуля для внутреннего использования
    #
    # @return [Object] Значение модуля.
    getData: ->
      @view.getData()

    # @method #show
    # Показать представление модуля.
    # @author nickbespalov
    # @version 1.0
    show: ->
      if @view then @view.show()

    # @method #hide
    # Скрыть представление модуля.
    # @author nickbespalov
    # @version 1.0
    hide: ->
      if @view then @view.hide()

    # @method #getView
    # Получить экземпляр основного представления модуля.
    # @author nickbespalov
    # @example (Получить основное представление.)
    #   @getView()
    # @version 1.0
    getView: ->
      result = @view
      return result

    # @method #setView
    # Установить экземпляр основного представления модуля.
    # @author nickbespalov
    # @param [AbstractView] view Основное представления модуля.
    # @example (Установить основное представление.)
    #   @setView(view)
    # @version 1.0
    setView:(view) ->
      @view = view

    # @method #notify
    # Показать уведомление пользователю.
    # @author nickbespalov
    # @param [Array] data Список уведомлений.
    # @param [String] type Тип уведомления errors, warnings, success.
    # @param [String] notificationRecipient Идентификатор получателя сообщения
    # @example (Уведомить пользователя о неверной информации в форме входа.)
    #   @notify(['Внимание! Вы ввели неверный пароль!'])
    # @version 1.0
    notify: (data, type, notificationRecipient) =>
      view = @getView()
      helpBlock = view.helpBlock
      if typeof helpBlock is 'undefined' or !view.helpBlock.length
        @vent.trigger('CommonNotifications:notify', data, type, notificationRecipient)
      else
        view.notify(data, type, notificationRecipient)

    # @method #clearNotifications
    # Очистить сообщения поля.
    # Удаляет предущее состояние поля снимая классы ошибка/предупреждение/успешно
    # @author nickbespalov
    # @example (Уведомить пользователя о неверной информации в форме входа.)
    #   @clearNotifications()
    # @version 1.0
    clearNotifications: ->
      @view.clearNotifications()

    # @method #getName Получить имя модуля
    # Удаляет предущее состояние поля снимая классы ошибка/предупреждение/успешно
    # @author nickbespalov
    # @example (Уведомить пользователя о неверной информации в форме входа.)
    #   @clearNotifications()
    # @version 1.0
    @getName: ->
      @moduleName

    onSubscribe: (events) =>
      for event in events
        subscribeOnMethod = @[event.name]
        if subscribeOnMethod
          @[event.name] = _.wrap(
            subscribeOnMethod
            (wrapping) ->
              event.handler.apply(
                event.scope
                [wrapping.apply(@, _.toArray(arguments).slice(1))]
              )
          )
      return

    # @method #reset
    # Обнулить значение элемента.
    # @author nickbespalov
    # @version 1.0
    reset: ->
      @view.reset() if @readOnly is false
      
    # @method #disable
    # Заблокировать модуль от изменений.
    # @author nickbespalov
    # @version 1.0
    disable: ->
      @view?.disable()

    # @method #enable
    # Разблокировать модуль для изменений.
    # @author nickbespalov
    # @version 1.0
    enable: ->
      @view?.enable()

    # @method #setSubModules
    # Установить вложенные модули.
    # @author nickbespalov
    # @version 1.0
    setSubModules: (modules) ->
      @modules = modules

    # @method #makeRequest Получить данные с сервера
    # @param {Object} url URL
    # @param {Boolean} async Признак асинфронного запроса
    # @param {Object,String} data Данные для отправки на сервер
    # @param {String} type Тип запроса POST || GET
    # @param {Object} provider Поставщик услуг связи с сервером
    # @param {String} makeRequestMethodName Имя метода осуществляющего вызов сервера у поставщик услуг связи с сервером
    # @author nickbespalov
    # @version 1.0
    makeRequest: ({url, async, data, type, provider, makeRequestMethodName}) =>
      requestProvider = provider || @requestProvider
      providerMakeRequestMethod = makeRequestMethodName || @requestProviderMethodName
      @showPreloader()
      requestProvider[providerMakeRequestMethod].apply(
        requestProvider, [@makeRequestConfig.apply(@, arguments)]
      ).complete(@onMakeRequestComplete)

    # @method #onMakeRequestComplete Обработчик события завершения запроса
    # @author nickbespalov
    # @param [jqXHR] jqXHR Объект Запрос
    # @param [String] success Статус ответа
    # @version 1.0
    onMakeRequestComplete: (jqXHR) =>
      @hidePreloader()
      response = @parsejqXHR(jqXHR)
      return if response.aborted
      if response.success then @onMakeRequestSuccess(response) else @onMakeRequestFalse(response)

    # @method #parsejqXHR Разобрать ответ
    # @author nickbespalov
    # @param [jqXHR] jqXHR Объект Запрос
    # @version 1.0
    parsejqXHR: (jqXHR) ->
      try
        result = JSON.parse(jqXHR.responseText)
      catch exception
        @vent.trigger(
          'exception', 'При попытке разобрать ответ сервера произошла ошибка'
          @,arguments,exception,jqXHR
        ) if jqXHR?.statusText isnt 'abort'
        result =
          success: false
          message: @errorsMessages[jqXHR.status] || @onParseResponseErrors
        if jqXHR.statusText is 'abort' then result.aborted = true
      return result
    # @method #onMakeRequestSuccess При успешном получении данных с сервера
    # @author nickbespalov
    # @param [jqXHR] response Объект Запрос
    # @version 1.0
    onMakeRequestSuccess: (response) ->
      @view.onMakeRequestSuccess(response)

    # @method #onMakeRequestFalse При не успешном получении данных с сервера
    # @author nickbespalov
    # @param [jqXHR] response Объект Запрос
    # @version 1.0
    onMakeRequestFalse: (response) ->
      @notify(response.message)

    # @method #makeRequestConfig Собрать конфигурацию запроса
    # @author nickbespalov
    # @param [Object] requestConfig Объект Запрос
    # @version 1.0
    makeRequestConfig: (requestConfig) ->
      @requestConfig = requestConfig
      return @requestConfig

    # @method #setPromptConfirmationOnExit Установить запрос подтверждения при выходе
    # @author nickbespalov
    # @version 1.0
    setPromptConfirmationOnExit: ->
      @getRootElement().trigger('promptComfirmationOnExit')

    # @method #unsetPromptConfirmationOnExit Отменить запрос подтверждения при выходе
    # @author nickbespalov
    # @version 1.0
    unsetPromptConfirmationOnExit: ->
      if not @changed then @getRootElement().trigger('removePromptComfirmationOnExit')

    # @method #loadData Загрузить данные
    # @author nickbespalov
    # @version 1.0
    loadData: (data) ->
      view = @view
      model = view.model || view.collection?.first()
      moduleValue = data[model.get('name')] if model
      model.set('value', moduleValue) if typeof moduleValue isnt 'undefined'

    unInitialize: ->
      @view.unInitialize() if typeof @view isnt 'undefined'
      if typeof @Collection isnt 'undefined' then @Collection = undefined
      if typeof @Model isnt 'undefined' then @Model = undefined
      if typeof @View isnt 'undefined' then @View = undefined
      return @

    # @method #showPreloader Отобразить индикатор загрузки
    # @author nickbespalov
    # @version 1.0
    showPreloader: ->
      @view?.showPreloader()

    # @method #hidePreloader
    # @author nickbespalov
    # @version 1.0
    hidePreloader: ->
      @view?.hidePreloader()
      
    # @method #onModuleInitialized Обработчик глобального события инициализации модуля
    # @author nickbespalov
    # @version 1.0
    onModuleInitialized: ->

    # @method #onGetValueRequest Обработчик
    # @param [jQuery.Deferred] Deferred
    # @author nickbespalov
    # @version 1.0
    onGetValueRequest: (deferred) =>
      deferred.resolve(@getData())

    # @method #defineTemplates Предопределить шаблоны модуля
    # @author nickbespalov
    # @return [array] templates Шаблоны модуля
    # @version 1.0
    defineTemplates: ->
      result = []
      result.push(PreloaderTemplate)
      result.push(@Template) if typeof @Template is 'function'
      @Templates = result

    # @method #serializePredefinedData Сереализовать предустановленные данные из разметки модуля
    # @author nickbespalov
    # @param [array] templates Шаблоны модуля
    # @version 1.0
    serializePredefinedData: (templates = @getInitializedTemplates())->
      @View.getPredefinedData(@$all, templates)

    # @method #onGetValueRequest Обработчик запроса измерений представления текущего модуля
    # @param [jQuery.Deferred] Deferred
    # @author nickbespalov
    # @version 1.0
    onGetDimensionsRequest: (deferred) =>
      if deferred then deferred.resolve(@getView().getDimensions())
      else @vent.trigger('exception', context: @, arguments: arguments)

    # @method #canBeSubmitted Обработчик возможности отправить данные модуля на сервер
    # @author nickbespalov
    # @return [object] Описание возможности отправки данных {verdict: true/false, reason: ''/'....'}
    # @version 1.0
    canBeSubmitted: =>
      result = verdict: true, reason: ''

      if @inProgress then result.verdict = false ; result.reason = @cantSubmitReasonsDescriptions?['inProgress'] or ''

      return result
