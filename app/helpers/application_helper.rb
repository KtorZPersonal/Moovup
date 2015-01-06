module ApplicationHelper
	def nav_class_of(status_requested, status_link)
		if status_requested == status_link 
			"btn btn-primary btn-xs"
		else
			"btn btn-default btn-xs"
		end
	end
end
