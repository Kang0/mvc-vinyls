class Images < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image
    end
  end
end
