class Admin::PositionsController < Admin::BaseController

  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.find_using_slug!(params[:id], :include => {:position_questions => :question}))
  end

end
