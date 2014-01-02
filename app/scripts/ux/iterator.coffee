###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 07.08.13
* Time: 13:11
###

define [], ()->
  # Класс Iterator Выполняет перебор коллекций.
  #
  # @example Как пользоваться классом.
  #  new Iterator(vent,_);
  #  vent.trigger('iterate',['t','e','s','t'],function(){})
  class Iterator
    # Создать экземпляр класса.
    #
    # @param [Backbone.Events] Общаяя шина событий.
    # @param [function] Поставщик итератор. Функция переберающая полученную коллекцию. Например underscore.
    # @todo Refactor to provider map
    #
    constructor:(vent,provider)->
      if not vent or !vent.trigger or !provider.each
        throw new TypeError()
      else
        @vent = vent
        @provider = provider
      # Подпишемся на события.
      @vent.on 'iterate', @iterate, @
      return
    # Перебрать элементы в указанной коллекции.
    #
    # @param [Mixed] Коллекция значений/свойств.
    # @param [function] Функция в которую будет совершаться вызов для каждого текущего элемента коллекции.
    #
    iterate:(collection,callback)->
      if typeof collection is 'object'
        @provider.each(collection,callback,arguments[arguments.length-1])

  return Iterator