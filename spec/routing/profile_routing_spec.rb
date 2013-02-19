require 'spec_helper'

describe 'Profile routes' do
  it 'routes to /profile' do
    expect(get: '/profile').to route_to(
      controller: 'profile', action: 'show')
  end

  it 'routes to /profile/edit' do
    expect(get: '/profile/edit').to route_to(
      controller: 'profile', action: 'edit')
  end

  it 'routes to /profile/edit with put method' do
    expect(put: '/profile/edit').to route_to(
      controller: 'profile', action: 'update')
  end
end
