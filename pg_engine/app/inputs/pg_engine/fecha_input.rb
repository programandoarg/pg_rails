# frozen_string_literal: true

module PgEngine
  class FechaInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options = nil)
      # esto es porque si no Rails llama a value_before_type_cast
      value = if object.is_a? Draper::Decorator
                # Salteo el decorator para que me tome la fecha con formato inglés
                object.object.public_send(attribute_name)
              else
                object.public_send(attribute_name)
              end
      @input_type = 'date'

      options = merge_wrapper_options({ value:, class: '', autocomplete: 'off' },
                                      wrapper_options)
      super(options)
    end
  end
end
