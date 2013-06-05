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
      tests: [
        "test/readme.md"
        "test/readme_no_toc.md"
        "test/readme_all_options.md"
        "test/readme_no_travis.md"
        "test/readme_no_footer.md"
        "test/readme_no_changelog.md"
      ]

    
    # Configuration to be run (and then tested).
    readme_generator:
      no_toc:
        options:
          has_travis: on
          output: "test/readme_no_toc.md"
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
      all_options:
        options:
          has_travis: on
          output: "test/readme_all_options.md"
          table_of_contents: on
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
      no_travis:
        options:
          has_travis: off
          output: "test/readme_no_travis.md"
          table_of_contents: on
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
      no_footer:
        options:
          has_travis: on
          output: "test/readme_no_footer.md"
          table_of_contents: on
          readme_folder: "test/readme"
          changelog_folder: "test/changelogs"
          changelog_version_prefix: "v"
          toc_extra_links: [
            "[Tip Me ![](http://i.imgur.com/C0P9DIx.gif?1)](https://www.gittip.com/aponxi/)"
            "[Donate Me! ![](http://i.imgur.com/2tqfhMO.png?1)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=VBUW4M9LKTR62)"
          ]
          generate_footer: no
          banner: "banner.md"

        order:
          "installation.md" : "Installation"
          "usage.md" :"Usage"
          "options.md" :"Options"
          "example.md":"Example"
          "output.md":"Example Output"
          "building-and-testing.md":"Building and Testing"
          "legal.md" : "Legal Mambo Jambo"
      no_release_history:
        options:
          has_travis: on
          output: "test/readme_no_changelog.md"
          table_of_contents: on
          readme_folder: "test/readme"
          generate_changelog: off
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
  grunt.registerTask "test", [
    "clean", 
    "readme_generator:all_options"
    "readme_generator:no_toc"
    "readme_generator:no_travis"
    "readme_generator:no_footer"
    "readme_generator:no_release_history"
  ]
  
  # By default, lint and run all tests.
  grunt.registerTask "default", ["build", "test"]