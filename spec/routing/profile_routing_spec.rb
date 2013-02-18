require 'spec_helper'

describe 'Profile routes' do
  it 'routes to #show' do
    expect(get: '/profile').to route_to(
      controller: 'profile', action: 'show')
  end
end


