module AirbrakeTags

  include Radiant::Taggable

  desc '
    *Usage:*

      <pre><code>
        <r:airbrake_javascript_notifier />
      </code></pre>
  '
  tag "airbrake_javascript_notifier" do |tag|
    request = tag.globals.page.request
<<-EOF
  <script type="text/javascript">
  //<![CDATA[

    (function(){
      document.write(unescape("%3Cscript src='/javascripts/notifier.js' type='text/javascript'%3E%3C/script%3E"));
    })();

  //]]>
  </script>

  <script type="text/javascript">
  //<![CDATA[

      window.Airbrake = (typeof(Airbrake) == 'undefined' && typeof(Hoptoad) != 'undefined') ? Hoptoad : Airbrake

      Airbrake.setKey("#{Airbrake.configuration.api_key}");
      Airbrake.setHost("#{Airbrake.configuration.host}");
      Airbrake.setEnvironment("#{Airbrake.configuration.environment_name}");
      Airbrake.setErrorDefaults({ url: "#{h(request.url)}", component: "#{request.parameters["controller"]}", action: "#{request.parameters["action"]}" });

  //]]>
  </script>
EOF
  end

end
