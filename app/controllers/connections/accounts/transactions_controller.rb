module Connections
  module Accounts
    class TransactionsController < ApplicationController
      before_action :find_account, only: :index

      def index
        transactions_list_builder = TransactionsListBuilder.new(user: current_user, account: @account)
        transactions_list_builder.build
        @transactions = transactions_list_builder.transactions

        flash.now[:alert] = transactions_list_builder.errors.join(" ") if transactions_list_builder.errors.present?
      end

      private

      def find_account
        @account = current_user.accounts.find(params[:account_id])
      end
    end
  end
end
