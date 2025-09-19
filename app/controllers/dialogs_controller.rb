class DialogsController < ApplicationController
  before_action :set_session_id
  before_action :set_dialog, only: [ :show, :destroy ]

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
    redirect_to root_path, notice: "Dialog was successfully deleted"
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
end
