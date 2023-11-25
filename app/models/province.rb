class Province < ApplicationRecord
  # Validation for the presence of the province name
  validates :name, presence: true

  # Validation for numericality of the new tax columns
  # You can adjust the validation as per your requirements
  validates :gst, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :pst, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :hst, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Define searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    # Update the attributes list as per the changes in the model
    %w[name gst pst hst]
  end
end