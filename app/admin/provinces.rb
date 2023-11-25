ActiveAdmin.register Province do
  # Update permit_params to include the new columns and remove tax_rate
  permit_params :name, :gst, :pst, :hst

  index do
    selectable_column
    id_column
    column :name
    column :gst
    column :pst
    column :hst
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :gst
      f.input :pst
      f.input :hst
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :gst
      row :pst
      row :hst
    end
  end
end
