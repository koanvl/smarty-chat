class DialogsController < ApplicationController
  before_action :set_session_id
  before_action :set_dialog, only: [ :show, :destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  def index
    @dialogs = Dialog.where(session_id: session[:chat_id]).order(updated_at: :desc)
  end

  def show
    @dialogs = Dialog.where(session_id: session[:chat_id]).order(updated_at: :desc)
    @dialog = nil if params[:id] == "new"
  end

  def create
    dialog = Dialog.create!(
      title: params[:title].presence || "New dialog",
      session_id: session[:chat_id]
    )
    redirect_to dialog_path(dialog)
  end

  def destroy
    @dialog.destroy

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.remove(@dialog),
          turbo_stream.update("flash", "Dialog was deleted")
        ]
      }
      format.html { redirect_to root_path, notice: "Dialog was deleted" }
    end
  end

  private

  def set_session_id
    session[:chat_id] ||= SecureRandom.hex(8)
  end

  def set_dialog
    return if params[:id] == "new"
    @dialog = Dialog.where(session_id: session[:chat_id]).find(params[:id])
    @messages = @dialog.messages.order(:created_at)
  end

  def handle_not_found
    respond_to do |format|
      format.html do
        flash[:error] = "Dialog not found or you don't have access to it"
        redirect_to root_path
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("flash",
          render_to_string(partial: "shared/flash", locals: { message: "Dialog not found or you don't have access to it", type: "error" })
        )
      end
    end
  end
end
