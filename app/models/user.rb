class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :is_stub
  has_secure_password

  before_validation :default_is_stub_to_false

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :password, presence: true, on: :create

  after_initialize :ensure_session_token

  has_many :paid_bills, class_name: "Bill", foreign_key: :owner_id
  has_many :debt_splits, class_name: "BillSplit", foreign_key: :debtor_id

  has_many :user_group_memberships, dependent: :destroy
  has_many :groups, through: :user_group_memberships

  def self.find_by_credentials(email, password)
    user = self.find_by_email(email)

    if user && user.authenticate(password)
      return user
    else
      return nil
    end
  end

  def self.new_stub(email)
    stub_password = SecureRandom.urlsafe_base64(16)
    User.new({email: email, is_stub: true, password: stub_password})
  end

  def self.create_stub!(email)
    stub_password = SecureRandom.urlsafe_base64(16)
    User.create!({email: email, is_stub: true, password: stub_password})
  end    

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
  end

  def display_name
    self.name || self.email
  end

  def stub?
    self.is_stub
  end

  def user_ids_with_outstanding_balance
    debits = self.debt_splits.includes(:bill)
    credits = self.paid_bills.includes(:bill_splits)
                             .map { |b| b.bill_splits }.flatten

    user_balances = Hash.new(0)
    debits.each do |debit_split|
      user_balances[debit_split.bill.owner_id] -= debit_split.amount
    end

    credits.each do |credit_split|
      user_balances[credit_split.debtor_id] += credit_split.amount
    end

    user_balances.reject { |_, amount| amount == 0 }
  end

  def users_with_outstanding_balance
    user_balances = user_ids_with_outstanding_balance

    user_ids = user_balances.keys.sort
    users = User.find(user_ids).sort_by { |u| u.id }
    user_mapping = Hash[user_ids.zip(users)]

    # new hash with User objects as keys and balances as values
    Hash[user_balances.map { |k, v| [user_mapping[k], v] }]
  end


  def balance_with(other_user)
    credit = BillSplit.joins(:bill)
                      .where("bill_splits.debtor_id" => other_user.id)
                      .where("bills.owner_id" => self.id)
                      .sum("amount")

    debt = BillSplit.joins(:bill)
                    .where("bill_splits.debtor_id" => self.id)
                    .where("bills.owner_id" => other_user.id)
                    .sum("amount")

    credit - debt
  end

  def splits_with(other_user)
    debits = self.debt_splits.includes(:bill)
                             .where("bills.owner_id" => other_user.id)
                             .all

    credits = BillSplit.includes(:bill)
                       .where("bill_splits.debtor_id" => other_user.id)
                       .where("bills.owner_id" => self.id)
                       .all

    debits.concat(credits).sort { |a, b| b.created_at <=> a.created_at }
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def default_is_stub_to_false
    self.is_stub ||= false
    true
  end
end
