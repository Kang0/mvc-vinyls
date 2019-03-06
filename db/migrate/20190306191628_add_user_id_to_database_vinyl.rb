class AddUserIdToDatabaseVinyl < ActiveRecord::Migration
  def change
    add_column :database_vinyls, :user_id, :integer
  end
end
