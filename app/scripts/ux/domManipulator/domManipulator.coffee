###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 06.08.13
* Time: 16:20
###

define [], ->
  # Класс DomManipulator Взаимодействует с DOM.
  #
  # @example Как пользоваться классом.
  #  new DomManipulator(vent,$)
  #  vent.trigger('getDom','div',function(){},this)
  #
  #
  #
  class DomManipulator

    # @param [array] operators Коллекция операторов для операций с выборкой из DOM

    # Создать экземпляр класса.
    #
    # @param [Backbone.Events] Общаяя шина событий.
    # @param [function] Поставщик манипулятор дом. Функция принимающая CSS селектор. Например jquery.
    #
    constructor: (vent,provider,operators)->
      @operators = if typeof operators is 'object' then operators else []
      if vent and vent.trigger and typeof provider is 'function'
        @vent = vent
        @provider = provider
      else throw new TypeError('Event bus or provider is not presented.')

      @vent.on 'getDom', @getDom, @
    # Получить элемент из DOM.
    #
    # @param [string, object] Общаяя шина событий.
    # @param [function] Функция в которую в качестве атрибута буде возвращен полученный DOM элемент.
    # @param [object] Scope контекст в котором будет выполнен вызов функции callback.
    #
    getDom:(request,requestScope,callback,scope)->
      selector = if typeof request is 'string' then request else request.selector
      operation = if typeof request is 'object' then request.operation
      result = if requestScope then @provider(requestScope).find(request) else @provider(selector)
      if operation then operator = this.getOperator(operation)
      if operator
        result = operator(result,request)
      callback.call scope,result

    # Метод getOperator Получить оператора
    # Метод возвращает оператора по его индексу или имени.
    # @param requiredOperator [number,string] Имя или индекс искомого оператора.
    getOperator:(requiredOperator)->
      result = undefined
      if typeof requiredOperator is 'number'
        result = @operators[requiredOperator]
      else
        @operators.every (element)->
          operator = element[requiredOperator]
          if operator
            result = operator
            return false
      return result
    # Метод setOperator Установить оператора
    # Метод добавляет оператора в конец коллекции operators.
    # @param operator [object] Имя или индекс искомого оператора.
    # @return [function,undefined] Установленный оператор или undefined если тип аргумента operator не является объектом.
    setOperator:(operator)->
      if typeof operator is 'object' then @operators.push operator

  return DomManipulator