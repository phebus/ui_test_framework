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

#### 1. Tests with tags. These are ORed so all tests with any of these tags will run
   `$ rake TAGS=@tag1,@tag2,@tag3`

#### 2. Tests with all tags specified. These are ANDed so only tests with all tags listed will run
   `$ rake AND_TAGS=@tag1,@tag2,@tag3`
   
#### 3. Specific feature file
   `$ rake FEATURE=<path to feature file>/feature_file.feature`
        
#### 4. Specific scenario in a feature file
   `$ rake FEATURE=<path to feature file>/feature_file.feature:<scenario line number>`
#### 5. Other environment variable options 
1. **BROWSER**=*browser name* 
    
    chrome, firefox, ie, opera, safari, phantomjs (provided they are 
    installed or available on Browserstack or like service)
    
    Default is chrome
    
2. **SITE**=*environment to run against*

    Right now 'dev' and 'staging' are the only environments to run in.
    These are controlled by the yaml files in features/support/configs.
    This will load the global.yml and merge it with the named env.
    These parameters are made available through EnvSettings.configs,
    a DeepStruct of the environment config file.
    Used for describing predefined environment conditions (users,
    assets, etc.)
    
3. **BS**=*true* **GRID**=*true*

    Tests will run on Browserstack. Requires **BS_NAME** and **BS_KEY** to 
    also be set to your user name and api key for Browserstack.
    Also, **OS**, **OS_VERSION**, **DEVICE**, **BUILD_NAME**, **PROJECT_NAME**, 
    and **BROWSER_VERSION** are only applicable when running on Browserstack. 
    See [Browserstack Capabilities](https://www.browserstack.com/automate/capabilities) for acceptable values.
    Also see [Browserstack Browsers and Platforms](https://www.browserstack.com/list-of-browsers-and-platforms?product=automate) for list of browsers, platforms, 
    and devices offered. It can be run on mobile emulators by sending **BROWSER**=*ipad* | *iphone* | *android* and
    **DEVICE**=*something from the list of devices on the above page* (if not included Browserstack will choose for 
    you.
    
    
#### 5. Docker

You can build and run these tests in a Docker container. By itself this doesn't achieve much except the ability to run 
tests without having to worry about prerequisites on your machine (other than Docker of course). This was added 
primarily to be used in a Jenkins CI environment to run against Browserstack (or other 3rd party Selenium vendor), 
however you can still override these things.


#### 6. Parallel Testing

There is a rake task to run parallel tests. By default this will launch a cucumber process per feature file per number
of cpus on the system it is running. You can override this by setting **NUM_PROCS** to the desired number of parallel
processes.

#### 7. Parallel Testing with Docker Compose

There is a docker-compose.yml file which defines a selenium hub and nodes, and the browser tests to run in parallel.
This is still a bit of a work in progress but there are a few ways this can be called right now, each with varying
levels of utility. The best way to see things working is:

`$ docker-compose up -d chrome && docker-compose scale chrome=8`

`$ docker-compose up ui_test_framework`

As with regular runs you can override environment variables to set your browser, version, to run on Browserstack, etc.

The next steps with this is to get reporting working.
