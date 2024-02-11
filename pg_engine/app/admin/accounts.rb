ActiveAdmin.register Account do
  permit_params :plan, :nombre, :hashid

  index do
    selectable_column
    id_column
    column :plan
    column :nombre
    column :hashid
    actions
  end

  filter :plan
  filter :nombre
  filter :hashid

  form do |f|
    f.inputs do
      f.input :plan
      f.input :nombre
      f.input :hashid
    end
    f.actions
  end
end
