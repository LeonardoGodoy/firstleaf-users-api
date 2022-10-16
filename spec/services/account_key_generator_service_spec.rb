require 'rails_helper'

RSpec.describe AccountKeyGeneratorService, type: :unit do
  context 'when the service responds with success' do
    it 'returns a account key' do
      response = { email: 'test@email.com', account_key: 'account_key' }
      stub_request(:post, AccountKeyGeneratorService::ACCOUNT_KEY_URL)
        .to_return(status: 200, body: response.to_json, headers: { 'Content-Type': 'application/json' })

      account_key = described_class.perform('test@email.com', 'my_key')

      expect(account_key).to eq('account_key')
    end
  end

  context 'when the service responds with error' do
    it 'raises a AccountKeyServiceError' do
      response = { error: 'This service is currently unavailable' }
      stub_request(:post, AccountKeyGeneratorService::ACCOUNT_KEY_URL)
        .to_return(status: 200, body: response.to_json, headers: { 'Content-Type': 'application/json' })

      expect { described_class.perform('test@email.com', 'my_key') }
        .to raise_error(AccountKeyGeneratorService::AccountKeyServiceError, 'This service is currently unavailable')
    end
  end
end