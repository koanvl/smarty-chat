class Message < ApplicationRecord
  belongs_to :dialog, optional: true
  enum role: { user: 0, bot: 1 }
  validates :content, presence: true

  after_create_commit -> { broadcast_append_to stream_key, target: "messages" }
  after_update_commit -> { broadcast_replace_to stream_key }

  private

  def stream_key
    dialog_id.present? ? "dialog_#{dialog_id}" : "chat_#{session_id}"
  end
end
