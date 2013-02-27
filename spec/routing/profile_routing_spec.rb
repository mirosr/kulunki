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

  it 'routes to /profile/password/change with put method' do
    expect(put: '/profile/password/change').to route_to(
      controller: 'profile', action: 'change_password')
  end

  it 'routes to /profile/email/change with put method' do
    expect(put: '/profile/email/change').to route_to(
      controller: 'profile', action: 'change_email')
  end
end
