class ConnectionsController < ApplicationController
  before_action :build_connection, only: :new

  def index
    connection_list_builder = ConnectionsListBuilder.new(user: current_user)
    connection_list_builder.build
    @connections = connection_list_builder.connections

    flash.now[:alert] = connection_list_builder.errors.join(" ") if connection_list_builder.errors.present?
  end

  def new
    new_connect_session = ConnectSessionsBuilder.new(user: current_user, callback_url: root_url)

    if new_connect_session.build
      @connection = new_connect_session.connect_session_url
    else
      flash.now[:alert] = new_connect_session.errors.join(" ")
    end
  end

  # def creat
    
  # end

  # def update
  # end

  # def destory
  # end

  private

  def build_connection
    @connection = ""
  end
end
