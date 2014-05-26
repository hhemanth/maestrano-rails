module Maestrano
  module Generators
    module OrmHelpers
      
      def model_contents
        buffer = <<-CONTENT
  # Enable Maestrano for this model
  maestrano_#{model_type}_via :provider, :uid

CONTENT
        buffer += <<-CONTENT if needs_attr_accessible?
  # Setup protected attributes for your model
  attr_protected :provider, :uid

CONTENT
        buffer
      end
      
      def model_type
        self.class.name.split("::").last.gsub("Maestrano","").gsub("Generator","").downcase
      end
      
      def needs_attr_accessible?
        rails_3? && !strong_parameters_enabled?
      end

      def rails_3?
        ::Rails::VERSION::MAJOR == 3
      end

      def strong_parameters_enabled?
        defined?(ActionController::StrongParameters)
      end
      
      private
        def model_exists?
          File.exists?(File.join(destination_root, model_path))
        end

        def migration_exists?(table_name)
          Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_add_maestrano_to_#{table_name}.rb$/).first
        end

        def migration_path
          @migration_path ||= File.join("db", "migrate")
        end

        def model_path
          @model_path ||= File.join("app", "models", "#{file_path}.rb")
        end
    end
  end
end