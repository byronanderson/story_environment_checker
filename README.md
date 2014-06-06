Pivotal Tracker Story Deployment Service
========================================

This project is meant to provide an HTTP interface to determine on which
environments a certain story has been deployed, using a copy of a git local to
the service instance.

These are the pre-requisites for running the server:

* Ruby 2.1
* Bundler
* A run of `bundle install`
* A local copy of the repository your environments are using to compare against
* configuration to point to this repository in `config.yml`, see the example in
  `config.yml.example`
* Ruby files inside the directory `environments` that append to the global
  variable `$environments` the environments that need to be 

To be a valid environment, the environment needs to have a '#name' and a
`#deployed_sha`

Once you have done this, run this command:

```sh
rackup config.ru
```

And your server will be availabley by default on the port 9292, you can see it by
