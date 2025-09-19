class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def n8n_response
    user_message = Message.find(params[:id])
    
    Message.create!(
      content: params[:text],
      role: :bot,
      status: "completed",
      session_id: user_message.session_id
    )

    head :ok
  rescue => e
    Rails.logger.error "Error in webhook: #{e.message}"
    head :unprocessable_entity
  end
end