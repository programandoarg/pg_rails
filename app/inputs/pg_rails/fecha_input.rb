# frozen_string_literal: true

module PgRails
  class FechaInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options = nil)
      # esto es porque si no Rails llama a value_before_type_cast
      value = object.public_send(attribute_name)
      @input_type = 'text'

      options = merge_wrapper_options({ value: value, class: 'datefield', autocomplete: 'off' },
                                      wrapper_options)
      super(options)
    end
  end
end
