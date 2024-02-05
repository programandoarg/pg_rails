# frozen_string_literal: true

module PgRails
  class Configuracion
    attr_accessor :sistema_iconos, :clase_botones_chicos, :boton_destroy, :boton_edit,
                  :boton_show, :boton_light, :icono_destroy, :icono_edit, :icono_show, :boton_export, :bootstrap_version,
                  :current_user_method

    def initialize
      @sistema_iconos = 'bi'
      @clase_botones_chicos = 'btn-sm'
      @boton_destroy = 'light'
      @boton_export = 'warning'
      @boton_edit = 'light'
      @boton_show = 'light'
      @boton_light = 'light'
      @icono_destroy = 'trash-fill'
      @icono_edit = 'pencil'
      @icono_show = 'eye-fill'
      @bootstrap_version = 5
      @current_user_method = :current_user
    end
  end
end
