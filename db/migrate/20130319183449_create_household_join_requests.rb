class CreateHouseholdJoinRequests < ActiveRecord::Migration
  def change
    create_table :household_join_requests do |t|
      t.integer :user_id, null: false
      t.integer :household_id, null: false
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end

    add_index :household_join_requests, [:user_id, :household_id], uniqueness: true
  end
end
