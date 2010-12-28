class PositionsController < ApplicationController

  before_filter :prepare_position, :only => [:show, :apply]
  
  def index
    @search = Position.search(params[:position_search])
    @teams  = Team.for_listing(@search.to_relation).all
  end
  
  def show
  end

  def apply
    @position_application = @position.applications.build
    process_application if request.post?
  end

  protected

  def process_application
    @position_application.attributes = params[:position_application]
    if @position_application.save
      redirect_to :root, :notice => tf(:application_received)
    else
      render :action => 'apply'
    end
  end

  def prepare_position
    @position = Position.viewable.find_using_slug!(params[:id])
    @team     = @position.team
    add_title_variables! :position_title => @position.title, :team_name => @team.name
  end
  
end