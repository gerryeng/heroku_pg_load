Heroku Postgres Database Loader
==============

A simple command line utility that downloads your Heroku Postgres live database and dumps it into a local database


## Installation

    gem install heroku_pg_loader

    # If you are using rbenv
    rbenv rehash


## How to Use

Go to the directory where your heroku app is at and run:

    heroku_pg_load


The utility will attempt to detect the heroku app and database settings from directory. Follow the prompts.

    $ cd my_heroku_project_directory
    $ heroku_pg_load

    Heroku App Detected: morning_star
    Heroku App Name: [morning_star]
    >

    Local Database Name:
    (WARNING: THIS DATABASE WILL BE ERASED) [my_dev_database]
    >

    Database Username: [db_developer]
    > db_developer

    Database Password: [75830]
    > 


    [Running] heroku pgbackups:capture --app morning_star --expire
    [Running] heroku pgbackups:url --app morning_star

    ...

Thats all.