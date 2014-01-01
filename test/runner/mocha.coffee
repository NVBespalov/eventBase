###
* Created with JetBrains PhpStorm.
* User: nbespalov
* Date: 29.06.13
* Time: 17:43
###

( ->
  runner = mocha.run()

  if(!window.PHANTOMJS) then return;

  runner.on 'test', (test) ->
    sendMessage 'testStart', test.title
    return


  runner.on 'test end', (test) ->
    sendMessage 'testDone', test.title, test.state
    return


  runner.on 'suite', (suite) ->
    sendMessage 'suiteStart', suite.title
    return


  runner.on 'suite end', (suite) ->
    if suite.root then return;
    sendMessage 'suiteDone', suite.title
    return


  runner.on 'fail', (test, err) ->
    sendMessage 'testFail', test.title, err
    return


  runner.on 'end', ->
    output =
      failed:this.failures,
      passed:this.total - this.failures,
      total:this.total
    sendMessage 'done', output.failed,output.passed, output.total
    return

  sendMessage = ->
    args = [].slice.call arguments
    alert(JSON.stringify(args))
    return
  return

)()
