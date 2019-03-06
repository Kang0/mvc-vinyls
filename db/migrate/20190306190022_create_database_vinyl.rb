class CreateDatabaseVinyl < ActiveRecord::Migration
  def change
    create_table :database_vinyls do |t|
      t.string :artist
      t.string :album_name
      t.string :record_label
      t.integer :year_released
      t.string :genre
    end
  end
end
