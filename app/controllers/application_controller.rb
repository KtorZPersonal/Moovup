class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if current_user.rank == User::PRO
      pro_root_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

protected
  # Configuration des paramètre du profil pour devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << [:firstname, :lastname, :address, :phone, :birthday]
    devise_parameter_sanitizer.for(:sign_up) << [:firstname, :lastname, :address, :phone, :birthday, :i_am_pro]
  end

  # Permet de rediriger un utilisateur non pro
  def redirect_if_not_pro
  	unless user_signed_in? && current_user.rank == User::PRO
  		redirect_to new_user_session_path
		end
  end
end
