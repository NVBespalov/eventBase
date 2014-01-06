#/*global require*/
'use strict'

require.config
  shim:
    underscore:
      exports: '_'
    backbone:
      deps: [
        'underscore'
        'jquery'
      ]
      exports: 'Backbone'
    bootstrap:
      deps: ['jquery'],
      exports: 'jquery'
  paths:
    jquery: '../bower_components/jquery/jquery'
    backbone: '../bower_components/backbone/backbone'
    underscore: '../bower_components/underscore/underscore'
    bootstrap: '../bower_components/sass-bootstrap/dist/js/bootstrap'

require [
  'backbone'
  'underscore'
  'ux/vent'
  'ux/iterator'
  'ux/domManipulator/domManipulator'
  'ux/moduleManager'
  'ux/instanceManager/instanceManager'
], (
  Backbone
  _
  vent
  Iterator
  DOMManipulator
  ModuleManager
  InstanceManager
) ->
  debugger
  iterator = new Iterator vent, _
  domManipulator = new DOMManipulator vent,$,[]
  instanceManager = new InstanceManager vent
  moduleManager = new ModuleManager(vent,[])