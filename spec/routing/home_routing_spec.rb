require 'spec_helper'

describe 'Home route' do
  it 'routes to dashbard#show' do
    expect(get: '/').to route_to(
      controller: 'dashboard', action: 'show')
  end
end
