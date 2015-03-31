module.exports = (grunt) ->

  grunt.initConfig
    clean:
      tasks: [ 'tasks' ]

    coffee:
      tasks:
        expand: true
        cwd: 'src/'
        src: '*.coffee'
        dest: 'tasks/'
        ext: '.js'

  grunt.loadTasks 'tasks/'

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'build', [ 'clean', 'coffee' ]
  grunt.registerTask 'default', [ 'build' ]
