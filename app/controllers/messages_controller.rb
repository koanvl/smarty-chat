class MessagesController < ApplicationController
  before_action :set_session_id

  def index
    @messages = Message.where(session_id: session[:chat_id]).order(:created_at)
  end

  def create
    @message = Message.create!(
      content: params[:message][:content],
      role: :user,
      status: "pending",
      session_id: session[:chat_id]
    )

    send_to_n8n(@message)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to messages_path }
    end
  end

  private

  def set_session_id
    session[:chat_id] ||= SecureRandom.hex(8)
  end

  def send_to_n8n(message)
    webhook_url = ENV['N8N_WEBHOOK_URL']
    return false if webhook_url.blank?

    response = Faraday.post(webhook_url) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        text: message.content,
        id: message.id
      }.to_json
    end

    response.success?
  rescue StandardError => e
    Rails.logger.error "N8n webhook error: #{e.message}"
    false
  end
end