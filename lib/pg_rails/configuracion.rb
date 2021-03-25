module PgRails
  class Configuracion
    attr_accessor :sistema_iconos
    attr_accessor :clase_botones_chicos
    attr_accessor :boton_destroy
    attr_accessor :boton_edit
    attr_accessor :boton_show
    attr_accessor :boton_light
    attr_accessor :icono_destroy
    attr_accessor :icono_edit
    attr_accessor :icono_show
    attr_accessor :boton_export
    attr_accessor :bootstrap_version

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
