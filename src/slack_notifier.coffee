SlackClient = require 'slack-api-client'

module.exports = (grunt) ->

  sendMessage = (options, cb) ->
    slack = new SlackClient options.token

    grunt.log.writeln "Sending notification to #{options.channel} Slack channel..."

    slack.api.chat.postMessage
      channel: options.channel
      text: if typeof options.text == 'function' then options.text(grunt, options) else options.text
      username: options.username
    , (err, res) ->
      grunt.fatal err if err
      grunt.log.ok 'Notification sent!'
      cb()

  grunt.registerMultiTask 'slack_notifier', 'Send a message to a Slack channel', ->

    done = @async()
    error = false

    options = @options
      token: ''
      channel: ''
      text: ''
      username: 'Grunt.js'

    unless options.token
      error = true
      grunt.log.error 'Token is not set'

    unless options.channel
      error = true
      grunt.log.error 'Channel is not set'

    unless options.text
      error = true
      grunt.log.error 'Text is not set'

    if error
      grunt.log.error 'Notification not sent!'
      done()
    else
      sendMessage options, ->
        done()
