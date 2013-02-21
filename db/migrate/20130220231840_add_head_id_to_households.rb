class AddHeadIdToHouseholds < ActiveRecord::Migration
  def change
    add_column :households, :head_id, :integer, null: false

    add_index :households, :head_id
  end
end
