class UserProfilesController < ApplicationController
  def show; end

  def update
    customer = CustomerBuilder.new(user: current_user)

    if customer.build
      flash[:notice] = "Gateway customer created"
    else
      flash[:alert] = customer.errors.join(" ")
    end

    redirect_to user_profiles_path
  end
end
