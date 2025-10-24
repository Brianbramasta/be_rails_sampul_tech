
class MessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "message_channel"
    # Kirim 100 pesan terakhir ke client yang baru subscribe
    messages = Message.order(created_at: :asc).limit(100)
    transmit({ type: 'initial_messages', messages: messages })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def fetch_messages
    messages = Message.order(created_at: :asc).limit(100)
    transmit({ type: 'initial_messages', messages: messages })
  end

  # Handle pesan yang masuk dari client
  def send_message(data)
    # Create and broadcast message
    message = Message.new(
      username: data['username'],
      content: data['content']
    )

    if message.save
      # Broadcast pesan ke semua client
      ActionCable.server.broadcast("message_channel", { message: message })
    else
      transmit({ type: 'message_error', errors: message.errors.full_messages })
    end
  end

  private

  def broadcast_message(message)
    ActionCable.server.broadcast(
      "message_channel",
      {
        type: 'new_message',
        message: message
      }
    )
  end
end