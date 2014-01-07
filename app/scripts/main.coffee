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
  'modules/container'
], (
  Backbone
  _
  vent
  Iterator
  DOMManipulator
  ModuleManager
  InstanceManager
  ContainerModule
) ->
  new Iterator vent, _
  new DOMManipulator vent,$,[]
  new InstanceManager vent
  new ModuleManager(vent,[ContainerModule])
  return