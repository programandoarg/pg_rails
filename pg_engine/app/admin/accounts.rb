ActiveAdmin.register Account do
  permit_params :plan, :nombre

  index do
    selectable_column
    id_column
    column :plan
    column :nombre
    actions
  end

  filter :plan
  filter :nombre

  form do |f|
    f.inputs do
      f.input :plan
      f.input :nombre
    end
    f.actions
  end
end
