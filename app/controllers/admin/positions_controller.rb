class Admin::PositionsController < Admin::BaseController

  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.with_questions.find_using_slug!(params[:id]))
  end

end
