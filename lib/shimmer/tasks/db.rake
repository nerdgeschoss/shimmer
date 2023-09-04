# frozen_string_literal: true

namespace :db do
  def env?(key)
    Shimmer::Config.coerce(ENV[key], :bool)
  end

  desc "Set the ENV for database operations"
  task prepare_database_env: :environment do
    config = if Rails.version.to_f >= 7
      ActiveRecord::Base.connection_db_config.configuration_hash.with_indifferent_access
    else
      ActiveRecord::Base.connection_db_config.config
    end
    ENV["DISABLE_DATABASE_ENVIRONMENT_CHECK"] = "1"
    ENV["PGUSER"] = config["username"]
    ENV["PGHOST"] = config["host"]
    ENV["PGPORT"] = config["port"].to_s

    ENV["DATABASE"] ||= config["database"]
    ENV["DATABASE"] = "#{ENV["DATABASE"]}_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}" if env?("SUFFIXED")
    ENV["EXCLUDE_TABLE_DATA_PART"] = ENV["IGNORE_TABLES"].to_s.split(",").filter(&:presence).join(";").presence&.then { |t| "--exclude-table-data '#{t}'" }
  end

  desc "Downloads the app database from Heroku and imports it to the local database"
  task pull_data: :"db:prepare_database_env" do
    heroku_app_part = ENV["HEROKU_APP"].presence&.then { |app| "--app #{app}" }

    sh "dropdb --if-exists #{ENV["DATABASE"]}"
    sh "heroku pg:pull DATABASE_URL #{heroku_app_part} #{ENV["EXCLUDE_TABLE_DATA_PART"]} #{ENV["DATABASE"]}".squish
    sh "rails db:environment:set"

    Rake::Task["db:post_pull_data"].invoke if Rake::Task.task_defined?("db:post_pull_data")
    Rake::Task["db:tmp:dump"].invoke if env?("AUTO_TMP_DUMP")
  end

  desc "Set the ENV for AWS operations"
  task prepare_aws_env: :environment do
    heroku_app_part = ENV["HEROKU_APP"].presence&.then { |app| "--app #{app}" }
    config = JSON.parse(`heroku config --json #{heroku_app_part}`)
    ENV["AWS_REGION"] = config.fetch("AWS_REGION")
    ENV["AWS_BUCKET"] = config.fetch("AWS_BUCKET")
    ENV["AWS_ACCESS_KEY_ID"] = config.fetch("AWS_ACCESS_KEY_ID")
    ENV["AWS_SECRET_ACCESS_KEY"] = config.fetch("AWS_SECRET_ACCESS_KEY")
  end

  desc "Downloads the app assets from AWS to directory `storage`."
  task pull_assets: :"db:prepare_aws_env" do
    bucket = ENV.fetch("AWS_BUCKET")
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

  namespace :tmp do
    desc "Dump the development database to the `tmp` folder of the project."
    task dump: :"db:prepare_database_env" do
      dump_filename = ENV["DUMP_NAME"].presence || ENV["DATABASE"]
      sh "pg_dump --verbose --format=c #{ENV["DATABASE"]} #{ENV["EXCLUDE_TABLE_DATA_PART"]} --file=tmp/#{dump_filename}.dump".squish
    end

    desc "Restore the development database from the `tmp` folder of the project."
    task restore: :"db:prepare_database_env" do
      sh "dropdb --if-exists #{ENV["DATABASE"]}"
      sh "createdb #{ENV["DATABASE"]}"
      dump_filename = ENV["DUMP_NAME"].presence || ENV["DATABASE"]
      sh "pg_restore --verbose --format=c --jobs=8 --disable-triggers --dbname=#{ENV["DATABASE"]} tmp/#{dump_filename}.dump".squish
      sh "rake db:environment:set"
    end
  end
end
