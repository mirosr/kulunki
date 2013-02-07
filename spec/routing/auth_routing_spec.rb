require 'spec_helper'

describe 'Auth routes' do
  it 'routes to /signup' do
    expect(get: '/signup').to route_to(
      controller: 'users', action: 'new')
  end

  it 'routes to /signin' do
    expect(get: '/signin').to route_to(
      controller: 'sessions', action: 'new')
  end

  it 'routes to /signin with post method' do
    expect(post: '/signin').to route_to(
      controller: 'sessions', action: 'create')
  end
end
