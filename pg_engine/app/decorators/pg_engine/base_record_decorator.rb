# frozen_string_literal: true

module PgEngine
  class BaseRecordDecorator < Draper::Decorator
    include ActionView::Helpers
    include PrintHelper
    include FormHelper
    include RouteHelper
    include Pundit::Authorization

    attr_accessor :output_buffer

    delegate_all

    # Polemic, draper lo implementa con el propio decorator, pero necesito
    # que sea el ActiveRecord para que funcione el dom_id
    def to_model
      object
    end

    def as_json(options = {})
      object.as_json(options).tap { |o| o[:to_s] = to_s }
    end

    def to_s_short
      truncate(object.to_s)
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

    def destroy_link_redirect
      if helpers.using_modal?
        destroy_link
      else
        destroy_link(redirect_to: helpers.url_for(target_index))
      end
    end

    def destroy_link(confirm_text: '¿Confirmás que querés borrar el registro?', klass: 'btn-light', redirect_to: nil)
      return unless Pundit.policy!(Current.user, object).destroy?

      helpers.content_tag :span, rel: :tooltip, title: 'Eliminar' do
        helpers.link_to object_url + (redirect_to.present? ? "?redirect_to=#{redirect_to}" : ''),
                        data: { 'turbo-confirm': confirm_text, 'turbo-method': :delete },
                        class: "btn btn-sm #{klass}" do
          helpers.content_tag :span, nil, class: clase_icono('trash-fill')
        end
      end
    end

    def edit_link(text: ' Modificar', klass: 'btn-warning')
      return unless Pundit.policy!(Current.user, object).edit?

      modal = object.class.default_modal

      helpers.content_tag :span, rel: :tooltip, title: 'Modificar' do
        helpers.link_to edit_object_url,
                        class: "btn btn-sm #{klass}",
                        'data-turbo-frame': modal ? 'modal_content' : '_top',
                        'data-turbo-stream': modal do
          helpers.content_tag(:span, nil, class: clase_icono('pencil')) + text
        end
      end
    end

    def show_link(text: '', klass: 'btn-light')
      return unless Pundit.policy!(Current.user, object).show?

      modal = object.class.default_modal

      helpers.content_tag :span, rel: :tooltip, title: 'Ver' do
        helpers.link_to object_url,
                        class: "btn btn-sm #{klass}",
                        'data-turbo-frame': modal ? 'modal_content' : '_top',
                        'data-turbo-stream': modal do
          helpers.content_tag(:span, nil, class: clase_icono('eye-fill')) + text
        end
      end
    end

    def export_link(url, text: '', klass: 'btn-info')
      return unless Pundit.policy!(Current.user, object).export?

      helpers.content_tag :span, rel: :tooltip, title: 'Exportar en excel' do
        helpers.content_tag :a, target: '_blank',
                                class: "btn btn-sm #{klass}", href: url_change_format(url, 'xlsx') do
          "#{helpers.content_tag(:span, nil, class: clase_icono('file-earmark-excel-fill'))} #{text}".html_safe
        end
      end
    end

    def new_link(klass: 'btn-warning')
      return unless Pundit.policy!(Current.user, object).new?

      modal = object.class.default_modal

      helpers.content_tag :span, rel: :tooltip, title: submit_default_value do
        helpers.link_to(new_object_url,
                        class: "btn btn-sm #{klass}",
                        'data-turbo-frame': modal ? 'modal_content' : '_top',
                        'data-turbo-stream': modal) do
          helpers.content_tag(:span, nil,
                              class: clase_icono('plus').to_s) + "<span class='d-none d-sm-inline'> #{submit_default_value}</span>".html_safe
        end
      end
    end

    def edit_object_url(**args)
      helpers.url_for([:edit, target_object, **args].flatten)
    end

    def new_object_url
      helpers.url_for(target_new)
    end

    def object_url
      helpers.url_for(target_object)
    end

    def nested_record
      # TODO: esto es raro
      return if !Current.controller.respond_to?(:nested_record) ||
                Current.controller.nested_record.nil? ||
                Current.controller.nested_record.instance_of?(object.class)

      Current.controller.nested_record
    end

    def target_object
      [pg_namespace, nested_record, object].compact
    end

    def target_new
      mod_name_sing = object.class.model_name.singular.to_sym
      [:new, pg_namespace, nested_record, mod_name_sing]
    end

    def target_index
      pg_namespace.present? ? [pg_namespace, object.class] : object.class
    end

    # actionview-7.1.3.2/lib/action_view/helpers/form_helper.rb
    def submit_default_value
      key = :create
      model = object.model_name.human.downcase
      defaults = []
      defaults << :"helpers.submit.#{object.model_name.i18n_key}.#{key}"
      defaults << :"helpers.submit.#{key}"
      defaults << "#{key.to_s.humanize} #{model}"
      I18n.t(defaults.shift, model:, default: defaults)
    end

    private

    def clase_icono(icono)
      "bi bi-#{icono}"
    end
  end
end
