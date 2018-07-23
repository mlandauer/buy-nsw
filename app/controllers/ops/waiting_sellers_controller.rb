class Ops::WaitingSellersController < Ops::BaseController

  def edit
    @operation = Ops::BuildUpdateWaitingSeller.call(waiting_seller_id: params[:id])
  end

  def update
    @operation = Ops::UpdateWaitingSeller.call(
      waiting_seller_id: params[:id],
      attributes: params[:waiting_seller],
    )

    if @operation.success?
      flash.notice = 'Saved'
      redirect_to edit_ops_waiting_seller_path(@operation.waiting_seller)
    else
      render :edit
    end
  end

  def upload
    @operation = Ops::UploadWaitingSellers.call(
      file: params[:file],
      file_contents: params[:file_contents],
      persist: params[:persist],
    )

    if operation.success?
      if operation.persisted? == true
        flash.notice = 'Saved'
        redirect_to ops_waiting_sellers_path
      else
        render :upload
      end
    else
      flash.alert = "We couldn't parse any rows from your CSV"
      redirect_to ops_waiting_sellers_path
    end
  end

  def invite
    @operation = Ops::BuildInviteWaitingSellers.call(
      waiting_seller_ids: params.dig(:invite, :ids),
    )

    if operation.failure? && operation.no_sellers_selected?
      flash.alert = "You didn't select any sellers to invite"
      return redirect_to ops_waiting_sellers_path
    end
  end

  def do_invite
    @operation = Ops::InviteWaitingSellers.call(
      waiting_seller_ids: params.dig(:invite, :ids),
    )

    if operation.success?
      flash.notice = 'Invitations sent'
      redirect_to ops_waiting_sellers_path
    else
      render :invite
    end
  end

private
  def operation
    @operation
  end
  helper_method :operation

  def search
    @search ||= Search::WaitingSeller.new(
      selected_filters: params,
      page: params.fetch(:page, 1),
      per_page: 25,
    )
  end
  helper_method :search

  def statistics
    @statistics ||= WaitingSeller.aasm.states.map {|state|
      [state.name, WaitingSeller.in_invitation_state(state.name).count]
    }
  end
  helper_method :statistics

end
