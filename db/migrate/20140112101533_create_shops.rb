class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
    	t.string :name
		t.text :description
		t.string :address
		t.string :email
		t.string :phone
		t.attachment :photo
		t.attachment :cover
        t.boolean :pending, default: false
        t.boolean :confirmed, default: false
        t.string :pending_comment
		
		t.integer :manager_id

		t.float :latitude
		t.float :longitude
      	t.timestamps
    end
  	add_index :shops, :manager_id
  end
end
