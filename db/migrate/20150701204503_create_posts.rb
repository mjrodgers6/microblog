class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.datetime :posttime
      t.string :posttext
      t.integer :user_id
    end
  end
end
