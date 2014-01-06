###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 07.08.13
* Time: 16:31
###

define ['modules/abstract','backbone','underscore','jquery'], (AbstractModule,Backbone,_,$)->

  suite 'Abstract module', ->

    sut = null
    vent = null
    sandbox = null

    setup ->
      if not vent then vent = _.clone Backbone.Events
      if not sut then sut = new AbstractModule vent, test:'test'
      return

    teardown ->
      if sut then sut = null
      if vent then vent = null
      return

    suite '#constructor', ->

      test 'Should be defined', ->
        assert.isDefined sut, 'Sut is undefined'
        return

      test 'Should throw exception if no vent given', ->
        assert.throws AbstractModule, TypeError
        return

      test 'Should have property Model', ->
        assert.notEqual _.keys(sut.__proto__).indexOf('Model'), 'has no Model property'
        return

      test 'Should have property View', ->
        assert.notEqual _.keys(sut.__proto__).indexOf('View'), 'has no View property'
        return

      test 'Should have property view', ->
        assert.notEqual _.keys(sut.__proto__).indexOf('view'), 'has no view property'
        return

      test 'Should have property domSelector', ->
        assert.notEqual _.keys(sut.__proto__).indexOf('domSelector'), 'has no view domSelector'
        return

      test 'Should have property restSelector', ->
        assert.notEqual _.keys(sut.__proto__).indexOf('restSelector'), 'has no view restSelector'
        return

      test 'Should have property rootElement', ->
        assert.notEqual _.keys(sut.__proto__).indexOf('rootElement'), 'has no view rootElement'
        return

      test 'Should have property restElements', ->
        assert.notEqual _.keys(sut.__proto__).indexOf('restElements'), 'has no view restElements'
        return

      test 'Should have property options', ->
        assert.notEqual _.keys(sut.__proto__).indexOf('options'), 'has no options property'
        return

      test 'Should have property defaults', ->
        assert.notEqual -1, _.keys(sut).indexOf('defaults'), 'has no defaults property'
        return

      test 'Should extend default options with given as options parameter', ->
        assert.isDefined sut.defaults['test'], 'Did not extend default options'
        return

      return

    suite '#show', ->

      test 'Should be defined', ->
        assert.isDefined sut.show, 'Sut show method is undefined'
        return

      return

    suite '#hide', ->

      test 'Should be defined', ->
        assert.isDefined sut.show, 'Sut show method is undefined'
        return

      return

    suite '#getView', ->

      test 'Should be defined', ->
        assert.isDefined sut.getView, 'Sut getView method is undefined'
        return

#      test 'Should return view instance', ->
#        debugger
#        assert.instanceOf sut.getView(), sut.View, 'Sut getView returns undefined'
#        return

      return

    suite '#setView', ->

      test 'Should be defined', ->
        assert.isDefined sut.setView, 'Sut getView method is undefined'
        return

      #      test 'Should return view instance', ->
      #        sut.setView()
      #        assert.instanceOf sut.getView(), sut.View, 'Sut getView returns undefined'
      #        return

      return

    suite '#getDomSelector', ->

      test 'Should be defined', ->
        assert.isDefined AbstractModule.getDomSelector, 'Sut getDomSelector method is undefined'
        return

      test 'Should return string', ->
        assert.isString AbstractModule.getDomSelector()
        return


      return

    suite '#setDomSelector', ->

      test 'Should be defined', ->
        assert.isDefined sut.setDomSelector, 'Sut setDomSelector method is undefined'
        return

      test 'Should set domSelector property equals to given string', ->
        sut.setDomSelector('test')
        assert.equal 'test', sut.domSelector, 'Did not set property domSelector equals to given string'
        return


      return
    suite '#setRootElement', ->

      test 'Should be defined', ->
        assert.isDefined sut.setRootElement, 'Sut setRootElement method is undefined'
        return

      test 'Should set rootElement property equals to given element', ->
        $rootElement = $('#mocha')
        sut.setRootElement($rootElement)
        assert.equal $rootElement, sut.getRootElement(), 'Root element is not equals to given element'
        return

      test 'Should set rest elements selector to [data-for= + testingData.id + ],[for= + testingData.id + ]', ->
        $rootElement = $('#mocha')
        inputId  = $rootElement.attr('id')
        sut.setRootElement($rootElement)
        assert.equal '[data-for=' + inputId + '],[for=' + inputId + ']', sut.getRestSelector(), 'Wrong rest selector'
        return


      return

    suite '#setRestSelector', ->

      test 'Should be defined', ->
        assert.isDefined sut.setRestSelector, 'Sut setRestSelector method is undefined'
        return

      test 'Should set restSelector property equals to given string', ->
        sut.setRestSelector('test')
        assert.equal 'test', sut.getRestSelector(), 'Did not set property restSelector equals to given string'
        return


      return

    suite '#getRestSelector', ->

      test 'Should be defined', ->
        assert.isDefined sut.getRestSelector, 'Sut getRestSelector method is undefined'
        return

      test 'Should return restSelector value with type of string', ->
        assert.isString sut.getRestSelector()
        return


      return

    suite '#setRestElements', ->

      test 'Should be defined', ->
        assert.isDefined sut.setRestElements, 'Sut setRestElements method is undefined'
        return

      test 'Should set restElements to given', ->
        testingData = $('#mocha')
        sut.setRestElements(testingData)
        assert.equal testingData, sut.getRestElements()
        return

      return

    suite '#getRestElements', ->
      stub = null

      setup ->
        if not vent then vent = _.clone Backbone.Events
        if not sandbox then sandbox = sinon.sandbox.create({})
        if not stub then stub = sandbox.stub(vent, 'trigger')
        if not sut then sut = new AbstractModule vent
        return

      teardown ->
        if sandbox
          sandbox.restore()
          sandbox = null
        if stub then stub = null
        if sut then sut = null
        if vent then vent = null
        return

      test 'Should be defined', ->
        assert.isDefined sut.getRestElements, 'Sut getRestElements method is undefined'
        return

      test 'Should trigger getDom if restElements is undefined', ->
        sut.getRestElements()
        assert.isTrue stub.calledWith 'getDom','*',sut.setRestElements,sut
        return

      test 'If restElements property is defined, should return rest elements instead of triggering getDom event', ->
        testingData = $('#mocha')
        sut.setRestElements(testingData)
        assert.isDefined sut.getRestElements()
        assert.isFalse stub.called
        return

    suite '#initialize', ->

      test 'Should be defined', ->
        assert.isDefined sut.initialize, 'Initialize is undefined'
        return

      test 'Should return undefined if no Model or View', ->
        assert.isUndefined sut.initialize()
        return

      return

      return

    return

  return