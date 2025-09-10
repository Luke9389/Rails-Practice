# README

This is a barebones Rails app, and it is meant to ensure you have a working environment to do the Splitwise take-home project!

You should verify that you can do the following:
- Install gems and setup your database 
- Run tests
- Run a server process and view a webpage

### Install gems and setup your database 

To install gems and setup your database, please run:
- bin/setup

Your output should look something like:
```
$ bin/setup
== Installing dependencies ==
The Gemfile's dependencies are satisfied

== Preparing database ==
== 20230120173154 CreateTests: migrating ======================================
-- create_table(:tests)
   -> 0.0007s
== 20230120173154 CreateTests: migrated (0.0007s) =============================

== 20230120173154 CreateTests: migrating ======================================
-- create_table(:tests)
   -> 0.0006s
== 20230120173154 CreateTests: migrated (0.0006s) =============================

== Removing old logs and tempfiles ==

== Restarting application server ==
```
### Run tests

To run tests, please run:
- bin/rails test
OR
- bin/rails spec
Your output should look something like:
```
$ bin/rails test

........

Finished in 0.064502s, 124.0272 runs/s, 155.0340 assertions/s.
8 runs, 10 assertions, 0 failures, 0 errors, 0 skips
```
OR
```
$ bin/rails spec
.............

Finished in 0.03934 seconds (files took 0.7349 seconds to load)
27 examples, 0 failures, 14 pending
```
### View a web page

Run the following:
```
bin/rails server --daemon
open http://127.0.0.1:3000/tests  
```
You should have opened a browser and being looking at a 'Tests' index page

Run the following to stop the server:
```
kill $(cat tmp/pids/server.pid)
```

### Troubleshooting: 

`bin/setup` is very likely to not work on first try. The most common problem is
that either ruby is not installed in your machine, or you don't have the correct
ruby version for the project.

There're various ways to install ruby in your machine. Check out the [official documentation for installing Ruby](https://www.ruby-lang.org/en/documentation/installation/). If you are using Windows, check out [this guide](https://gorails.com/setup/windows/10#ruby). If you're using MacOS and have `brew` installed, we recommend [installing via Brew](https://formulae.brew.sh/formula/ruby#default)

If you would like to learn more about setting up Ruby on Rails, please follow the guide here: https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails

If you have any questions, please let us know!
