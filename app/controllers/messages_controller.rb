class MessagesController < ApplicationController
  before_action :set_session_id
  before_action :set_dialog, except: [ :create_with_dialog ]

  def create
    @message = @dialog.messages.create!(
      content: params[:message][:content],
      role: :user,
      status: "pending",
      session_id: session[:chat_id]
    )

    send_to_n8n(@message)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to dialog_path(@dialog) }
    end
  end

  def create_with_dialog
    @dialog = Dialog.create!(
      title: "New dialog",
      session_id: session[:chat_id]
    )

    @message = @dialog.messages.create!(
      content: params[:message][:content],
      role: :user,
      status: "pending",
      session_id: session[:chat_id]
    )

    send_to_n8n(@message)
    redirect_to dialog_path(@dialog)
  end

  private

  def set_session_id
    session[:chat_id] ||= SecureRandom.hex(8)
  end

  def set_dialog
    @dialog = Dialog.where(session_id: session[:chat_id]).find(params[:dialog_id])
  end

  def send_to_n8n(message)
    webhook_url = ENV["N8N_WEBHOOK_URL"]
    return false if webhook_url.blank?

    response = Faraday.post(webhook_url) do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = {
        text: message.content,
        id: message.id,
        dialog_id: @dialog.id
      }.to_json
    end

    response.success?
  rescue StandardError => e
    Rails.logger.error "N8n webhook error: #{e.message}"
    false
  end
end
