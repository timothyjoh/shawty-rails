# frozen_string_literal: true

# common methods to use in controllers
class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def find_link
    if params[:id]
      slug, secret = params[:id].split('-')
      @link = Link.find_by(slug: slug)
      return @link.secret == secret ? @link : nil
    end
    nil
  end
end
