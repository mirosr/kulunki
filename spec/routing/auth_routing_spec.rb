require 'spec_helper'

describe 'Auth routes' do
  it 'routes to #signup' do
    expect(get: '/signup').to route_to(
      controller: 'users', action: 'new')
  end

  it 'routes to #sigin' do
    expect(get: '/signin').to route_to(
      controller: 'sessions', action: 'new')
  end
end
