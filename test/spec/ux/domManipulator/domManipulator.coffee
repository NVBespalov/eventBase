###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 06.08.13
* Time: 16:10
###

define ['ux/domManipulator/domManipulator','backbone','underscore','jquery'], (Sut,Backbone,_,$)->
  sut = null
  vent = null
  operator = null
  suite 'DomManipulator', ->

    setup ->
      if not operator then operator = test:->
    teardown ->
      if operator then operator = null

    suite '#constructor', ->

      setup ->
        if not vent then vent = _.clone Backbone.Events
        if not sut then sut = new Sut vent, $
        return

      teardown ->
        sut = null
        vent = null
        return

      test 'Should be defined', ->
        assert.isDefined sut, 'Sut is not defined'
        return

      test 'Should throw exception if no vent or provider given', ->
        assert.throws Sut, 'Event bus or provider is not presented.', 'no event bus given'
        return

      test 'Should sing on getDom event', ->
        assert.isDefined vent._events['getDom']
        return

      test 'Should have proper operators', ->
        assert.isDefined sut.operators
        assert.isArray sut.operators
        return

      test 'Should have empty operators', ->
        assert.equal sut.operators.length, 0, 'Operators stack is not empty'
        return

      return

    suite '#getOperator', ->

      setup ->
        if not vent then vent = _.clone Backbone.Events
        if not sut then sut = new Sut vent, $

        return

      teardown ->
        sut = null
        vent = null
        return

      test 'Should be defined', ->
        assert.isDefined sut.getOperator, 'Sut is not defined'
        return

      test 'Should return operator by index in stack', ->
        sut.setOperator(operator)
        assert.isDefined sut.getOperator(0), 'Not returned required operator'
        return

      test 'Should return undefined if no operator found by index', ->
        sut.setOperator(operator)
        assert.isUndefined sut.getOperator(1)
        return

      test 'Should return undefined if no operator found by name', ->
        sut.setOperator(operator)
        assert.isUndefined sut.getOperator('a')
        return

      test 'Should return operator if found by name', ->
        sut.setOperator(operator)
        assert.isFunction sut.getOperator('test')
        return

      return
    suite '#setOperator', ->

      setup ->
        if not vent then vent = _.clone Backbone.Events
        if not sut then sut = new Sut vent, $
        return

      teardown ->
        sut = null
        vent = null
        return

      test 'Should be defined', ->
        assert.isDefined sut.setOperator, 'Sut is not defined'
        return

      test 'Should push new operator in operators stack', ->
        sut.setOperator(operator)
        assert.isDefined sut.getOperator(0), 'Not pushed operator in operators stack'
        return

      test 'Should return pushed operator', ->
        sut.setOperator(operator)
        assert.isTrue (typeof sut.getOperator(0) == 'object'), 'Not returned pushed operator'
        return

      test 'Should return undefined if operator is not a function', ->
          sut.setOperator(undefined)
          assert.isUndefined sut.getOperator(0)
          return

      return

    suite '#getDom', ->

      setup ->
        if not vent then vent = _.clone Backbone.Events
        if not sut then sut = new Sut vent, $
        return

      teardown ->
        if vent then vent = null
        if sut then sut = null
        return

      test 'Should trigger gotDom event if obtaine dom element', ->

        result = false
        callbackObject =
          callback:->
            result = true
        sut.getDom('#mocha',callbackObject.callback,callbackObject)
        assert.isTrue result, 'Not callback call'
        return

      test 'Should throw exception if no vent or provider given', ->
        assert.throws Sut, 'Event bus or provider is not presented.', 'no event bus given'
        return

      return

    return

  return