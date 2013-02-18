require 'spec_helper'

describe 'Dashboard routes' do
  it 'routes to /dashboard' do
    expect(get: '/dashboard').to route_to(
      controller: 'dashboard', action: 'show')
  end
end

