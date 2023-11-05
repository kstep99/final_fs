ActiveAdmin.register Customer do
  # Permitting the appropriate parameters
  permit_params :full_name, :phone_number, :email, :notes, :image, :password, :password_confirmation

  # Filters
  filter :full_name
  filter :phone_number
  filter :email
  # Add any other filters you want here but exclude the image filter if it's causing problems

  # Formtastic gem (used by ActiveAdmin) for form fields
  form do |f|
    # This will automatically handle displaying the errors correctly
    f.semantic_errors *f.object.errors.full_messages

    f.inputs 'Customer Details' do
      f.input :full_name
      f.input :phone_number
      f.input :email
      f.input :notes
      f.input :image, as: :file

      # Include password fields if the object is new or password is present
      if f.object.new_record? || f.object.password.present?
        f.input :password
        f.input :password_confirmation
      end
    end

    f.actions
  end

  # Displaying the image in the show view
  show do |customer|
    attributes_table do
      row :full_name
      row :phone_number
      row :email
      row :notes
      row :image do |cust|
        if cust.image.attached?
          image_tag url_for(cust.image), width: '50%'
        else
          text_node 'No image attached'
        end
      end
    end
  end

  # Customizing the index table
  index do
    selectable_column
    id_column
    column :full_name
    column :phone_number
    column :email
    column :notes
    column 'Image' do |customer|
      if customer.image.attached?
        image_tag url_for(customer.image), size: '50x50'
      else
        'No image'
      end
    end
    actions
  end

  # Permitting parameters for file upload
  controller do
    def create
      super do |format|
        redirect_to collection_url and return if resource.valid?
      end
    end
  end
end
