class CreateVinyls < ActiveRecord::Migration
  def change
    create_table :vinyls do |t|
      t.belongs_to :user, index: true
      t.string :artist
      t.string :album_name
      t.string :record_label
      t.integer :year_released
      t.string :genre
    end
  end
end
