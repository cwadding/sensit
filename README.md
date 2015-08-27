# Sensit Server

## Dependencies

### Ruby version
Currently only tested with ruby MRI which is 2.1.0.

### ElasticSearch
On MacOSX (via homebrew)

	brew install elasticsearch

Make sure ElasticSeach is running with 

	elasticsearch -f -D es.config=/usr/local/opt/elasticsearch/config/elasticsearch.yml

### PostgreSQL
On MacOSX (via homebrew)

	brew install postgresql
	initdb /usr/local/var/postgres -E utf8
	pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start



#### Database creation

	1. edit the username and password credentials in config/database.yml
	2. `rake db:create:all`

#### Database initialization
	1. Run the database migrations with rake db:migrate
	2. Seed the database with CNG data using rake db:seed

## Deployment
There is currently a running instance on heroku as a demo at https://sensit.herokuapp.com/.
There is also an instance of node-red with some sensit plugins for importing data into the server https://sensit-red.herokuapp.com/.

To deploy your own fork on to Heroku
	```
	heroku create my-sensit
	git push heroku master
	heroku run rake db:migrate
	heroku run rake db:seed
	```

## API Documentaion

[http://docs.sensit.apiary.io/](http://docs.sensit.apiary.io/)

## Client Libraries

node
[https://github.com/cwadding/sensit-node](https://github.com/cwadding/sensit-node)
or `npm install sensit-client`

ruby
[https://github.com/cwadding/sensit-ruby](https://github.com/cwadding/sensit-ruby)
or `gem install sensit-client`

python
[https://github.com/cwadding/sensit-python](https://github.com/cwadding/sensit-python)
`pip install sensit-client` (a bit outdated though)

php
[https://github.com/cwadding/sensit-php](https://github.com/cwadding/sensit-php)


## Contributing

Sensit is organized into several rails engines to make the code more modular. Every major add-on feature is intended to be it's own gem while the core functionality is in the core gem (sensit_core). The UI gems are separated from the API gems.

The main data abstractions are as follows:

* User: This is the master account with which all topics and applications are linked to. An elasticsearch index is created for each user and each topic has its own type within that index.

* Topic: A topic is root name which data is attached to. It is the equivalent of a source in searchlight or a table.

* Field: A topic has many fields and a field defines the column names and the datatypes. It is similar to columninfo and also stores the datatype

* Feed: A topic also has many feeds which represents an event or a row of data at a particular time. The data in feed correspond to fields and their datatypes. Feed data is stored in elasticsearch while all other data is stored in a relational database.

### How to run the test suite
Running all of the tests from the root directory is still a work in progress but you can currently run the tests in each of the directories of the individual components
