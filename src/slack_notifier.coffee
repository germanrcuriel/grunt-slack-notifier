SlackClient = require 'slack-api-client'

module.exports = (grunt) ->

  ###*
  * @typedef {Object} field
  * @property {String} title Shown as a bold heading above the value text. It cannot contain markup and will be escaped for you.
  * @property {String} value The text value of the field. It may contain standard message markup and must be escaped as normal. May be multi-line.
  * @property {Boolean} short An optional flag indicating whether the value is short enough to be displayed side-by-side with other values.
  ###

  ###*
  * @description Definition of the structured message attachment
  * @see https://api.slack.com/docs/attachments
  * @typedef {Object} attachment
  * @property {String} fallback A plain-text summary of the attachment. This text will be used in clients that don't show formatted text (eg. IRC, mobile notifications) and should not contain any markup.
  * @property {String} text This is the main text in a message attachment, and can contain standard message markup. The content will automatically collapse if it contains 700+ characters or 5+ linebreaks, and will display a "Show more..." link to expand the content.
  * @property {String} title The title is displayed as larger, bold text near the top of a message attachment.
  * @property {String} [title_link] By passing a valid URL in the title_link parameter (optional), the title text will be hyperlinked.
  * @property {String} [color] An optional value that can either be one of good, warning, danger, or any hex color code (eg. #439FE0). This value is used to color the border along the left side of the message attachment.
  * @property {String} [pretext] This is optional text that appears above the message attachment block.
  * @property {String} [author_name] Small text used to display the author's name.
  * @property {String} [author_link] A valid URL that will hyperlink the author_name text mentioned above. Will only work if author_name is present.
  * @property {String} [author_icon] A valid URL that displays a small 16x16px image to the left of the author_name text. Will only work if author_name is present.
  * @property {Array.<field>} [fields] Fields are defined as an array, and hashes contained within it will be displayed in a table inside the message attachment.
  * @property {String} [image_url] A valid URL to an image file that will be displayed inside a message attachment. We currently support the following formats: GIF, JPEG, PNG, and BMP. Large images will be resized to a maximum width of 400px or a maximum height of 500px, while still maintaining the original aspect ratio.
  * @property {String} [thumb_url] A valid URL to an image file that will be displayed as a thumbnail on the right side of a message attachment. We currently support the following formats: GIF, JPEG, PNG, and BMP. The thumbnail's longest dimension will be scaled down to 75px while maintaining the aspect ratio of the image. The filesize of the image must also be less than 500 KB.
  ###

  ###*
  * @description Options Object for configuring the postMessage call to Slack
  * @see https://api.slack.com/methods/chat.postMessage
  * @typedef {Object} options
  * @property {String} token Authentication token
  * @property {String} channel Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name. See below for more details.
  * @property {String} text Text of the message to send. See below for an explanation of formatting.
  * @property {String} username Name of bot.
  * @property {Boolean} [as_user=false] Pass true to post the message as the authed user, instead of as a bot.
  * @property {String} [parse='full'] Change how messages are treated.
  * @property {Boolean} [link_names=false] Find and link channel names and usernames.
  * @property {Array.<attachment>} [attachments] Structured message attachments.
  * @property {Boolean} [unfurl_links] Pass true to enable unfurling of primarily text-based content.
  * @property {Boolean} [unfurl_media] Pass false to disable unfurling of media content.
  * @property {String} [icon_url] URL to an image to use as the icon for this message
  * @property {String} [icon_emoji] emoji to use as the icon for this message. Overrides icon_url.
  ###

  ###*
  * @description Sends a message to Slack using the Slack API client
  * @param {options} options An object containing the configuration parameters for postMessage
  * @param {Function} cb Callback function called when the postMessage call finished.
  ###
  sendMessage = (options, cb) ->
    slack = new SlackClient options.token

    grunt.log.writeln "Sending notification to #{options.channel} Slack channel..."

    slack.api.chat.postMessage
      channel: options.channel
      text: if typeof options.text is 'function' then options.text(grunt, options) else options.text
      username: options.username
      as_user: options.as_user || null,
      parse: options.parse || null,
      link_names: options.link_names || null
      attachments: if grunt.util.kindOf(options.attachments) is 'array' then JSON.stringify(options.attachments) else null
      unfurl_links: options.unfurl_links || null
      unfurl_media: options.unfurl_media || null
      icon_url: options.icon_url || null
      icon_emoji: options.icon_emoji || null
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
