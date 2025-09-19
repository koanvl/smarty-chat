class Dialog < ApplicationRecord
  has_many :messages, dependent: :destroy
  validates :session_id, presence: true
end
