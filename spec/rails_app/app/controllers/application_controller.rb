class ApplicationController < ActionController::Base
  include Shimmer::FileHelper
  include Shimmer::Consent
  include Shimmer::Localizable
  include Shimmer::RemoteNavigation

  default_form_builder Shimmer::Form::Builder
end
