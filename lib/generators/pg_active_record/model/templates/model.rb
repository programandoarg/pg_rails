# frozen_string_literal: true

# generado con pg_rails

<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_record"

<% end -%>
<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
  audited
  <%- if options[:paranoia] -%>
  acts_as_paranoid without_default_scope: true
  <%- end -%>
  <%- if options[:discard] -%>
  include Discard::Model
  <%- end -%>
  <%- if attributes.any?(&:reference?) -%>

    <%- attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %><%= ', optional: true' unless attribute.required? %><%= ", class_name: '#{attribute.clase_con_modulo}'" if attribute.tiene_nombre_de_clase_explicito? %>
    <%- end -%>
  <%- end -%>
  <%- if options[:trackeo_de_usuarios] -%>

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'
  <%- end -%>
  <%- if attributes.any?(&:es_enum?) -%>

    <%- attributes.select(&:es_enum?).each do |attribute| -%>
  enumerize :<%= attribute.name %>, in: { completar: 0, los: 1, valores: 2 }
    <%- end -%>
  <%- end -%>
  <%- if attributes.any?(&:required?) -%>

  validates <%= attributes.select(&:required?).map { |at| ":#{at.name}" }.join(', ') %>, presence: true
  <%- end -%>
  <%- attributes.select(&:token?).each do |attribute| -%>
  has_secure_token<% if attribute.name != "token" %> :<%= attribute.name %><% end %>
  <%- end -%>
  <%- if attributes.any?(&:password_digest?) -%>
  has_secure_password
  <%- end -%>
end
<% end -%>
