module PgRails
  module FormHelper
    def pg_form_for(object, *args, &block)
      options = args.extract_options!
      to_merge = { builder: PgFormBuilder, html: { class: 'pg-form'} }
      simple_form_for(object, *(args << options.merge(to_merge)), &block)
    end
  end
end
