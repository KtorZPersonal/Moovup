#encoding = utf-8
class Users::RegistrationsController < Devise::RegistrationsController
	before_filter :authenticate_user!
	before_filter :redirect_if_not_connected, only: [:profil, :edit_avatar, :update_avatar, :favorites]

	def profil
	end

	def edit_avatar
	end

	def favorites
	end

	def update_avatar
		if current_user.update_attributes(avatar_params)
			redirect_to user_profil_path, notice: "Avatar mis à jour"
		else
			render :edit_avatar
		end
	end

	protected

  def after_update_path_for(resource)
    user_profil_path
  end

  def avatar_params
  	return nil if params[:user].nil?
	params.required(:user).permit(:avatar)
  end

  def redirect_if_not_connected
    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Vous devez être connecté pour continuer."
    end
  end
end