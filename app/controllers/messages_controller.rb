class MessagesController < ApplicationController
  def index
    @messages = Message.order(created_at: :asc).limit(100)
    render json: @messages
  end
  
  def create
    @message = Message.new(message_params)
    
    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end
  
  private
  
  def message_params
    params.require(:message).permit(:username, :content)
  end
end