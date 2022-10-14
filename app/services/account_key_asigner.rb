module AccountKeyAsigner
  def self.perform(user)
    account_key = AccountKeyGenerator.perform(user.email, user.key)

    user.update!(account_key: account_key)
  end
end