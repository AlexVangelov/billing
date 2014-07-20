namespace :billing do
  desc "Billing Install"
  task install: :environment do
    Rake::Task['billing:install:migrations'].invoke
  end

end