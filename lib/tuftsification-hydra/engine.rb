module TuftsificationHydra
  class Engine < ::Rails::Engine
      # Load rake tasks
#      config.autoload_paths << File.expand_path("../lib/h", __FILE__)

    initializer :append_dependent_assets_path, :group => :all do |app|
       engine_root = TuftsificationHydra::Engine.root
       app.config.assets.paths.push(engine_root +'lib/assets/javascripts')
       app.config.assets.paths.push(engine_root +'lib/assets/stylesheets')
    end

     config.autoload_paths += %W(
       #{config.root}/lib
       #{config.root}/lib/tufts
       #{config.root}/app/controllers/concerns
       #{config.root}/app/models/concerns
       #{config.root}/app/models/datastreams
       #{config.root}/app/jobs
     )
     #collection_facet_error_logfile = File.open("#{Rails.root}/log/collection_facet_error.log")
     #COLLECTION_ERROR_LOG = ActiveSupport::BufferedLogger.new("#{Rails.root}/log/collection_facet_error.log")

      rake_tasks do
        Dir.glob(File.join(File.expand_path('../', File.dirname(__FILE__)),'railties', '*.rake')).each do |railtie|
          load railtie
        end
      end
  end
end
