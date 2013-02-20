class CreateHouseholds < ActiveRecord::Migration
  def change
    create_table :households do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :households, :name, uniqueness: true
  end
end
