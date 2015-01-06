class FavoriteAssignment < ActiveRecord::Base
	belongs_to :liker, class_name: "User"
	belongs_to :favorite, class_name: "Shop"
end
