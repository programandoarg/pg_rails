# frozen_string_literal: true

module PgRails
  class BaseDecorator < Draper::Decorator
    include ActionView::Helpers
    include PrintHelper
    include Pundit

    delegate_all

    def as_json(options = {})
      object.as_json.tap { |o| o[:to_s] = self.to_s }
    end

    def method_missing(m, *args, &block)
      valor = self.object.attributes[m.to_s]
      return super unless valor.present?
      if valor.class == Date
        dmy(valor)
      # elsif valor.class == ActiveSupport::TimeWithZone
      #   dmy_time(valor)
      else
        super
      end
    end

    def destroy_link(message = '¿Estás seguro?')
      return unless Pundit.policy!(helpers.current_user, object).destroy?
      helpers.content_tag :span, rel: :tooltip, title: 'Eliminar' do
        helpers.link_to object_url, data: { confirm: message }, method: :delete, class: "btn #{_config.clase_botones_chicos} btn-#{_config.boton_destroy}" do
          helpers.content_tag :span, nil, class: "#{clase_icono(_config.icono_destroy)}"
        end
      end
    end

    def edit_link(texto = '')
      return unless Pundit.policy!(helpers.current_user, object).edit?
      helpers.content_tag :span, rel: :tooltip, title: 'Editar' do
        helpers.link_to edit_object_url, class: "btn #{_config.clase_botones_chicos} btn-#{_config.boton_edit}" do
          helpers.content_tag(:span, nil, class: "#{clase_icono(_config.icono_edit)}") + texto
        end
      end
    end

    def show_link(texto = '')
      return unless Pundit.policy!(helpers.current_user, object).show?
      helpers.content_tag :span, rel: :tooltip, title: 'Ver' do
        helpers.link_to object_url, class: "btn #{_config.clase_botones_chicos} btn-#{_config.boton_show}" do
          helpers.content_tag(:span, nil, class: "#{clase_icono(_config.icono_show)}") + texto
        end
      end
    end

    def export_link(data, texto = '')
      return unless Pundit.policy!(helpers.current_user, object).export?
      helpers.content_tag :span, rel: :tooltip, title: 'Exportar' do
        helpers.content_tag :button, class: "btn #{_config.clase_botones_chicos} btn-#{_config.boton_export} exportar", data: {url: data} do
          helpers.content_tag(:span, nil, class: "fa fa-list") + ' ' + texto
        end
      end
    end

    def new_link
      return unless Pundit.policy!(helpers.current_user, object).new?
      helpers.content_tag :span, rel: :tooltip, title: 'Crear' do
        helpers.link_to new_object_url, class: "btn #{_config.clase_botones_chicos} btn-primary" do
          helpers.content_tag( :span, nil, class: "#{clase_icono('plus')}") + " Crear #{object.class.nombre_singular.downcase}"
        end
      end
    end

    def edit_object_url
      helpers.url_for([:edit, object])
    end

    def new_object_url
      helpers.url_for(object.class) + '/new'
    end

    def object_url
      helpers.url_for(object)
    end

    private

      def _config
        PgRails.configuracion
      end

      def clase_icono(icono)
        "#{_config.sistema_iconos} #{_config.sistema_iconos}-#{icono}"
      end
  end
end
