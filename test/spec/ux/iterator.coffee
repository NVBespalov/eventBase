###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 07.08.13
* Time: 12:35
###

define ['ux/iterator', 'backbone', 'underscore'], (Iterator,Backbone,_)->
  suite 'Iterator', ->

    sut = null
    vent = null

    suite '#constructor', ->

      setup ->
        if not vent then vent = _.clone Backbone.Events
        if not sut then sut = new Iterator vent,_
        return

      teardown ->
        if sut then sut = null
        if vent then vent = null
        return

      test 'Should be defined', ->
        assert.isDefined sut, 'Sut is undefined'

      test 'Should throw exception if no vent or no provider', ->
        assert.throws Iterator, TypeError

      test 'Variables @vent @provider should be defined', ->
        result = false
        if sut.vent && sut.provider then result = true
        assert.isTrue result , TypeError

      test 'Should sing up for iterate event', ->
        assert.isDefined vent._events['iterate'], 'Not signed up for the event - iterate'
        return

      return
      
    suite '#iterate', ->

      setup ->
        if not vent then vent = _.clone Backbone.Events
        if not sut then sut = new Iterator vent,_
        return

      teardown ->
        if sut then sut = null
        if vent then vent = null
        return

      test 'Should run callback for each given collection element', ->
        result = 0;
        callback = ->
          result++
        sut.iterate ['t','e','s','t'], callback
        assert.equal result, 4, 'Sut is undefined'
        return

      return

    return
  return