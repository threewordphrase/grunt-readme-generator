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
  # helper functions

  # helps with debug messages
  inform = (msg) ->

    grunt.log.oklns msg+"..."

  get_package_info = (opts) ->
    # if opts.informative then inform "Getting package info from options"

    is_package_json_needed = no
    if opts.package_name? and opts.package_name.length > 0 then name = opts.package_name
    else is_package_json_needed = yes

    if opts.package_desc? and opts.package_desc.length > 0 then desc = opts.package_desc
    else is_package_json_needed = yes

    # console.log is_package_json_needed
    # if opts.informative then inform "Need to fill in the blanks from package.json"

    if is_package_json_needed
      pkg = grunt.config.get ['pkg']
      # console.log pkg
      unless pkg?
        grunt.fail.fatal "The package configuration is missing. Please add `pkg: grunt.file.readJSON('package.json')` to your grunt init in Gruntfile; or provide package_name and package_desc options"
      else
        unless name? then name = pkg.name
        unless desc? then desc = pkg.description
        # if opts.informative then inform "Got the necessary information from package.json"
    package_info =
      name:name
      description : desc
    # console.log package_info
    package_info


  make_anchor = (string) ->
    #  make convert a string like "Special Thanks" to "special-thanks"
    # console.log string
    str = string.replace(/\s+/g, '-').toLowerCase()
    str = "#"+str

  back_to_top = (opts) ->
    # just creates the link
    travis = opts.has_travis
    pkg = get_package_info opts
    str = make_anchor pkg.name
    if travis then str += "-"
    result = "\[[Back To Top]\](#{str})"

  get_file_extension = (file) ->
    ext = file.split('.').pop()
    ext

  is_valid_extention = (file) ->
    ext = get_file_extension file
    if ext.toLowerCase() is "md" or ext.toLowerCase() is "markdown" or ext.toLowerCase() is "mdown"
      yes
    else no


  get_latest_changelog = (opts)->
    if opts.informative then inform "Getting the latest changelog"
    #  get the latest changelog file and print it to the readme
    prefix = opts.changelog_version_prefix
    changelog_folder = opts.changelog_folder

    versions_found = []
    files = fs.readdirSync changelog_folder
    # console.log files
    for filename in files
      # console.log filename.substring(0,prefix.length) is prefix
      # console.log grunt.file.isFile(changelog_folder+"/"+filename)

      if filename.substring(0,prefix.length) is prefix and grunt.file.isFile(changelog_folder+"/"+filename) and is_valid_extention filename

        versions_found.push filename
    
    if versions_found.length > 0
      versions_found.sort()
      latest = versions_found[versions_found.length - 1]
      
      # returns the whole file name like v0.1.1.md
      latest
    else
      grunt.fail.fatal "No changelogs are present. Please write a changelog file or fix prefixes."
      false


  generate_banner = (opts) ->
    if opts.informative then inform "Generating banner"
    
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
    if opts.informative then inform "Generating table of contents"
    toc_extra_links = opts.toc_extra_links
    changelog_insert_before = opts.changelog_insert_before
    output = opts.output

    fs.appendFileSync output, "## Jump to Section\n\n"
    # console.dir files
    changelog_inserted = no
    for file, title of files
    
      if file is changelog_insert_before and opts.generate_changelog
        changelog_inserted = yes
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
    
    # what if changelog wasn't inserted?
    if opts.generate_changelog and not changelog_inserted
      # lets insert it at the end
      release_title = make_anchor "Release History"
      fs.appendFileSync output, "* [Release History](#{release_title})\n"

    if toc_extra_links.length > 0
      for i in toc_extra_links
        ex = i
        fs.appendFileSync output, "* #{ex}\n"
    
    fs.appendFileSync output, "\n"
      
  generate_title = (opts) ->
    if opts.informative then inform "Writing package name and description"
    output = opts.output
    travis = opts.has_travis
    username = opts.github_username
    pkg = get_package_info opts
    title = pkg.name
    desc = pkg.description
    
    fs.appendFileSync output, "# #{title} "

    if travis
      if opts.informative then inform "Engineering travis button"
      
      tra = "[![Build Status](https://secure.travis-ci.org/#{username}/#{title}.png?branch=master)](http://travis-ci.org/#{username}/#{title})"
      fs.appendFileSync output, "#{tra}"
    
    fs.appendFileSync output, "\n\n> #{desc}\n\n"

  append = (opts, file, title) ->
    path = opts.readme_folder
    travis = opts.has_travis
    output = opts.output

    fs.appendFileSync output, "## #{title}\n"

    if opts.table_of_contents
      top = back_to_top(opts)
      fs.appendFileSync output, "#{top}\n"
    
    fs.appendFileSync output, "\n"

    f = path+"/"+file
    
    unless grunt.file.exists f
      grunt.fail.fatal "Source file \"" + f + "\" not found."
    else
      fs.appendFileSync output, grunt.file.read f 
      fs.appendFileSync output, "\n\n"

  generate_release_history = (opts) ->
    if opts.informative then inform "Digging the past for release information"
    prefix = opts.changelog_version_prefix
    changelog_folder = opts.changelog_folder
    travis = opts.has_travis
    output = opts.output

    fs.appendFileSync output, "## Release History\n"

    if opts.table_of_contents
      top = back_to_top(travis)
      fs.appendFileSync output, "#{top}\n"
    fs.appendFileSync output, "\nYou can find [all the changelogs here](/#{changelog_folder}).\n\n"
    latest = get_latest_changelog opts
    latest_file = changelog_folder + "/" + latest

    # let's get the version number from file v0.1.2.md, we just want 0.1.2
    
    latest_extension = get_file_extension latest
    # lets say extension is .md
    # then we omit `md` (latest_extension.length) then `.` (-1)
    latest_version = latest.slice(prefix.length, - latest_extension.length - 1)

    fs.appendFileSync output, "### Latest changelog is for [#{latest}](/#{latest_file}):\n\n"
    unless grunt.file.exists latest_file
      grunt.fail.fatal "Changelog file \"" + latest_file + "\" not found."
    else
      fs.appendFileSync output, grunt.file.read latest_file 
      fs.appendFileSync output, "\n"


  generate_footer = (opts) ->
    if opts.informative then inform "Adding the generation message, thank you"
    output = opts.output
    date = new Date();
    str = "\n\n--------\n<small>_This readme has been automatically generated by [readme generator](https://github.com/aponxi/grunt-readme-generator) on #{date}._</small>"
    fs.appendFileSync output, str


  grunt.registerMultiTask "readme_generator", "Generate Readme File", ->
    
    # Merge task-specific and/or target-specific options with these defaults.
    options = @options(
      # the folder where readme partial files are located
      readme_folder: "readme" 
      # where readme file should be generated in respect to Gruntfile location
      output: "README.md" 

      # generate table of contents
      table_of_contents: on
      # Sometimes I like adding quicklinks on the top in table of contents. Table of contents (TOC) must be enabled for this option to matter
      toc_extra_links: [] 

      # generates automatic changelog
      generate_changelog: on 
      # where changelog files are located
      changelog_folder: "changelogs" 
      # under changelog folder, there are files like v0.1.0.md if the prefix is "V"
      changelog_version_prefix: "v" 
      # I like my legal stuff at the bottom of the readme and release history before that
      changelog_insert_before: "legal.md" 
      
      # I like some ascii art on the top of the readme
      banner: null 

      # I use travis a lot and want to have the travis image generated on the top
      has_travis: on 
      # this is mainly for travis link
      github_username: "aponxi" 

      # generates automatic footer that tells the time it was generated using this task
      generate_footer: on 
      
      # generates automatic title from package name and description
      generate_title: on 
      # by default we get it from the package.json
      package_name : "" 
      # by default we get it from package.json
      package_desc : "" 
      
      # tell the people what's going on (verbose)
      informative : yes 
    )
    # lets clean up the output readme
    grunt.file.write options.output, ""


    files = @data.order
    # generate banner
    if options.banner?
      generate_banner options
    # generate title and description
    if options.generate_title then generate_title options

    if options.table_of_contents then generate_TOC files, options

    changelog_inserted = no

    # Iterate over all specified file groups.
    for file, title of files
      # console.log "file: ", file
      # console.log "title: ", title
      if file is options.changelog_insert_before and options.generate_changelog
        # add release history
        generate_release_history options
      append options, file, title

    # what if changelog wasn't inserted?
    if options.generate_changelog and not changelog_inserted
      # lets insert it at the end
      generate_release_history options

    # after writing all the contents 
    # add footer
    if options.generate_footer then generate_footer options
    
    # Print a success message.
    grunt.log.writeln "Your readme file \"" + options.output + "\" is ready!"
    grunt.log.ok()

