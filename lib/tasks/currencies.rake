namespace :currencies do
  desc "TODO"
  task :update_all => :environment do
    Currency.update_all
  end
end
