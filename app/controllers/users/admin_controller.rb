class Users::AdminController < ApplicationController
	before_filter :authenticate_user!
	before_filter :redirect_unless_modo
	before_filter :find_offer, only: [:valid_offer, :offer_send_validation]
	before_filter :find_shop, only: [:valid_shop, :shop_send_validation]

	# GET admin/offers
	def offers
		@offers = Offer.where(pending: true).all
	end

	# GET admin/shops
	def shops
		@shops = Shop.where(pending: true).all
	end

	# GET admin/offer/:id
	def valid_offer
	end

	# GET admin/shop/:id
	def valid_shop
	end

	# PUT admin/offer/:id
	def offer_send_validation
		@offer.pending_comment = params[:offer][:pending_comment]
		@offer.confirmed = params[:offer][:confirmed]
		@offer.pending = false
		if @offer.save
			flash[:notice] = "Validation/Invalidation envoyée"
		else
			flash[:alert] = "Impossible d'effectuer la validation"
		end
		redirect_to offers_admin_path
	end

	# PUT admin/shop/:id
	def shop_send_validation
		@shop.pending_comment = params[:shop][:pending_comment]
		@shop.confirmed = params[:shop][:confirmed]
		@shop.pending = false
		if @shop.save
			flash[:notice] = "Validation/Invalidation envoyée"
		else
			flash[:alert] = "Impossible d'effectuer la validation"
		end
		redirect_to shops_admin_path
	end
private
	def find_offer
		begin
			@offer = Offer.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			redirect_to offers_admin_path, alert: "L'annonce n'existe pas"
		end
	end

	def find_shop
		begin
			@shop = Shop.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			redirect_to shops_admin_path, alert: "Le magasin n'existe pas"
		end
	end

	def redirect_unless_modo
		redirect_to root_path unless user_signed_in? && current_user.rank >= User::MODO
	end
end