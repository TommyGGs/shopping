class AddModeNamesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :mode_name, :string
  end
end
