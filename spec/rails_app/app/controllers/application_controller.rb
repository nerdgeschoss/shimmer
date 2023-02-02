# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Shimmer::FileHelper
  include Shimmer::Consent
  include Shimmer::Localizable
  include Shimmer::RemoteNavigation
end
