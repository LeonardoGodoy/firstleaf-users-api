require 'rails_helper'

RSpec.describe AccountKeyAsigner, type: :unit do
  it 'sets the account key user field' do
    user = create(:user, account_key: nil)

    allow(AccountKeyGenerator).to receive(:perform).and_return('account_key')

    described_class.perform(user)

    expect(user.account_key).to eq('account_key')
  end
end