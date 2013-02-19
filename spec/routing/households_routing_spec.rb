require 'spec_helper'

describe 'Households' do
  it 'routes to /households/new' do
    expect(get: '/households/new').to route_to(
      controller: 'households', action: 'new')
  end

  it 'routes to /households with post method' do
    expect(post: '/households').to route_to(
      controller: 'households', action: 'create')
  end
end

