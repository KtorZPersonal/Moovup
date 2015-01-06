class AddAssignmentBetweenOfferAndShop < ActiveRecord::Migration
  def change
    create_table :offer_assignments do |t|
    	t.integer :shop_id
    	t.integer :offer_id

    	t.timestamps
    end
    add_index :offer_assignments, :shop_id
    add_index :offer_assignments, :offer_id
  end
end
