###
 * Created with JetBrains PhpStorm.
 * User: nickbespalov
 * Date: 28.08.13
 * Time: 14:33
###

define ['ux/instanceManager/collection', 'jquery'], (Sut,$)->
  sut = null
  FakeModule = null
  fakeModule = null
  suite '#instanceManagerCollection', ->
    setup ->
      class FakeModule
        @getDomSelector:->'input'
        rootElement:undefined
        setRootElement:(rootElement)->
          @rootElement = rootElement
          return @
        getRootElement:->
          return @rootElement
        setRestSelector:->
        getRestSelector:->'li'
        setRestElements:(@restElements)->
        initialize:->
          return
      return

    teardown ->
      if FakeModule then FakeModule = null
      return

    suite '#constructor', ->
      setup ->
        if not sut then sut = new Sut
        return

      teardown ->
        sut = null
        return

      test 'Should be defined', ->
        assert.isDefined sut, 'instance manager collection is undefined'
        return

      return

    suite '#add', ->
      setup ->
        if not sut then sut = new Sut
        if not fakeModule then fakeModule = new FakeModule()
        return

      teardown ->
        sut = null
        if fakeModule then fakeModule = null
        return

      test 'Should be able to add module instance in', ->
        sut.add(fakeModule.setRootElement($('#mocha')))
        assert.equal 1,sut.length, 'instance manager collection cant add module instance in to'
        return

      return

    suite '#get', ->
      setup ->
        if not sut then sut = new Sut
        if not fakeModule then fakeModule = new FakeModule()
        return

      teardown ->
        sut = null
        if fakeModule then fakeModule = null
        return

      test 'Should be able to get model by model id atribute', ->
        sut.add(fakeModule.setRootElement($('#mocha')))
        assert.isDefined sut.get('mocha'), 'Returns no model on demand, when model id given'
        return

      test 'Should be able to get model by model cid atribute', ->
        sut.add(fakeModule.setRootElement($('#mocha')))
        assert.isDefined sut.get(sut.get('mocha')['cid']), 'Returns no model on demand, when model cid given'
        return

      test 'Should be able to get model by model', ->
        sut.add(fakeModule.setRootElement($('#mocha')))
        assert.isDefined sut.get(sut.get('mocha')), 'Returns no model on demand, when model given'
        return

      test 'Should be able to get model by passing an a config object with the key - sub and its value equals to the DOM object which wrapped in to jquery', ->
        sut.add(fakeModule.setRootElement($('#mocha')))
        sut.add(fakeModule.setRootElement($('#mocha li').first()))
        assert.equal 1, sut.get(sub:$('#mocha')).length, 'Returns no model on demand, when config given'
        return

      return

    return
  return