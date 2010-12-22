class PositionsController < ApplicationController
  
  def index
    @teams = Team.for_listing.all
  end
  
  def show
    @position = Position.viewable.find_using_slug(params[:id])
    @team     = @position.team
  end
  
end