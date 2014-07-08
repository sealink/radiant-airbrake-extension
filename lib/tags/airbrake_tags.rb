module AirbrakeTags

  include Radiant::Taggable

  desc '
    *Usage:*

      <pre><code>
        <r:airbrake_javascript_notifier />
      </code></pre>
  '
  tag "airbrake_javascript_notifier" do |tag|
    return '' if defined?(Rails) && Rails.env.development?
    request = tag.globals.page.request
    js = <<-EOF
  <script type="text/javascript">
  //<![CDATA[

    (function(){
      setTimeout(function(){var a=document.createElement("script");
      var b=document.getElementsByTagName("script")[0];
      a.src="/javascripts/notifier.js";
      a.async=true;a.type="text/javascript";b.parentNode.insertBefore(a,b);}, 1);
    })();

  //]]>
  </script>

  <script type="text/javascript">
  //<![CDATA[

      window.Airbrake = (typeof(Airbrake) == 'undefined' && typeof(Hoptoad) != 'undefined') ? Hoptoad : Airbrake;

      Airbrake.setKey("#{Airbrake.configuration.api_key}");
      Airbrake.setHost("#{Airbrake.configuration.host}");
      Airbrake.setEnvironment("#{Airbrake.configuration.environment_name}");
      Airbrake.setErrorDefaults({ url: "#{h(request.url)}", component: "#{request.parameters["controller"]}", action: "#{request.parameters["action"]}" });

  //]]>
  </script>
EOF
    js.html_safe
  end

end
