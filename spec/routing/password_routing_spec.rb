require 'spec_helper'

describe 'Password routes' do
  it 'routes to /password/reset' do
    expect(get: '/password/reset').to route_to(
      controller: 'password', action: 'edit')
  end

  it 'routes to /password/reset with post method' do
    expect(post: '/password/reset').to route_to(
      controller: 'password', action: 'update')
  end
end

