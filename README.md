# Chirpr

A simple Twitter-like Sinatra application for TorqueBox. 


## Configuration

Dependencies and all configuration is done in <tt>environment.rb</tt>. Your
database is also set up here. DataMapper will use postgresql by default. Tests use
the sqlite3-memory adapter (no configuration needed).

## Getting Started

You need TorqueBox. If you don't already have it installed, it's easy to do.
[Download](http://torquebox.org/download/) the latest and follow the
[instructions](http://torquebox.org/documentation/1.0.0.CR2/).

Once you've done that, be sure you have these environment variables.

    TORQUEBOX_HOME=/path/to/torquebox
    JBOSS_HOME=$TORQUEBOX_HOME/jboss
    JRUBY_HOME=$TORQUEBOX_HOME/jruby
    PATH=$JRUBY_HOME/bin:$PATH


### Install the gems

Chirpr (and TorqueBox) depend on a few gems. Install them.

    $ jruby -S bundle install # from chirpr root dir

### Setup the database

Run these commands as a user who has database CREATE priviledges for a local
PostgreSQL instance.  

    $ ./script/dbsetup install
    $ jruby -S rake db:migrate

### Deploy

You can scribble a TorqueBox deployment descriptor to
`$TORQUEBOX_HOME/apps/chirpr-knob.yml` by hand, or use the rake task.

    $ jruby -S rake torquebox:deploy

In either case you'll need to set your Twitter OAuth credentials since we use
that to authenticate users.  Add these to the environment section so that your
yaml looks something like this.

    application: 
      root: /path/to/chirpr
    web: 
      context: /
    
    environment:
      oauth_key: YOUR_KEY_FROM_TWITTER
      oauth_secret: YOUR_SECRET_FROM_TWITTER

If you've done all of that, you're good to go. To run chirpr in development 
mode, issue the following command.
  
    $ jruby -S rake torquebox:run


## TODO

  - Follow and unfollow 
  - Download and store a user's twitter profile image locally/cloudly when the
    Profile is created.  On subsequent logins, check the response from twitter
    for the latest profile image url and compare. If it's changed, update the
    local image.
  - Styling, styling, styling
  - Other things I haven't thought of. Or have thought of and forgotten about.
