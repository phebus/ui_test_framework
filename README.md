# ui_test_framework
UI Automation Scripts

This repository is the skeleton for browser automation tests. It is a [Cucumber](https://cucumber.io/) driven, [Selenium Webdriver](http://www.seleniumhq.org/docs/03_webdriver.jsp) based framework
that utilizes the [PageObject gem](https://github.com/cheezy/page-object) as a DSL for Webdriver abstraction
and page object pattern enforcer.

## Prerequisites:

   The following prerequisites are suggested but not necessary in all
   cases. Mostly this describes the environment that this framework
   was developed in, but YMMV outside of this setup. We are open to
   any contribution to documenting or updating the framework for use 
   in other environments.
    
   * Ruby 3.1 - This latest update made some changes that are specific to Ruby
3.1+
   * OSX 12.6
   * [Homebrew](http://brew.sh/) - for installing the below
       * chromedriver - for chrome
       * geckodriver - for firefox testing
   * [RVM](https://rvm.io/) - for managing rubies (rbenv is fine too)
   * RubyMine - very useful for debugging but everyone has their favorite
                IDE (or they hate IDEs)
   

## To setup:
   `$ git clone https://github.com/phebus/ui_test_framework`
   
   `$ bundle install`
    
## To run: ##

#### Tests with tags. These are ORed so all tests with any of these tags will run
`rake TAGS=@tag1,@tag2,@tag3`

#### Tests with all tags specified. These are ANDed so only tests with all tags listed will run
`rake AND_TAGS=@tag1,@tag2,@tag3`

#### Specific feature file
`rake FEATURE=<path to feature file>/feature_file.feature`

#### Specific scenario in feature file
`rake FEATURE=<path to feature file>/feature_file.feature:<line number of scenario>`

#### Reports
There are a few ways reports can be built. The default `run` task automatically builds a report.
This will create the `test_report.html` file in the `output` directory. The `parallel` task (details below) also automatically
builds the report. You can also run the default run. Reports are generated with the [report_builder gem](https://github.com/rajatthareja/ReportBuilder)

#### Other environment variable options
* **BROWSER**=*browser name*

  `chrome`, `firefox`, `ie`, `edge`, `safari` (provided they are
  installed and have their corresponding drivers)

  Default is `chrome`

  NOTE: Development and testing is primarily done on the latest Chrome version. Other browsers and versions may
  act differently or fail completely. We are open to accepting changes that get others working as long as they don't
  significantly affect the tests with respect to how they perform in Chrome. More testing with other browsers would be
  greatly appreciated even.

    * **SITE**=*environment to run against*

      The `SITE` env var corresponds with the target environment you want to run
      your tests against. This is accomplished by creating a config file for the env at
      at the very least and if necessary you can create a directory with the same name
      to further break down the environment into smaller units (apps, sites, etc.). 
      
      These are controlled by the yaml files in `features/support/configs`. At the very minimum
      there needs to be a `global.yml`. This ideally would contain information for any app being 
      tested. As an example theres files here for a development, production, an qa environment. 
      Individual app configs belong in the `features/support/configs/<env>`
      Configs are loaded through the `EnvSettings` class by merging information from
      `global.yml`, `<env>.yml`, and all the app configs in the specific env folder.
      These parameters are made available through `EnvSettings.configs`,
      a `DeepStruct` of the environment config file.
      Used for describing predefined environment conditions (users,
      assets, etc.)

        * Example:
          To get the username and password for the example app in the qa environment 
          when your `SITE` env var is set to `qa`. 
          `features/support/config/qa/example.yml` 
          ```
          :login:
            :username: test_user
            :password: p4$$w0rd
          ```
          `EnvSettings.configs.example.login.username`
          `EnvSettings.configs.example.login.password`
        This allows you to have another `example.yml` in another environment with the same
        named config with different values, which allows you to run the same tests in either
        environment without changing the tests.

* **HEADLESS**=*true*

  Run in headless mode. Currently this is only supported for Chrome.

* **DEBUG**=*true*

  Set Selenium logging to debug mode. Debug notices will be sent to STDOUT

* **STEP**=*true*

  Pause execution after each step, press Enter to continue

#### Remote
This framework supports 2 remote grids, Zalenium (Selenium 3), and Selenium 4. 
In order to run against a remote grid you will need to set the `ZAL` or `SE4` env variable to `true`
and set the `HUB_ADDR` (without the `http://`) and the `HUB_PORT` env variables to point to the desired grid address.

Previously there was a class for Browserstack and I've experimented with Sauce and other vendor grids
so any of these are easily addable. 

#### Docker

You can build and run these tests in a Docker container. This is also the quickest way to get going.

To build:

`docker build -t <build_name> <path or url to repo>` Build the default container

Another way to run the tests is inside the container with headless Chrome. The image is built with chrome and
chromedriver installed. Setting the **`HEADLESS`** env variable to `true` will trigger this mode. This is
not to be used in conjunction with Zalenium testing. Also note that headless Chrome is still relatively new and
you may run into issues that you might not see running in regular Chrome or another browser.

Example:

`docker run -e HEADLESS=true -e TAGS=@manage_smoke -t <build_name>`

I will attempt to keep the container up to date with the latest chromedriver however it's possible you may want to build
it with a different version. You can rebuild it and pass a different version number like this:

`docker build --build-arg CD_VERSION=<chromedriver version> -t <build_name> <path or url to repo>`

#### Parallel Testing

There is a rake task to run parallel tests, `rake parallel`. By default this will launch a cucumber process per feature file per number
of cpus on the system it is running. You can override this by setting **NUM_PROCS** to the desired number of parallel
processes.
