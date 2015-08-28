# Sensit

Sensit was designed as a storage and monitoring server for the internet of things (IoT) which aims to offer similar functionality to a service like [Xively](https://xively.com/). However, Sensit can also serve as a greate solution for aggregating large amounts of tabular data such as transactions. Sensit provides an abstraction around [ElasticSearch](https://www.elastic.co/) with the added functionality of OAuth2 authentication and authorization allowing you to view reports on your incoming data. Sensit offers many ways for you to import your data. You can post a compressed or uncompressed spreadsheet such as a csv, xls, xlsx, or odsf file or you can simply send data via its REST API in JSON or XML format. Alternatively you can use stream your data in using a socket with TCP, MQTT, AMQP, XMPP, and other protocols that may be added in the future. As your data is being imported Sensit will analyze each line or Feed against a registered set of 'Percolator' queries to see if there are any matches. If a match exists then a notification can then be dispatched  through a HTTP, MQTT, Email, a Tweet or some other form of notification. These 'Percolator' queries act as a filter for your data allowing you to perform certain actions as a result of a 'rule' that you may create. 

As an example, you may have several sensors to monitor your garden such as the soil moisture. The data for the current value of the soil moisture will constantly be sent to Sensit to check if the soil moisture level is greater than some threshold. If the value were to fall below this threshold then the server can communicate with a watering device instructing the device to add water to the soil.


The main data abstractions are as follows:

* Topic: A topic is root name which data is attached to and acts as endpoint for a sensor to send data to. A single user can have as many as many topics as the wish.

* Field: A topic has many fields and a field defines the column names and the datatypes to create the elasticsearch mappings. Sensit offers a rich set of fieldtypes including: string, integer, boolean, float, datetime, timezone, uri, ip_address and lat_long. There is a plan to offer an even richer set of data types such as amounts, address, or a product code which Sensit can use to know the best way to index and a nalyze the incoming data. Having specific datatypes allows the data being imported to be mapped to the correct datatype. For example, a utc timestamp (1440731700) could be referred to as just an integer or datetime. Specifying that a particular field with a utc timestamp gets properly matched and indexed in elasticsearch as a datetime and not an integer. Sensit

* Feed: A topic also has many feeds which represents an event or a row of data at a particular time. The data in a feed corresponds to fields and their datatypes. Feed data is stored in elasticsearch while all other data is stored in a relational database.

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

## Code Coverage Reports

[Core API](http://cwadding.github.io/sensit/src/api/core/coverage/index.html#_AllFiles)
The Core API represents the main data abstractions around Topics, Feeds, Fields, Users and Authentication. It provides a basic REST API for your imported data.

[Reports API](http://cwadding.github.io/sensit/src/api/reports/coverage/index.html#_AllFiles)
The Reports API can be added to the core API to allow saving of specific [elasticsearch aggregation](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations.html) queries to a Topic. This makes for a more accessible way of reporting since the they can be refeered to by a single name and a simple GET request.

[Percolator API](http://cwadding.github.io/sensit/src/api/percolator/coverage/index.html#_AllFiles)
This Percolator API can be added to the core API to allow access to specific [elasticsearch percolator queries](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-percolate.html) but with the OAuth2 application permissions and partitioning per user.

[Subscriptions API](http://cwadding.github.io/sensit/src/api/subscriptions/coverage/index.html#_AllFiles)
The Subscriptions API allows you to import data via a socket rather than just throught the REST API provided by Core API. You can choose your protocol the server to connect to and the topic to listen on for incoming data.

[Publications API](http://cwadding.github.io/sensit/src/api/publications/coverage/index.html#_AllFiles)
The publications API allows you to broadcast data when a Percolator query is active. You can choose the protocol as well as the server to connect to and the topic name will be the name of your percolator query.

[Sensit Messenger gem](http://cwadding.github.io/sensit/src/api/messenger/coverage/index.html#_AllFiles)
This is a simple library which creates an abstraction for communication of various protocols that are used by the Subscriptions and Publications API.


### How to run the test suite
Running all of the tests from the root directory is still a work in progress but you can currently run the tests in each of the directories of the individual components
