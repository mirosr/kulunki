class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, nill: false, default: 'user'

    add_index :users, :role
  end
end
