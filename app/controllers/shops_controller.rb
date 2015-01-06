#encoding = utf-8
class ShopsController < ApplicationController
	before_filter :authenticate_user!, except: [:show]
	before_filter :redirect_if_not_pro, except: [:show, :show_near, :liker, :set_requested_coords]
	before_filter :find_shop, only: [:edit, :destroy, :update, :submit]
	before_filter :find_shop_public, only: [:show, :liker]

	# GET /shops
	def index
		@shops = Shop.where(manager: current_user).where(confirmed: params[:status] != "pending")

		respond_to do |format|
			format.html
			format.js {render "shops/js/index"}
		end
	end

	# GET /shops/new
	def new
		@shop = Shop.new
	end

	# GET /shops/1
	def show
	end

	# GET /shops/aroundme
	def show_near
		requested_coord = Geocoder.coordinates(current_user.address)
		if requested_coord.nil?
			redirect_to user_favorites_path, alert: "Vous n'avez pas de chez vous... à moins que vous ayez juste oublié de remplir votre profil !"
		end
		@shops = (Shop.includes(:offers).where(confirmed: true).near(requested_coord, 25)).uniq
	end

	# GET /shops/1/edit
	def edit
	end

	# POST /shops
	def create
		@shop = Shop.new(shop_params)
		@shop.manager = current_user
		if @shop.save
			redirect_to index_shops_path(:pending), notice: "Magasin créé avec succès"
		else
			render 'new'
		end
	end

	# PUT /shops/1
	def update
		@shop.confirmed = false
		@shop.pending_comment = ""
		@shop.pending = false
		if @shop.update_attributes(shop_params)
			redirect_to index_shops_path(:pending), notice: "Magasin mis à jour avec succès"
		else
			render 'edit'
		end
	end

	# PUT /shop/1/like
	def liker
		if @shop.likers.include?(current_user)
			@shop.likers.delete(current_user)
			@notice = "Le magasin a été retiré de vos favoris"
		else
			@shop.likers << current_user
			@notice = "Le magasin a été ajouté à vos favoris"
		end

		respond_to do |format|
			if @shop.save
				format.html {redirect_to :back, notice: @notice}
				format.js {render "shops/js/liker"}
			else
				@error = "Impossible d'ajouter le magasin aux favoris"
				format.html {redirect_to :back, alert: @error}
				format.js {render "shops/js/liker"}
			end
		end
	end

	# PUT /offer/1/submit
	def submit
		@shop.pending = true
		@shop.pending_comment = ""
		@shop.confirmed = false
		if @shop.save
			flash[:notice] = "Le magasin a été envoyé à l'équipe Moovup pour validation"
		else
			flash[:error] = "Erreur pendant la soumission du magasin"
		end
		redirect_to index_shops_path(:pending)
	end

	# DELETE /shops/1
	def destroy
		respond_to do |format|
			if @shop.destroy
				format.html {redirect_to shops_path, notice: "Magasin supprimé avec succès"}
				format.js {render 'shops/js/destroy'}
			else
				@error =  "Impossible de supprimer le magasin"
				format.html {redirect_to shops_path, alert: @error}
				format.js {render 'shops/js/destroy'}
			end
		end
	end

private
	# Protection contre l'injection de parametres
	def shop_params
		params[:description] = Sanitize.clean(params[:description], Sanitize::Config::RESTRICTED)
		params.required(:shop).permit(:description, :address, :phone, :email, :name, :photo, :cover)
	end

	#Intancier le magasin concerné par l'url
	def find_shop
		begin
			@shop = Shop.includes(:manager).where(manager: current_user).find(params[:id])
		rescue ActiveRecord::RecordNotFound
			redirect_to index_shops_path(:active), alert: "Le magasin n'existe pas"
		end
	end

	def find_shop_public
		begin
			@shop = Shop.includes([:offers, :manager]).find(params[:id])
			raise ActiveRecord::RecordNotFound unless @shop.confirmed || @shop.manager == current_user
			@shop.offers = @shop.offers.delete_if {|offer| offer.pending || offer.expiry < DateTime.now}
		rescue ActiveRecord::RecordNotFound
			redirect_to root_path, alert: "Le magasin n'existe pas"
		end
	end
end
