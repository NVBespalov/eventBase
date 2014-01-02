###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 05.08.13
* Time: 13:04
###
define ['scripts/ux/vent','backbone'],(vent,Backbone) ->

  suite 'Vent', ->
    suite '#require', ->
      sut = null

      setup ->
        sut = vent
        return

      teardown ->
        sut = null
        return

      test 'Should be defined', ->
        assert.isDefined(sut);


        return

      return

    return
  return
