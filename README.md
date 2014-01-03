# Sensit

Node: The document root. It is the equivalent of database
Topic: The equivalent of a Table in a database
Field: The columns in the table
Feed: A row of data at a particular time
Data: A single key value pair of data with the key being the same as one of its parents fields and the value being the corresponding correct datatype

## Installation

Add this line to your application's Gemfile:

    gem 'sensit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sensit

## Usage

Check'N'Go

Seed the database

Searching through the API

Generate Reports

View reports

View Transactions corresponding to video

## Building the demo

cd demo
bundle install
rails g sensit
bundle exec rake db:migrate
rails s

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
