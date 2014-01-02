###
 * Created with JetBrains PhpStorm.
 * User: nickbespalov
 * Date: 17.09.13
 * Time: 11:38
###

define ['ux/domManipulator/operators/groupBy','jquery'], (Sut,$)->

  sut = null

  suite 'Abstract operator', ->

    suite '#constructor', ->

      setup ->
        if not sut then Sut

      teardown ->
        if sut then sut = null

      test 'Should be defined', ->
        assert.isDefined sut, 'Sut is not defined'
        return

      return

    return

  return