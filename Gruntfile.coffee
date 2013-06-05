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
    pkg: grunt.file.readJSON('package.json')
    
    # Before generating any new files, remove any previously-created files.
    clean:
      tests: ["test/readme.md"]

    
    # Configuration to be run (and then tested).
    readme_generator:
      test:
        options:
          has_travis: off
          output: "test/readme.md"
          table_of_contents: off
          readme_folder: "test/readme"
          changelog_folder: "test/changelogs"
          changelog_version_prefix: "v"
          toc_extra_links: [
            "[Tip Me ![](http://i.imgur.com/C0P9DIx.gif?1)](https://www.gittip.com/aponxi/)"
            "[Donate Me! ![](http://i.imgur.com/2tqfhMO.png?1)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=VBUW4M9LKTR62)"
          ]
          banner: "banner.md"

        order:
          "installation.md" : "Installation"
          "usage.md" :"Usage"
          "options.md" :"Options"
          "example.md":"Example"
          "output.md":"Example Output"
          "building-and-testing.md":"Building and Testing"
          "legal.md" : "Legal Mambo Jambo"


  
  # Actually load this plugin's task(s).
  grunt.loadTasks "tasks"
  
  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-clean"
  
  # Whenever the "test" task is run, first clean the "tmp" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask "test", ["clean", "readme_generator:test"]
  
  # By default, lint and run all tests.
  grunt.registerTask "default", ["build", "test"]