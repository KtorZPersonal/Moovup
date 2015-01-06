#encoding = utf-8
module ShopsHelper

def favorite_class_of(shop, user)
	if shop.likers.include?(user)
		"favorite-icon-selected"
	else
		"favorite-icon"
	end
end
def favorite_tooltip_of(shop, user)
	if shop.likers.include?(user)
		"Retirer des favoris"
	else
		"Ajouter aux favoris"
	end
end

def dump_google_map(shops)
	center = Geocoder::Calculations.geographic_center(shops)

	mark_str = "var marqueur;\n var optionsMarqueur;\n var image='/assets/marker.png';\n"
	shops.each do |shop|
		mark_str.concat "optionsMarqueur = {
			position: new google.maps.LatLng(#{shop.latitude}, #{shop.longitude}),
			map: maCarte,
			title: \"#{shop.address}\",
			animation: google.maps.Animation.DROP,
			icon: image
		};"
		mark_str.concat "marqueur = new google.maps.Marker(optionsMarqueur);"
	end
	html = <<-HTML
	<div id="google_map" class="map"></div>
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false&libraries=adsense,weather"></script>
	<script type="text/javascript">
		function initialisation() {
			var centreCarte = new google.maps.LatLng(#{center[0]}, #{center[1]});
			var optionsCarte = {
				zoom: 13,
				center: centreCarte,
				mapTypeControl: true,
				mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.DROPDOWN_MENU },
				zoomControl: true,
				scrollwheel: false,
				zoomControlOptions: { style: google.maps.ZoomControlStyle.LARGE },
				panControl: false,
				streetViewControl: true,
				mapTypeId: google.maps.MapTypeId.ROADMAP,
				overviewMapControl: false,
				draggable : true,
				scaleControl: true
			}

			var maCarte = new google.maps.Map(document.getElementById("google_map"), optionsCarte);

			#{mark_str}
		}

		$(document).ready(initialisation);
	</script>
	HTML

	html.html_safe
end
end
