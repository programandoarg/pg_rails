# PgRails
Short description and motivation.

[![CircleCI](https://circleci.com/gh/programandoarg/pg_rails.svg?style=shield)](https://circleci.com/gh/programandoarg/pg_rails)


## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'pg_rails'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install pg_rails
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


rails g pg_scaffold CategoriaDeCosa nombre:string{required} "tipo:integer{enum,required}" fecha:date tiempo:datetime --paranoia
rails g pg_scaffold Cosa nombre:string{required} "tipo:integer{enum,required}" categoria_de_cosa:references{required} --paranoia