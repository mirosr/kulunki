require 'spec_helper'

describe 'Email routes' do
  it 'routes to /email/change' do
    expect(get: '/email/change/token_value').to route_to(
      controller: 'email', action: 'update', token: 'token_value')
  end
end

