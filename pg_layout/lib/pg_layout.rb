# Para que la viewpath de pg_layout tenga precedencia sobre las de kaminari y devise
require 'kaminari'
require 'devise'
require 'devise-i18n'

require_relative 'pg_layout/engine'

module PgLayout
end
