require 'spec_helper'

describe 'Email routes' do
  it 'routes to /email/change with put method' do
    expect(put: '/email/change/token_value').to route_to(
      controller: 'email', action: 'update', token: 'token_value')
  end
end

