class AddChangeEmailFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :change_email_token, :string
    add_column :users, :change_email_token_expires_at, :datetime
    add_column :users, :change_email_new_value, :string

    add_index :users, :change_email_token, unique: true
  end
end
