class Message < ApplicationRecord
  validates :username, presence: true
  validates :content, presence: true
  
  after_create_commit { broadcast_message }
  
  private
  
  def broadcast_message
    ActionCable.server.broadcast('message_channel', {
      type: 'new_message',
      message: self
    })
  end
end