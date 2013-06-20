# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'
class AirbrakeExtension < Radiant::Extension
  version "1.0"
  description "Extension to handle server-side/client-side integration of Airbrake/Hoptoad."
  url ''


  def activate
    require 'tags/airbrake_tags'
    Page.send :include, AirbrakeTags

    require 'airbrake_render_tag_override'
    PageContext.send :include, AirbrakeRenderTagOverride

    airbrake_yml = "#{Rails.root}/config/airbrake.yml"
    if File.exists?(airbrake_yml) #&& Rails.env == 'production'
      airbrake_config = YAML::load(File.read(airbrake_yml))
      Airbrake.configure do |config|
        airbrake_config.each do |key, value|
          config.send("#{key}=", value)
        end
        config.secure = config.port == 443

        # Asynchronous notification for Airbrake
        config.async do |notice|
          Thread.new { Airbrake.sender.send_to_airbrake(notice) }
        end
      end
    else
      error_message = "#{airbrake_yml} does not exist. Please use #{airbrake_yml}.example as a reference."
      if Rails.env == 'production'
        raise error_message
      else
        puts 'WARNING: ' + error_message
      end
    end
  end


  def deactivate
  end
end
