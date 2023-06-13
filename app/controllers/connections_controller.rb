class ConnectionsController < ApplicationController
  before_action :build_connection, only: :new
  before_action :find_connection, only: [:update, :destroy]

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

  def update
    res = ConnectionStateUpdateService.call(connection: @connection, kind: params[:kind], callback_url: root_url)

    if res.is_a?(String)
      redirect_to res, allow_other_host: true
    elsif res
      flash[:notice] = "Connection was refreshed"
      redirect_to root_path
    else
      flash[:alert] = "Can't refresh connection. Please check consent or posible refresh date."
      redirect_to root_path
    end
  end

  def destory
    # connection_id
  end

  private

  def build_connection
    @connection = ""
  end

  def find_connection
    @connection = current_user.connections.find(params[:id])
  end
end
