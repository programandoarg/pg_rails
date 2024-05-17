# frozen_string_literal: true

module PgEngine
  module FormHelper
    def pg_form_for(object, *args, &)
      resource = object
      if object.is_a? PgEngine::BaseRecordDecorator
        object = object.target_object
      elsif object.is_a?(PgEngine::BaseRecord) &&
            object.decorator_class.present? &&
            object.decorator_class < PgEngine::BaseRecordDecorator
        object = object.decorate.target_object
      end
      # byebug
      options = args.extract_options!

      options[:builder] = PgFormBuilder
      options[:html] ||= {}
      options[:html][:class] = if options[:html].key?(:class)
                                 ['pg-form', options[:html][:class]].compact
                               else
                                 'pg-form'
                               end

      if resource.errors.any?
        options[:html][:data] ||= {}
        options[:html][:data][:errors] = resource.errors.details.to_json
      end

      simple_form_for(object, *(args << options), &)
    end

    def url_change_format(url, formato)
      uri = URI.parse(url)
      uri.path = "#{uri.path}.#{formato}"
      uri.to_s
    end

    # This method creates a link with `data-id` `data-fields` attributes.
    # These attributes are used to create new instances of the nested fields through Javascript.
    def link_to_add_fields(name, form, association, required: false, view_path: nil)
      # view_path is required when rendering outside a controller flow

      # Takes an object (@person) and creates a new instance of its associated model (:addresses)
      # To better understand, run the following in your terminal:
      # rails c --sandbox
      # @person = Person.new
      # new_object = @person.send(:addresses).klass.new
      new_object = form.object.send(association).klass.new

      # Saves the unique ID of the object into a variable.
      # This is needed to ensure the key of the associated array is unique.
      # This is makes parsing the content in the `data-fields` attribute easier through Javascript.
      # We could use another method to achive this.
      id = new_object.object_id

      # https://api.rubyonrails.org/ fields_for(record_name, record_object = nil, fields_options = {}, &block)
      # record_name = :addresses
      # record_object = new_object
      # fields_options = { child_index: id }
      # child_index` is used to ensure the key of the associated array is unique,
      # and that it matched the value in the `data-id` attribute.
      # `person[addresses_attributes][child_index_value][_destroy]`
      fields =
        form.fields_for(association, new_object, child_index: id) do |builder|
          # `association.to_s.singularize + "_fields"` ends up evaluating to `address_fields`
          # The render function will then look for `views/people/_address_fields.html.erb`
          # The render function also needs to be passed the value of 'builder', because
          # `views/people/_address_fields.html.erb` needs this to render the form tags.
          render(view_path || "#{association.to_s.singularize}_fields", f: builder)
        end

      # This renders a simple link, but passes information into `data` attributes.
      # This info can be named anything we want, but in this case we chose `data-id:` and `data-fields:`.
      # The `id:` is from `new_object.object_id`.
      # The `fields:` are rendered from the `fields` blocks.
      # We use `gsub("\n", "")` to remove anywhite space from the rendered partial.
      # The `id:` value needs to match the value used in `child_index: id`.
      link_to(
        'javascript:void(0)',
        class: 'link-to-add',
        data: {
          controller: 'nested',
          action: 'nested#addItem',
          id:,
          required:,
          fields: fields.gsub("\n", '')
        }
      ) do
        # rubocop:disable Rails/OutputSafety
        "<i class=\"bi bi-plus-lg\"></i> #{name}".html_safe
        # rubocop:enable Rails/OutputSafety
      end
    end

    def link_to_remove(text = nil, &)
      if block_given?
        link_to('javascript:void(0)', class: 'link-to-remove text-danger-emphasis', title: 'Quitar',
                                      data: { controller: 'nested', action: 'nested#quitar' }, &)
      elsif text.present?
        link_to text, 'javascript:void(0)', class: 'link-to-remove text-danger-emphasis', title: 'Quitar',
                                            data: { controller: 'nested', action: 'nested#quitar' }
      else
        link_to 'javascript:void(0)', class: 'link-to-remove text-danger-emphasis', title: 'Quitar',
                                      data: { controller: 'nested', action: 'nested#quitar' } do
          '<i class="bi bi-x-lg"></i>'.html_safe
        end
      end
    end
  end
end
