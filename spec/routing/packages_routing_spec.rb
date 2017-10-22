# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackagesController, type: :routing do
  it { expect(get: '/packages').to   route_to('packages#index') }
  it { expect(get: '/packages/1').to route_to('packages#show', id: '1') }
end
