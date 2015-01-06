module BootstrapFlashHelper
  ALERT_TYPES = [:danger, :info, :success, :warning] unless const_defined?(:ALERT_TYPES)

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?
      
      type = :info if type == :notice
      type = :danger   if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div, msg.html_safe, :class => "alert-dismissable alert fade in alert-#{type}", "data-dismiss" => "alert")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
end