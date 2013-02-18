require 'spec_helper'

describe 'Home route' do
  it 'routes to /' do
    expect(get: '/').to route_to(
      controller: 'dashboard', action: 'show')
  end
end
