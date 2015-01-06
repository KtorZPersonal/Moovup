module HomeHelper
	def nearestCityFrom(coordinates)
		cities = {
			"Amiens"=>[49.894067, 2.295753], 
			"Angers"=>[47.478419, -0.5631659999999999], 
			"Besancon"=>[47.237829, 6.024053899999999], 
			"Bordeaux"=>[44.837789, -0.57918], 
			"Brest"=>[48.390394, -4.486076], 
			"Caen"=>[49.182863, -0.370679], 
			"Clermont"=>[45.77722199999999, 3.087025], 
			"Dijon"=>[47.322047, 5.04148], 
			"Grenoble"=>[45.188529, 5.724524], 
			"Le-havre"=>[49.49437, 0.107929], 
			"Le-mans"=>[48.00611000000001, 0.199556], 
			"Lille"=>[50.62925, 3.057256], 
			"Limoges"=>[45.83361900000001, 1.261105], 
			"Lyon"=>[45.764043, 4.835659], 
			"Marseille"=>[43.296482, 5.36978], 
			"Metz"=>[49.119666, 6.176905], 
			"Montpellier"=>[43.610769, 3.876716], 
			"Nancy"=>[48.692054, 6.184417], 
			"Nantes"=>[47.218371, -1.553621], 
			"Nice"=>[43.696036, 7.265592], 
			"Orleans"=>[47.902964, 1.909251], 
			"Paris"=>[48.853, 2.35],
			"Perpignan"=>[42.698684, 2.8958719], 
			"Reims"=>[49.258329, 4.031696], 
			"Rennes"=>[48.113475, -1.675708], 
			"Rouen"=>[49.44323199999999, 1.099971], 
			"Strasbourg"=>[48.583148, 7.747882], 
			"Toulouse"=>[43.604652, 1.444209], 
			"Tours"=>[47.394144, 0.68484]
		}

	#coordonnées par défaut en cas de probleme
  	coordinates = cities["Paris"] if coordinates.eql?([0.0, 0.0])

  	#initialisation
  	nearest_city = ""
  	distance_max = 10000000

  	#recherche de la ville la plus proche
  	cities.each do |c, coord|
  		distance = Geocoder::Calculations.distance_between(coord, coordinates)
  		if distance < distance_max
  			distance_max = distance
  			nearest_city = c
  		end
  	end

  	return nearest_city
  end
end
