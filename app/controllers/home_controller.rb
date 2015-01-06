class HomeController < ApplicationController
include HomeHelper

	# GET '/'
  def index
  	location = request.location.coordinates unless request.location.blank?

    if user_signed_in? && !current_user.address.nil?
      location = Geocoder.coordinates(current_user.address)
    end

  	#Paris
  	#location = Geocoder.search("87.231.0.0").first 

  	# Albi
  	#location = Geocoder.search("82.216.93.155 ").first 

  	# Lille
    #location = Geocoder.search("90.1.242.185").first 

  	# Metz
    # location = Geocoder.search("31.38.237.73").first 

    # St sulpice
    #location = Geocoder.search("62.35.58.193").first

    if location.blank?
      @nearest_city = nearestCityFrom([48.853, 2.35])
    else
      @nearest_city = nearestCityFrom(location)
    end

    puts(location)

    @user = User.new
  end

  def index_pro
  end
end
