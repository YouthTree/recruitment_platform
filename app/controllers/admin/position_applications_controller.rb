class Admin::PositionApplicationsController < Admin::BaseController
  
  belongs_to :position, :finder => :find_using_slug!
  
  respond_to :html, :only => :show
  respond_to :csv,  :only => :index

  def index
    super do |format|
      format.csv do
        send_data application_reporter.to_csv,
          :type => :csv,
          :filename => "#{parent.team.name} - #{parent.title} Applications.csv"
      end
    end
  end

  protected
  
  def end_of_association_chain
    parent.applications
  end
  
  def application_reporter
    parent.to_application_reporter(params[:position_application_reporter])
  end

end
