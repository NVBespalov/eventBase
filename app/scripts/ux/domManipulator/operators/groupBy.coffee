###
 * Created with JetBrains PhpStorm.
 * User: nickbespalov
 * Date: 16.09.13
 * Time: 11:38
###

define ['ux/domManipulator/operators/abstract','jquery'], (Abstract,$)->
  # Класс оператор группировщик jquery объектов по аттрибуту
  class GroupBy extends Abstract
    # Метод execute Выполнить операцию
    # @param $stack[jQuery] Коллекция HTML объектов
    # @param options [object] Опции
    execute:($stack,options)->
      parameters = options.parameters;
      grouper = if $.isArray parameters then parameters[0] else parameters
      result = {}
      $stack.each ->
        attributeValue = $(this).attr(grouper)
        alreadyInResult = result[attributeValue]
        if alreadyInResult
          result[attributeValue] = result[attributeValue].add(this)
        else
          result[attributeValue] = $().add(this)

      return result

  return groupBy:new GroupBy().execute

