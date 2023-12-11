class AddDataSpaceCategory < ActiveRecord::Migration[7.0]
  def change
    category = Category.find_by(name: 'Data Space')
    if category
      category.update(description: 'Space for storage of converted LAS files')
    else
      Category.create(name: 'Data Space', description: 'Space for storage of converted LAS files')
    end
  end
end
