class Images < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image
      t.belongs_to :database_vinyl, index: true
    end
  end
end
