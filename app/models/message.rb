class Message < ApplicationRecord
  enum role: { user: 0, bot: 1 }
  validates :content, presence: true

  after_create_commit -> { broadcast_append_to "chat_#{session_id}" }
end