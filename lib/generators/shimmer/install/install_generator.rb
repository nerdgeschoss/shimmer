require "rails/generators"
require "rails/generators/migration"

module Shimmer
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def copy_migrations
        migration_template "add_primary_color_and_preview_hash_to_active_storage_blobs.rb", "db/migrate/add_primary_color_and_preview_hash_to_active_storage_blobs.rb"
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
