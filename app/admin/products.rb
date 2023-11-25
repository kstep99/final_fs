ActiveAdmin.register Product do
  # Permit all attributes for assignment, including multiple images
  permit_params :name, :description, :price, :quantity_available, :category_id, images: [], images_attributes: [:id, :_destroy]

  # Define the index page table columns
  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column :quantity_available
    column :category

    # Add a column for images
    column :images do |product|
      if product.images.attached?
        ul do
          product.images.limit(1).each do |img|
            li do
              image_tag img.variant(resize_to_limit: [100, 100]).processed
            end
          end
        end
      else
        'No image'
      end
    end

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
      f.input :quantity_available
      f.input :category, as: :select, collection: Category.all.collect { |c| [c.name, c.id] }
    end

    f.inputs 'Product Images (check the box beside image, to delete on update)' do
      # Display existing images with checkboxes for deletion
      if f.object.images.attached?
        f.object.images.each_with_index do |img, index|
          div class: 'image_with_checkbox' do
            # Display the image thumbnail
            span do
              image_tag img.variant(resize_to_limit: [100, 100]).processed
            end

            # Checkbox to mark the image for deletion
            span do
              label_tag "remove_image_#{img.id}", 'Delete'
              check_box_tag "remove_image[#{img.id}]"
            end
          end
        end
      end

      # Input for adding new images
      f.input :images, as: :file, input_html: { multiple: true }
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
      row :quantity_available
      row :images do |prod|
        ul do
          prod.images.each do |img|
            li do
              image_tag img.variant(resize_to_limit: [100, 100]).processed
            end
          end
        end
      end
    end

    active_admin_comments
  end

  # Customize the controller actions, specifically update
  controller do
    def update
      # Handle existing image deletion
      if params[:remove_image].present?
        params[:remove_image].each do |image_id, value|
          if value == '1'
            image = ActiveStorage::Attachment.find(image_id)
            image.purge_later if image.record_id == resource.id
          end
        end
      end

      # Attach new images if present
      resource.images.attach(params[:product][:images]) if params[:product][:images].present?

      # Proceed with the update
      params[:product].delete(:images)
      super
    end
  end

end
