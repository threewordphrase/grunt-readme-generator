In your project's Gruntfile, add a section named `readme_generator` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  pkg: grunt.file.readJSON('package.json'),
  readme_generator: {
    options: {
      // Task-specific options go here.
      // detailed explanation is under options
      readme_folder: "readme",
      output: "README.md",
      table_of_contents: true,
      toc_extra_links: [],
      generate_changelog: false,
      changelog_folder: "changelogs",
      changelog_version_prefix: "",
      changelog_insert_before: "",
      banner: null,
      has_travis: true,
      github_username: "aponxi",
      generate_footer: true,
      generate_title: true,
      package_name: "",
      package_desc: "",
      informative: true
    },
    order: {
      // Title of the piece and the file name goes here
      // like so
      "installation.md": "Installation",
      "usage.md": "Usage",
      "options.md": "Options",
      "example.md": "Example",
      "output.md": "Example Output",
      "building-and-testing.md": "Building and Testing",
      "legal.md": "Legal Mambo Jambo"
    },
  },
})
```

- You provide with markdown files and the titles in the `order` object which has the format of `file : title`
- It generates the readme by iterating through that array in the given order
- In the example `"building-and-testing.md": "Building and Testing"` it is going to create a section called `Building and Testing`, making it a title; then it will read `building-and-testing.md` file from the readme directory set in `readme_folder` option and insert it after the title. 
- Meaning that you shouldn't have titles in your seperate markdown files or in `building-and-testing.md` for the above example. They are automatically generated from the title.