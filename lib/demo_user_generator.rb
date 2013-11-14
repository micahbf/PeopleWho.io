module DemoUserGenerator
  def self.new_demo_user(expiration_time = 12.hours)
    now = Time.now
    to_destroy = []

    user_rand = Random.rand(10000)
    name = "Guest #{user_rand}"
    email = "guest#{user_rand}@example.com"
    password = "password#{user_rand}"

    guest_user = User.create({name: name, email: email, password: password})
    to_destroy << guest_user

    stub_user_attrs = []
    10.times do
      name = Faker::Name.name
      email = Faker::Internet.email
      password = Faker::Internet.password

      stub_user_attrs << {name: name, email: email, password: password}
    end

    stub_users = User.create(stub_user_attrs)
    to_destroy.concat(stub_users)

    roommates = UserGroup.new({name: "Roommates"})
    roommate_ids = stub_users[0..2].map { |u| u.id }
    roommates.user_ids = [guest_user.id].concat(roommate_ids)
    roommates.save

    to_destroy << roommates

    [
      {description: "Dish soap", total: 481, created_at: now - 18.days},
      {description: "Internet bill", total: 9435, created_at: now - 15.days},
      {description: "Party supplies", total: 5823, created_at: now - 13.days},
      {description: "Shower curtain", total: 1920, created_at: now - 10.days},
      {description: "Electric bill", total: 16792, created_at: now - 9.days},
      {description: "New vacuum cleaner", total: 12490, created_at: now - 7.days},
      {description: "Light bulbs", total: 2036, created_at: now - 4.days},
      {description: "Gas bill", total: 20782, created_at: now - 2.days},
      {description: "Re-upping coffee stash", total: 1638, created_at: now - 6.hours}
    ].map do |bill_attrs|
      bill_attrs.merge({
        owner_id: roommate.user_ids.sample,
        group_id: roommates.id
      })
    end.tap do |bills_attrs|
      bills = Bill.create(bills_attrs, without_protection: true)
      to_destroy.concat(bills)
    end

    vacation = UserGroup.new({name: "Eastern Europe Trip"})
    vacation_user_ids = stub_users[3..5].map { |u| u.id }
    vacation.user_ids = [guest_user.id].concat(vacation_user_ids)
    vacation.save

    to_destroy << vacation

    [
      {description: "Budapest hostel", orig_currency_code: "HUF", total: 2700000, created_at: now - 36.days},
      {description: "Train tickets Budapest -> Zagreb", orig_currency_code: "HUF", total: 4500000, created_at: now - 35.days},
      {description: "Croatia car rental", orig_currency_code: "HRK", total: 103000, created_at: now - 34.days},
      {description: "Dubrovnik hotel room", orig_currency_code: "HRK", total: 150000, created_at: now - 34.days},
      {description: "Train tickets Dubrovnik -> Sarajevo", orig_currency_code: "HRK", total: 73500, created_at: now - 33.days},
      {description: "Sarajevo hostel", orig_currency_code: "BAM", total: 32000, created_at: now - 32.days},
      {description: "Sarajevo guided tour", orig_currency_code: "BAM", total: 10000, created_at: now - 31.days},
      {description: "Train tickets Sarajevo -> Belgrade", orig_currency_code: "BAM", total: 37871, created_at: now - 30.days},
      {description: "Dinner at Serbian restaurant", orig_currency_code: "RSD", total: 6800, created_at: now - 29.days},
      {description: "Belgrade hotel", orig_currency_code: "RSD", total: 2200000, created_at: now - 28.days},
      {description: "Bus tickets Belgrade -> Prague", orig_currency_code: "RSD", total: 620000, created_at: now - 27.days},
      {description: "Prague river cruise", orig_currency_code: "CZK", total: 350000, created_at: now - 26.days},
      {description: "Prague AirBnB apartment", orig_currency_code: "CZK", total: 700000, created_at: now - 25.days}
    ].map do |bill_attrs|
      bill_attrs.merge({
        owner_id: vacation.user_ids.sample,
        group_id: vacation.id
      })
    end.tap do |bills_attrs|
      bills = Bill.create(bills_attrs, without_protection: true)
      to_destroy.concat(bills)
    end

    [
      {description: "Dinner at the Chatterbox", total: 6209},
      {description: "Daft Punk tickets", total: 14254},
      {description: "Lunch at Chairman", total: 1852},
      {description: "Drinks at the Nomad", total: 3922},
      {description: "Cash", total: 4000},
      {description: "Gas", total: 4862},
      {description: "Lunch", total: 2842},
      {description: "Movie tickets", total: 2817},
      {description: "Cab to show", total: 3419}
    ].each do |bill_attrs|
      other_user_id = stub_users[6..10].sample.id

      bill = Bill.new(bill_attrs)
      if (Random.rand > 0.5)
        bill.owner_id = guest_user.id
        bill.bill_splits.build({debtor_id: other_user_id, amount: bill.total / 2})
      else
        bill.owner_id = other_user_id
        bill.bill_splits.build({debtor_id: guest_user.id, amount: bill.total / 2})
      end
      bill.save
      to_destroy << bill
    end

    to_destroy.each do |model_to_destroy|
      model_to_destroy.delay(run_at: expiration_time.from_now).destroy
    end

    guest_user
  end
end