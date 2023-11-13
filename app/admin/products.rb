ActiveAdmin.register Product do
  # Permit all attributes for assignment
  permit_params :name, :description, :price, :category_id

  # Define the index page table columns
  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column :category
    actions
  end

  # Define filters for the index page sidebar
  filter :name
  filter :price
  filter :category

  # Define the form for creating/editing a product
  form do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :category, as: :select, collection: Category.all.collect { |c| [c.name, c.id] }
    end
    f.actions
  end

  # Define the show page
  show do |product|
    attributes_table do
      row :name
      row :description
      row :price
      row :category
      # Add other product attributes here as needed
    end
    active_admin_comments
  end

  # Customize the controller actions as needed
  controller do
    # Define custom create, update, or delete logic here if needed
  end
end
