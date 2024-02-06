# frozen_string_literal: true

module PgEngine
  class BaseDecorator < Draper::Decorator
    include ActionView::Helpers
    include PrintHelper
    include FormHelper
    include RouteHelper
    include Pundit::Authorization

    attr_accessor :output_buffer

    delegate_all

    def as_json(_options = {})
      object.as_json.tap { |o| o[:to_s] = to_s }
    end

    # def method_missing(method_name, *args, &block)
    #   valor = object.attributes[method_name.to_s]
    #   return super unless valor.present?

    #   if valor.instance_of?(Date)
    #     dmy(valor)
    #   # elsif valor.class == ActiveSupport::TimeWithZone
    #   #   dmy_time(valor)
    #   else
    #     super
    #   end
    # end

    def destroy_link(message = '¿Estás seguro?')
      return unless Pundit.policy!(helpers.send(PgEngine.configuracion.current_user_method), object).destroy?

      helpers.content_tag :span, rel: :tooltip, title: 'Eliminar' do
        helpers.link_to object_url, data: { 'turbo-confirm': message, 'turbo-method': :delete },
                                    class: "btn #{_config.clase_botones_chicos} btn-#{_config.boton_destroy}" do
          helpers.content_tag :span, nil, class: clase_icono(_config.icono_destroy).to_s
        end
      end
    end

    def edit_link(texto = '')
      return unless Pundit.policy!(helpers.send(PgEngine.configuracion.current_user_method), object).edit?

      helpers.content_tag :span, rel: :tooltip, title: 'Editar' do
        helpers.link_to edit_object_url, data: { turbo_frame: :main },
                                         class: "btn #{_config.clase_botones_chicos} btn-#{_config.boton_edit}" do
          helpers.content_tag(:span, nil, class: clase_icono(_config.icono_edit).to_s) + texto
        end
      end
    end

    def show_link(texto = '')
      return unless Pundit.policy!(helpers.send(PgEngine.configuracion.current_user_method), object).show?

      helpers.content_tag :span, rel: :tooltip, title: 'Ver' do
        helpers.link_to object_url, data: { turbo_frame: :main },
                                    class: "btn #{_config.clase_botones_chicos} btn-#{_config.boton_show}" do
          helpers.content_tag(:span, nil, class: clase_icono(_config.icono_show).to_s) + texto
        end
      end
    end

    def export_link(url, texto = '')
      return unless Pundit.policy!(helpers.send(PgEngine.configuracion.current_user_method), object).export?

      helpers.content_tag :span, rel: :tooltip, title: 'Exportar' do
        helpers.content_tag :a, target: '_blank',
                                class: "btn #{_config.clase_botones_chicos} btn-#{_config.boton_export}", href: url_change_format(url, 'xlsx') do
          "#{helpers.content_tag(:span, nil, class: clase_icono('file-earmark-excel-fill'))} #{texto}".html_safe
        end
      end
    end

    def new_link(options = {})
      return unless Pundit.policy!(helpers.send(PgEngine.configuracion.current_user_method), object).new?

      helpers.content_tag :span, rel: :tooltip, title: 'Crear' do
        helpers.link_to new_object_url, class: "btn #{_config.clase_botones_chicos} btn-primary",
                                        remote: options[:remote] do
          helpers.content_tag(:span, nil,
                              class: clase_icono('plus').to_s) + "<span class='d-none d-sm-inline'> Crear #{object.class.nombre_singular.downcase}</span>".html_safe
        end
      end
    end

    def edit_object_url
      helpers.url_for([:edit, target_object].flatten)
    end

    def new_object_url
      "#{helpers.url_for(target_index)}/new"
    end

    def object_url
      helpers.url_for(target_object)
    end

    def target_object
      pg_namespace.present? ? [pg_namespace, object] : object
    end

    def target_index
      pg_namespace.present? ? [pg_namespace, object.class] : object.class
    end

    private

    def _config
      PgEngine.configuracion
    end

    def clase_icono(icono)
      "#{_config.sistema_iconos} #{_config.sistema_iconos}-#{icono}"
    end
  end
end
