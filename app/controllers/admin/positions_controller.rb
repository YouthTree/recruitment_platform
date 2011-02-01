class Admin::PositionsController < Admin::BaseController

  def clone_position(options = {}, &block)
    flash.now[:notice] = "Cloning existing position - Please edit below and save as normal."
    respond_with(*(with_chain(build_resource_for_cloning) << options), &block)
  end

  def reorder
    Position.update_order(params[:position_ids]) if params[:position_ids]
    redirect_to :admin_positions
  end

  protected

  def end_of_association_chain
    super.in_order
  end

  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.with_questions.find_using_slug!(params[:id]))
  end

  def build_resource_for_cloning
    get_resource_ivar || set_resource_ivar(resource.clone_for_editing)
  end

end
