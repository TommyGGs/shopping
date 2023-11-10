class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :item
      t.references :user 
      t.timestamps null: false 
    end 
  end
end
