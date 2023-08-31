# frozen_string_literal: true

namespace :db do
  desc "Downloads the app database from Heroku and imports it to the local database"
  task pull_data: :environment do
    config = if Rails.version.to_f >= 7
      ActiveRecord::Base.connection_db_config.configuration_hash.with_indifferent_access
    else
      ActiveRecord::Base.connection_db_config.config
    end
    ENV["DISABLE_DATABASE_ENVIRONMENT_CHECK"] = "1"
    Rake::Task["db:drop"].invoke
    ENV["PGUSER"] = config["username"]
    ENV["PGHOST"] = config["host"]
    ENV["PGPORT"] = config["port"].to_s

    exclude_table_part = ENV["IGNORE_TABLES"].to_s.split(",").filter(&:presence).join(";").presence&.then { |t| "--exclude-table-data '#{t}'" }

    # TODO: Optionally provider Heroku App name.

    # TODO: Optionally provide destination database + `:new_db` option (somehow) + confirm_used_database

    # TODO: Option to Auto-Dump locally

    # TODO: Try to automatically run post-pull task. eg: `Rake::Task[db:post_pull]&.invoke`

    sh "heroku pg:pull DATABASE_URL #{exclude_table_part} #{config["database"]}"
    sh "rails db:environment:set"
    sh "RAILS_ENV=test rails db:create"
  end

  desc "Downloads the app assets from AWS to directory `storage`."
  task pull_assets: :environment do
    config = JSON.parse(`heroku config --json`)
    ENV["AWS_DEFAULT_REGION"] = config.fetch("AWS_REGION")
    bucket = config.fetch("AWS_BUCKET")
    ENV["AWS_ACCESS_KEY_ID"] = config.fetch("AWS_ACCESS_KEY_ID")
    ENV["AWS_SECRET_ACCESS_KEY"] = config.fetch("AWS_SECRET_ACCESS_KEY")
    storage_folder = Rails.root.join("storage")
    download_folder = storage_folder.join("downloads")
    FileUtils.mkdir_p download_folder
    sh "aws s3 sync s3://#{bucket} #{storage_folder}/downloads"
    download_folder.each_child do |file|
      next if file.directory?

      new_path = storage_folder.join file.basename.to_s.then { |e| [e[0..1], e[2..3], e] }.join("/")
      FileUtils.mkdir_p(new_path.dirname)
      FileUtils.cp(file, new_path)
    end
    # purge variants
    ActiveStorage::VariantRecord.delete_all
    ActiveStorage::Blob.update_all(service_name: :local)
  end

  desc "Download all app data, including assets"
  task pull: [:pull_data, :pull_assets]

  desc "Migrates if the database has any tables."
  task migrate_if_tables: :environment do
    if ActiveRecord::Base.connection.tables.any?
      Rake::Task["db:migrate"].invoke
    else
      puts "No tables in database yet, skipping migration"
    end
  end
end
