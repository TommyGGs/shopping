class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.string :name
      t.string :title
      t.integer :rating
      t.string :paragraph
      t.integer :item_id
      t.timestamps null: false
    end
  end
end
