###
 * Created with JetBrains PhpStorm.
 * User: nickbespalov
 * Date: 16.09.13
 * Time: 11:39
###

define ['ux/domManipulator/operators/groupBy','jquery'], (Sut,$)->

  sut = null
  $stack = null
  suite 'Group by operator', ->
    setup ->
      if not sut then sut = Sut['groupBy']
      if not $stack
        $stack = $()
        addOne = ($stack,index)->
          $stack.add('<input />',
            type:'radio'
            name:'optionsRadios' + if $stack.length >= 5 then 1 else ''
            id:'optionsRadios' + index
            value:'creditcard'
          )
        $stack = addOne($stack,index) for index in [1..10]
      return

    teardown ->
      if $stack.length then $stack = null
      return

    suite '#constructor', ->

      test 'Should be defined', ->
        assert.isDefined sut, 'Sut is not defined'
        return

      test 'Should return object if array passed in parameters attribute', ->
        assert.isObject sut($stack,parameters:['name']), 'Cant handle array'
        return

      test 'Should return object', ->
        assert.isObject sut($stack,parameters:'name'), 'Returns not an object'
        return

      test 'Should group name', ->
        result = sut($stack,parameters:'name')
        assert.isDefined result['optionsRadios1']
        assert.isDefined result['optionsRadios']
        return

      return

    return

  return