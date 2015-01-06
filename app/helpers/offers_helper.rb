module OffersHelper
	def shops_list(manager)
		shops = []
		Shop.where(manager: manager).each do |shop|
			shops << [shop.name, shop.id]
		end
		shops
	end

	def drop_offers_nav(category, favorites)
		favorites_tag = favorites
		favorites_tag = "all" unless favorites_tag == "favorites"

		li = ["", ""] #Listes pour les large screens et small screens
		categories_list.insert(0, ["Tout", "all"]).each do |name, tag|
			2.times do |i|
				li[i] += content_tag(
					:li, 
					link_to(
						raw("<span class=\"tooltiped glyphicon glyphicon-#{category_to_icon(tag)}\" data-toggle=\"tooltip\" data-original-title=\"#{name}\"></span> #{name if i == 0}"), 
						aroundme_offers_path(tag, favorites_tag.to_sym), 
						:remote => true, 
						:class => "disappear remove-articles"),
					:class => "#{ 'active' if category == tag }")
			end
		end
		nav_lg = content_tag(
			:ul,
			li[0].html_safe,
			:class => "nav nav-pills nav-stacked col-md-3 nav-pills-fixed visible-md visible-lg")

		nav_xs = content_tag(
			:ul,
			li[1].html_safe,
			:class => "nav nav-pills nav-pills-sm visible-sm visible-xs text-center")

		return nav_xs.concat(nav_lg).html_safe
	end

	def drop_offers_favorites_nav(category, favorites)
		if user_signed_in?
			ul_lg = content_tag(
				:ul,
				content_tag(:li,link_to("Toutes les promotions", aroundme_offers_path(category, :all), remote: true, :class => "disappear"),:class => "#{'active' if favorites == 'all'}").concat(
				content_tag(:li,link_to("Dans mes boutiques préférés", aroundme_offers_path(category, :favorites), remote: true, :class => "disappear"),:class => "#{'active' if favorites == 'favorites'}")),
				:class => "hidden-xs")
			ul_xs = content_tag(
				:ul,
				content_tag(:li,link_to("Toutes les promos", aroundme_offers_path(category, :all), :class => "disappear"),:class => "#{'active' if favorites == 'all'}").concat(
				content_tag(:li,link_to("Mes boutiques", aroundme_offers_path(category, :favorites), :class => "disappear"),:class => "#{'active' if favorites == 'favorites'}")),
				:class => "visible-xs")
			offers_favorites_nav = content_tag(
				:div,
				ul_lg.concat(ul_xs).html_safe,
				:class => "col-md-8 col-md-offset-4 text-center offers-nav")
		else
			""
		end
	end

	def categories_list
		categories = [
			["Culture", "culture"],
			["Bien-être", "health"],
			["Enfants", "kids"],
			["Cuisine", "cooking"],
			["Technologies", "technologies"],
			["Loisirs", "entertainments"],
			["Maison", "house"]
		]
	end

	def category_to_icon(category)
		categories = {
			"culture" => "book",
			"health" => "heart",
			"technologies" => "phone",
			"house=" => "home",
			"entertainments" => "music",
			"kids" => "send",
			"cooking" => "cutlery"
		}
		if categories.keys.include?(category)
			categories[category]
		else
			"asterisk"
		end
	end

end
