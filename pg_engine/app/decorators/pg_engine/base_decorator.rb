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

    def as_json(options = {})
      object.as_json(options).tap { |o| o[:to_s] = to_s }
    end

    # rubocop:disable Style/MissingRespondToMissing
    def method_missing(method_name, *args, &)
      valor = object.attributes[method_name.to_s]
      return super if valor.blank?

      if valor.instance_of?(Date)
        dmy(valor)
      elsif valor.instance_of?(ActiveSupport::TimeWithZone)
        dmy_time(valor)
      else
        super
      end
    end
    # rubocop:enable Style/MissingRespondToMissing

    def destroy_link(confirm_text: '¿Estás seguro?', klass: 'btn-light')
      return unless Pundit.policy!(helpers.send(PgEngine.configuracion.current_user_method), object).destroy?

      helpers.content_tag :span, rel: :tooltip, title: 'Eliminar' do
        helpers.link_to object_url, data: { 'turbo-confirm': confirm_text, 'turbo-method': :delete },
                                    class: "btn btn-sm #{klass}" do
          helpers.content_tag :span, nil, class: clase_icono('trash-fill')
        end
      end
    end

    def edit_link(text: '', klass: 'btn-light')
      return unless Pundit.policy!(helpers.send(PgEngine.configuracion.current_user_method), object).edit?

      helpers.content_tag :span, rel: :tooltip, title: 'Editar' do
        helpers.link_to edit_object_url, data: { turbo_frame: :main },
                                         class: "btn btn-sm #{klass}" do
          helpers.content_tag(:span, nil, class: clase_icono('pencil')) + text
        end
      end
    end

    def show_link(text: '', klass: 'btn-light')
      return unless Pundit.policy!(helpers.send(PgEngine.configuracion.current_user_method), object).show?

      helpers.content_tag :span, rel: :tooltip, title: 'Ver' do
        helpers.link_to object_url, data: { turbo_frame: :main },
                                    class: "btn btn-sm #{klass}" do
          helpers.content_tag(:span, nil, class: clase_icono('eye-fill')) + text
        end
      end
    end

    def export_link(url, text: '', klass: 'btn-info')
      return unless Pundit.policy!(helpers.current_user, object).export?

      helpers.content_tag :span, rel: :tooltip, title: 'Exportar en excel' do
        helpers.content_tag :a, target: '_blank',
                                class: "btn btn-sm #{klass}", href: url_change_format(url, 'xlsx') do
          "#{helpers.content_tag(:span, nil, class: clase_icono('file-earmark-excel-fill'))} #{text}".html_safe
        end
      end
    end

    def new_link(remote: nil, klass: 'btn-warning')
      return unless Pundit.policy!(helpers.send(PgEngine.configuracion.current_user_method), object).new?

      word_to_create = I18n.t("form.#{object.class.nombre_singular.downcase}.create", default: :'form.create')

      full_text = "#{word_to_create} #{object.class.nombre_singular.downcase}"

      helpers.content_tag :span, rel: :tooltip, title: word_to_create do
        helpers.link_to(new_object_url, class: "btn btn-sm #{klass}",
                                        remote:) do
          helpers.content_tag(:span, nil,
                              class: clase_icono('plus').to_s) + "<span class='d-none d-sm-inline'> #{full_text}</span>".html_safe
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

    def clase_icono(icono)
      "bi bi-#{icono}"
    end
  end
end
