class Admin::PositionApplicationsController < Admin::BaseController
  
  belongs_to :position, :finder => :find_using_slug!
  
  respond_to :html
  respond_to :csv,  :only => :index

  def index
    super do |format|
      format.csv do
        send_data application_reporter.to_csv,
          :type => :csv,
          :filename => "#{parent.team.name} - #{parent.title} Applications.csv"
      end
      format.html do
        render :layout => 'application'
      end
    end
  end
  
  def printable
    resource
    render :layout => 'application'
  end

  protected
  
  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.from_searchable_identifier!(params[:id]))
  end

  def end_of_association_chain
    parent.applications.includes(:email_address).submitted
  end
  
  def application_reporter
    parent.to_application_reporter(params[:position_application_reporter])
  end

end
