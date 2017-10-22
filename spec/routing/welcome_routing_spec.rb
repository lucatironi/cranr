# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :routing do
  it { expect(get: '/').to route_to('welcome#index') }
end
