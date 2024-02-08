ActiveAdmin.register <%= class_name %> do
  permit_params <%= attributes_names.map { |a| ":#{a}" }.join(', ') %>

  index do
    selectable_column
    id_column<% attributes.each do |at| %>
    column :<%= at.name %><% end %>
    actions
  end
<% attributes.each do |at| %>
  filter :<%= at.name %><% end %>

  form do |f|
    f.inputs do<% attributes.each do |at| %>
      f.input :<%= at.name %><% end %>
    end
    f.actions
  end
end
