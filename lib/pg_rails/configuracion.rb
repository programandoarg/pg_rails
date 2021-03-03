# frozen_string_literal: true

module PgRails
  class Configuracion
    attr_accessor :sistema_iconos, :clase_botones_chicos, :boton_destroy, :boton_edit,
                  :boton_show, :boton_light, :icono_destroy, :icono_edit, :icono_show, :boton_export, :bootstrap_version

    def initialize
      @sistema_iconos = 'fa'
      @clase_botones_chicos = 'btn-sm'
      @boton_destroy = 'danger'
      @boton_export = 'warning'
      @boton_edit = 'info'
      @boton_show = 'primary'
      @boton_light = 'light'
      @icono_destroy = 'trash'
      @icono_edit = 'edit'
      @icono_show = 'eye'
      @bootstrap_version = 4
    end
  end
end
