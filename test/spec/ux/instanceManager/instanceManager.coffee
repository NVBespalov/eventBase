###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 06.08.13
* Time: 10:28
###

define ['ux/instanceManager/instanceManager','backbone', 'underscore'], (InstanceManager, Backbone, _)->
  sut = null
  vent = null
  sandbox = null
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
        initialize:->@

    teardown ->
      if FakeModule then FakeModule = null
      return

    suite '#constructor', ->

      setup ->
        if not vent then vent = _.clone Backbone.Events
        if not sut then sut = new InstanceManager vent
        return

      teardown ->
        vent = null
        sut = null
        return

      test 'Should be defined', ->
        assert.isDefined sut, 'instance manager should be defined'
        return

      test 'Should throw exception if no vent given', ->
        assert.throws InstanceManager, 'Event bus is not presented.'
        return

      test 'Should sing up for gotModules event', ->
        assert.isDefined vent._events['gotModules'], 'Not signed up for the event: gotModules'
        return

      test 'Should sing up for gotModule event', ->
        assert.isDefined vent._events['gotModule'], 'Not signed up for the event: gotModule'
        return

      test 'Should sing up for getInstances event', ->
        assert.isDefined vent._events['getInstances'], 'Not signed up for the event: getInstances'
        return

      return

    suite '#processModules', ->

      stub = null

      setup ->
        vent = _.clone Backbone.Events
        if not sandbox then sandbox = sinon.sandbox.create({})
        if not stub then stub = sandbox.stub(vent, 'trigger')
        if not sut then sut = new InstanceManager vent
        return

      teardown ->
        if vent then vent = null
        if sut then sut = null
        if sandbox
          sandbox.restore()
          sandbox = null
        if stub then stub = null
        return

      test 'Should trigger event iterate if given atribute is array of modules', ->
        sut.processModules(['test'])
        assert.isTrue true, stub.called, "Didn't trigger event iterate"
        return

      test 'Should trigger event iterate if given atribute is array of modules with callback and passed array', ->
        testingData =['test']
        sut.processModules(testingData)
        assert.isTrue true, stub.calledWith('iterate',testingData, sut.processModule,sut), "Didn't trigger event iterate with proper arguments"
        return

      return

    suite '#processModule', ->

      stub = null

      setup ->
        vent = _.clone Backbone.Events
        if not sandbox then sandbox = sinon.sandbox.create({})
        if not stub then stub = sandbox.stub(vent, 'trigger')
        if not sut then sut = new InstanceManager vent

        return

      teardown ->
        if vent then vent = null
        if sut then sut = null
        if sandbox
          sandbox.restore()
          sandbox = null
        if stub then stub = null
        return

      test 'Should trigger event getDom', ->
        sut.processModule(FakeModule)
        assert.isTrue stub.called, "Didn't trigger event getDom"
        return

      test 'Should trigger event getDom with arguments[
              the name of event is getDom,
              the name of dom element result of passed module getDomSelector method result,
              the callback is inline function,
              context is self
            ]', ->
        sut.processModule(FakeModule)
        assert.isTrue stub.calledWith('getDom',FakeModule.getDomSelector()), "Didn't trigger event getDom with proper arguments"
        return

      return

    suite '#assemblyPhaseOne', ->

      stub = null

      setup ->
        vent = _.clone Backbone.Events
        if not sandbox then sandbox = sinon.sandbox.create({})
        if not stub then stub = sandbox.stub(vent, 'trigger')
        if not sut then sut = new InstanceManager vent
        return

      teardown ->
        if vent then vent = null
        if sut then sut = null
        if sandbox
          sandbox.restore()
          sandbox = null
        if stub then stub = null
        return

      test 'Should be defined', ->
        assert.isDefined sut.assemblyPhaseOne, 'have no assemblyPhaseOne method'
        return

      test 'Should trigger event iterate', ->

        sut.assemblyPhaseOne(FakeModule,$('#mocha'))
        assert.isTrue stub.called, 'Did not trigger iterate event'
        return

      return

    suite '#assemblyPhaseTwo', ->

      stub = null

      setup ->
        vent = _.clone Backbone.Events
        if not sandbox then sandbox = sinon.sandbox.create({})
        if not stub then stub = sandbox.stub(vent, 'trigger')
        if not sut then sut = new InstanceManager vent
        return

      teardown ->
        if vent then vent = null
        if sut then sut = null
        if sandbox
          sandbox.restore()
          sandbox = null
        if stub then stub = null
        return

      test 'Should be defined', ->
        assert.isDefined sut.assemblyPhaseTwo, 'have no assemblyPhaseTwo method'
        return

#      test 'Should wrap given root element in jquery if it is not wrapped', ->
#        sut.assemblyPhaseTwo(FakeModule,$('#mocha')[0])
#        assert.isDefined sut.getInstances()[0].get('rootElement').jquery, 'did not wrapp simple dom in to jquery object'
#        return

      test 'Should trigger event getDom', ->
        sut.assemblyPhaseTwo(FakeModule,$('#mocha'))
        assert.isTrue stub.called, 'Did not trigger getDom event'
        return

      return

    suite '#assemblyPhaseThree', ->

      stub = null
      helperElements = null
      setup ->
        vent = _.clone Backbone.Events
        if not sandbox then sandbox = sinon.sandbox.create({})
        if not stub then stub = sandbox.stub(vent, 'trigger')
        if not sut then sut = new InstanceManager vent
        if not helperElements then helperElements = $('#mocha')
        return

      teardown ->
        if vent then vent = null
        if sut then sut = null
        if sandbox
          sandbox.restore()
          sandbox = null
        if stub then stub = null
        if helperElements then helperElements = null
        return

      test 'Should be defined', ->
        assert.isDefined sut.assemblyPhaseThree, 'have no assemblyPhaseTwo method'
        return

      test 'Should call setRestElements method', ->
        fakeModule = new FakeModule()
        stub = sandbox.stub(fakeModule, 'setRestElements')
        helperElements = $('#mocha')
        sut.assemblyPhaseThree fakeModule, helperElements
        assert.isTrue stub.called, 'did not call setRestElements'
        return

      test 'Should call setRestElements method with given helperElements argument', ->
        fakeModule = new FakeModule()
        stub = sandbox.stub(fakeModule, 'setRestElements')
        sut.assemblyPhaseThree fakeModule, helperElements
        assert.isTrue stub.calledWith(helperElements), 'did not call setRestElements with arguments'
        return

      test 'Should push new instance in to instances array', ->
        fakeModule = new FakeModule()
        sut.assemblyPhaseThree fakeModule, helperElements
        assert.equal 1,sut.getInstances().length, 'Pushes nothing in to the instances array'
        return

      return

    suite '#setInstance', ->

      setup ->
        vent = _.clone Backbone.Events
        if !sut then sut = new InstanceManager vent
        return

      teardown ->
        if vent then vent = null
        if sut then sut = null
        return

      test 'Should be defined', ->
        assert.isDefined sut.setInstance, 'Sut has no method - setInstance'
        return

      test 'Should add instance in to array of instances', ->
        sut.setInstance fakeModule.setRootElement $('#mocha')
        assert.equal 1, sut.getInstances().length, 'did not add instance in to array of instances'
        return

      return

    suite '#getInstance', ->

      setup ->
        vent = _.clone Backbone.Events
        sut = new InstanceManager vent
        return

      teardown ->
        if vent then vent = null
        if sut then sut = null
        return

      test 'Should be defined', ->
        assert.isDefined sut.getInstance, 'Sut has no method - getInstance'
        return

      test 'Should return instance', ->
        sut.setInstance fakeModule.setRootElement($('#mocha'))
        assert.isDefined sut.getInstance('mocha'), 'did not return instances'
        return

      return

      suite '#getInstances', ->

      setup ->
        vent = _.clone Backbone.Events
        sut = new InstanceManager vent
        return

      teardown ->
        if vent then vent = null
        if sut then sut = null
        return

      test 'Should be defined', ->
        assert.isDefined sut.getInstances, 'Sut has no method - getInstances'
        return

      test 'Should return instance', ->
        sut.setInstance fakeModule
        assert.isDefined sut.getInstances(), 'did not return instance'
        return

      return

    return

  return