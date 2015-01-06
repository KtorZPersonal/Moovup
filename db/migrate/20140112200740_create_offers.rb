class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
  		t.string :title
  		t.string :description
  		t.date :expiry, default: Time.now
      t.string :category
      t.boolean :pending, default: false
      t.boolean :confirmed, default: false
      t.string :pending_comment
      t.attachment :photo

      t.integer :owner_id
      t.timestamps
    end
    add_index :offers, :owner_id
  end
end
