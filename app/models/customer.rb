class Customer < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Override Devise's email required method
  def email_required?
    false
  end


  # Active Storage association for the image
  has_one_attached :image

  # Only allow certain attributes to be searchable
  def self.ransackable_attributes(auth_object = nil)
    %w[id full_name email phone_number created_at updated_at]
  end

  # Allowlist associations for Ransack searches
  # Return an empty array if you do not want any associations to be searchable
  def self.ransackable_associations(auth_object = nil)
    # Example: %w[orders payments]
    []
  end

  # Validations
  validates :full_name, presence: true

  # You might have a typo here, it should be :email if that's the column in your database, not :email_address
  # So either change your validation to match the database column, or change the database column to match this (which may involve a migration).
  validates :email, uniqueness: true, allow_blank: true

  # Uncomment and edit the line below to add phone number format validation as required
  # validates :phone_number, format: { with: /\A(\+\d{1,3}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}\z/ }, allow_blank: true
end
