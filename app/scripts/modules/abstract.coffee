###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 07.08.13
* Time: 16:36
###

define ['underscore'], (_)->

  # Абстрактная реализация модуля.
  # Используется классом - медиатор: ModuleManager
  # @example Как пользоваться классом.
  #  class FormModule extends AbstractModule
  #    domSelector:'form'
  #  new ModuleManager(vent, [Module])
  # @author nickbespalov
  # @version 1.0
  class AbstractModule

    get = (props) =>  @::__defineGetter__ name, getter for name, getter of props
    set = (props) => @::__defineSetter__ name, setter for name, setter of props

    # @property [Object] options Настройки модуля.
    @options:
      autoInitialize:true

    # @property [String] DOM селектор корневого элемента модуля.
    get domSelector: -> @_domSelector
    set domSelector: (@_domSelector)->

    # @property [String] DOM селектор вспомогательных элементов модуля.
    get restSelector: -> @_restSelector
    set restSelector: (@_restSelector)->

      # @property [jQuery] Корневой элемент модуля.
    get rootElement: -> @_rootElement
    set rootElement: (@_rootElement)->

    # @property [jQuery] Вспомогательные элементы модуля.
    get restElements: -> @_restElements
    set restElements: (@_restElements)->

    # @property [Backbone.View] Класс основного представление модуля.
    get View: -> @_View
    set View: (@_View)->

    # @property [Backbone.Model] Класс основной модели модуля.
    get Model: -> @_Model
    set Model: (@_Model)->

    # @property [Backbone.View] Экземпляр класса основного представление модуля.
    get view: -> @_view
    set view: (@_view)->

    # @property [Backbone.Events] Общаяя шина событий.
    get vent: -> @_vent
    set vent: (@_vent)->

    # @property [Object] Значения по умолчанию
    get defaults: -> @_defaults
    set defaults: (@_defaults)->

    # @method #constructor(vent,defaults)
    #   Создать новый экземпляр класса AbstractModule
    # @param vent [Backbone.Events] Общаяя шина событий.
    # @param defaults [Object]  Настройки модуля.
    # @return [AbstractModule] Экземпляр класса ModuleManager
    # @throw Вызывает исключение если в параметрах нет шины событий.
    # @example (Cоздать новый экземпляр класса AbstractModule)
    #   new AbstractModule(vent,defaults)
    # @author nickbespalov
    # @version 1.0
    constructor:(vent,defaults)->
      if vent and vent.trigger then @vent = vent
      else throw new TypeError('Event bus is not presented.')
      @defaults = {}
      if defaults? then _.extend @defaults, defaults
      return @


    # @method #initialize
    #   Инициализация модуля.
    # @return [AbstractModule] Экземпляр класса ModuleManager
    # @author nickbespalov
    # @version 1.0
    initialize:->
      if not @View or not @Model or not @rootElement then return
      @view = new @View(
        el:@rootElement
        model:new @Model
        helpers:@getRestElements()
      )
      return @

    # @method #notify
    #   Показать уведомление пользователю.
    # @author nickbespalov
    # @param [Array] data Список уведомлений.
    # @param [String] type Тип уведомления errors, warnings, success.
    # @example (Уведомить пользователя о неверной информации в форме входа.)
    #   @notify(['Внимание! Вы ввели неверный пароль!'])
    # @version 1.0
    notify:(data,type)->
      @getView().notify(data,type)
      return

    # @method #clearNotifications
    # Очистить сообщения поля.
    # Удаляет предущее состояние поля снимая классы ошибка/предупреждение/успешно
    # @author nickbespalov
    # @example (Уведомить пользователя о неверной информации в форме входа.)
    #   @clearNotifications()
    # @version 1.0
    clearNotifications:->
      @view.clearNotifications()
      return

  return AbstractModule