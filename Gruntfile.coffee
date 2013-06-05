#
# * grunt-readme-generator
# * https://github.com/aponxi/grunt-readme-generator
# *
# * Copyright (c) 2013 Logan Howlett
# * Licensed under the MIT license.

"use strict"
module.exports = (grunt) ->
  
  # Project configuration.
  grunt.initConfig
    jshint:
      all: ["Gruntfile.js", "tasks/*.js", "<%= nodeunit.tests %>"]
      options:
        jshintrc: ".jshintrc"

    
    # Before generating any new files, remove any previously-created files.
    clean:
      tests: ["tmp"]

    
    # Configuration to be run (and then tested).
    readme_generator:
      default_options:
        options:
          output: "test/readme.md"
          table_of_contents: on
          readme_folder: "test/readme"
          changelog_folder: "changelogs"
          changelog_version_prefix: "v"
          toc_extra_links: [
            "[Tip Me ![](http://i.imgur.com/C0P9DIx.gif?1)](https://www.gittip.com/aponxi/)"
            "[Donate Me![](http://i.imgur.com/2tqfhMO.png?1)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=VBUW4M9LKTR62)"
          ]
          banner: "banner.md"

        files:
          "installation.md" : "Installation"
          "usage.md" :"Usage"
          "options.md" :"Options"
          "example.md":"Example"
          "output.md":"Example Output"
          "building-and-testing.md":"Building and Testing"
          "legal.md" : "Legal Mambo Jambo"

      

    
    # Unit tests.
    nodeunit:
      tests: ["test/*_test.js"]

  
  # Actually load this plugin's task(s).
  grunt.loadTasks "tasks"
  
  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-nodeunit"
  
  # Whenever the "test" task is run, first clean the "tmp" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask "test", ["clean", "readme_generator", "nodeunit"]
  
  # By default, lint and run all tests.
  grunt.registerTask "default", ["jshint", "test"]