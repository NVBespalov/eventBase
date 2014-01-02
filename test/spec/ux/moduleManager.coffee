###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 05.08.13
* Time: 16:26
###

define ['ux/moduleManager','backbone'], (Sut,Backbone)->
  suite 'Module manager', ->
    sut = null
    eventBuss = null
    objectForTesting = null

    setup ->
      if not eventBuss then eventBuss = Backbone.Events
      if not sut then sut = new Sut(eventBuss)
      if not objectForTesting
        objectForTesting =
          getDomSelector:->
          options:
            autoInitialize:true
      return

    teardown ->
      if sut then sut = null
      if eventBuss
        eventBuss.off()
        eventBuss = null
      if objectForTesting then objectForTesting = null
      return

    suite '#constructor', ->

      test 'Should be defined', ->
        assert.isDefined sut, 'should be defined'
        return

      test 'Should throw exception if no vent given', ->
        try
          new Sut
        catch exception
          result = true
        assert.isTrue result, 'should be defined'
        return

      test 'Has modules property', ->
        assert.isDefined sut.modules, 'modules should be defined'
        return

      test 'Modules property should be an array', ->
        assert.isArray sut.modules, 'modules should be an array'
        return

      test 'Should trigger iterate event if modules givent', ->

        if !sandbox then sandbox = sinon.sandbox.create({})
        stub = sandbox.stub(eventBuss, 'trigger')
        sut = new Sut(eventBuss,[objectForTesting])
        assert.isTrue stub.args[0][0] == 'iterate', 'constructor should trigger iterate if array of modules given'
        sandbox.restore()
        return

      test 'Should trigger iterate event with given array as property if modules givent', ->
        if !sandbox then sandbox = sinon.sandbox.create({})
        stub = sandbox.stub(eventBuss, 'trigger')
        new Sut(eventBuss,[objectForTesting,objectForTesting])
        assert.isTrue stub.args[0][1][0] == objectForTesting, 'constructor should trigger iterate with array of given modules if array of modules given'
        sandbox.restore()
        return

      test 'Should call callback function with the module as first argument, on event  getModule', ->
        testingObject = callbackFunction: ->
        sut.setModule objectForTesting
        if !sandbox then sandbox = sinon.sandbox.create({})
        stub = sandbox.stub(testingObject, 'callbackFunction')
        eventBuss.trigger 'getModule', 0, testingObject.callbackFunction, testingObject
        assert.isTrue stub.calledWith(objectForTesting), 'constructor should trigger iterate with array of given modules if array of modules given'
        sandbox.restore()
        return

      return

    suite '#getModule', ->

      test 'Should be defined', ->
        assert.isDefined sut.getModule
        return

      test 'Should return element at givent index', ->
        sut.modules.push('test')
        assert.isString sut.getModule(0)
        return

      return

    suite '#setModule', ->

      test 'Should be defined', ->
        assert.isDefined sut.setModule
        return

      test 'Should add only objects with getDomSelector', ->
        sut.modules = []
        sut.setModule(objectForTesting)
        assert.isObject sut.getModule(0)
        return

      return

    suite '#setAndDefineModule', ->

      sandbox = null
      stub = null

      setup ->
        if !sandbox then sandbox = sinon.sandbox.create({})
        if !stub then stub = sandbox.stub(eventBuss, 'trigger')

      teardown ->
        if sandbox
          sandbox.restore()
          sandbox = null
        if stub then stub = null

      test 'Should be defined', ->
        assert.isDefined sut.setAndDefineModule
        return

      test 'Should add one module and trigger gotModule event', ->
        sut.setAndDefineModule(objectForTesting)
        assert.isTrue stub.calledWith('gotModule'), 'should trigger gotModule'
        return

      test 'Should add one module and not trigger gotModule event if module options.autoInitialize is false', ->
        # This module will not be initialized during the phase of bootstraping
        objectForTesting.options.autoInitialize = false
        sut.setAndDefineModule(objectForTesting)
        assert.isFalse stub.called, 'should not trigger gotModule'
        return

      return

    suite '#getModules', ->

      test 'Should be defined', ->
        assert.isDefined sut.getModules
        return

      test 'Should return element all modules', ->
        sut.modules.push('test','test2')
        assert.isArray sut.getModules()
        return

      return


    return
  return