require 'spec_helper'

describe 'Password routes' do
  it 'routes to /password/reset' do
    expect(get: '/password/reset').to route_to(
      controller: 'password', action: 'new')
  end

  it 'routes to /password/reset with post method' do
    expect(post: '/password/reset').to route_to(
      controller: 'password', action: 'create')
  end

  it 'routes to /password/change' do
    expect(get: '/password/change/token_value').to route_to(
      controller: 'password', action: 'edit', token: 'token_value')
  end

  it 'routes to /password/change with post method' do
    expect(put: '/password/change/token_value').to route_to(
      controller: 'password', action: 'update', token: 'token_value')
  end
end
