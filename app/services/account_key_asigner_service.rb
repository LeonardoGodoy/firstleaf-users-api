module AccountKeyAsignerService
  def self.perform(user)
    account_key = AccountKeyGeneratorService.perform(user.email, user.key)

    user.update!(account_key: account_key)
  end
end