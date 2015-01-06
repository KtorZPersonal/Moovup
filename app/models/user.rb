class User < ActiveRecord::Base
	#Devise pour la gestion des sessions
	devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

	#Prise en compte de l'avatar
	has_attached_file :avatar, 
		:styles => { :medium => "150x150#", :thumb => "100x100#" }, 
		:default_url => "/assets/no_photo.jpg",
		:s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
	    :path => ":class/:attachment/:id/:style/:filename",
	    :url  => ":s3_eu_url"

	#Géolocalisation des visiteurs
	geocoded_by :full_street_address
	reverse_geocoded_by :latitude, :longitude
	after_validation :geocode, :reverse_geocode
	
  	#Définition de paramètres personnalisés privés
  	before_create :init_private_params

	#Relations
	has_many :shops, dependent: :destroy
	has_many :favorite_assignments, :foreign_key => 'liker_id'
	has_many :favorites, through: :favorite_assignments, class_name: "Shop"

	#Constantes de classe
	MEMBER = 1
	PRO = 2
	MODO = 10
	ADMIN = 100

	#Simplification de l'inscription
	attr_accessor :i_am_pro

	#Validations
 	validates :email,
		format: {with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/},
		uniqueness: true

	validates :password,
		confirmation: true,
		length: {in: 4..50},
		on: :create

	validates :firstname,
		length: {in: 2..50},
		allow_blank: true,
		on: :update 

	validates :lastname,
		length: {in: 2..50},
		allow_blank: true,
		on: :update 

	validates :phone,
		length: {is: 10},
		numericality: { only_integer: true },
		allow_blank: true,
		on: :update

	validates_date :birthday,
		before: lambda {18.years.ago},
		allow_blank: true,
		on: :update

	validate :validates_address, on: :update

	validates_attachment :avatar,
		content_type: { :content_type => ["image/jpeg", "image/jpg", "image/png"]}, 
		size: { :in => 0..200.kilobytes }

	with_options if: "self.i_am_pro.to_i == 1 || self.rank == PRO" do |pro|
		pro.validates :firstname, length: {in: 2..50}
		pro.validates :lastname, length: {in: 2..50}
		pro.validates :phone, length: {is: 10}, numericality: { only_integer: true }
		pro.validates_date :birthday, before: lambda {18.years.ago}
		pro.validate :validates_address
	end

private
	def init_private_params
		self.rank = if self.i_am_pro.to_i == 1 then PRO else MEMBER end
	end

	def full_street_address
		self.address
	end

	def validates_address
		if Geocoder.coordinates(self.address).blank?
			errors.add(:address, "est invalide")
		end
	end
end
