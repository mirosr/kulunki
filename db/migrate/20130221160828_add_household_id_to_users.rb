class AddHouseholdIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :household_id, :integer

    add_index :users, :household_id
  end
end
