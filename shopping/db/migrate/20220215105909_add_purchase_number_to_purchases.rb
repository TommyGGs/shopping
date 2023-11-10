class AddPurchaseNumberToPurchases < ActiveRecord::Migration[6.1]
  def change
    add_column :purchases, :purchase_number, :integer
  end
end
