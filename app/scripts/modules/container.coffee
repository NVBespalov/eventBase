###
 * Created with WebStorm.
 * User: nickbespalov
 * Date: 07.01.14
 * Time: 3:36
###

define ['modules/abstract'], (AbstractModule)->
  # Модуль контейнер.
  # @extend AbstractModule
  # @author nickbespalov
  # @version 1.0
  class Container extends AbstractModule
    @_domSelector:'[data-module=container]'