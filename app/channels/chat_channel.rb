class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_for "chat_#{params[:session_id]}"
  end
end
