class PositionsController < ApplicationController

  before_filter :prepare_position, :only => [:show, :apply, :applied]
  
  def index
    @search    = Position.search(params[:position_search])
    @positions = Position.for_listing(@search.to_relation).all
  end
  
  def show
    autoset_position_notice
  end

  def apply
    @position_application = @position.applications.build
    process_application if request.post?
  end

  def applied
  end

  protected

  def process_application
    @position_application.attributes = params[:position_application]
    if @position_application.save
      redirect_to [:applied, @position]
    else
      render :action => 'apply'
    end
  end

  def prepare_position
    @position = position_scope.find_using_slug!(params[:id])
    @team     = @position.team
    add_title_variables! :position_title => @position.title, :team_name => @team.name
  end
  
  def position_scope
    user_signed_in? ? Position : Position.viewable
  end

  def autoset_position_notice
    if user_signed_in? && !@position.viewable?
      flash.now[:notice] = "Please note - This position is not currently viewable to normal visitors."
    end
  end

end