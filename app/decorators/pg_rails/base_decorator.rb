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
      if m.match(/(fecha|date)/) && self.object.attributes.keys.include?(m.to_s)
        value = self.object.public_send(m)
        if value.class == Date
          dmy(value)
        else
          super
        end
      else
        super
      end
    end

    def destroy_link(message = '¿Estás seguro?')
      return unless Pundit.policy!(helpers.current_user, object).destroy?
      helpers.content_tag :span, rel: :tooltip, title: 'Eliminar' do
        helpers.link_to object_url, data: { confirm: message }, remote: true, method: :delete, class: "btn #{_config.clase_botones_chicos} btn-#{_config.boton_destroy}" do
          helpers.content_tag :span, nil, class: "#{clase_icono(_config.icono_destroy)}"
        end
      end
    end

    def edit_link
      return unless Pundit.policy!(helpers.current_user, object).edit?
      helpers.content_tag :span, rel: :tooltip, title: 'Editar' do
        helpers.link_to edit_object_url, class: "btn #{_config.clase_botones_chicos} btn-#{_config.boton_edit}" do
          helpers.content_tag :span, nil, class: "#{clase_icono(_config.icono_edit)}"
        end
      end
    end

    def show_link
      return unless Pundit.policy!(helpers.current_user, object).show?
      helpers.content_tag :span, rel: :tooltip, title: 'Ver' do
        helpers.link_to object_url, class: "btn #{_config.clase_botones_chicos} btn-#{_config.boton_show}" do
          helpers.content_tag :span, nil, class: "#{clase_icono(_config.icono_show)}"
        end
      end
    end

    def edit_object_url
      helpers.url_for([:edit, object])
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
