###
 * Created with WebStorm.
 * User: nickbespalov
 * Date: 02.01.14
 * Time: 2:46
###

(
  require.config
    paths:
      App: 'app'
      jquery: '../bower_components/jquery/jquery'
      underscore: '../bower_components/underscore/underscore'
      backbone: '../bower_components/backbone/backbone'
      bootstrap: 'vendor/bootstrap'
      text: '../bower_components/requirejs-text/text'
      templates: '../templates'
    shim:
      bootstrap:
        deps: ['jquery', 'underscore']
        exports: 'jquery'
      backbone:
        deps: ['underscore', 'jquery']
        exports: 'Backbone'
      underscore:
        deps: []
        exports: '_'

)()