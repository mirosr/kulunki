require 'spec_helper'

describe 'Password routes' do
  it 'routes to #reset' do
    expect(get: '/password/reset').to route_to(
      controller: 'password', action: 'reset')
  end
end

