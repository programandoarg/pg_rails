# PgRails
Short description and motivation.

[![CircleCI](https://circleci.com/gh/programandoarg/pg_rails.svg?style=shield)](https://circleci.com/gh/programandoarg/pg_rails)
[![Maintainability](https://api.codeclimate.com/v1/badges/2a3081a26ca2ab9feac6/maintainability)](https://codeclimate.com/github/programandoarg/pg_rails/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2a3081a26ca2ab9feac6/test_coverage)](https://codeclimate.com/github/programandoarg/pg_rails/test_coverage)

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

## Upgrading
#### Actualizar a version 0.2
  - `PgRails::Filtros.filtrar` no va más
  - FiltrosBuilder: attr_accessor :controller no está más
  -
    - def initialize(controller, clase_modelo, filtros_permitidos)
    + def initialize(opciones = {})
    + def opciones_generales(opciones = {})
  - 
    - def filtrar(query)
    + def filtrar(query, parametros = nil)

  - filtros_y_policy no va más
    + crear_filtros

  - por defecto aplica policy scope y without_deleted
