class Customer < ApplicationRecord
  # Includes Devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable, ,
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :timeoutable, :rememberable

  # Active Storage association for the image
  has_one_attached :image

  # Validations
  validates :full_name, presence: true, allow_blank: true

  # Ensures the email is unique and allows it to be blank (if your application logic requires it)
  validates :email, uniqueness: true, allow_blank: false

  # Add phone number format validation (the regex can be adjusted as needed)
  validates :phone_number, format: { with: /\A(\+\d{1,3}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/ }, allow_blank: true

  # Ransackable Attributes and Associations
  # Only allow certain attributes to be searchable.
  def self.ransackable_attributes(auth_object = nil)
    %w[id full_name email phone_number created_at updated_at]
  end

  # Allowlist associations for Ransack searches
  # Return an empty array if you do not want any associations to be searchable
  def self.ransackable_associations(auth_object = nil)
    []
  end
end
