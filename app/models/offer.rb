class Offer < ActiveRecord::Base
	#Relations
	has_many :offer_assignments
	has_many :shops, through: :offer_assignments
	belongs_to :owner, class_name: "User"

	#Photo de l'annonce
	has_attached_file :photo, 
		:styles => { :thumb => "100x100#", :show => "150x150#", :showInDaShop => "300x300#"}, 
		:default_url => "/assets/no_photo.jpg",
		:s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
	    :path => ":class/:attachment/:id/:style/:filename",
	    :url  => ":s3_eu_url"

	#Validations
	validates :title,
		length: {in: 5..40}

	validates :description,
		length: {maximum: 200},
		:allow_blank => true

	validates :owner,
		presence: true

	validates :category,
		inclusion: { in: %w(culture health technologies entertainments kids home cooking)}
	
	validates_date :expiry,
		:after => lambda {2.days.ago}

	validates_attachment :photo,
		content_type: { :content_type => ["image/jpeg", "image/jpg", "image/png"]}, 
		size: { :in => 0..1000.kilobytes }
end
