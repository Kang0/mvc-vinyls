class CreateUsersVinyls < ActiveRecord::Migration
  def change
    create_table :users_vinyls do |t|
      t.integer :user_id
      t.integer :vinyl_id
    end
  end
end
