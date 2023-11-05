class AddDeviseFieldsToCustomers < ActiveRecord::Migration[6.0]
  def change
    ## Database authenticatable
    add_column :customers, :encrypted_password, :string, null: false, default: ""

    ## Recoverable
    add_column :customers, :reset_password_token, :string
    add_column :customers, :reset_password_sent_at, :datetime

    ## Rememberable
    add_column :customers, :remember_created_at, :datetime

    ## Trackable
    # add_column :customers, :sign_in_count, :integer, default: 0, null: false
    # add_column :customers, :current_sign_in_at, :datetime
    # add_column :customers, :last_sign_in_at, :datetime
    # add_column :customers, :current_sign_in_ip, :string
    # add_column :customers, :last_sign_in_ip, :string

    ## Confirmable
    # add_column :customers, :confirmation_token, :string
    # add_column :customers, :confirmed_at, :datetime
    # add_column :customers, :confirmation_sent_at, :datetime
    # add_column :customers, :unconfirmed_email, :string # Only if using reconfirmable

    ## Lockable
    # add_column :customers, :failed_attempts, :integer, default: 0, null: false # Only if lock strategy is :failed_attempts
    # add_column :customers, :unlock_token, :string # Only if unlock strategy is :email or :both
    # add_column :customers, :locked_at, :datetime

    add_index :customers, :reset_password_token, unique: true
    # add_index :customers, :confirmation_token,   unique: true
    # add_index :customers, :unlock_token,         unique: true
  end
end
