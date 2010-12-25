class PositionsController < ApplicationController
  
  def index
    @search = Position.search(params[:search])
    @teams  = Team.for_listing(@search).all
  end
  
  def show
    @position = Position.viewable.find_using_slug(params[:id])
    @team     = @position.team
    add_title_variables! :position_title => @position.title, :team_name => @team.name
  end
  
end