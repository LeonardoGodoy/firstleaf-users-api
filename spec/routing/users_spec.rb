require 'rails_helper'

RSpec.describe :users, type: :routing do
  it { expect(get: '/v1/users').to route_to(controller: 'v1/users', action: 'index', format: 'json') }
  it { expect(post: '/v1/users').to route_to(controller: 'v1/users', action: 'create', format: 'json') }
end
