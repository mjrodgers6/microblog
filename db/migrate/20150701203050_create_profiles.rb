class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :location
      t.string :occupation
      t.integer :age
      t.integer :user_id
    end
  end
end
