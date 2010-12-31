class Admin::PositionApplicationsController < Admin::BaseController
  
  belongs_to :position, :finder => :find_using_slug!
  
  protected
  
  def end_of_association_chain
    parent.applications
  end
  
end
