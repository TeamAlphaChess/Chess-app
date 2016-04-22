class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|

      t.string :email
      t.integer :user_id

      t.timestamps
    end

    add_index :avatars, [:email, :user_id] 
  end
end
