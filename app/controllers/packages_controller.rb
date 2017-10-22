# frozen_string_literal: true

class PackagesController < ApplicationController
  def index
    @packages = Package.latest
  end

  def show
    @package = Package.includes(:authors, :maintainers).find(params[:id])
  end
end
