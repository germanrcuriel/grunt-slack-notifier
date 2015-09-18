# grunt-slack-notifier [![NPM Version](https://badge.fury.io/js/grunt-slack-notifier.svg)](https://npmjs.org/package/grunt-slack-notifier) [![Package downloads](http://img.shields.io/npm/dm/grunt-slack-notifier.svg)](https://npmjs.org/package/grunt-slack-notifier)

> Send notifications to a Slack channel or user


## Getting Started
This plugin requires Grunt `>=0.4.0`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:


```shell
npm install grunt-slack-notifier --save-dev
```


Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:


```js
grunt.loadNpmTasks('grunt-slack-notifier');
```


*This plugin was designed to work with Grunt 0.4.x. If you're still using grunt v0.3.x it's strongly recommended that [you upgrade](http://gruntjs.com/upgrading-from-0.3-to-0.4), but in case you can't please use [v0.3.2](https://github.com/gruntjs/grunt-contrib-copy/tree/grunt-0.3-stable).*


## 'slack_notifier' task
_Run this task with the `grunt slack_notifier` command._

Task targets, files and options may be specified according to the grunt [Configuring tasks](http://gruntjs.com/configuring-tasks) guide.


### Options


#### token
Type: `String`

The Slack authentication token available at [Slack Web API](https://api.slack.com/web).


#### channel
Type: `String`

Channel to send message to. Can be a public channel, private group or IM channel. Can be an encoded ID, or a name.


#### text
Type: `String` or `Function`

Text of the message to send. Messages are formatted as described in the [formatting spec](https://api.slack.com/docs/formatting).
You can also define the text as function so you're able to build the text at run time.


#### username
Type: `String`
Default: `Grunt.js`

Name of bot.

#### as_user
Type: `Boolean`
Default: `false`

Set to true to post the message as the authenticated user (based on token). In that case `username`, `icon_url` and `icon_emoji` settings will be ignored

#### parse
Type: `String`
Default: `full`

Set to `none` to let Slack handle the message as plain text without escaping entities

#### link_names
Type: `Boolean`
Default: `false`

Set to true if you want references to private/public channels or users to be automatically linked

#### attachments
Type: `Array`
Default: `null`

An list of attachements for your message. See https://api.slack.com/docs/attachments#message_formatting

#### unfurl_links
Type: `Boolean`
Default: `true`

See https://api.slack.com/docs/unfurling

#### unfurl_media
Type: `Boolean`
Default: `false`

See https://api.slack.com/docs/unfurling

#### icon_url
Type: `String`
Default: `null`

Define an image to be used as profile picture for your slackBot message

#### icon_emoji
Type: `String`
Default: `null`

Alternatively define a emoji as profile picture. This overwrites `icon_url`


### Usage Examples

```js
slack_notifier: {
  notification: {
    options: {
      token: 'EXAMPLE-TOKEN',
      channel: '#notifications',
      text: 'Deploying to production...',
      username: 'Grunt.js',
      as_user: false,
      parse: 'full',
      link_names: true,
      attachments: [
        {
          'fallback': 'Required plain-text summary of the attachment.',
          'color': '#36a64f',
          'pretext': 'Optional text that appears above the attachment block',
          'author_name': 'Bobby Tables',
          'author_link': 'http://flickr.com/bobby/',
          'author_icon': 'http://flickr.com/icons/bobby.jpg',
          'title': 'Slack API Documentation',
          'title_link': 'https://api.slack.com/',
          'text': 'Optional text that appears within the attachment',
          'fields': [
            {
              'title': 'Priority',
              'value': 'High',
              'short': false
            }
          ],
          'image_url': 'http://my-website.com/path/to/image.jpg',
          'thumb_url': 'http://example.com/path/to/thumb.png'
        }
      ],
      unfurl_links: true,
      unfurl_media: true,
      icon_url: 'http://my-website.com/path/to/image.jpg',
      icon_emoji: ':stuck_out_tongue_winking_eye:'
    }
  }
}
```

alternatively you can define the text as a function:

```js
slack_notifier: {
  notification: {
    options: {
      token: 'EXAMPLE-TOKEN',
      channel: '#notifications',
      text: function(grunt, options) {
          var currentId = grunt.config.get('customerId'),
              customerName = customers.getCustomerName(currentId);
          return 'Deployed customer ' + customerName + ' with customer ID ' + currentId;
      },
      username: 'Grunt.js'
      ...
    }
  }
}
```

## Release history

 * 2015-06-04 v0.0.3  Fix package.json keywords
 * 2015-03-31 v0.0.2  First release
