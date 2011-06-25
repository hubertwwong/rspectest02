class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :debug_partial
  
  # swtich to turn on debug partial in the layout files.
  # if you want to turn this off comment out the before_filter above.
  def debug_partial
    @debug_partial = true
  end
  
  private

  # devise path after sign in.
  def after_sign_in_path_for(resource)
    tweets_path
  end

  # devise path after sign out.
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
