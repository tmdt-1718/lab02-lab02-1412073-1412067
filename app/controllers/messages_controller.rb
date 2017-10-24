class MessagesController < ApplicationController
	before_action :authenticate
	def index
		filter_send = params[:send]

		if filter_send.nil?
			#filter_send = null => receiver = current_user 
			@messages = Message.where("receiver = #{current_user["id"]}").order("created_at DESC")
		else
			@messages = Message.where("user_id = #{current_user["id"]}").order("created_at DESC")
		end
	end

	def show
		@message = Message.find(params[:id])
		@message.update_attribute(:time_read, DateTime.now)
		@message.update_attribute(:isread, true)
	end

	def new
		@friends = User.where(id: Friendship.where("user_id = #{current_user["id"]}").pluck(:friend_id))
	end

	def create
		current_user = User.find(session[:current_user]["id"])	
		@message = current_user.messages.create(message_params)
		redirect_to messages_path
	end
	
	private
		def message_params
			params.permit(:receiver, :text)
		end
end
