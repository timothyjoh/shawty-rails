# frozen_string_literal: true

# The main webpage controllers
class HomeController < ApplicationController
  def index; end

  def short
    @link = Link.find_by(slug: params[:slug])
    redirect_to @link.url, status: :moved_permanently and return if @link

    redirect_to home_path
  end

  def edit
    @link = find_link
    redirect_to home_path and return unless @link
  end
end
