class CreateLiDarFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :li_dar_files do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :title, null: false
      t.string :file_path # This is optional by default

      t.timestamps
    end
  end
end
