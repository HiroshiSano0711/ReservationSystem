class HomeController < ApplicationController
  def index
    # TODO: ページネーションにする　10件ずつくらい
    @teams = Team.all
  end
end
