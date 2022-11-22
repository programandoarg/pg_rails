# frozen_string_literal: true

module PgRails
  class FechaInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options = nil)
      # esto es porque si no Rails llama a value_before_type_cast
      if object.is_a? Draper::Decorator
        # Salteo el decorator para que me tome la fecha con formato inglés
        value = object.object.public_send(attribute_name)
      else
        value = object.public_send(attribute_name)
      end
      @input_type = 'date'

      options = merge_wrapper_options({ value: value, class: '', autocomplete: 'off' },
                                      wrapper_options)
      super(options)
    end
  end
end
