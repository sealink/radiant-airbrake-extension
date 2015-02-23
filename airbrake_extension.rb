# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

# Need this for 'config_exists?'
require 'radiant_extension_helper'

class AirbrakeExtension < Radiant::Extension
  version "1.0"
  description "Extension to handle server-side/client-side integration of Airbrake/Hoptoad."
  url ''


  def activate
    require 'tags/airbrake_tags'
    Page.send :include, AirbrakeTags

    require 'airbrake_render_tag_override'
    PageContext.send :include, AirbrakeRenderTagOverride

    return unless config_exists?('production')

    configure do |config|
      config.secure = config.port == 443

      # Asynchronous notification for Airbrake
      config.async do |notice|
        Thread.new { Airbrake.sender.send_to_airbrake(notice) }
      end
    end
  end


  def deactivate
  end
end
