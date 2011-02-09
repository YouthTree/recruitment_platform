class PositionApplicationsController < ApplicationController

  before_filter :prepare_position
  before_filter :prepare_position_application, :except => :create

  def create
    @position_application = @position.applications.create!
    redirect_to [:edit, @position, @position_application]
  end

  def edit
    redirect_if_submitted && return
  end

  def update
    redirect_if_submitted && return
    @position_application.attributes = params[:position_application]
    if @position_application.save && @position_application.submitted?
      redirect_to [:applied, @position, @position_application]
    else
      if @position_application.errors.present?
        flash.now[:alert] = tf(:application_fields_required)
      else
        flash.now[:notice] = tf(:application_saved)
      end
      render :action => 'edit'
    end
  end

  def show
    if @position_application.submitted?
      redirect_to [:applied, @position, @position_application]
    else
      redirect_to [:edit, @position, @position_application]
    end
  end

  def applied
  end

  protected

  def prepare_position
    @position = position_scope.find_using_slug!(params[:position_id])
    @team     = @position.team
    add_title_variables! :position_title => @position.title, :team_name => @team.name
  end

  def position_scope
    user_signed_in? ? Position : Position.viewable
  end

  def prepare_position_application
    @position_application = @position.applications.from_searchable_identifier!(params[:id])
  end

  def redirect_if_submitted
    if @position_application.submitted?
      redirect_to [:applied, @position, @position_application]
      return true
    end
    false
  end

end
