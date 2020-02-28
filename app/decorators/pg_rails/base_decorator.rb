# frozen_string_literal: true

module PgRails
  class BaseDecorator < Draper::Decorator
    include ActionView::Helpers
    include PrintHelper

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
      helpers.content_tag :span, rel: :tooltip, title: 'Eliminar' do
        helpers.link_to object_url, data: { confirm: message }, method: :delete, class: 'btn btn-sm btn-danger' do
          helpers.content_tag :span, nil, class: 'fa fa-trash'
        end
      end
    end

    def edit_link
      helpers.content_tag :span, rel: :tooltip, title: 'Editar' do
        helpers.link_to edit_object_url, class: 'btn btn-sm btn-info' do
          helpers.content_tag :span, nil, class: 'fa fa-edit'
        end
      end
    end

    def show_link
      helpers.content_tag :span, rel: :tooltip, title: 'Ver' do
        helpers.link_to object_url, class: 'btn btn-sm btn-primary' do
          helpers.content_tag :span, nil, class: 'fa fa-eye'
        end
      end
    end

    def edit_object_url
      helpers.url_for([:edit, object])
    end

    def object_url
      helpers.url_for(object)
    end
  end
end
