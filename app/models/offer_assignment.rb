class OfferAssignment < ActiveRecord::Base
	belongs_to :shop
	belongs_to :offer
end
