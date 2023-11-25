ActiveAdmin.register Province do
  permit_params :name, :tax_rate

  index do
    selectable_column
    id_column
    column :name
    column :tax_rate
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :tax_rate
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :tax_rate
    end
  end
end
