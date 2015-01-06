class AddParametersToUser < ActiveRecord::Migration
  def change
  	add_column :users, :avatar_url, :string
    add_column :users, :phone, :string
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :birthday, :date
    add_column :users, :address, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :rank, :integer
    add_attachment :users, :avatar
  end
end
