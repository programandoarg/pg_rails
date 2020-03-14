module PgRails
  class AsociacionCreableInput < SimpleForm::Inputs::CollectionSelectInput
    include ActionView::Helpers::FormTagHelper

    def crear(wrapper_options = {})
      button_tag "Crear",
        class: "btn btn-#{PgRails.configuracion.boton_light} 
          #{PgRails.configuracion.clase_botones_chicos} crear_asociado",
        data: { url: options[:url] }, type: :button
    end
  end
end
