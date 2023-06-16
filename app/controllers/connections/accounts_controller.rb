module Connections
  class AccountsController < ApplicationController
    before_action :find_connection, only: :index

    def index
      accounts_list_builder = AccountsListBuilder.new(user: current_user, connection: @connection)
      accounts_list_builder.build
      @accounts = accounts_list_builder.accounts

      flash.now[:alert] = accounts_list_builder.errors.join(" ") if accounts_list_builder.errors.present?
    end

    private 

    def find_connection
      @connection = current_user.connections.includes(:accounts).find(params[:connection_id])
    end
  end
end
