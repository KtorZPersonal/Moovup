#encoding = utf-8
class OffersController < ApplicationController
	before_filter :authenticate_user!, except: [:show_near, :set_requested_coords]
	before_filter :redirect_if_not_pro, except: [:show_near, :set_requested_coords]
	before_filter :find_offer, 	except: [:index, :new, :create, :show_near, :set_requested_coords]

	# GET /offers/:status
	def index
		@offers = Offer.includes(:shops)
			.where(confirmed: params[:status] != "pending")
			.where(owner: current_user)

		respond_to do |format|
			format.html
			format.js {render "offers/js/index"}
		end
	end

	# GET /offers/new
	def new
		@offer = Offer.new
	end

	# GET /offer/1/edit
	def edit
	end

	# GET /offer/1/publish
	def publisher_selection
	end

	# GET /offers/aroundme
	def show_near
		#Récupération des coordonnées
		@requested_coords = session[:requested_coords]
		@requested_coords ||= request.location.coordinates

		#Récupération des favoris s'il y a lieu
		favorites = current_user.favorites if user_signed_in? && params[:favorites].to_sym == :favorites

		#Récupération de toutes les offres
		@offers = offers_near_coords(@requested_coords, params[:category], favorites)
		
		#En attendant le système freemium, on shuffle pour le fun
		@offers.shuffle!

		respond_to do |format|
			format.html
			format.js {render "offers/js/show_near"}
		end
	end

	# POST /offers/aroundme/:category
	def set_requested_coords
		coords = Geocoder.coordinates(params[:address])
		session[:requested_coords] = coords unless coords.nil?
		redirect_to aroundme_offers_path(params[:category], params[:favorites])
	end

	# POST /offers
	def create
		@offer = Offer.new(offer_params)
		@offer.owner = current_user
		if @offer.save
			redirect_to index_offers_path(:pending), notice: "Annonce créée avec succès"
		else
			render 'new'
		end
	end

	# PUT /offer/1/publish
	def publish
		begin
			shop = Shop.where(manager: current_user).find(params[:offer][:shops])
			@offer.shops << shop unless @offer.shops.include? shop
			if @offer.save
				flash[:notice] = "Annonce publiée avec succès"
			else
				flash[:alert] = "Impossible de publier l'annonce"
			end
		rescue	ActiveRecord::RecordNotFound
			flash[:alert] = "Le magasin n'existe pas"
		end
		redirect_to index_offers_path(:active)
	end

	# PUT /offer/1
	def update
		@offer.confirmed = false
		@offer.pending = false
		@offer.pending_comment = ""
		if @offer.update_attributes(offer_params)
			redirect_to index_offers_path(:pending), notice: "Annonce mise à jour avec succès"
		else
			render 'edit'
		end
	end

	# PUT /offer/1/submit
	def submit
		@offer.pending = true
		@offer.pending_comment = ""
		@offer.confirmed = false
		if @offer.save
			flash[:notice] = "L'annonce a été envoyé à l'équipe Moovup pour validation"
		else
			flash[:alert] = "Erreur pendant la soumission de l'annonce"
		end
		redirect_to index_offers_path(:pending)
	end

	# DELETE /offers/1/publish/1
	def unpublish
		begin
			@shop = Shop.where(manager: current_user).find(params[:shop_id])
			@offer.shops.delete(@shop)
		rescue	ActiveRecord::RecordNotFound
			@error = "Le magasin n'existe pas"
		end
		respond_to do |format|
			if @error.nil? && @offer.save 
				format.html {redirect_to index_offers_path(:active), notice: "Annonce retirée avec succès"}
				format.js { render "offers/js/unpublish"}
			else
				@error = "Impossible de retirer l'annonce"
				format.html {redirect_to index_offers_path(:active), alert: @error}
				format.js {render "offers/js/unpublish"}
			end
		end	
	end

	# DELETE /offers/1
	def destroy
		respond_to do |format|
			if @offer.destroy
				format.html {redirect_to index_offers_path(:active), notice: "Annonce supprimée avec succès"}
				format.js {render "offers/js/destroy"}
			else
				@error = "Impossible de supprimer l'annonce"
				format.html {redirect_to index_offers_path(:active), alert: @error}
				format.js {render "offers/js/destroy"}
			end
		end
	end


private
	# Protection contre l'injection de parametres
	def offer_params
		params.required(:offer).permit(:title, :description, :expiry, :photo, :category)
	end

	#Intancier le magasin concerné par l'url
	def find_offer
		begin
			@offer = Offer.includes(:shops).where(owner: current_user).find(params[:id])
		rescue ActiveRecord::RecordNotFound
			redirect_to index_offers_path(:active), alert: "L'annonce n'existe pas"
		end
	end

	def is_required(offer_category, category_requested)
		categories = ["culture", "health", "technologies", "house", "entertainments", "kids", "cooking"]
		return true if category_requested == "all"
		return true unless categories.include?(category_requested)
		return offer_category == category_requested
	end

	def offers_near_coords(requested_coords, category, favorites = nil)
		shops = (Shop.includes(:offers).where(confirmed: true).near(requested_coords, 25)).uniq
		offers = []
		offers_seen = []
		shops.each do |shop|
			if favorites.nil? || favorites.include?(shop)
				shop.offers.each do |offer|
					unless offers_seen.include?(offer) || offer.pending || offer.expiry < DateTime.now || !is_required(offer.category, category)
						offers << [offer, shop]
						offers_seen << offer
					end
				end
			end	
		end
		return offers
	end
end