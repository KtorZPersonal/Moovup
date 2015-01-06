class Shop < ActiveRecord::Base
	#Géolocalisation des magasins
	geocoded_by :full_street_address
	reverse_geocoded_by :latitude, :longitude
	after_validation :geocode, :reverse_geocode

	#Attachment
	has_attached_file :photo, 
		:styles => { :thumb => "100x100#", :show => "200x200#"}, 
		:default_url => "/assets/no_photo.jpg",
		:s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
	    :path => ":class/:attachment/:id/:style/:filename",
	    :url  => ":s3_eu_url"

	has_attached_file :cover, 
		:styles => { :show => "2000x500#"}, 
		:default_url => "/assets/no_cover.jpg",
		:s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
	    :path => ":class/:attachment/:id/:style/:filename",
	    :url  => ":s3_eu_url"

	#Relations
	belongs_to :manager, class_name: "User"
	has_many :offer_assignments
	has_many :offers, through: :offer_assignments
	has_many :favorite_assignments, :foreign_key => 'favorite_id'
	has_many :likers, through: :favorite_assignments, class_name: "User"

 	validates :email,
		format: {with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/}

	validates :name,
		length: {in: 5..40}

	validates :description,
		length: {in: 150..500},
		:allow_blank => true

	validates :phone,
		length: {is: 10},
		numericality: { only_integer: true }

	validate :validates_address

	validates :manager,
		presence: true

	validates_attachment :photo,
		content_type: { :content_type => ["image/jpeg", "image/jpg", "image/png"]}, 
		size: { :in => 0..1000.kilobytes }

	validates_attachment :cover,
		content_type: { :content_type => ["image/jpeg", "image/jpg", "image/png"]}, 
		size: { :in => 0..1000.kilobytes }	


protected 
	def full_street_address
		self.address
	end

	def validates_address
		if Geocoder.coordinates(self.address).blank?
			errors.add(:address, "est invalide")
		end
	end
end

