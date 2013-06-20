namespace :radiant do
  namespace :extensions do
    namespace :airbrake do
      desc "Runs the migration of the extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          GeneralSettingsExtension.migrator.migrate(ENV["VERSION"].to_i)
          Rake::Task['db:schema:dump'].invoke
        else
          GeneralSettingsExtension.migrator.migrate
          Rake::Task['db:schema:dump'].invoke
        end
      end


      desc "Copies public assets of the extension to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from AirbrakeExtension"
        Dir[AirbrakeExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(AirbrakeExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          puts "file = #{file}"
          cp file, RAILS_ROOT + path, :verbose => false
        end
        file = "#{AirbrakeExtension.root}/config/airbrake.yml.example"
        path = file.sub(AirbrakeExtension.root, '')
        directory = File.dirname(path)
        mkdir_p RAILS_ROOT + directory, :verbose => false
        cp file, RAILS_ROOT + path, :verbose => false
      end
    end
  end
end
