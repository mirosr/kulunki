require 'spec_helper'

describe 'Auth routes' do
  it 'routes to #signup' do
    expect(get: '/signup').to route_to(
      controller: 'users', action: 'new')
  end
end
