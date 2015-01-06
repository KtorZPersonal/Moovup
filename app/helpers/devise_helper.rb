module DeviseHelper
	def devise_error_messages!
	    return "" if resource.errors.empty?

	    messages = resource.errors.full_messages.map {|msg| "#{msg}<br/>"}.join
	    sentence = I18n.t("errors.messages.not_saved",:count => resource.errors.count,:resource => resource.class.model_name.human.downcase)

	    html = <<-HTML
			<div data-dismiss="alert" class="alert fade in alert-dismissable alert-danger">
				<ul>#{messages}</ul>
			</div>
		HTML

	    html.html_safe
	end

	def model_error_messages!(model)
	    return "" if model.errors.empty?

	    messages = model.errors.full_messages.map {|msg| "#{msg}<br/>"}.join
	    sentence = I18n.t("errors.messages.not_saved",:count => model.errors.count,:resource => model.class.model_name.human.downcase)

	    html = <<-HTML
			<div data-dismiss="alert" class="alert fade in alert-dismissable alert-danger">
				<ul>#{messages}</ul>
			</div>
		HTML

	    html.html_safe
	end
end