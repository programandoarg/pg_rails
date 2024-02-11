[![CircleCI](https://circleci.com/gh/programandoarg/pg_rails.svg?style=shield)](https://circleci.com/gh/programandoarg/pg_rails)
[![Maintainability](https://api.codeclimate.com/v1/badges/2a3081a26ca2ab9feac6/maintainability)](https://codeclimate.com/github/programandoarg/pg_rails/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2a3081a26ca2ab9feac6/test_coverage)](https://codeclimate.com/github/programandoarg/pg_rails/test_coverage)
# PgRails
Plugin de Programando para Rails

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'pg_rails', git: 'https://github.com/programandoarg/pg_rails.git', ref: '<commit hash>'
```

And then execute:
```bash
$ bundle
```
## Uso

### Asociación creable

```
f.asociacion_creable(campo, index_url, new_url, opciones)
```

Opciones:
- label: Texto para la label o false para que no haya label

Ejemplo:
```
= pg_form_for(@cosa) do |f|
  = f.asociacion_creable(:categoria_de_cosa, categoria_de_cosas_url, new_categoria_de_cosa_url, crear_asociado: true)
```

## Contributing

### Setup

1. Ingresar a la consola de postgres:
```
sudo -u postgres psql template1
```
2. Crear el rol
```
create role pgrails password 'pgrails' login superuser;
```

3. Ejecutar el script `bin/setup`. This script will:

* Check you have the required Ruby version
* Install dependencies using Bundler
* Create a `.env.development` file
* Create, migrate, and seed the database

### Testear y ejecutar

1. Instalar overcommit: `gem install overcommit`
2. Correr los linters con `overcommit -r`
3. Correr los tests con `bundle exec rspec`
4. Instalar foreman: `gem install foreman`
5. `cd spec/dummy`
6. `foreman start`

Acceder a la app en <http://localhost:3000/>.

### Regenerar modelos dummy

  cd spec/dummy

1. `bundle exec rails d pg_scaffold Admin/Cosa`
2. `bundle exec rails d pg_scaffold Admin/CategoriaDeCosa`
3. Borrar policies
4. `bundle exec rails g pg_scaffold Admin/CategoriaDeCosa nombre:string{required} "tipo:integer{enum,required}" fecha:date tiempo:datetime --model-name=CategoriaDeCosa --discard --activeadmin`
5. `bundle exec rails g pg_scaffold Admin/Cosa  nombre:string{required} "tipo:integer{enum,required}" categoria_de_cosa:references{required}  --model-name=Cosa --discard --activeadmin`
6. Setup asociacion creable en cosas/_form



be rake app:pg_engine_engine:install:migrations

be rails pg_engine_engine:install:migrations


    "build": "esbuild pg_rails/js/index.js --bundle --sourcemap --format=esm --outdir=pg_rails/builds --public-path=/assets",
    "build:css:compile": "sass ./pg_rails/scss/pg_rails.scss:./pg_rails/builds/application.css --no-source-map --load-path=node_modules",
    "build:css:prefix": "postcss ./pg_rails/builds/application.css --use=autoprefixer --output=./pg_rails/builds/application.css",
    "build:css": "yarn build:css:compile && yarn build:css:prefix",

