class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # Specify which attributes are searchable in Active Admin
  def self.ransackable_attributes(auth_object = nil)
    %w[id email created_at updated_at]
    # Add other attributes you want searchable, but exclude sensitive data
  end
end
