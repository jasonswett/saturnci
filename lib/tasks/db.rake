namespace :db do
  namespace :migrate do
    task concurrent: :environment do
      ActiveRecord::Base.connection.migration_context.migrate
    rescue ActiveRecord::ConcurrentMigrationError
      print "Skipping migrations because other migrations are already running"
    end
  end
end
