class AddFavoriteToUser < ActiveRecord::Migration
  def change
    create_table :favorite_assignments do |t|
    	t.integer :liker_id
    	t.integer :favorite_id
      t.timestamps
    end
    add_index :favorite_assignments, :liker_id
    add_index :favorite_assignments, :favorite_id
  end
end
