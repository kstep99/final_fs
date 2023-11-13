class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images

  def self.ransackable_attributes(auth_object = nil)
    %w[name description price category_id] # add other attributes you want searchable
  end
end
