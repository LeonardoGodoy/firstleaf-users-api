module AccountKeyGeneratorService
  ACCOUNT_KEY_URL = 'https://account-key-service.herokuapp.com/v1/account'.freeze

  class AccountKeyServiceError < StandardError; end

  def self.perform(email, key)
    form_data = {
      'email': email,
      'key': key
    }

    response = HTTParty.post(ACCOUNT_KEY_URL, body: form_data.to_json, headers: { 'Content-Type': 'application/json' })

    successful_request = response.success? && response['account_key'].present?

    raise AccountKeyServiceError, response.parsed_response['error'] unless successful_request

    response.parsed_response['account_key']
  end
end
