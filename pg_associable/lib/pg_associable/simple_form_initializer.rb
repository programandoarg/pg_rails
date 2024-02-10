SimpleForm.setup do |config|
  config.wrappers :pg_associable, tag: 'div', class: 'pg_associable mb-3', html: { data: { controller: 'asociable', 'asociable-modal-outlet': '.modal' } },
                                  error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'form-label'
    b.use :hidden_input
    b.wrapper tag: 'div', class: 'position-relative' do |ba|
      ba.use :input, class: 'form-control', disabled: true, placeholder: 'Clic para seleccionar...',
                     error_class: 'is-invalid'
      ba.use :pencil
      ba.use :modal_link
      ba.use :limpiar
    end
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
    b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  config.wrappers :pg_associable_inline, tag: 'div', class: 'pg_associable_inline mb-3', html: { data: { controller: 'asociable_inline' } },
                                         error_class: 'form-group-invalid', valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'form-label'
    b.use :hidden_input
    b.wrapper tag: 'div', class: 'search-box position-relative' do |ba|
      ba.use :search_form, error_class: 'is-invalid'
      ba.use :limpiar
      ba.use :pencil
      # ba.use :input, class: 'form-control', placeholder: 'Buscar...'
    end
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
    b.use :hint, wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end
end
