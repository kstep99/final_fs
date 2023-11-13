class CreateStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :statuses do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    add_index :statuses, :name, unique: true
  end
end
