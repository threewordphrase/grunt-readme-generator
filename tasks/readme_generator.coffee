#
# * grunt-readme-generator
# * https://github.com/aponxi/grunt-readme-generator
# *
# * Copyright (c) 2013 Logan Howlett
# * Licensed under the MIT license.
# 
"use strict"
fs = require 'fs'
module.exports = (grunt) ->

  pkg = grunt.config.get ['pkg']
  # console.log pkg
  unless pkg?
    grunt.fail.fatal "The package configuration is missing. Please add `pkg: grunt.file.readJSON('package.json')` to your grunt init in Gruntfile; or provide a `pkg` object in `grunt.config` with package name and description."
  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  
  # helper functions
  

  make_anchor = (string) ->
    #  make convert a string like "Special Thanks" to "special-thanks"
    # console.log string
    str = string.replace(/\s+/g, '-').toLowerCase()
    str = "#"+str

  back_to_top = (travis) ->
    # just creates the link
    str = make_anchor pkg.name
    if travis then str += "-"
    result = "[Back To Top](#{str})"

  get_latest_changelog = (opts)->
    #  get the latest changelog file and print it to the readme
    # todo: what if the extension is .markdown or something else...
    # currently only .md extensions are supported
    prefix = opts.changelog_version_prefix
    changelog_folder = opts.changelog_folder

    versions_found = []
    files = fs.readdirSync changelog_folder
    # console.log files
    for filename in files
      # console.log filename.substring(0,prefix.length) is prefix
      # console.log grunt.file.isFile(changelog_folder+"/"+filename)

      if filename.substring(0,prefix.length) is prefix and grunt.file.isFile(changelog_folder+"/"+filename)

        # -3 is for .md part
        version = filename.slice(prefix.length,-3)
        versions_found.push version
    if versions_found.length > 0
      versions_found.sort()
      latest = versions_found[versions_found.length - 1]
      # returns just 0.1.1 from v0.1.1.md
      latest
    else
      grunt.fail.fatal "No changelogs are present. Please write a changelog file or fix prefixes."
      false


  generate_banner = (opts) ->
    path = opts.readme_folder
    banner_file = opts.banner
    output = opts.output

    f = path+"/"+banner_file
    unless grunt.file.exists f
      grunt.fail.fatal "Source file \"" + f + "\" not found."
    else
      fs.appendFileSync output, grunt.file.read f
      fs.appendFileSync output, "\n"


  generate_TOC = (files, opts) ->
    toc_extra_links = opts.toc_extra_links
    changelog_insert_before = opts.changelog_insert_before
    output = opts.output

    fs.appendFileSync output, "## Jump to Section\n\n"
    # console.dir files
    
    for file, title of files
    
      if file is changelog_insert_before
        # release history is generated specially since the latest-changelog is generated dynamically.
        # console.log "inserting release history"
        release_title = make_anchor "Release History"
        fs.appendFileSync output, "* [Release History](#{release_title})\n"
        # console.log "inserting #{title}"
        link = make_anchor title
        fs.appendFileSync output, "* [#{title}](#{link})\n"
      else
        link = make_anchor title
        fs.appendFileSync output, "* [#{title}](#{link})\n"
    
    if toc_extra_links.length > 0
      for i in toc_extra_links
        ex = i
        fs.appendFileSync output, "* #{ex}\n"
    fs.appendFileSync output, "\n"
      
  generate_title = (opts) ->
    output = opts.output
    travis = opts.has_travis
    username = opts.github_username

    title = pkg.name
    desc = pkg.description
    fs.appendFileSync output, "# #{title} "

    if travis
      tra = "[![Build Status](https://secure.travis-ci.org/#{username}/#{title}.png?branch=master)](http://travis-ci.org/#{username}/#{title})"
      fs.appendFileSync output, "#{tra}"
    fs.appendFileSync output, "\n\n> #{desc}\n\n"

  append = (opts, file, title) ->
    path = opts.readme_folder
    travis = opts.has_travis
    output = opts.output

    fs.appendFileSync output, "## #{title}\n"
    top = back_to_top(travis)
    fs.appendFileSync output, "#{top}\n\n"
    f = path+"/"+file
    unless grunt.file.exists f
      grunt.fail.fatal "Source file \"" + f + "\" not found."
    else
      fs.appendFileSync output, grunt.file.read f 
      fs.appendFileSync output, "\n\n"

  generate_release_history = (opts) ->
    prefix = opts.changelog_version_prefix
    changelog_folder = opts.changelog_folder
    travis = opts.has_travis
    output = opts.output
    fs.appendFileSync output, "## Release History\n"
    top = back_to_top(travis)
    fs.appendFileSync output, "#{top}\n\n"
    fs.appendFileSync output, "You can find [all the changelogs here](/#{changelog_folder}).\n\n"
    latest = get_latest_changelog opts
    # todo: only supporting .md format at the moment.
    latest_file = changelog_folder + "/" + prefix + latest + ".md"
    fs.appendFileSync output, "### Latest changelog is for [#{latest}](/#{latest_file}):\n\n"
    unless grunt.file.exists latest_file
      grunt.fail.fatal "Changelog file \"" + latest_file + "\" not found."
    else
      fs.appendFileSync output, grunt.file.read latest_file 
      fs.appendFileSync output, "\n"


  generate_footer = (opts) ->
    output = opts.output
    date = new Date();
    str = "\n--------\n_This readme has been automatically generated by [readme generator](https://github.com/aponxi/grunt-readme-generator) on #{date}._"
    fs.appendFileSync output, str


  grunt.registerMultiTask "readme_generator", "Generate Readme File", ->
    
    # Merge task-specific and/or target-specific options with these defaults.
    options = @options(
      github_username: "aponxi" # this is mainly for travis link
      output: "README.md" # where readme file should be generated in respect to Gruntfile location
      table_of_contents: on # generate table of contents
      readme_folder: "readme" # where readme partial files are located
      changelog_folder: "changelogs" # where changelog files are located
      changelog_version_prefix: "v" # under changelog folder, there are files like v0.1.0.md if the prefix is "V"
      changelog_insert_before: "legal.md" # I like my legal stuff at the bottom of the readme
      toc_extra_links: [] # Sometimes I like adding quicklinks on the top in table of contents. Table of contents (TOC) must be enabled for this option
      banner: null # I like some ascii art on the top of the readme
      has_travis: on # I use travis a lot and want to have the travis image generated on the top
    )
    # lets clean up the output readme
    grunt.file.write options.output, ""


    files = @data.order
    # generate banner
    if options.banner?
      generate_banner options
    # generate title and description
    generate_title options
    generate_TOC files, options

    # Iterate over all specified file groups.
    for file, title of files
      # console.log "file: ", file
      # console.log "title: ", title
      if file is options.changelog_insert_before
        # add release history
        generate_release_history options
      append options, file, title

    # after writing all the contents 
    
    # add footer
    generate_footer options
    # Print a success message.
    grunt.log.writeln "File \"" + options.output + "\" created."

