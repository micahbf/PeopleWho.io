require 'demo_user_generator'

namespace :demo_user do
  desc "Generate a new demo user and cache it"
  task :generate_new_cached => :environment do
    demo_user = DemoUserGenerator::new_demo_user
    demo_user_with_includes = User.includes(
      paid_bills: [:bill_splits, :group],
     debt_splits: [:bill],
          groups: [:user_group_memberships, :bills]).find(demo_user.id)

    Rails.cache.write("demo-user", demo_user_with_includes, expires_in: 6.hours)
  end

end
