class PositionsController < ApplicationController
  
  def index
    @teams = Team.for_listing.all
  end
  
  def show
    @position = Position.viewable.find_using_slug(params[:id])
    @team     = @position.team
    add_title_variables! :position_title => @position.title, :team_name => @team.name
  end
  
end