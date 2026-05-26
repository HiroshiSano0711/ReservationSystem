class HomeController < ApplicationController
  def index
    @teams = Team.includes([:image_attachment]).all
  end
end
